#!/usr/bin/env node
// Publishes queued blog posts that are "due" (scheduled time has passed) and are
// not already in the database. Idempotent: the DB is the source of truth for
// what is already live, so re-runs, delayed runs and overlapping runs never
// double-post. Driven by a GitHub Actions cron.
//
// This mirrors the drip-publisher on spendwisecents, deliberately. The queue
// lives in files committed to the repo rather than as 'scheduled' rows in the
// database, which matters for three reasons:
//
//   1. An article is reviewable in a diff before it can ever go live.
//   2. Nothing half-written sits in the posts table waiting for a status flip,
//      so a mistake in the publisher cannot expose a draft.
//   3. "Already in the DB" is a far safer due-check than "status = scheduled",
//      because it survives someone editing a post by hand in the admin.
//
// Env:
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY  (required — GitHub repo secrets)
//   SITE_BASE_URL, REVALIDATION_SECRET       (optional — refreshes the live site)
//   DRY_RUN=1        optional — log what would publish, insert nothing
//   MAX_PER_RUN=12   optional — safety cap on inserts per run (default 12)
//
// Content queue (committed to the repo):
//   content-queue/schedule.json          { "<slug>": "2026-09-04T07:00:00Z", ... }
//   content-queue/articles/<slug>.json   { slug,title,excerpt,quick_answer,content,
//                                          seo_title,seo_description,audience_tags,
//                                          faq_items,category }

import { readFile, readdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const QUEUE = join(ROOT, "content-queue");

// The Supabase project is shared with other live sites. Every request below is
// scoped to this id without exception.
const SITE_ID = "ed23c093-ff1e-4355-8e4a-fd1961a03587"; // ofthepitch

const CATEGORY_ID = {
  "horse-racing": "01493019-231a-4562-a778-bcdd7500e720",
  "racing-enclosures": "702ef44a-32f1-47d0-b132-90677e392542",
  "racing-dress-codes": "825700f7-915d-4b7c-924b-821ce4b3409b",
  "racing-racedays": "71224195-11f4-4e5b-ad6d-9292762d463b",
  tennis: "6446ce27-6a94-4806-9bfd-891d3f6820b4",
  "tennis-venues": "8f6d8f49-eff1-4d06-878e-509c96c05ccc",
  "tennis-tickets": "5ecd7b0a-1064-4720-ba98-46bf9140de61",
  "tennis-dress-codes": "f6e83d32-27f4-41fd-95be-40309c6cbe0f",
  "formula-1": "8af8890c-b657-450c-9fbf-06bd8703d377",
  "f1-circuits": "8d4ec407-7b1f-4492-991a-0036d9159790",
  "f1-grandstands": "64a38901-30d4-47ac-89d5-22ea885f8e2c",
  "f1-hospitality": "b47b4503-5e55-4fb1-857e-1e00fbf33cec",
  skiing: "1c9ab964-6aa6-47f9-b789-1468f16fe83c",
  "ski-resorts": "606e3b29-f6ad-4dfe-98cb-59ff9d39e053",
  "ski-planning": "cdfec3a7-5d4a-4057-b87b-17f63724a0c7",
  football: "49b495a2-dbae-47ec-ae64-02ac9ade9521",
  "football-grounds": "212fa70e-de68-4cef-86b0-ba7ce1abaca8",
  "football-tickets": "42eb6a3f-6114-45b8-9d8f-d8c8f017c0ec",
  "football-matchdays": "e12a6a01-5749-4303-b4c1-d3898b9396d9",
  "world-cup-2026": "464d5114-0fd4-40f5-afb7-78f551b8568d",
};

// Normalize the URL defensively: trim whitespace/newlines, add https:// if the
// scheme was omitted, and strip any trailing slash. A malformed SUPABASE_URL
// secret (missing scheme is the classic one) otherwise throws "Invalid URL".
function normalizeUrl(raw) {
  let u = (raw || "").trim().replace(/\/+$/, "");
  if (u && !/^https?:\/\//i.test(u)) u = "https://" + u;
  return u;
}

const BASE = normalizeUrl(process.env.SUPABASE_URL);
const KEY = (process.env.SUPABASE_SERVICE_ROLE_KEY || "").trim();
const DRY_RUN = process.env.DRY_RUN === "1";
const MAX_PER_RUN = Number(process.env.MAX_PER_RUN || 12);

if (!BASE || !KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}
try {
  new URL(BASE);
} catch {
  console.error(
    `SUPABASE_URL is not a valid URL after normalization: "${BASE}". ` +
      `It should look like https://<project-ref>.supabase.co`
  );
  process.exit(1);
}

const auth = { apikey: KEY, Authorization: `Bearer ${KEY}` };

const REQUIRED = [
  "slug",
  "title",
  "excerpt",
  "quick_answer",
  "content",
  "seo_title",
  "seo_description",
  "faq_items",
  "category",
];

async function main() {
  const schedule = JSON.parse(await readFile(join(QUEUE, "schedule.json"), "utf8"));
  const now = Date.now();

  // Slugs already in the DB, whatever their status — never re-insert.
  const existingRes = await fetch(
    `${BASE}/rest/v1/posts?site_id=eq.${SITE_ID}&select=slug`,
    { headers: auth }
  );
  if (!existingRes.ok) {
    throw new Error(`fetch existing failed: ${existingRes.status} ${await existingRes.text()}`);
  }
  const existing = new Set((await existingRes.json()).map((r) => r.slug));

  const files = (await readdir(join(QUEUE, "articles"))).filter((f) => f.endsWith(".json"));
  const due = [];
  for (const f of files) {
    const slug = f.replace(/\.json$/, "");
    const when = schedule[slug];
    if (!when) {
      console.log(`skip ${slug}: not in schedule`);
      continue;
    }
    if (Date.parse(when) > now) continue; // not due yet
    if (existing.has(slug)) continue; // already published
    due.push({ slug, when });
  }
  due.sort((a, b) => Date.parse(a.when) - Date.parse(b.when));

  console.log(`${due.length} due & unpublished (cap ${MAX_PER_RUN})${DRY_RUN ? " [DRY RUN]" : ""}`);

  let published = 0;
  const errors = [];
  const publishedRows = [];

  for (const { slug, when } of due.slice(0, MAX_PER_RUN)) {
    let a;
    try {
      a = JSON.parse(await readFile(join(QUEUE, "articles", `${slug}.json`), "utf8"));
    } catch (e) {
      errors.push([slug, `read: ${e.message}`]);
      continue;
    }

    const miss = REQUIRED.filter((k) => !a[k]);
    if (miss.length) {
      errors.push([slug, `missing ${miss}`]);
      continue;
    }
    const catId = CATEGORY_ID[a.category];
    if (!catId) {
      errors.push([slug, `unknown category ${a.category}`]);
      continue;
    }

    const row = {
      site_id: SITE_ID,
      slug,
      title: a.title,
      excerpt: a.excerpt,
      content: a.content,
      quick_answer: a.quick_answer,
      category_id: catId,
      audience_tags: Array.isArray(a.audience_tags) ? a.audience_tags : [],
      status: "published",
      seo_title: a.seo_title,
      seo_description: a.seo_description,
      faq_items: (a.faq_items || []).map((x) => ({
        question: x.question || "",
        answer: x.answer || "",
      })),
      // Left NULL on purpose: the post page falls back to a generated card from
      // /api/og, and the dashboard's "missing image" count stays truthful.
      featured_image_url: a.featured_image_url ?? null,
      published_at: when,
    };

    if (DRY_RUN) {
      console.log(`would publish ${slug} (${when})`);
      published++;
      continue;
    }

    const res = await fetch(`${BASE}/rest/v1/posts?on_conflict=site_id,slug`, {
      method: "POST",
      headers: {
        ...auth,
        "Content-Type": "application/json",
        Prefer: "resolution=merge-duplicates,return=minimal",
      },
      body: JSON.stringify([row]),
    });
    if (!res.ok) {
      errors.push([slug, `${res.status} ${(await res.text()).slice(0, 200)}`]);
      continue;
    }
    console.log(`published ${slug} (${when})`);
    publishedRows.push({ slug, category: a.category });
    published++;
  }

  if (publishedRows.length) await revalidate(publishedRows);

  console.log(`\nDONE: published ${published}${DRY_RUN ? " (dry run)" : ""}`);
  if (errors.length) {
    console.error("ERRORS:");
    for (const [s, m] of errors) console.error(`  ${s} -> ${m}`);
    process.exit(1);
  }
}

/**
 * Asks the running site to rebuild the pages a new post appears on. Posts live
 * at the site root, never under /blog/<slug>, so the post path is just /<slug>.
 * A failed revalidation is not a failed publish: the post is live either way
 * and the next deploy or cache expiry picks it up.
 */
async function revalidate(rows) {
  const site = normalizeUrl(process.env.SITE_BASE_URL);
  const secret = (process.env.REVALIDATION_SECRET || "").trim();
  if (!site || !secret) {
    console.log("SITE_BASE_URL or REVALIDATION_SECRET unset, skipping revalidation.");
    return;
  }

  // A post in a subcategory also shows on its parent's archive, so refresh both.
  const cats = new Set();
  for (const { category } of rows) {
    cats.add(category);
    const res = await fetch(
      `${BASE}/rest/v1/categories?site_id=eq.${SITE_ID}&slug=eq.${category}&select=parent_id`,
      { headers: auth }
    );
    const [row] = res.ok ? await res.json() : [];
    if (!row?.parent_id) continue;
    const pRes = await fetch(
      `${BASE}/rest/v1/categories?site_id=eq.${SITE_ID}&id=eq.${row.parent_id}&select=slug`,
      { headers: auth }
    );
    const [parent] = pRes.ok ? await pRes.json() : [];
    if (parent?.slug) cats.add(parent.slug);
  }

  const paths = [
    "/",
    "/blog",
    ...rows.map((r) => `/${r.slug}`),
    ...[...cats].map((c) => `/category/${c}`),
  ];

  try {
    const res = await fetch(`${site}/api/revalidate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ secret, paths }),
    });
    if (!res.ok) {
      console.error(`Revalidation returned ${res.status}: ${(await res.text()).slice(0, 200)}`);
      return;
    }
    console.log(`Revalidated ${paths.length} path(s).`);
  } catch (e) {
    console.error(`Revalidation failed: ${e.message}`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

#!/usr/bin/env node
/**
 * Publishes posts whose scheduled date has arrived.
 *
 * Articles are written in batches and stored with status 'scheduled' and a
 * published_at in the future. This flips them to 'published' once that date
 * passes, then asks the site to revalidate the pages the new post appears on.
 *
 * The status flip is what matters, not the date. lib/queries.ts filters on
 * status = 'published' and published_at IS NOT NULL, but it does not compare
 * published_at to now(), so a future-dated post with status 'published' would
 * appear on the site immediately. Scheduling therefore has to live in status.
 *
 *   node scripts/publish-due-posts.mjs          # publish what is due
 *   node scripts/publish-due-posts.mjs --dry-run  # report without writing
 */

import { createClient } from "@supabase/supabase-js";

const SITE_ID = "ed23c093-ff1e-4355-8e4a-fd1961a03587";
const DRY_RUN = process.argv.includes("--dry-run");

const { SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, SITE_BASE_URL, REVALIDATION_SECRET } =
  process.env;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required.");
  process.exit(1);
}

const db = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

async function main() {
  const now = new Date().toISOString();

  // Scoped to this site. The Supabase project is shared with other live sites,
  // so every query here filters on site_id without exception.
  const { data: due, error } = await db
    .from("posts")
    .select("id, slug, title, published_at, category_id")
    .eq("site_id", SITE_ID)
    .eq("status", "scheduled")
    .lte("published_at", now)
    .order("published_at", { ascending: true });

  if (error) {
    console.error(`Query failed: ${error.message}`);
    process.exit(1);
  }

  if (!due?.length) {
    console.log(`Nothing due as of ${now}.`);
    return;
  }

  console.log(`${due.length} post(s) due:`);
  for (const p of due) console.log(`  ${p.published_at}  ${p.slug}  ${p.title}`);

  if (DRY_RUN) {
    console.log("\nDry run, nothing written.");
    return;
  }

  const ids = due.map((p) => p.id);
  const { error: writeErr } = await db
    .from("posts")
    .update({ status: "published", updated_at: now })
    .eq("site_id", SITE_ID)
    .eq("status", "scheduled")
    .in("id", ids);

  if (writeErr) {
    console.error(`Publish failed: ${writeErr.message}`);
    process.exit(1);
  }
  console.log(`\nPublished ${ids.length} post(s).`);

  await revalidate(due);
}

/**
 * Asks the running site to rebuild the pages this post appears on. Posts live
 * at the site root, never under /blog/<slug>, so the post path is just /<slug>.
 */
async function revalidate(posts) {
  if (!SITE_BASE_URL || !REVALIDATION_SECRET) {
    console.log("SITE_BASE_URL or REVALIDATION_SECRET unset, skipping revalidation.");
    return;
  }

  const categoryIds = [...new Set(posts.map((p) => p.category_id).filter(Boolean))];
  let categoryPaths = [];

  if (categoryIds.length) {
    // Include the parent archive: a post in a subcategory also rolls up to it.
    const { data: cats } = await db
      .from("categories")
      .select("slug, parent_id")
      .eq("site_id", SITE_ID)
      .in("id", categoryIds);

    const parentIds = [...new Set((cats ?? []).map((c) => c.parent_id).filter(Boolean))];
    const { data: parents } = parentIds.length
      ? await db
          .from("categories")
          .select("slug")
          .eq("site_id", SITE_ID)
          .in("id", parentIds)
      : { data: [] };

    categoryPaths = [...(cats ?? []), ...(parents ?? [])].map((c) => `/category/${c.slug}`);
  }

  const paths = [
    "/",
    "/blog",
    ...posts.map((p) => `/${p.slug}`),
    ...new Set(categoryPaths),
  ];

  const res = await fetch(`${SITE_BASE_URL.replace(/\/$/, "")}/api/revalidate`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ secret: REVALIDATION_SECRET, paths }),
  });

  if (!res.ok) {
    // A failed revalidation is not a failed publish. The post is live either
    // way and the next deploy or cache expiry picks it up.
    console.error(`Revalidation returned ${res.status}: ${await res.text()}`);
    return;
  }
  console.log(`Revalidated ${paths.length} path(s).`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});

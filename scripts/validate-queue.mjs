#!/usr/bin/env node
/**
 * Validates the content queue before a batch is committed.
 *
 * Every check here exists because the rule it enforces was broken at least
 * once in the first fifteen articles. See content-queue/WRITING-STANDARDS.md
 * for the reasoning behind each one.
 *
 *   node scripts/validate-queue.mjs
 *
 * Exits non-zero on any error, so it can gate a commit or a CI step.
 */

import { readFileSync, readdirSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const QUEUE = join(ROOT, "content-queue");
const ARTICLES = join(QUEUE, "articles");

const REQUIRED = [
  "slug", "title", "excerpt", "quick_answer", "content",
  "seo_title", "seo_description", "faq_items", "category",
];

// Must match CATEGORY_ID in scripts/publish-due-posts.mjs.
const CATEGORIES = new Set([
  "horse-racing", "racing-enclosures", "racing-dress-codes", "racing-racedays",
  "tennis", "tennis-venues", "tennis-tickets", "tennis-dress-codes",
  "formula-1", "f1-circuits", "f1-grandstands", "f1-hospitality",
  "skiing", "ski-resorts", "ski-planning",
  "football", "football-grounds", "football-tickets", "football-matchdays",
  "world-cup-2026",
]);

const errors = [];
const warnings = [];
const err = (slug, msg) => errors.push(`${slug}: ${msg}`);
const warn = (slug, msg) => warnings.push(`${slug}: ${msg}`);

const schedule = JSON.parse(readFileSync(join(QUEUE, "schedule.json"), "utf8"));
const files = readdirSync(ARTICLES).filter((f) => f.endsWith(".json"));
const slugs = new Set(files.map((f) => f.replace(/\.json$/, "")));
const inbound = new Map();

for (const file of files) {
  const slug = file.replace(/\.json$/, "");
  let a;
  try {
    a = JSON.parse(readFileSync(join(ARTICLES, file), "utf8"));
  } catch (e) {
    err(slug, `unparseable JSON: ${e.message}`);
    continue;
  }

  for (const k of REQUIRED) if (!a[k]) err(slug, `missing ${k}`);
  if (a.slug !== slug) err(slug, `slug field is "${a.slug}"`);
  if (!schedule[slug]) err(slug, "not in schedule.json");
  if (a.category && !CATEGORIES.has(a.category)) err(slug, `unknown category "${a.category}"`);

  // Rule 10: the card is generated, never uploaded.
  if (a.featured_image_url) warn(slug, "featured_image_url set; the card is generated");

  const c = a.content ?? "";

  // Rule 7: no em or en dashes.
  if (/[—–]/.test(c) || / -- /.test(c)) err(slug, "contains an em/en dash");
  for (const f of ["title", "excerpt", "quick_answer", "seo_title", "seo_description"]) {
    if (a[f] && /[—–]/.test(a[f])) err(slug, `em/en dash in ${f}`);
  }

  // Rule 9: field lengths.
  if (a.seo_title?.length > 60) warn(slug, `seo_title ${a.seo_title.length} chars, truncates near 60`);
  if (a.seo_description && (a.seo_description.length < 120 || a.seo_description.length > 165)) {
    warn(slug, `seo_description ${a.seo_description.length} chars, aim 140-160`);
  }

  // Rule 4: structure for extraction.
  const h2 = c.match(/^## .+$/gm) ?? [];
  if (h2.length < 5) err(slug, `only ${h2.length} H2 sections`);
  const questions = h2.filter((h) => h.trim().endsWith("?"));
  if (questions.length < h2.length * 0.6) {
    warn(slug, `${questions.length}/${h2.length} H2s are questions, aim for most`);
  }
  if ((a.faq_items?.length ?? 0) < 5) err(slug, `${a.faq_items?.length ?? 0} FAQ items, need 5+`);

  // An FAQ question may repeat an H2: the H2 body is written for a reader and
  // the FAQ answer is a condensed standalone version for FAQPage extraction,
  // which is the point. What is not acceptable is the ANSWER being a copy of
  // the section's opening, since then the schema adds nothing.
  const sections = new Map();
  for (const part of c.split(/^## /m).slice(1)) {
    const [head, ...rest] = part.split("\n");
    sections.set(head.trim().toLowerCase(), rest.join(" ").trim());
  }
  for (const q of a.faq_items ?? []) {
    const body = sections.get((q.question ?? "").trim().toLowerCase());
    if (!body) continue;
    const opening = body.slice(0, 90).toLowerCase();
    if (opening && (q.answer ?? "").toLowerCase().startsWith(opening)) {
      warn(slug, `FAQ answer copies the section opening: "${q.question}"`);
    }
  }

  // Rule 6: sources footer.
  if (!c.includes("**Sources:**")) err(slug, "no Sources footer");

  // Rule 5: related guides, placed before the sources line.
  const rel = c.indexOf("## Related guides");
  const src = c.indexOf("**Sources:**");
  if (rel === -1) err(slug, "no Related guides block");
  else if (src !== -1 && rel > src) err(slug, "Related guides sits after Sources");

  for (const target of c.match(/\]\(\/([a-z0-9-]+)\)/g) ?? []) {
    const t = target.slice(3, -1);
    inbound.set(t, (inbound.get(t) ?? 0) + 1);
  }
}

// Rule 5: every article needs a way in.
for (const slug of slugs) {
  if (!inbound.has(slug)) warn(slug, "no inbound internal links");
}

// Internal links must resolve to a queued article or an existing published one.
for (const [target] of inbound) {
  if (!slugs.has(target)) warnings.push(`link target /${target} is not in the queue (fine if already published)`);
}

// Schedule entries with no article behind them.
for (const slug of Object.keys(schedule)) {
  if (!existsSync(join(ARTICLES, `${slug}.json`))) err(slug, "in schedule.json but has no article file");
}

console.log(`${files.length} articles checked\n`);
if (warnings.length) {
  console.log("WARNINGS");
  for (const w of warnings) console.log(`  ${w}`);
  console.log();
}
if (errors.length) {
  console.log("ERRORS");
  for (const e of errors) console.log(`  ${e}`);
  console.log(`\n${errors.length} error(s). Fix before committing.`);
  process.exit(1);
}
console.log(`No errors${warnings.length ? `, ${warnings.length} warning(s)` : ""}.`);

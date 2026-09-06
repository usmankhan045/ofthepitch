#!/usr/bin/env node
/**
 * Validates docs/PINS-FULL-BATCH.md against docs/PIN-RULES.md.
 *
 * Every check here exists because the rule it enforces was broken at least
 * once. The one that matters most is rule 9: the first ninety prompts said
 * "a headline drawn from the pin title" instead of quoting the words, so the
 * image model wrote its own copy and produced pins headlined "Good Style Lasts
 * Longer" and one about a summer wedding on an account about racecourse dress
 * codes. Nothing caught it until the images came back.
 *
 *   node scripts/validate-pins.mjs            # check
 *   node scripts/validate-pins.mjs --links    # also verify every URL is 200
 *
 * Exits non-zero on any error, so it can gate a commit.
 */

import { readFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const FILE = join(ROOT, "docs/PINS-FULL-BATCH.md");
const CHECK_LINKS = process.argv.includes("--links");

// No exemptions. Pins 1 to 12 were made before the rules existed and have
// since been brought up to them, so the whole file is held to one standard.
const EXEMPT = 0;

const TITLE_MIN = 40;
const TITLE_MAX = 60;
const DESC_MIN = 200;
const DESC_MAX = 240;
const ANGLES_MIN = 4;
const ANGLES_MAX = 6;

// Rule 1. A phrase here means the line was assembled, not written.
const BANNED = [
  /\b\d+\s+(things|ways|tips|reasons|steps|facts|rules)\b/i,
  /\bthings you need to know\b/i,
  /\bultimate guide\b/i,
  /\beverything you need to know\b/i,
  /\bwhat nobody tells you\b/i,
  /\bread more\b/i,
  /\bclick here\b/i,
  /\blearn more\b/i,
  /\bfind out more\b/i,
  /\bswipe up\b/i,
  /\bunlock\b/i,
  /\belevate\b/i,
  /\blevel up\b/i,
  /\bgame.?changer\b/i,
];

const errors = [];
const warnings = [];
const err = (n, m) => errors.push(`pin ${n}: ${m}`);
const warn = (n, m) => warnings.push(`pin ${n}: ${m}`);

const text = readFileSync(FILE, "utf8");
const blocks = text
  .split(/\n(?=## \d{4}-\d{2}-\d{2} · )/)
  .filter((b) => b.startsWith("## 20"));

if (blocks.length === 0) {
  console.error("No pins found. Has the batch file moved?");
  process.exit(1);
}

const field = (b, name) => {
  const m = b.match(new RegExp(`\\*\\*${name}\\*\\*\\n\`\`\`\\n([\\s\\S]*?)\\n\`\`\``));
  return m ? m[1].trim() : null;
};

/**
 * Two titles share a skeleton if, with their distinctive words removed, what
 * is left is the same. Catches "5 things about X" / "5 things about Y" even
 * when no banned phrase appears.
 */
const skeleton = (t) =>
  t
    .toLowerCase()
    .replace(/[^a-z ]/g, "")
    .split(/\s+/)
    .filter((w) =>
      ["the", "a", "an", "and", "or", "of", "for", "to", "in", "at", "on",
       "is", "are", "do", "does", "you", "your", "what", "which", "how",
       "can", "will", "not", "no", "it", "that", "with", "but", "if",
       "so", "as", "be", "get", "gets", "go", "goes"].includes(w)
    )
    .join(" ");

const titles = new Map();
const skeletons = new Map();
const perArticle = new Map();
const links = new Set();

blocks.forEach((b, i) => {
  const n = i + 1;
  const exempt = i < EXEMPT;

  const title = field(b, "Title");
  const desc = field(b, "Description");
  const alt = field(b, "Alt text");
  const prompt = field(b, "Prompt");
  const link = field(b, "Link");

  if (!title) return err(n, "no Title block");
  if (!desc) err(n, "no Description block");
  if (!alt) err(n, "no Alt text block");
  if (!prompt) return err(n, "no Prompt block");
  if (!link) err(n, "Link is not a copyable block");

  // Rule 1: uniqueness, across the whole account.
  if (titles.has(title)) err(n, `title duplicates pin ${titles.get(title)}`);
  titles.set(title, n);

  // A skeleton of one or two words is not a skeleton, it is coincidence.
  // Only flag where enough structure survives the stopword strip to mean
  // something.
  const sk = skeleton(title);
  if (sk.split(" ").length >= 4) {
    if (skeletons.has(sk)) {
      warn(n, `title shares a skeleton with pin ${skeletons.get(sk)}: "${sk}"`);
    } else {
      skeletons.set(sk, n);
    }
  }

  for (const re of BANNED) {
    if (re.test(title)) err(n, `banned phrase in title: ${re}`);
    if (prompt && re.test(prompt)) err(n, `banned phrase in prompt: ${re}`);
  }

  if (link) {
    links.add(link);
    const slug = link.split("/").pop();
    perArticle.set(slug, (perArticle.get(slug) ?? 0) + 1);
  }

  if (exempt) return; // scheduled before the rules existed

  // Rule 3: title length.
  if (title.length < TITLE_MIN || title.length > TITLE_MAX) {
    err(n, `title ${title.length} chars, needs ${TITLE_MIN} to ${TITLE_MAX}`);
  }
  if (title === title.toUpperCase()) err(n, "title is ALL CAPS");

  // Rule 4: description length.
  if (desc && (desc.length < DESC_MIN || desc.length > DESC_MAX)) {
    warn(n, `description ${desc.length} chars, aim 220 to 232`);
  }
  if (desc && desc.toLowerCase() === title.toLowerCase()) {
    err(n, "description restates the title");
  }

  // Rule 9: the prompt must carry every on-image word.
  if (!prompt.includes("PRINT EXACTLY THIS TEXT")) {
    err(n, "prompt does not demand literal text");
  }
  if (!prompt.includes("No other words anywhere on the image")) {
    err(n, 'prompt is missing "No other words anywhere on the image"');
  }
  if (!prompt.includes(`"${title}"`)) {
    err(n, "prompt does not quote the title verbatim");
  }
  if (/drawn from the pin title|from the description|your own headline/i.test(prompt)) {
    err(n, "prompt leaves the headline to the model");
  }

  // Rule 12: the url is the only branding.
  if (/"OP"|Of The Pitch"|wordmark|monogram/i.test(prompt)) {
    err(n, "badge or wordmark still in the prompt");
  }
  if (!prompt.includes("ofthepitch.com")) err(n, "no url line in the prompt");

  // Rule 8: the ground never varies.
  if (!prompt.includes("#FAF7F1")) err(n, "ground is not #FAF7F1");

  // Rule 10: the photograph must be specified, not left vague.
  if (!/Palette for this pin:/.test(prompt)) err(n, "no palette named");
  if (!/Photograph:/.test(prompt)) err(n, "no photograph section");
  if (/a well.dressed (wo)?man|smartly dressed person|nice outfit/i.test(prompt)) {
    err(n, "vague outfit description");
  }
  if (!/editorial/i.test(prompt)) warn(n, "prompt does not say editorial photography");

  // Words split mid-syllable by an earlier generator's character wrapping.
  const broken = prompt.match(/\b[a-z]{2,}\s+[a-z]{1,3}\b(?=[\s,.])/g) ?? [];
  for (const pair of broken) {
    const [a, b2] = pair.split(/\s+/);
    if (/^(charco|grosgrai|racecour|dayligh|blurre|structu|stewar)$/.test(a)) {
      err(n, `word broken across a line: "${pair}"`);
    }
  }
});

// Rule 2: four to six angles per article.
for (const [slug, count] of perArticle) {
  if (count < ANGLES_MIN) warn(slug, `only ${count} pins, minimum ${ANGLES_MIN}`);
  if (count > ANGLES_MAX) errors.push(`${slug}: ${count} pins, maximum ${ANGLES_MAX}`);
}

if (CHECK_LINKS) {
  console.log(`Checking ${links.size} destinations...\n`);
  for (const url of links) {
    const res = await fetch(url, { method: "HEAD" }).catch(() => null);
    if (!res || res.status !== 200) {
      errors.push(`${url} returns ${res ? res.status : "no response"}`);
    }
  }
}

console.log(`${blocks.length} pins checked (${EXEMPT} exempt, already scheduled)\n`);
if (warnings.length) {
  console.log("WARNINGS");
  for (const w of warnings) console.log(`  ${w}`);
  console.log();
}
if (errors.length) {
  console.log("ERRORS");
  for (const e of errors) console.log(`  ${e}`);
  console.log(`\n${errors.length} error(s). See docs/PIN-RULES.md.`);
  process.exit(1);
}
console.log(`No errors${warnings.length ? `, ${warnings.length} warning(s)` : ""}.`);

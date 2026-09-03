#!/usr/bin/env node
/**
 * Lists Pexels candidates for a query without downloading anything, so a
 * photograph can be checked against its title before it lands in the repo.
 * The plain search picks the top hit, which is how a handball match ended up
 * filed under tennis.
 *
 *   node --env-file=.env.local scripts/pexels-candidates.mjs "grass tennis court match"
 */

const KEY = process.env.PEXELS_API_KEY;
const query = process.argv.slice(2).join(" ");

if (!KEY || !query) {
  console.error('Usage: node --env-file=.env.local scripts/pexels-candidates.mjs "<query>"');
  process.exit(1);
}

const url = new URL("https://api.pexels.com/v1/search");
url.searchParams.set("query", query);
url.searchParams.set("orientation", "landscape");
url.searchParams.set("size", "large");
url.searchParams.set("per_page", "15");

const res = await fetch(url, { headers: { Authorization: KEY } });
if (!res.ok) {
  console.error(`Pexels error ${res.status}: ${await res.text()}`);
  process.exit(1);
}

const { photos } = await res.json();
for (const p of photos) {
  const ratio = (p.width / p.height).toFixed(2);
  // `alt` is the photographer's own description and is the most reliable
  // signal for whether the image shows what the query asked for.
  console.log(`${p.id}  ${ratio}  ${p.alt || "(no description)"}`);
}

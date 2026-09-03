#!/usr/bin/env node
/**
 * Downloads one banner photograph per sport from Pexels into
 * public/images/sports, and writes a CREDITS.md alongside them.
 *
 * The images are committed to the repo rather than hotlinked. Two reasons:
 * pages stay fast because nothing waits on a third-party host, and Pinterest
 * demotes the "Visit site" button on domains that load slowly, which is the
 * single measurable thing we know affects outbound clicks.
 *
 * Pexels licence: free for commercial use, no attribution required. We credit
 * the photographers anyway.
 *
 *   PEXELS_API_KEY=xxx node scripts/fetch-sport-images.mjs
 *   node scripts/fetch-sport-images.mjs --force   (re-download existing files)
 */

import { writeFile, mkdir, access, readdir, unlink } from "node:fs/promises";
import { createHash } from "node:crypto";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const OUT_DIR = join(ROOT, "public", "images", "sports");

// Each query is written to return a photograph of the sport as a spectator
// sees it, not a stock-looking studio shot. `orientation=landscape` matters
// because the cards crop to 16:9.
const SPORTS = [
  {
    slug: "tennis",
    // Pinned: a plain search for "tennis" returned an Olympic handball match.
    // Verified as a clay-court match. Check candidates with
    // scripts/pexels-candidates.mjs before changing an id.
    id: 38503161,
    query: "tennis match player court",
    alt: "A tennis match in progress on a clay court",
  },
  {
    slug: "horse-racing",
    // Pinned: a plain search returned harness racing (sulky carts), which is
    // the wrong discipline for a site covering Ascot and Cheltenham.
    id: 15576531,
    query: "thoroughbred horse race jockey track",
    alt: "Racehorses and jockeys mid-race in front of a crowd",
  },
  {
    slug: "formula-1",
    // Pinned: an empty circuit reads as architecture, not motorsport. This is
    // a car mid-race at Baku, and a street circuit suits a travel site.
    id: 28832062,
    query: "formula 1 car racing close up",
    alt: "A Formula 1 car at speed on a street circuit",
  },
  {
    slug: "skiing",
    // Pinned: the landscape shot had no skier in it. This is Soelden, a real
    // resort, with the skier as the subject.
    id: 11370605,
    query: "skier skiing down slope snow",
    alt: "A skier descending a piste at an alpine resort",
  },
  {
    slug: "football",
    // Pinned: the stadium shot rendered the pitch tiny and dark once cropped.
    // This has players in play and a crowd behind them.
    id: 5470351,
    query: "soccer players playing match pitch",
    alt: "Footballers competing during a match watched by a crowd",
  },
];

const KEY = process.env.PEXELS_API_KEY;
const FORCE = process.argv.includes("--force");

if (!KEY) {
  console.error(
    "PEXELS_API_KEY is not set.\n" +
      "Add it to .env.local, then run:\n" +
      "  PEXELS_API_KEY=$(grep '^PEXELS_API_KEY=' .env.local | cut -d= -f2-) node scripts/fetch-sport-images.mjs"
  );
  process.exit(1);
}

async function exists(path) {
  try {
    await access(path);
    return true;
  } catch {
    return false;
  }
}

async function byId(id) {
  const res = await fetch(`https://api.pexels.com/v1/photos/${id}`, {
    headers: { Authorization: KEY },
  });
  if (!res.ok) throw new Error(`Pexels photo ${id} failed (${res.status})`);
  return res.json();
}

async function search(query) {
  const url = new URL("https://api.pexels.com/v1/search");
  url.searchParams.set("query", query);
  url.searchParams.set("orientation", "landscape");
  url.searchParams.set("size", "large");
  url.searchParams.set("per_page", "10");

  const res = await fetch(url, { headers: { Authorization: KEY } });
  if (!res.ok) {
    throw new Error(`Pexels search failed (${res.status}): ${await res.text()}`);
  }
  const body = await res.json();
  if (!body.photos?.length) throw new Error(`No results for "${query}"`);

  // Prefer a genuinely wide photo: the card crops to 16:9, and a near-square
  // source loses most of its subject to that crop.
  const ranked = body.photos
    .map((p) => ({ photo: p, ratio: p.width / p.height }))
    .filter((p) => p.ratio >= 1.4)
    .sort((a, b) => Math.abs(a.ratio - 1.78) - Math.abs(b.ratio - 1.78));

  return (ranked[0] ?? { photo: body.photos[0] }).photo;
}

/**
 * Writes the file with a content hash in its name and returns the public path.
 * Next caches optimised images by URL, so reusing a fixed filename leaves
 * stale versions served from the build cache and from browsers that already
 * hold the page. A new hash means a new URL, which no cache can answer.
 */
async function writeHashed(slug, buffer) {
  const hash = createHash("md5").update(buffer).digest("hex").slice(0, 8);
  const name = `${slug}-${hash}.jpg`;

  // Drop earlier hashed copies of this sport so the directory stays clean.
  for (const f of await readdir(OUT_DIR)) {
    if (new RegExp(`^${slug}-[0-9a-f]{8}\\.jpg$`).test(f) && f !== name) {
      await unlink(join(OUT_DIR, f));
    }
  }

  await writeFile(join(OUT_DIR, name), buffer);
  return { name, path: `/images/sports/${name}` };
}

async function download(photo, dest) {
  // `large` is 1880px wide, plenty for a card that renders under 600px on a
  // 2x display, without committing a 5MB original.
  const src = photo.src.large2x ?? photo.src.large;
  const res = await fetch(src);
  if (!res.ok) throw new Error(`Download failed (${res.status}) for ${src}`);
  await writeFile(dest, Buffer.from(await res.arrayBuffer()));
}

async function main() {
  await mkdir(OUT_DIR, { recursive: true });
  const credits = [];

  for (const sport of SPORTS) {
    const dest = join(OUT_DIR, `${sport.slug}.jpg`);

    if (!FORCE && (await exists(dest))) {
      console.log(`skip   ${sport.slug}.jpg (exists, use --force to replace)`);
      continue;
    }

    try {
      const photo = sport.id ? await byId(sport.id) : await search(sport.query);
      await download(photo, dest);
      credits.push({ slug: sport.slug, photo });
      console.log(
        `saved  ${sport.slug}.jpg  ${photo.width}x${photo.height}  by ${photo.photographer}`
      );
    } catch (err) {
      // One failed sport should not stop the rest.
      console.error(`FAILED ${sport.slug}: ${err.message}`);
    }
  }

  if (credits.length > 0) {
    const md = [
      "# Sport banner photographs",
      "",
      "Downloaded from Pexels by `scripts/fetch-sport-images.mjs`.",
      "The Pexels licence allows commercial use with no attribution required.",
      "Photographers are credited here regardless.",
      "",
      ...credits.map(
        ({ slug, photo }) =>
          `- **${slug}** by [${photo.photographer}](${photo.photographer_url}) ` +
          `([source](${photo.url}))`
      ),
      "",
    ].join("\n");
    await writeFile(join(OUT_DIR, "CREDITS.md"), md);
    console.log("\nwrote  CREDITS.md");
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});

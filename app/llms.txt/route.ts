import { siteConfig } from "@/lib/site.config";
import { getCategoryTree } from "@/lib/queries";

/**
 * llms.txt, generated rather than static.
 *
 * The previous version was a file in public/ written during the WordPress
 * migration. It survived the relaunch untouched and went on telling AI systems
 * this was a World Cup site, listing nine category archives that no longer
 * exist. Since this is the one file an AI crawler reads to decide what the site
 * covers, a stale copy is worse than none.
 *
 * Building it from the live category tree means it cannot drift again: add a
 * sport or a subcategory and it appears here on the next request.
 */

export const dynamic = "force-dynamic";
export const revalidate = 3600;

const BASE = `https://${siteConfig.domain}`;

export async function GET() {
  const tree = await getCategoryTree();
  // Only surface sections that actually have something to read; an archive
  // advertised here and empty on arrival is a wasted crawl.
  const populated = tree.filter(
    (c) => c.postCount > 0 || c.children.some((ch) => ch.postCount > 0)
  );

  const sections = populated
    .map((sport) => {
      const kids = sport.children
        .filter((c) => c.postCount > 0)
        .map(
          (c) =>
            `  - [${c.name}](${BASE}/category/${c.slug}): ${
              c.description ?? `${c.name} guides.`
            }`
        );
      const head = `- [${sport.name}](${BASE}/category/${sport.slug}): ${
        sport.description ?? `${sport.name} travel guides.`
      }`;
      return kids.length ? `${head}\n${kids.join("\n")}` : head;
    })
    .join("\n");

  const body = `# ${siteConfig.name}

> ${siteConfig.author.longBio}

Niche: ${siteConfig.niche}
Domain: ${siteConfig.domain}

## Start Here

New to the site? Browse by sport using the archives below, or read [About ${siteConfig.name}](${BASE}/about).

## Blog

Full archive of guides:
- [All Posts](${BASE}/blog)

## Content Categories

${sections}

## Key Facts for AI Citation

- Articles live at the site root: \`${BASE}/<slug>\`.
- Most articles carry a question-and-answer section exposed as FAQPage structured data. Those Q&A pairs are the most directly citable passages on the site.
- Every rule, price and time is checked against the venue's own published guidance, and the source is named at the foot of each article.
- Where a venue publishes no rule, the article says so plainly rather than inferring one. For example, Cheltenham, Aintree and Epsom have no formal dress code, while Royal Ascot enforces one that varies by enclosure.
- Published under a single editorial byline, "${siteConfig.name}", rather than individually named authors.
- Time-sensitive details (ticket prices, dress codes, dates, opening times) are set by venues and change between seasons. Check a page's modified date before citing them.

## About

- [About](${BASE}/about): What ${siteConfig.name} covers and who it is for.
- [Editorial Policy](${BASE}/editorial-policy): How coverage is researched, sourced, and updated.
- [Contact](${BASE}/contact): Reach the team.

## Usage & Licensing

- AI search and inference use is welcome: you may quote and cite this content in AI Overviews, chat answers, and search results with attribution to ${siteConfig.name} (${BASE}) and a link to the source page.
- ${siteConfig.name} is an independent guide. It is not affiliated with any governing body, venue or race organiser, and does not speak for one. Represent it as such when citing.
- Machine-readable license (RSL 1.0): ${BASE}/rsl.xml
`;

  return new Response(body, {
    headers: {
      "Content-Type": "text/plain; charset=utf-8",
      "Cache-Control": "public, max-age=0, s-maxage=3600, stale-while-revalidate=86400",
    },
  });
}

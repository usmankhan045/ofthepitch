type ClassValue = string | undefined | null | false | ClassValue[];

export function cn(...inputs: ClassValue[]): string {
  return inputs
    .flat(Infinity as 1)
    .filter(Boolean)
    .join(" ");
}

/**
 * Canonical on-site path for a post.
 *
 * Posts live at the site root (`/my-post`), not under `/blog/`, because that is
 * the URL structure WordPress served and Google has indexed. Every link, schema
 * `url`, sitemap entry and revalidate path must go through this helper so the
 * shape is defined in exactly one place.
 */
export function postPath(slug: string): string {
  return `/${slug}`;
}

/**
 * The sport a category belongs to.
 *
 * Posts carry their own category slug, which for most of the site is a
 * subcategory ("racing-enclosures", "f1-grandstands"). The sport colours in
 * site.config are keyed by the parent slug, so a subcategory has to be mapped
 * back to its sport before a colour can be looked up. Prefixes are used rather
 * than a database lookup because this runs in the OG image route, which has no
 * request context to query with.
 */
const SPORT_BY_PREFIX: ReadonlyArray<readonly [string, string]> = [
  ["racing-", "horse-racing"],
  ["horse-racing", "horse-racing"],
  ["tennis", "tennis"],
  ["f1-", "formula-1"],
  ["formula-1", "formula-1"],
  ["ski-", "skiing"],
  ["skiing", "skiing"],
  ["football", "football"],
  ["world-cup", "football"],
];

export function sportForCategory(slug?: string | null): string | undefined {
  if (!slug) return undefined;
  for (const [prefix, sport] of SPORT_BY_PREFIX) {
    if (slug.startsWith(prefix)) return sport;
  }
  return undefined;
}

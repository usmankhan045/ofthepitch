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

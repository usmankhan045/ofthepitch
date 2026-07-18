import type { MetadataRoute } from "next";
import { siteConfig } from "@/lib/site.config";
import { getPublishedPosts, getCategories } from "@/lib/queries";
import { postPath } from "@/lib/utils";

const BASE_URL = `https://${siteConfig.domain}`;

// Generate at request time, NOT at build time. Post rows come from Supabase; a
// build-time prerender that lacks DB env would silently ship a sitemap with only
// the static routes. Rendering at runtime guarantees the DB env is present, so
// every post is listed.
export const dynamic = "force-dynamic";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  // Static/listing pages deliberately omit `lastModified`: setting it to the
  // request time (which never correlates with a real content change) trains
  // Google to distrust the whole sitemap's lastmod signal. Only pages with a
  // real DB timestamp (posts) carry lastModified.
  const staticRoutes: MetadataRoute.Sitemap = [
    { url: BASE_URL, changeFrequency: "weekly", priority: 1.0 },
    { url: `${BASE_URL}/blog`, changeFrequency: "daily", priority: 0.9 },
    { url: `${BASE_URL}/about`, changeFrequency: "monthly", priority: 0.5 },
    { url: `${BASE_URL}${siteConfig.author.url}`, changeFrequency: "monthly", priority: 0.4 },
    { url: `${BASE_URL}/editorial-policy`, changeFrequency: "yearly", priority: 0.3 },
    { url: `${BASE_URL}/affiliate-disclosure`, changeFrequency: "yearly", priority: 0.3 },
    { url: `${BASE_URL}/contact`, changeFrequency: "yearly", priority: 0.3 },
  ];

  // Dynamic: posts and categories — fall back to empty if DB not configured
  let postRoutes: MetadataRoute.Sitemap = [];
  let categoryRoutes: MetadataRoute.Sitemap = [];

  try {
    const posts = await getPublishedPosts({ limit: 1000 });
    postRoutes = posts.map((post) => ({
      url: `${BASE_URL}${postPath(post.slug)}`,
      lastModified: post.updated_at,
      changeFrequency: "weekly" as const,
      priority: 0.8,
    }));
  } catch (err) {
    // Never silently swallow — a failure here drops every post from the sitemap.
    console.error("[sitemap] failed to load posts:", err);
  }

  try {
    const categories = await getCategories();
    categoryRoutes = categories.map((cat) => ({
      url: `${BASE_URL}/category/${cat.slug}`,
      changeFrequency: "weekly" as const,
      priority: 0.7,
    }));
  } catch (err) {
    console.error("[sitemap] failed to load categories:", err);
  }


  return [...staticRoutes, ...postRoutes, ...categoryRoutes];
}

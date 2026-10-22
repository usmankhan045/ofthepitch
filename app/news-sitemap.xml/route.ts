import { getPublishedPosts } from "@/lib/queries";
import { siteConfig } from "@/lib/site.config";
import { postPath } from "@/lib/utils";
import { escapeXml } from "@/lib/xml";

export const dynamic = "force-dynamic";

const BASE_URL = `https://${siteConfig.domain}`;

export async function GET() {
  const cutoff = new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString();
  let posts: Awaited<ReturnType<typeof getPublishedPosts>> = [];

  try {
    posts = await getPublishedPosts({ publishedSince: cutoff, limit: 1000 });
  } catch (error) {
    console.error("[news-sitemap] failed to load posts:", error);
  }

  const urls = posts
    .filter((post) => post.published_at)
    .map(
      (post) => `  <url>
    <loc>${escapeXml(`${BASE_URL}${postPath(post.slug)}`)}</loc>
    <news:news>
      <news:publication>
        <news:name>${escapeXml(siteConfig.name)}</news:name>
        <news:language>en</news:language>
      </news:publication>
      <news:publication_date>${escapeXml(post.published_at!)}</news:publication_date>
      <news:title>${escapeXml(post.title)}</news:title>
    </news:news>
  </url>`
    )
    .join("\n");

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:news="http://www.google.com/schemas/sitemap-news/0.9">
${urls}
</urlset>`;

  return new Response(xml, {
    headers: {
      "Content-Type": "application/xml; charset=utf-8",
      "Cache-Control": "public, max-age=0, s-maxage=300, stale-while-revalidate=300",
    },
  });
}

import { getPublishedPosts } from "@/lib/queries";
import { siteConfig } from "@/lib/site.config";
import { postPath } from "@/lib/utils";
import { escapeCdata, escapeXml } from "@/lib/xml";

export const dynamic = "force-dynamic";

const BASE_URL = `https://${siteConfig.domain}`;

function articleHtml(content: string | null, excerpt: string | null): string {
  const text = content?.trim() || excerpt?.trim() || "";
  return `<div>${escapeXml(text).replace(/\n/g, "<br />")}</div>`;
}

export async function GET() {
  let posts: Awaited<ReturnType<typeof getPublishedPosts>> = [];
  try {
    posts = await getPublishedPosts({ limit: 50 });
  } catch (error) {
    console.error("[feed] failed to load posts:", error);
  }

  const items = posts
    .map((post) => {
      const url = `${BASE_URL}${postPath(post.slug)}`;
      const published = post.published_at ?? post.created_at;
      return `    <item>
      <title>${escapeXml(post.title)}</title>
      <link>${escapeXml(url)}</link>
      <guid isPermaLink="true">${escapeXml(url)}</guid>
      <pubDate>${new Date(published).toUTCString()}</pubDate>
      <dc:creator>${escapeXml(siteConfig.author.name)}</dc:creator>
      ${post.categories ? `<category>${escapeXml(post.categories.name)}</category>` : ""}
      <description>${escapeXml(post.excerpt ?? "")}</description>
      <content:encoded><![CDATA[${escapeCdata(articleHtml(post.content, post.excerpt))}]]></content:encoded>
    </item>`;
    })
    .join("\n");

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:atom="http://www.w3.org/2005/Atom"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>${escapeXml(siteConfig.name)}</title>
    <link>${BASE_URL}</link>
    <description>${escapeXml(siteConfig.niche)}</description>
    <language>en</language>
    <atom:link href="${BASE_URL}/feed.xml" rel="self" type="application/rss+xml" />
${items}
  </channel>
</rss>`;

  return new Response(xml, {
    headers: {
      "Content-Type": "application/rss+xml; charset=utf-8",
      "Cache-Control": "public, max-age=0, s-maxage=900, stale-while-revalidate=3600",
    },
  });
}

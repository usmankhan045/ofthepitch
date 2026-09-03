import { siteConfig } from "./site.config";

/**
 * Open Graph / Twitter image helpers. Next.js does NOT deep-merge `openGraph`
 * across segments — any route that defines its own `openGraph` REPLACES the
 * layout default, dropping the inherited image. So every route that sets
 * openGraph must supply images explicitly. These helpers keep that consistent.
 * Relative URLs resolve against `metadataBase` (set in app/layout.tsx).
 */
const DEFAULT_OG_IMAGE = "/og-default.jpg";

export function ogImages(
  url: string | null | undefined = DEFAULT_OG_IMAGE,
  alt: string = `${siteConfig.name}: ${siteConfig.tagline}`
) {
  const resolved = url ?? DEFAULT_OG_IMAGE;
  return [
    {
      url: resolved,
      width: 1200,
      height: 630,
      alt,
      // /api/og re-encodes to JPEG before returning, so everything this
      // helper serves is JPEG apart from an uploaded .png.
      type: resolved.endsWith(".png") ? "image/png" : "image/jpeg",
    },
  ];
}

export function twitterImages(url: string | null | undefined = DEFAULT_OG_IMAGE) {
  return {
    card: "summary_large_image" as const,
    images: [url ?? DEFAULT_OG_IMAGE],
  };
}

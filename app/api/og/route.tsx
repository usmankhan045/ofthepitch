import { ImageResponse } from "next/og";
import type { NextRequest } from "next/server";

import { siteConfig } from "@/lib/site.config";

/**
 * Generated preview card, used whenever a post has no featured image.
 *
 * Rendered by Satori, which supports a subset of CSS: FLEXBOX ONLY — no grid —
 * and every element that has more than one child needs an explicit `display`.
 * Keep it to the Matchday design language: flat colour, hard offset shadow,
 * no gradients or blurs.
 */

const { colors } = siteConfig.theme;

export const contentType = "image/png";

const SIZE = { width: 1200, height: 630 };

/** Long titles need to step down a size or they overflow the card. */
function titleSize(title: string): number {
  if (title.length > 110) return 46;
  if (title.length > 75) return 56;
  if (title.length > 45) return 68;
  return 78;
}

export async function GET(request: NextRequest) {
  const sp = request.nextUrl.searchParams;

  const rawTitle = sp.get("title")?.trim() || siteConfig.name;
  // Hard cap so a hostile or accidental mega-title can't blow up rendering.
  const title = rawTitle.slice(0, 160);
  const label = sp.get("label")?.trim().slice(0, 40);

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
          backgroundColor: colors.background,
          padding: 64,
          // The ink outline that defines the site's flat, stamped look.
          border: `12px solid ${colors.text}`,
        }}
      >
        {/* Top row: monogram + optional category chip */}
        <div style={{ display: "flex", alignItems: "center", gap: 20 }}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              width: 72,
              height: 72,
              backgroundColor: colors.primary,
              color: "#FFFFFF",
              fontSize: 34,
              fontWeight: 700,
              borderRadius: 14,
            }}
          >
            {siteConfig.brand.monogram}
          </div>

          {label ? (
            <div
              style={{
                display: "flex",
                backgroundColor: colors.accent,
                color: colors.text,
                fontSize: 22,
                fontWeight: 700,
                letterSpacing: 2,
                textTransform: "uppercase",
                padding: "10px 20px",
                borderRadius: 999,
              }}
            >
              {label}
            </div>
          ) : null}
        </div>

        {/* Title */}
        <div
          style={{
            display: "flex",
            fontSize: titleSize(title),
            fontWeight: 800,
            lineHeight: 1.08,
            color: colors.text,
            letterSpacing: -1.5,
            // Satori has no line-clamp; the size step-down above is the guard.
            maxWidth: 1000,
          }}
        >
          {title}
        </div>

        {/* Bottom rule + wordmark */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            borderTop: `4px solid ${colors.line}`,
            paddingTop: 28,
          }}
        >
          <div
            style={{
              display: "flex",
              fontSize: 28,
              fontWeight: 700,
              color: colors.primary,
            }}
          >
            {siteConfig.domain}
          </div>
          <div
            style={{
              display: "flex",
              fontSize: 22,
              color: colors.muted,
              letterSpacing: 1,
            }}
          >
            {siteConfig.tagline}
          </div>
        </div>
      </div>
    ),
    {
      ...SIZE,
      headers: {
        // Deterministic output for a given query string, so it caches hard.
        "Cache-Control": "public, max-age=31536000, immutable",
      },
    }
  );
}

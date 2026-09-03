import { ImageResponse } from "next/og";
import type { NextRequest } from "next/server";

import { siteConfig } from "@/lib/site.config";
import { sportForCategory } from "@/lib/utils";

/**
 * Generated preview card, used whenever a post has no featured image.
 *
 * Rendered by Satori, which supports a subset of CSS: FLEXBOX ONLY — no grid,
 * no line-clamp, no CSS variables — and every element with more than one child
 * needs an explicit `display`.
 *
 * The card is a dark ink panel so it holds its own against the photographs on
 * the sport cards, with the sport's colour carried by the rail down the left
 * edge, the eyebrow dot and the arc motif. Cards for the same sport therefore
 * read as a set without any of them repeating a photograph.
 */

const { colors, sports } = siteConfig.theme;

export const contentType = "image/png";

// 1200x630 is the Open Graph standard and is what social scrapers expect.
// Post cards on the site render into a 16:10 box, though, and cropping a
// 1.91:1 image to 1.6:1 with object-cover shaves ~16% off each side, which
// took the first character of every title and clipped the footer rule. The
// `ratio` parameter lets the card be drawn at the shape it will be displayed
// in instead of being cropped into it.
const SIZES = {
  og: { width: 1200, height: 630 },   // social / meta tags
  card: { width: 1200, height: 750 }, // 16:10, the on-site post card
} as const;

/** Long titles step down a size rather than overflow: Satori cannot clamp. */
function titleSize(title: string): number {
  if (title.length > 110) return 44;
  if (title.length > 80) return 52;
  if (title.length > 52) return 62;
  if (title.length > 30) return 72;
  return 80;
}

/**
 * The arc motif, echoing the loop in the site's mark. Drawn as three nested
 * rings with a dot riding the innermost one, so it reads as motion rather than
 * decoration. Stroke-only, so it never competes with the title.
 */
function Arcs({ tint, d, top }: { tint: string; d: number; top: number }) {
  return (
    <svg
      width={d}
      height={d}
      viewBox="0 0 200 200"
      style={{ position: "absolute", right: 64, top }}
    >
      <circle cx="100" cy="100" r="92" fill="none" stroke="#FFFFFF" strokeOpacity="0.10" strokeWidth="2" />
      <path d="M100 8 A92 92 0 0 1 192 100" fill="none" stroke={tint} strokeWidth="7" strokeLinecap="round" />
      <circle cx="100" cy="100" r="64" fill="none" stroke="#FFFFFF" strokeOpacity="0.14" strokeWidth="2" />
      <path d="M100 36 A64 64 0 0 1 164 100" fill="none" stroke={tint} strokeOpacity="0.55" strokeWidth="6" strokeLinecap="round" />
      <circle cx="164" cy="100" r="11" fill={tint} />
    </svg>
  );
}

export async function GET(request: NextRequest) {
  const sp = request.nextUrl.searchParams;

  const rawTitle = sp.get("title")?.trim() || siteConfig.name;
  // Hard cap so a hostile or accidental mega-title cannot blow up rendering.
  const title = rawTitle.slice(0, 160);
  const label = sp.get("label")?.trim().slice(0, 40);
  const kicker = sp.get("kicker")?.trim().slice(0, 28);
  const size = sp.get("ratio") === "card" ? SIZES.card : SIZES.og;

  // The sport's colour, resolved from the category slug so subcategories
  // inherit their parent's hue. Amber is the fallback for anything unmapped.
  const sport = sportForCategory(sp.get("category"));
  const tint = (sport && sports[sport]) || colors.accent;

  const ink = "#141210";

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          backgroundColor: ink,
          color: "#FFFFFF",
          position: "relative",
          overflow: "hidden",
        }}
      >
        {/* The sport's colour as a rail down the leading edge. */}
        <div style={{ display: "flex", width: 14, backgroundColor: tint }} />

        <Arcs
          tint={tint}
          d={size.height * 0.62}
          top={(size.height - size.height * 0.62) / 2}
        />

        <div
          style={{
            display: "flex",
            flexDirection: "column",
            justifyContent: "space-between",
            flex: 1,
            padding: "58px 64px",
          }}
        >
          {/* Eyebrow: a dot in the sport's colour, then the category. */}
          <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
            <div style={{ display: "flex", width: 14, height: 14, borderRadius: 999, backgroundColor: tint }} />
            <div
              style={{
                display: "flex",
                fontSize: 21,
                fontWeight: 700,
                letterSpacing: 3,
                textTransform: "uppercase",
                color: "rgba(255,255,255,0.62)",
              }}
            >
              {label || siteConfig.name}
            </div>
          </div>

          <div style={{ display: "flex", flexDirection: "column", maxWidth: 660 }}>
            <div
              style={{
                display: "flex",
                fontSize: titleSize(title),
                fontWeight: 800,
                lineHeight: 1.06,
                letterSpacing: -2,
              }}
            >
              {title}
            </div>

            {kicker ? (
              <div
                style={{
                  display: "flex",
                  alignSelf: "flex-start",
                  marginTop: 26,
                  padding: "9px 18px",
                  borderRadius: 999,
                  backgroundColor: tint,
                  color: ink,
                  fontSize: 20,
                  fontWeight: 700,
                }}
              >
                {kicker}
              </div>
            ) : null}
          </div>

          {/* Foot: wordmark left, positioning line right. */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              borderTop: "1px solid rgba(255,255,255,0.14)",
              paddingTop: 24,
            }}
          >
            <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  width: 34,
                  height: 34,
                  borderRadius: 9,
                  backgroundColor: tint,
                  color: ink,
                  fontSize: 17,
                  fontWeight: 800,
                }}
              >
                {siteConfig.brand.monogram}
              </div>
              <div style={{ display: "flex", fontSize: 24, fontWeight: 700 }}>
                {siteConfig.name}
              </div>
            </div>
            <div style={{ display: "flex", fontSize: 19, color: "rgba(255,255,255,0.5)" }}>
              {siteConfig.tagline}
            </div>
          </div>
        </div>
      </div>
    ),
    {
      ...size,
      headers: {
        // Deterministic for a given query string, so it caches hard.
        "Cache-Control": "public, max-age=31536000, immutable",
      },
    }
  );
}

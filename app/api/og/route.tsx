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
 * The card is paper, the same warm off-white the site itself is built on, so a
 * preview sitting in a listing reads as part of the page rather than a black
 * rectangle dropped into it. An earlier version was a dark ink panel with an
 * arc motif; it predated the palette and clashed with every surface around it.
 *
 * Structure is a wide sport-coloured band down the left edge carrying the
 * category vertically, then the title on paper, then a rule and the wordmark.
 * The band is what makes a row of these read as a set: same shape every time,
 * a different colour per sport.
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
 * The sport's name set very large and very pale in the upper area. It fills
 * what was dead space, reinforces the category a second time, and unlike a
 * small graphic motif it cannot be misread as a smudge at thumbnail size.
 */
function Watermark({ text, tint }: { text: string; tint: string }) {
  return (
    <div
      style={{
        position: "absolute",
        right: 58,
        top: 40,
        display: "flex",
        fontSize: 132,
        fontWeight: 800,
        letterSpacing: -5,
        color: tint,
        opacity: 0.12,
        textTransform: "uppercase",
      }}
    >
      {text}
    </div>
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

  const paper = colors.background;   // #F6F3ED, the site's own ground
  const ink = colors.text;           // #181512
  const muted = colors.muted;        // #6E6558
  const rule = colors.line;          // #E1DACD

  // The band carries the category vertically. It is wide enough to be the
  // card's defining shape rather than a stripe, which is what lets a row of
  // these read as a set: identical geometry, one colour per sport.
  const band = Math.round(size.height * 0.155);

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          backgroundColor: paper,
          color: ink,
          position: "relative",
          overflow: "hidden",
        }}
      >
        {/* Sport band, with the category set vertically inside it. */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            width: band,
            backgroundColor: tint,
          }}
        >
          <div
            style={{
              display: "flex",
              transform: "rotate(-90deg)",
              whiteSpace: "nowrap",
              fontSize: 25,
              fontWeight: 700,
              letterSpacing: 8,
              textTransform: "uppercase",
              color: "rgba(255,255,255,0.94)",
            }}
          >
            {label || siteConfig.name}
          </div>
        </div>

        <Watermark text={sport ? sport.replace(/-/g, " ") : "sport"} tint={tint} />

        <div
          style={{
            display: "flex",
            flexDirection: "column",
            justifyContent: "flex-end",
            flex: 1,
            padding: "58px 66px 52px 62px",
          }}
        >
          {/* A short colour rule opens the card, echoing the band. */}
          <div style={{ display: "flex", width: 76, height: 7, backgroundColor: tint }} />

          {/* Pushes the title toward the foot, leaving the watermark the
              upper area. Not flush: the gap below the rule is deliberate. */}
          <div style={{ display: "flex", flex: 1 }} />

          <div style={{ display: "flex", flexDirection: "column", maxWidth: 790 }}>
            <div
              style={{
                display: "flex",
                fontSize: titleSize(title),
                fontWeight: 800,
                lineHeight: 1.05,
                letterSpacing: -2,
                color: ink,
              }}
            >
              {title}
            </div>

            {kicker ? (
              <div
                style={{
                  display: "flex",
                  alignSelf: "flex-start",
                  marginTop: 28,
                  padding: "10px 20px",
                  borderRadius: 999,
                  backgroundColor: tint,
                  color: "#FFFFFF",
                  fontSize: 21,
                  fontWeight: 700,
                }}
              >
                {kicker}
              </div>
            ) : null}
          </div>

          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              borderTop: `2px solid ${rule}`,
              marginTop: 40,
              paddingTop: 26,
            }}
          >
            <div style={{ display: "flex", alignItems: "baseline", gap: 12 }}>
              <div style={{ display: "flex", fontSize: 27, fontWeight: 800, color: ink }}>
                {siteConfig.name}
              </div>
              <div style={{ display: "flex", fontSize: 21, color: muted }}>
                {siteConfig.domain.replace("www.", "")}
              </div>
            </div>
            <div style={{ display: "flex", fontSize: 20, color: muted }}>
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

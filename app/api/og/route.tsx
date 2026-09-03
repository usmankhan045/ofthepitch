import { ImageResponse } from "next/og";
import type { NextRequest } from "next/server";

import sharp from "sharp";

import { siteConfig } from "@/lib/site.config";
import { sportForCategory } from "@/lib/utils";

export const runtime = "nodejs";

/**
 * Generated preview card, used whenever a post has no featured image.
 *
 * Rendered by Satori, which supports a subset of CSS: FLEXBOX ONLY — no grid,
 * no line-clamp, no CSS variables — and every element with more than one child
 * needs an explicit `display`.
 *
 * The card is the sport's own photograph under a dark scrim, with the title
 * set large across the lower half and a coloured rule tying it to the sport.
 *
 * Two earlier versions failed for reasons worth recording. A dark ink panel
 * with an arc motif predated the palette and clashed with every surface. A
 * paper-ground version then matched the site too well: the card's background
 * and the page's background were the same colour, so the card dissolved into
 * the listing and had no edge at all. A photograph solves both, and it also
 * fixes the real legibility problem, which is that these render at about
 * 530px wide on a category page, not the 1200px they are drawn at.
 */

const { colors, sports } = siteConfig.theme;

export const contentType = "image/jpeg";

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
  if (title.length > 110) return 58;
  if (title.length > 80) return 66;
  if (title.length > 52) return 76;
  if (title.length > 30) return 88;
  return 96;
}

/**
 * Absolute URL for the sport's card photograph. Satori cannot read from the
 * filesystem, so the image is fetched over HTTP like any other remote asset.
 *
 * These are NOT the files in theme.sportImages. Those are 1880px JPEGs, 322 to
 * 605KB each, sized for the full-bleed sport cards on the homepage. Feeding one
 * to Satori made a single 1.8MB preview card, because the whole source was
 * decoded and then re-encoded into the output. public/images/cards holds the
 * same photographs pre-cropped to exactly 1200x750 at quality 68, 101 to 155KB,
 * which is all the card can ever display and roughly a third of the bytes.
 * They sit under a heavy scrim, so the quality drop is invisible.
 *
 * Not WebP: Satori decodes PNG and JPEG only, and hands back a card with no
 * photograph at all if given anything else. It fails silently in the rendered
 * output and only says so in the server log.
 */
/**
 * How many photographs exist per sport in public/images/cards. A sport with
 * more than one is numbered `<sport>-1.jpg` upward; a sport with one is just
 * `<sport>.jpg`. Fifteen racing articles sharing a single image made a listing
 * look broken, so racing has four and the rest get more as they are sourced.
 * Keep this in step with the directory: a count higher than the files present
 * produces cards with no photograph.
 */
const PHOTO_COUNT: Record<string, number> = {
  "horse-racing": 4,
};

function photoFor(
  sport: string | undefined,
  origin: string,
  title: string
): string | null {
  if (!sport) return null;
  const n = PHOTO_COUNT[sport] ?? 1;
  if (n === 1) return `${origin}/images/cards/${sport}.jpg`;

  // Derived from the title so a post always gets the same photograph, because
  // the card is cached for a year and has to be stable rather than random.
  //
  // Three title-derived functions were tried and all three clustered over a
  // set this small: a 31-multiplier hash gave one photograph to eight of
  // fifteen posts and never picked the fourth, a character sum put nine on
  // one image, and title length was worse again. Fifteen titles about the
  // same subject are simply not varied enough to spread across four buckets
  // by any property of the string.
  //
  // Counting distinct words instead: it correlates with nothing about the
  // photographs, varies more than length, and is still perfectly stable for
  // a given title.
  const words = new Set(title.toLowerCase().match(/[a-z]+/g) ?? []).size;
  return `${origin}/images/cards/${sport}-${(words % n) + 1}.jpg`;
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

  const ink = colors.text;
  const photo = photoFor(sport, request.nextUrl.origin, title);

  const png = new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          position: "relative",
          backgroundColor: ink,
          overflow: "hidden",
        }}
      >
        {/* The sport's photograph fills the card. */}
        {photo ? (
          // eslint-disable-next-line @next/next/no-img-element, jsx-a11y/alt-text
          <img
            src={photo}
            width={size.width}
            height={size.height}
            style={{
              position: "absolute",
              top: 0,
              left: 0,
              width: size.width,
              height: size.height,
              objectFit: "cover",
            }}
          />
        ) : null}

        {/* Scrim: light at the top so the photograph reads, heavy at the foot
            so the title always has contrast whatever the image behind it. */}
        <div
          style={{
            position: "absolute",
            top: 0,
            left: 0,
            width: size.width,
            height: size.height,
            display: "flex",
            backgroundImage: `linear-gradient(to bottom, rgba(16,14,12,0.28) 0%, rgba(16,14,12,0.52) 42%, rgba(16,14,12,0.88) 100%)`,
          }}
        />

        {/* Sport colour along the foot, the one constant across every card. */}
        <div
          style={{
            position: "absolute",
            left: 0,
            bottom: 0,
            width: size.width,
            height: 12,
            display: "flex",
            backgroundColor: tint,
          }}
        />

        <div
          style={{
            display: "flex",
            flexDirection: "column",
            justifyContent: "flex-end",
            width: size.width,
            height: size.height,
            padding: "64px 68px 64px 68px",
          }}
        >
          {/* Category, in the sport's colour, above the title. */}
          <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
            <div style={{ display: "flex", width: 46, height: 6, backgroundColor: tint }} />
            <div
              style={{
                display: "flex",
                fontSize: 30,
                fontWeight: 700,
                letterSpacing: 5,
                textTransform: "uppercase",
                color: "#FFFFFF",
              }}
            >
              {label || siteConfig.name}
            </div>
          </div>

          <div
            style={{
              display: "flex",
              marginTop: 22,
              fontSize: titleSize(title),
              fontWeight: 800,
              lineHeight: 1.04,
              letterSpacing: -2,
              color: "#FFFFFF",
              maxWidth: 1010,
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
                padding: "12px 24px",
                borderRadius: 999,
                backgroundColor: tint,
                color: "#FFFFFF",
                fontSize: 26,
                fontWeight: 700,
              }}
            >
              {kicker}
            </div>
          ) : null}

          <div style={{ display: "flex", alignItems: "center", gap: 14, marginTop: 34 }}>
            <div style={{ display: "flex", fontSize: 30, fontWeight: 800, color: "#FFFFFF" }}>
              {siteConfig.name}
            </div>
            <div style={{ display: "flex", fontSize: 26, color: "rgba(255,255,255,0.72)" }}>
              {siteConfig.domain.replace("www.", "")}
            </div>
          </div>
        </div>
      </div>
    ),
    {
      ...size,
    }
  );

  // ImageResponse always encodes PNG. For a photographic card that is roughly
  // 1.8MB; the same pixels as JPEG are around 90KB. Re-encoding costs one pass
  // at generation time and the result is cached for a year, so it happens once
  // per card and never again.
  const jpeg = await sharp(Buffer.from(await png.arrayBuffer()))
    .jpeg({ quality: 82, progressive: true, mozjpeg: true })
    .toBuffer();

  return new Response(new Uint8Array(jpeg), {
    headers: {
      "Content-Type": "image/jpeg",
      // Deterministic for a given query string, so it caches hard. The
      // s-maxage line keeps it in the CDN too, so a card is rendered once
      // ever rather than once per cold serverless instance.
      "Cache-Control": "public, max-age=31536000, s-maxage=31536000, immutable",
      "CDN-Cache-Control": "public, max-age=31536000, immutable",
    },
  });
}

export const siteConfig = {
  slug: "ofthepitch",
  // Canonical host. MUST match the host the deployment actually serves with a
  // 200. WordPress served the apex directly (www 301s → apex), and every
  // migrated canonical tag points at the apex, so keep it apex-only.
  domain: "ofthepitch.com",
  // Known site_id for this tenant. Used as a resilient fallback if the runtime
  // `sites` table lookup is unavailable (e.g. build-time prerender). See
  // getCurrentSiteId() in lib/supabase.ts.
  siteId: "ed23c093-ff1e-4355-8e4a-fd1961a03587",
  name: "Of The Pitch",
  tagline: "World Cup 2026, off the pitch and on the ground",
  niche: "World Cup 2026 fan guides, travel, tickets and football culture",

  // ── AUTHORSHIP / E-E-A-T ─────────────────────────────────────────────────
  // Migrated from WordPress, where every post was bylined to a single editorial
  // account rather than a named person. Kept as-is so existing bylines and the
  // /author/ofthepitch-editorial archive keep resolving. Replacing this with a
  // real named editor is the single biggest E-E-A-T upgrade available here.
  author: {
    name: "Of The Pitch",
    slug: "ofthepitch-editorial",
    role: "Editorial Team",
    photo: "/images/author-ofthepitch.jpg",
    sameAs: [] as readonly string[],
    url: "/author/ofthepitch-editorial",
    shortBio:
      "Of The Pitch covers the 2026 World Cup from a travelling fan's point of view — visas, border crossings, fan zones, ticket prices and how to actually watch the football.",
    longBio:
      "Of The Pitch is an independent World Cup 2026 guide for fans travelling to the United States, Canada and Mexico. We cover the parts of a tournament that decide whether a trip works: entry requirements and visa waits, crossing borders between host countries, fan zone logistics, what tickets really cost, and where to watch every match. Coverage is researched against official sources — FIFA, host city authorities and national broadcasters — and updated as the tournament unfolds.",
  },

  // ── FEATURE FLAGS ────────────────────────────────────────────────────────
  // Printables are a personal-finance-template feature with no equivalent on a
  // football site. Off: /free-printables 404s and its nav item, footer link,
  // homepage CTAs and sitemap entries all disappear automatically.
  features: {
    printables: false,
  },

  // ── CONTACT + LEGAL IDENTITY ─────────────────────────────────────────────
  contact: {
    // The address published on the migrated WordPress contact page.
    email: "info@ofthepitch.com",
    privacyEmail: "info@ofthepitch.com",
  },
  legal: {
    lastUpdated: "July 18, 2026",
    // Football coverage is not YMYL — the finance disclaimer would be both
    // wrong and confusing here. Affiliate disclosure is the relevant one.
    disclaimer:
      "Of The Pitch is an independent fan guide and is not affiliated with FIFA or any national football association.",
  },
  brand: {
    monogram: "OP",
    foundedYear: 2026,
  },

  // ── THEME — "Matchday" ───────────────────────────────────────────────────
  // Pitch green and floodlight white with a warm amber highlight: the colours
  // of an evening kickoff. Same flat, ink-outlined system as the template —
  // depth comes from hard offset shadows, not gradients.
  theme: {
    colors: {
      primary:    "#0B6B3A", // Pitch Green — nav, buttons, panels
      accent:     "#F5A524", // Floodlight Amber — headline marks, chips, blobs
      background: "#FBFAF7", // Chalk White — warm paper white
      text:       "#12211A", // Boot Black — near-black with a green undertone
      muted:      "#5B6661", // Touchline Grey — secondary copy
      success:    "#1E8A6E", // Goal Green — positive states

      primaryDark: "#074A28", // pressed/hover state for primary surfaces
      surface:     "#FFFFFF", // cards and panels on the chalk base
      line:        "#E6E3DB", // hairline rules between sections
    },
    fonts: {
      display: "Bricolage Grotesque",
      body:    "Hanken Grotesk",
      mono:    "Geist Mono",
    },
    radius: "1rem",
  },

  // Mirrors the WordPress primary menu so the migrated site keeps the same
  // top-level shape. Category hrefs match the /category/<slug> archives that
  // are already indexed.
  nav: [
    { label: "Home", href: "/" },

    { label: "Blog", href: "/blog" },
    { label: "Visa & Immigration", href: "/category/visa-immigration" },
    { label: "Tickets", href: "/category/tickets-and-hospitality" },
    { label: "Fan Zones", href: "/category/fan-zone-guide" },
    { label: "About", href: "/about" },
  ],

  footerLinks: [
    { label: "About", href: "/about" },
    { label: "Editorial Policy", href: "/editorial-policy" },
    { label: "Affiliate Disclosure", href: "/affiliate-disclosure" },
    { label: "Contact", href: "/contact" },
    // WordPress served these at /privacy-policy-2 and /terms-of-service. Those
    // URLs 301 here (see next.config.ts) because the pages in app/ are far more
    // complete than the short WP copy, and legal pages carry little ranking
    // weight, so the redirect costs nothing.
    { label: "Privacy Policy", href: "/privacy-policy" },
    { label: "Terms of Use", href: "/terms-of-use" },
  ],

  // No social accounts migrated from WordPress yet. Typed so components can
  // keep referencing individual networks while the object is empty.
  social: {} as { pinterest?: string; x?: string; instagram?: string },

  // Only real reader quotes belong here. Empty = the homepage section hides.
  testimonials: [
    // { quote: "…", name: "…", context: "…" },
  ] as ReadonlyArray<{ quote: string; name: string; context: string }>,

  // AUDIENCE SEGMENTS — the template this repo was forked from used these to
  // generate audience hub pages at the site root. Of The Pitch organises by
  // category instead, and the root path is now reserved for migrated post
  // slugs, so this is intentionally empty. See app/[slug]/page.tsx.
  audienceSegments: [] as ReadonlyArray<{
    slug: string;
    label: string;
    tag: string;
    headline: string;
    tone: string;
    startHereLabel: string;
  }>,
} as const;

export type SiteConfig = typeof siteConfig;
export type AudienceSegment = SiteConfig["audienceSegments"][number];

/**
 * Nav links with feature-flagged items removed. When `features.printables` is
 * false, the "/free-printables" entry is dropped so the flag is the single
 * source of truth — components should render from this, not `siteConfig.nav`.
 */
export const navLinks: ReadonlyArray<{ label: string; href: string }> = (
  siteConfig.nav as ReadonlyArray<{ label: string; href: string }>
).filter(
  (link) => siteConfig.features.printables || link.href !== "/free-printables"
);

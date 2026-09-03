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
  tagline: "Going to the sport in person",
  niche: "Sports travel guides for tennis, racing, Formula 1, skiing and football. Dress codes, tickets, venues and what a trip really costs.",

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
      "Of The Pitch covers what a venue actually enforces, what a ticket tier really includes, where to stay, and what the day costs.",
    longBio:
      "Of The Pitch is an independent guide to attending tennis, horse racing, Formula 1, skiing and football. We cover the parts that decide whether a trip works. What a venue's dress code actually enforces versus what people assume. Which enclosure or grandstand a ticket really admits you to. How to get there, where to stay, and what the day genuinely costs. Every rule is checked against the venue's own published guidance, and we say plainly when a venue has no rule at all.",
  },

  // ── FEATURE FLAGS ────────────────────────────────────────────────────────
  // Printables: free checklists and planners for travelling fans, served at
  // /printables and attachable to posts. Off: those routes 404 and the nav
  // item and sitemap entries disappear.
  features: {
    printables: true,
  },

  // ── CONTACT + LEGAL IDENTITY ─────────────────────────────────────────────
  contact: {
    // The address published on the migrated WordPress contact page.
    email: "info@ofthepitch.com",
    privacyEmail: "info@ofthepitch.com",
  },
  legal: {
    lastUpdated: "July 18, 2026",
    // Football coverage is not YMYL, the finance disclaimer would be both
    // wrong and confusing here. Affiliate disclosure is the relevant one.
    disclaimer:
      "Of The Pitch is an independent guide and is not affiliated with any governing body, venue, race organiser or event. Dress codes and ticket terms are set by venues and change. Always check the venue's own published guidance before you travel.",
  },
  brand: {
    monogram: "OP",
    foundedYear: 2026,
  },

  // ── THEME, "Enclosure" ──────────────────────────────────────────────────
  // The old palette was pitch green, correct for a World Cup site, wrong for
  // one that also covers Ascot, Wimbledon, Monaco and Courchevel. This reads
  // premium across all five sports without belonging to any single one:
  // a deep racing ink, warm brass, and a soft paper ground borrowed from
  // racecard and programme stock. Same flat, ink-outlined system, depth comes
  // from hard offset shadows, not gradients.
  theme: {
    colors: {
      primary:    "#181512", // Ink, nav, headings and panels
      accent:     "#E8A317", // Gold, the headline swipe and primary button
      background: "#F6F3ED", // Paper, warm off-white programme stock
      text:       "#181512", // Ink black, body copy
      muted:      "#6E6558", // Paddock grey, secondary copy
      success:    "#2F8F5B", // Turf green, positive states

      primaryDark: "#0D0B09", // pressed and hover state for primary surfaces
      surface:     "#FFFFFF", // cards and panels on the paper base
      line:        "#E1DACD", // hairline rules between sections

      // Gold is a light surface, so it cannot carry small text on paper.
      // accentInk is the same hue darkened for type: eyebrows, links, labels.
      accentInk:   "#8A5B06",
    },
    // One colour per sport. Cards, chips and category rules take their hue
    // from here so a reader can identify a sport before reading the label.
    sports: {
      "horse-racing": "#CF5A2E",
      "tennis":       "#2F8F5B",
      "formula-1":    "#D22C1F",
      "skiing":       "#2A87B4",
      "football":     "#7458C9",
    } as Record<string, string>,

    // Banner photograph per sport, served from public/images/sports. Files are
    // committed rather than hotlinked so the pages stay fast and do not depend
    // on a third party staying up. Credits live in the same directory.
    sportImages: {
      "tennis":        "/images/sports/tennis-870ab7a1.jpg",
      "horse-racing":  "/images/sports/horse-racing-a74f53fb.jpg",
      "formula-1":     "/images/sports/formula-1-32e8c438.jpg",
      "skiing":        "/images/sports/skiing-ccd0176f.jpg",
      "football":      "/images/sports/football-109146fe.jpg",
    } as Record<string, string>,
    fonts: {
      display: "Bricolage Grotesque",
      body:    "Hanken Grotesk",
      mono:    "Geist Mono",
    },
    radius: "1rem",
  },

  // Top level is now the sport, not the tournament. The old football category
  // archives (visa-immigration, tickets-and-hospitality, fan-zone-guide) are
  // still indexed and still resolve, they simply moved out of the primary nav
  // and under /category/football. Never delete those archives or their slugs.
  nav: [
    { label: "Home", href: "/" },
    { label: "Blog", href: "/blog" },
    { label: "Tennis", href: "/category/tennis" },
    { label: "Racing", href: "/category/horse-racing" },
    { label: "Formula 1", href: "/category/formula-1" },
    { label: "Skiing", href: "/category/skiing" },
    { label: "Football", href: "/category/football" },
    // Dropped from `navLinks` when features.printables is false.
    { label: "Printables", href: "/printables" },
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

  // AUDIENCE SEGMENTS, the template this repo was forked from used these to
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
 * false, the "/printables" entry is dropped so the flag is the single
 * source of truth, components should render from this, not `siteConfig.nav`.
 */
export const navLinks: ReadonlyArray<{ label: string; href: string }> = (
  siteConfig.nav as ReadonlyArray<{ label: string; href: string }>
).filter(
  (link) => siteConfig.features.printables || link.href !== "/printables"
);

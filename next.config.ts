import type { NextConfig } from "next";

// Content-Security-Policy tuned for this app:
// - 'unsafe-inline' on script/style is required because the App Router emits
//   inline bootstrap scripts and we inject theme CSS + JSON-LD inline (no nonce
//   pipeline). frame-ancestors 'self' still blocks clickjacking.
// - img/frame allow same-origin + Supabase storage (remote images, PDF preview).
const csp = [
  "default-src 'self'",
  "script-src 'self' 'unsafe-inline'",
  "style-src 'self' 'unsafe-inline'",
  "img-src 'self' data: blob: https:",
  "font-src 'self' data:",
  "connect-src 'self' https://*.supabase.co",
  "frame-src 'self' https://*.supabase.co",
  "object-src 'none'",
  "base-uri 'self'",
  "form-action 'self'",
  "frame-ancestors 'self'",
  "upgrade-insecure-requests",
].join("; ");

const securityHeaders = [
  { key: "Content-Security-Policy", value: csp },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "X-Frame-Options", value: "SAMEORIGIN" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=()" },
  {
    key: "Strict-Transport-Security",
    value: "max-age=63072000; includeSubDomains; preload",
  },
];

const nextConfig: NextConfig = {
  images: {
    formats: ["image/avif", "image/webp"],
    remotePatterns: [
      {
        protocol: "https",
        hostname: "**.supabase.co",
        pathname: "/storage/v1/object/public/**",
      },
    ],
  },
  // Printables created remotely through HQ live in Supabase Storage rather than
  // in this repo. A `fallback` rewrite only runs when no static file matched, so
  // the printables committed under public/printables keep being served straight
  // from the CDN, and only the ones that aren't there fall through to storage.
  // Both end up at /printables/<slug>.pdf, so the split is invisible to visitors
  // and no printable ever needs a commit or a redeploy.
  async rewrites() {
    return {
      fallback: [
        {
          source: "/printables/:path*",
          destination:
            "https://ruucexzgebbehjcrinhj.supabase.co/storage/v1/object/public/printables/ofthepitch/:path*",
        },
      ],
    };
  },

  async headers() {
    return [
      {
        source: "/:path*",
        headers: securityHeaders,
      },
    ];
  },
  // ── WordPress migration redirects ──────────────────────────────────────────
  // Posts now live at the site root, matching the URLs WordPress served and
  // Google indexed. These cover the two paths that did change.
  async redirects() {
    return [
      // The template rendered posts under /blog/<slug>; that shape was never
      // public on ofthepitch.com, but redirect it so any internal or pasted
      // link lands on the canonical URL instead of a 404.
      {
        source: "/blog/:slug",
        destination: "/:slug",
        permanent: true,
      },
      // WordPress nested the contact page under its "home" parent, so
      // /home/contact/ is the indexed URL. Point it at the canonical /contact.
      {
        source: "/home/contact",
        destination: "/contact",
        permanent: true,
      },
      // "/home" was the WP homepage duplicate; the real homepage is "/".
      {
        source: "/home",
        destination: "/",
        permanent: true,
      },
      // WordPress's legal slugs. The pages in app/ are far more complete than
      // the short WP copy, so those URLs point here rather than the other way
      // round. Legal pages carry little ranking weight, so the 301 is cheap.
      {
        source: "/privacy-policy-2",
        destination: "/privacy-policy",
        permanent: true,
      },
      {
        source: "/terms-of-service",
        destination: "/terms-of-use",
        permanent: true,
      },

      // ── Football consolidation, September 2026 ────────────────────────────
      // The nine World Cup category archives were merged into a single
      // /category/world-cup-2026 archive. Every one of those slugs was indexed
      // in Search Console, so they 301 into the archive rather than 404. The
      // posts themselves never moved: post URLs sit at the site root and do
      // not contain the category, so no article URL changed.
      ...[
        "team-reviews",
        "viewing-guides",
        "controversy-and-politics",
        "visa-immigration",
        "fan-zone-guide",
        "fan-travel-and-logistics",
        "fan-travel-logistics",
        "tickets-and-hospitality",
        "general",
        "celebrity-clashes-latest-news",
      ].map((slug) => ({
        source: `/category/${slug}`,
        destination: "/category/world-cup-2026",
        permanent: true,
      })),

      // Two WordPress posts cover the same topic and were competing with each
      // other for the same query. The 8.1k-character version is folded into
      // the 10.6k one, which is the more complete page. Consolidating beats
      // leaving both to split their own signals.
      {
        source: "/var-referee-controversy-world-cup-2026",
        destination: "/world-cup-2026-referee-var-controversy",
        permanent: true,
      },
    ];
  },
};

export default nextConfig;

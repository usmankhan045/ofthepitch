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
    ];
  },
};

export default nextConfig;

import Link from "next/link";
import { siteConfig } from "@/lib/site.config";
import { Container } from "@/components/ui";
import type { NavItem } from "@/lib/settings";

// Social SVGs — inlined to avoid a package dependency.
function PinterestIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden
    >
      <path d="M12 0C5.373 0 0 5.373 0 12c0 5.084 3.163 9.426 7.627 11.174-.105-.949-.2-2.405.042-3.441.218-.937 1.407-5.965 1.407-5.965s-.359-.719-.359-1.782c0-1.668.967-2.914 2.171-2.914 1.023 0 1.518.769 1.518 1.69 0 1.029-.655 2.568-.994 3.995-.283 1.194.599 2.169 1.777 2.169 2.133 0 3.772-2.249 3.772-5.495 0-2.873-2.064-4.882-5.012-4.882-3.414 0-5.418 2.561-5.418 5.207 0 1.031.397 2.138.893 2.738a.36.36 0 0 1 .083.345l-.333 1.36c-.053.22-.174.267-.402.161-1.499-.698-2.436-2.889-2.436-4.649 0-3.785 2.75-7.262 7.929-7.262 4.163 0 7.398 2.967 7.398 6.931 0 4.136-2.607 7.464-6.227 7.464-1.216 0-2.359-.632-2.75-1.378l-.748 2.853c-.271 1.043-1.002 2.35-1.492 3.146C9.57 23.812 10.763 24 12 24c6.627 0 12-5.373 12-12S18.627 0 12 0z" />
    </svg>
  );
}

function XIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden
    >
      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24h-6.65l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231 5.45-6.231zm-1.161 17.52h1.833L7.084 4.126H5.117L17.083 19.77z" />
    </svg>
  );
}

function InstagramIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden
    >
      <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
    </svg>
  );
}

export interface FooterProps {
  name?: string;
  tagline?: string;
  social?: { pinterest?: string; x?: string; instagram?: string };
  footerLinks?: readonly NavItem[];
}

// Brand, tagline, footer links and social handles default to site.config.ts but
// are overridden by the admin Settings screen — the root layout passes the
// resolved settings in. Without this the Settings screen was a silent no-op.
export function Footer({
  name = siteConfig.name,
  tagline = siteConfig.tagline,
  social = siteConfig.social,
  footerLinks = siteConfig.footerLinks,
}: FooterProps = {}) {
  const year = new Date().getFullYear();

  return (
    // The footer is the one full-bleed ink surface on the site — it closes the
    // page the way the 2px outlines close every card.
    <footer className="relative overflow-hidden bg-text text-white border-t-2 border-text">
      {/* Lime blob bleeding in from the right, echoing the hero panel. */}
      <div
        aria-hidden
        className="pointer-events-none absolute -top-24 -right-20 w-64 h-64 rounded-full bg-accent/10"
      />
      <Container className="relative">

        {/* ── Main grid ──────────────────────────────────────────────────── */}
        <div className="pt-8 pb-6 grid grid-cols-2 lg:grid-cols-3 gap-x-8 gap-y-6 lg:gap-x-12">

          {/* Column 1: Brand */}
          <div className="col-span-2 lg:col-span-1">
            <Link
              href="/"
              className="group flex items-center gap-2 mb-2"
            >
              <span
                className="relative w-6 h-6 rounded-[7px] bg-primary border-2 border-white/25 shrink-0 transition-transform duration-150 group-hover:-rotate-6"
                aria-hidden
              >
                <span className="absolute inset-[4px] rounded-full bg-accent" />
              </span>
              <span className="font-display text-lg font-extrabold tracking-[-0.03em] text-white">
                {name}
              </span>
            </Link>
            <p className="text-white/65 text-[0.8rem] leading-snug mb-2">
              {tagline}
            </p>

            {/* Authorship credit — E-E-A-T + links the author archive */}
            <p className="text-white/50 text-[0.7rem] mb-3">
              Written &amp; edited by{" "}
              <Link
                href={siteConfig.author.url}
                className="text-white/75 hover:text-white underline underline-offset-2 transition-colors"
              >
                {siteConfig.author.name}
              </Link>
            </p>

            {/* Social links — only those set in Settings render */}
            <div className="flex items-center gap-3">
              {social.pinterest && (
                <a
                  href={social.pinterest}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label={`${name} on Pinterest`}
                  className="p-2 rounded-full bg-white/10 text-white/70 hover:bg-accent hover:text-text transition-colors"
                >
                  <PinterestIcon />
                </a>
              )}
              {social.x && (
                <a
                  href={social.x}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label={`${name} on X`}
                  className="p-2 rounded-full bg-white/10 text-white/70 hover:bg-accent hover:text-text transition-colors"
                >
                  <XIcon />
                </a>
              )}
              {social.instagram && (
                <a
                  href={social.instagram}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label={`${name} on Instagram`}
                  className="p-2 rounded-full bg-white/10 text-white/70 hover:bg-accent hover:text-text transition-colors"
                >
                  <InstagramIcon />
                </a>
              )}
            </div>
          </div>

          {/* Column 2: Navigation */}
          <div>
            <p className="stamp text-accent mb-2.5">
              Navigation
            </p>
            <ul className="space-y-1.5">
              {footerLinks.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="block leading-tight text-[0.8rem] text-white/65 hover:text-white transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 3: Explore — situation hubs for quick navigation */}
          <div>
            <p className="stamp text-accent mb-2.5">
              Explore
            </p>
            <ul className="space-y-1.5">
              <li>
                <Link href="/blog" className="block leading-tight text-[0.8rem] text-white/65 hover:text-white transition-colors">
                  Blog
                </Link>
              </li>
              {siteConfig.audienceSegments.map((seg) => (
                <li key={seg.slug}>
                  <Link
                    href={`/${seg.slug}`}
                    className="block leading-tight text-[0.8rem] text-white/65 hover:text-white transition-colors"
                  >
                    {seg.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

        </div>

        {/* ── Bottom bar ─────────────────────────────────────────────────── */}
        <div className="border-t border-white/15 py-3 flex flex-col sm:flex-row items-center justify-between gap-1 text-[0.7rem] text-white/45">
          <p>© {year} {name}. All rights reserved.</p>
          <p>{siteConfig.legal.disclaimer}</p>
        </div>

      </Container>
    </footer>
  );
}

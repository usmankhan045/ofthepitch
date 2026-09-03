"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { siteConfig, navLinks } from "@/lib/site.config";
import { cn } from "@/lib/utils";
import { Container } from "@/components/ui";

type CategoryLink = { slug: string; name: string };

/** A sport with the subcategories filed under it, used by the mega menu. */
export type NavSport = {
  slug: string;
  name: string;
  postCount: number;
  children: Array<{ slug: string; name: string; description: string | null; postCount: number }>;
};

// Icons as tiny SVGs, no package dependency needed for two shapes.
function MenuIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="22"
      height="22"
      viewBox="0 0 22 22"
      fill="none"
      aria-hidden
    >
      <path d="M3 6h16M3 11h16M3 16h16" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" />
    </svg>
  );
}

function CloseIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="22"
      height="22"
      viewBox="0 0 22 22"
      fill="none"
      aria-hidden
    >
      <path d="M5 5l12 12M17 5L5 17" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" />
    </svg>
  );
}

function ChevronIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="14"
      height="14"
      viewBox="0 0 14 14"
      fill="none"
      aria-hidden
    >
      <path d="M3.5 5.25L7 8.75l3.5-3.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

type NavItem = { label: string; href: string };

/**
 * Nav hrefs come from admin settings and may point off-site. Only a same-origin
 * path gets client-side `<Link>` routing and active-state highlighting; anything
 * carrying a scheme (`https:`, `mailto:`, `tel:`) or a protocol-relative `//`
 * opens as a plain external anchor. Routing an absolute URL through `<Link>` and
 * `pathname.startsWith()` would break both navigation and the active state.
 */
function isInternalHref(href: string): boolean {
  return href.startsWith("/") && !href.startsWith("//");
}

/**
 * `nav` and `name` are supplied by the root layout from the admin Settings
 * screen. Both default to site.config.ts, so the header renders identically if
 * settings are unavailable or nothing has been overridden.
 */
export function Header({
  categories = [],
  sports = [],
  nav = navLinks,
  name = siteConfig.name,
}: {
  categories?: CategoryLink[];
  sports?: NavSport[];
  nav?: readonly NavItem[];
  name?: string;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [mobileCatOpen, setMobileCatOpen] = useState(false); // mobile accordion
  const pathname = usePathname();

  // Which sport's mega menu is open. Null when none is.
  const [openSport, setOpenSport] = useState<string | null>(null);
  const sportBySlug = new Map(sports.map((sp) => [`/category/${sp.slug}`, sp]));

  const close = useCallback(() => setIsOpen(false), []);

  // Close everything on route change
  useEffect(() => {
    setIsOpen(false);
    setOpenSport(null);
    setMobileCatOpen(false);
  }, [pathname]);

  // Close on Escape
  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        close();
        setOpenSport(null);
      }
    };
    document.addEventListener("keydown", handleKey);
    return () => document.removeEventListener("keydown", handleKey);
  }, [close]);

  // Lock body scroll when mobile drawer open
  useEffect(() => {
    document.body.style.overflow = isOpen ? "hidden" : "";
    return () => { document.body.style.overflow = ""; };
  }, [isOpen]);

  return (
    <header className="sticky top-0 z-50 border-b border-line bg-[color-mix(in_srgb,var(--color-background)_86%,transparent)] backdrop-blur-[14px] backdrop-saturate-150">
      <Container>
        <div className="grid grid-cols-[1fr_auto_1fr] items-center h-20 gap-6">

          {/* Wordmark. The last word takes gold ink so the name carries the
              brand colour without a separate logo object. */}
          <Link
            href="/"
            className="group flex items-center shrink-0"
            aria-label={`${name} home`}
          >
            <span className="font-display text-[1.35rem] font-extrabold tracking-[-0.045em] text-text">
              {name.split(" ").slice(0, -1).join(" ")}{" "}
              <span className="text-accent-ink">{name.split(" ").slice(-1)}</span>
            </span>
          </Link>

          {/* ── Desktop nav ──────────────────────────────────────────────── */}
          <nav className="hidden md:flex items-center justify-center gap-1" aria-label="Main navigation">
            {nav.map((link) => {
              const internal = isInternalHref(link.href);
              const isActive =
                internal &&
                (link.href === "/"
                  ? pathname === "/"
                  : pathname.startsWith(link.href));
              const linkClass = cn(
                "relative px-3.5 py-2 rounded-lg text-[0.95rem] font-semibold transition-colors duration-150",
                "after:absolute after:left-3.5 after:right-3.5 after:bottom-1 after:h-[2px] after:rounded-full",
                isActive
                  ? "text-text after:bg-accent"
                  : "text-muted hover:text-text hover:bg-text/[0.05] after:bg-transparent"
              );
              const navLink = internal ? (
                <Link key={link.href} href={link.href} className={linkClass}>
                  {link.label}
                </Link>
              ) : (
                <a
                  key={link.href}
                  href={link.href}
                  target="_blank"
                  rel="noopener noreferrer"
                  className={linkClass}
                >
                  {link.label}
                </a>
              );

              // A sport in the nav opens a mega menu on hover listing the
              // subcategories filed under it. Sports with no subcategories
              // behave as ordinary links.
              const sport = sportBySlug.get(link.href);
              if (sport && sport.children.length > 0) {
                const isMenuOpen = openSport === sport.slug;
                const sportColour =
                  siteConfig.theme.sports[sport.slug] ?? "var(--color-text)";
                return (
                  <div
                    key={link.href}
                    className="relative"
                    onMouseEnter={() => setOpenSport(sport.slug)}
                    onMouseLeave={() => setOpenSport(null)}
                  >
                    <Link
                      href={link.href}
                      className={linkClass}
                      aria-haspopup="true"
                      aria-expanded={isMenuOpen}
                    >
                      {link.label}
                    </Link>

                    {isMenuOpen && (
                      <div className="absolute left-1/2 -translate-x-1/2 top-full pt-3 z-50">
                        <div
                          role="menu"
                          className={cn(
                            "w-[24rem] overflow-hidden rounded-2xl bg-surface",
                            "shadow-[inset_0_0_0_1px_var(--color-line),0_24px_50px_-24px_rgb(24_21_18/0.34)]",
                            "animate-[rise_180ms_cubic-bezier(0.23,1,0.32,1)_forwards]"
                          )}
                        >
                          {/* Header band carries the sport colour so the panel is
                              identifiable before any label is read. */}
                          <div
                            className="flex items-baseline justify-between px-4 py-3"
                            style={{ background: sportColour, color: "#fff" }}
                          >
                            <span className="font-display text-[0.98rem] font-extrabold tracking-[-0.03em]">
                              {sport.name}
                            </span>
                            <span className="stamp opacity-80">
                              {sport.postCount} {sport.postCount === 1 ? "guide" : "guides"}
                            </span>
                          </div>

                          <div className="p-1.5">
                            {sport.children.map((child) => (
                              <Link
                                key={child.slug}
                                href={`/category/${child.slug}`}
                                role="menuitem"
                                className="group/mi relative block rounded-xl px-3 py-2.5 transition-colors duration-150 hover:bg-text/[0.04]"
                              >
                                {/* Colour rule appears on hover, matching the
                                    homepage picker rows. */}
                                <span
                                  aria-hidden
                                  className="absolute left-0 inset-y-1.5 w-[3px] rounded-full origin-center scale-y-0 transition-transform duration-200 group-hover/mi:scale-y-100"
                                  style={{ background: sportColour }}
                                />
                                <span className="flex items-baseline justify-between gap-3">
                                  <span className="text-[0.9rem] font-semibold text-text">
                                    {child.name}
                                  </span>
                                  <span className="font-mono text-[11px] text-muted tabular-nums shrink-0">
                                    {child.postCount}
                                  </span>
                                </span>
                                {child.description && (
                                  <span className="mt-0.5 block text-xs leading-snug text-muted line-clamp-2">
                                    {child.description}
                                  </span>
                                )}
                              </Link>
                            ))}
                          </div>

                          <Link
                            href={link.href}
                            className="flex items-center justify-between gap-2 border-t border-line px-4 py-3 transition-colors duration-150 hover:bg-text/[0.03]"
                          >
                            <span className="stamp" style={{ color: sportColour }}>
                              All {sport.name}
                            </span>
                            <span aria-hidden style={{ color: sportColour }}>
                              &rarr;
                            </span>
                          </Link>
                        </div>
                      </div>
                    )}
                  </div>
                );
              }

              return navLink;
            })}
          </nav>

          {/* ── Hamburger ────────────────────────────────────────────────── */}
          <button
            className={cn(
              "md:hidden justify-self-end p-2 rounded-full transition-colors cursor-pointer",
              "text-text shadow-[inset_0_0_0_1.5px_var(--color-line)] bg-surface",
              "hover:bg-accent",
              "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary"
            )}
            onClick={() => setIsOpen((v) => !v)}
            aria-label={isOpen ? "Close menu" : "Open menu"}
            aria-expanded={isOpen}
            aria-controls="mobile-nav"
          >
            {isOpen ? <CloseIcon /> : <MenuIcon />}
          </button>
          {/* Balances the grid so the nav is centred on the page, not on the
              space left over beside the wordmark. */}
          <span className="hidden md:block" aria-hidden />

        </div>
      </Container>

      {/* ── Mobile nav drawer ────────────────────────────────────────────── */}
      {isOpen && (
        <div
          id="mobile-nav"
          className="md:hidden border-t border-line bg-background"
        >
          <Container>
            <nav
              className="py-4 flex flex-col gap-0.5"
              aria-label="Mobile navigation"
            >
              {nav.map((link) => {
                const internal = isInternalHref(link.href);
                const isActive =
                  internal &&
                  (link.href === "/"
                    ? pathname === "/"
                    : pathname.startsWith(link.href));
                const linkClass = cn(
                  "px-4 py-3 rounded-full text-base font-medium transition-colors",
                  isActive
                    ? "text-text bg-accent"
                    : "text-text hover:bg-text/[0.06]"
                );
                const navLink = internal ? (
                  <Link key={link.href} href={link.href} className={linkClass}>
                    {link.label}
                  </Link>
                ) : (
                  <a
                    key={link.href}
                    href={link.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className={linkClass}
                  >
                    {link.label}
                  </a>
                );

                // A sport expands to show its subcategories inline.
                const mSport = sportBySlug.get(link.href);
                if (mSport && mSport.children.length > 0) {
                  const expanded = openSport === mSport.slug;
                  return (
                    <div key={link.href} className="flex flex-col gap-0.5">
                      <div className="flex items-center gap-1">
                        <Link href={link.href} className={cn(linkClass, "flex-1")}>
                          {link.label}
                        </Link>
                        <button
                          type="button"
                          onClick={() => setOpenSport(expanded ? null : mSport.slug)}
                          className="p-3 rounded-lg text-muted hover:text-text hover:bg-text/[0.05] cursor-pointer"
                          aria-expanded={expanded}
                          aria-label={`${expanded ? "Hide" : "Show"} ${mSport.name} sections`}
                        >
                          <ChevronIcon
                            className={cn("transition-transform duration-150", expanded && "rotate-180")}
                          />
                        </button>
                      </div>
                      {expanded && (
                        <div className="flex flex-col gap-0.5 pl-3 mb-1 border-l border-line ml-4">
                          {mSport.children.map((child) => (
                            <Link
                              key={child.slug}
                              href={`/category/${child.slug}`}
                              className="flex items-baseline justify-between gap-3 px-4 py-2.5 rounded-lg text-[15px] text-muted hover:text-text hover:bg-text/[0.05] transition-colors"
                            >
                              <span>{child.name}</span>
                              <span className="font-mono text-[11px] tabular-nums shrink-0">
                                {child.postCount}
                              </span>
                            </Link>
                          ))}
                        </div>
                      )}
                    </div>
                  );
                }

                return navLink;
              })}
            </nav>
          </Container>
        </div>
      )}
    </header>
  );
}

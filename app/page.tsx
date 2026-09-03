import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { getPublishedPosts, getCategoryTree, type Post } from "@/lib/queries";
import {
  Button,
  Card,
  Tag,
  SectionDivider,
  Container,
} from "@/components/ui";
import { cn } from "@/lib/utils";
import { siteConfig } from "@/lib/site.config";
import { PostCard } from "@/components/PostCard";
import { Testimonials } from "@/components/Testimonials";
import { ogImages, twitterImages } from "@/lib/metadata";

// ISR: regenerate at runtime so real posts/categories from Supabase render even
// when the build environment lacks DB access (otherwise the page freezes on the
// placeholder content shipped at build time, and every card links to /blog).
export const revalidate = 3600;

export const metadata: Metadata = {
  title: {
    absolute: "Of The Pitch: guides to going to the sport in person",
  },
  description:
    "Independent guides to attending tennis, horse racing, Formula 1, skiing and football. What a venue enforces, what a ticket includes, where to stay and what the day costs.",
  alternates: { canonical: "/" },
  openGraph: {
    url: "/",
    type: "website",
    title: "Of The Pitch: guides to going to the sport in person",
    description:
      "Independent guides to attending tennis, horse racing, Formula 1, skiing and football. Dress codes, tickets, venues and what a trip costs.",
    images: ogImages(),
  },
  twitter: twitterImages(),
};

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder posts, shown when the DB is not yet configured or has no content.
// These mirror real published articles so the fallback view is representative;
// they link to /blog rather than a slug (see PostCard).
// ─────────────────────────────────────────────────────────────────────────────
const PLACEHOLDER_POSTS: Post[] = [
  {
    id: "ph-1",
    slug: "world-cup-2026-ticket-price-controversy",
    title: "FIFA World Cup 2026 Ticket Price Controversy",
    excerpt:
      "Dynamic pricing, resale platforms and supporter group pushback. What the row over World Cup 2026 ticket prices is actually about, and what it means if you are still trying to buy.",
    content: null, quick_answer: null, featured_image_url: null,
    category_id: null, status: "published",
    seo_title: null, seo_description: null, faq_items: [],
    audience_tags: [],
    published_at: "2026-03-04T00:00:00Z",
    created_at: "2026-03-04T00:00:00Z",
    updated_at: "2026-03-04T00:00:00Z",
    categories: { slug: "controversy-and-politics", name: "Controversy & Politics" },
  },
  {
    id: "ph-2",
    slug: "world-cup-2026-visa-entry-denial-controversy",
    title: "World Cup 2026 Visa and Entry Denial Controversy",
    excerpt:
      "Fans from several countries have reported long waits and refusals at the visa stage. Here is how entry decisions work across the three host nations, and what a denial leaves you with.",
    content: null, quick_answer: null, featured_image_url: null,
    category_id: null, status: "published",
    seo_title: null, seo_description: null, faq_items: [],
    audience_tags: [],
    published_at: "2026-03-19T00:00:00Z",
    created_at: "2026-03-19T00:00:00Z",
    updated_at: "2026-03-19T00:00:00Z",
    categories: { slug: "visa-immigration", name: "Visa & Immigration" },
  },
  {
    id: "ph-3",
    slug: "boston-to-new-york-world-cup-2026",
    title: "Boston to New York World Cup 2026: Train, Bus and Drive",
    excerpt:
      "The Northeast corridor is the most-travelled hop of the tournament. Compare Amtrak, intercity buses and driving on time, cost and how late you can leave it on a match day.",
    content: null, quick_answer: null, featured_image_url: null,
    category_id: null, status: "published",
    seo_title: null, seo_description: null, faq_items: [],
    audience_tags: [],
    published_at: "2026-04-08T00:00:00Z",
    created_at: "2026-04-08T00:00:00Z",
    updated_at: "2026-04-08T00:00:00Z",
    categories: { slug: "fan-travel-and-logistics", name: "Fan Travel & Logistics" },
  },
  {
    id: "ph-4",
    slug: "how-to-watch-world-cup-2026-usa",
    title: "How to Watch World Cup 2026 in the USA: Fox Sports, Telemundo",
    excerpt:
      "Which matches land on broadcast, which sit behind a streaming tier, and how the English and Spanish-language rights split. A plain guide to watching from inside the United States.",
    content: null, quick_answer: null, featured_image_url: null,
    category_id: null, status: "published",
    seo_title: null, seo_description: null, faq_items: [],
    audience_tags: [],
    published_at: "2026-05-02T00:00:00Z",
    created_at: "2026-05-02T00:00:00Z",
    updated_at: "2026-05-02T00:00:00Z",
    categories: { slug: "viewing-guides", name: "Viewing Guides" },
  },
];

// ─────────────────────────────────────────────────────────────────────────────
// § Hero artifact, the sport picker.
//
// The one job the hero must do is tell a first-time visitor which sports this
// site covers. It deliberately shows no guide counts: four of the five sports
// read zero until their first article publishes, and a column of zeroes on the
// homepage advertises the gaps rather than the coverage. Each row takes its
// sport colour from site.config.
// ─────────────────────────────────────────────────────────────────────────────

const SPORT_ROWS: { slug: string; label: string; note: string }[] = [
  { slug: "horse-racing", label: "Horse Racing", note: "Ascot, Cheltenham, the Derby" },
  { slug: "tennis",       label: "Tennis",       note: "All four slams" },
  { slug: "formula-1",    label: "Formula 1",    note: "Circuit by circuit" },
  { slug: "skiing",       label: "Skiing",       note: "Both hemispheres" },
  { slug: "football",     label: "Football",     note: "Matchdays and the World Cup archive" },
];

function SportPicker() {
  return (
    <div className="w-full">
      <div className="flex items-baseline px-1 pb-2">
        <span className="stamp text-muted">Pick your sport</span>
      </div>

      <div className="flex flex-col gap-2">
        {SPORT_ROWS.map((row) => {
          const colour = siteConfig.theme.sports[row.slug];
          return (
            <Link
              key={row.slug}
              href={`/category/${row.slug}`}
              style={{ "--sport": colour } as React.CSSProperties}
              className={cn(
                "group/row relative grid grid-cols-[2.75rem_1fr_auto] items-center gap-4",
                "rounded-xl bg-surface px-4 py-3.5 overflow-hidden",
                "shadow-[inset_0_0_0_1px_var(--color-line)]",
                "transition-[transform,box-shadow] duration-300 ease-[cubic-bezier(0.23,1,0.32,1)]",
                "hover:translate-x-1.5",
                "hover:shadow-[inset_0_0_0_1px_color-mix(in_srgb,var(--sport)_40%,var(--color-line)),0_12px_26px_-14px_color-mix(in_srgb,var(--sport)_55%,transparent)]",
                "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent-ink"
              )}
            >
              {/* Colour rule down the left edge, grows to full height on hover. */}
              <span
                aria-hidden
                className="absolute left-0 inset-y-0 w-[3px] origin-center scale-y-[0.3] bg-[var(--sport)] transition-transform duration-300 ease-[cubic-bezier(0.23,1,0.32,1)] group-hover/row:scale-y-100"
              />
              {/* Colour wash sweeping in from the left. */}
              <span
                aria-hidden
                className="absolute inset-0 opacity-0 transition-opacity duration-300 group-hover/row:opacity-100"
                style={{
                  background:
                    "linear-gradient(90deg, color-mix(in srgb, var(--sport) 11%, transparent), transparent 58%)",
                }}
              />

              <span className="relative font-mono text-xs font-semibold text-center rounded-lg py-1.5 text-[var(--sport)] bg-text/[0.04] shadow-[inset_0_0_0_1px_var(--color-line)] transition-[background-color,color,transform] duration-300 group-hover/row:bg-[var(--sport)] group-hover/row:text-white group-hover/row:-rotate-6 group-hover/row:shadow-none">
                {String(SPORT_ROWS.indexOf(row) + 1).padStart(2, "0")}
              </span>

              <span className="relative min-w-0">
                <span className="block font-semibold text-[0.97rem] text-text tracking-[-0.02em]">
                  {row.label}
                </span>
                <span className="block text-xs text-muted mt-0.5 truncate">{row.note}</span>
              </span>

              <span
                aria-hidden
                className="relative grid place-items-center min-w-[1.6rem] text-muted transition-[color,transform] duration-300 group-hover/row:text-[var(--sport)] group-hover/row:translate-x-1"
              >
                &rarr;
              </span>
            </Link>
          );
        })}
      </div>
    </div>
  );
}

function CategoryCard({
  category,
}: {
  category: { slug: string; name: string; description: string | null; postCount: number };
}) {
  const sport = siteConfig.theme.sports[category.slug];
  const image = siteConfig.theme.sportImages[category.slug];

  return (
    <Link
      href={`/category/${category.slug}`}
      className="group block h-full focus-visible:outline-none"
      aria-label={`Browse ${category.name}`}
      style={{ "--sport": sport ?? "var(--color-text)" } as React.CSSProperties}
    >
      {/* The photograph is the card, not a thumbnail sitting inside one. Copy
          reads over a scrim at the bottom, which is where the image is darkest
          and where the eye lands last. */}
      <article
        className={cn(
          "relative h-full min-h-[17rem] overflow-hidden rounded-2xl isolate",
          "shadow-[inset_0_0_0_1px_var(--color-line)]",
          "transition-[transform,box-shadow] duration-[400ms] ease-[cubic-bezier(0.23,1,0.32,1)]",
          "group-hover:-translate-y-1.5",
          "group-hover:shadow-[inset_0_0_0_1px_color-mix(in_srgb,var(--sport)_45%,transparent),0_24px_48px_-24px_color-mix(in_srgb,var(--sport)_60%,transparent),0_10px_20px_-14px_rgb(24_21_18/0.3)]",
          "group-focus-visible:outline-2 group-focus-visible:outline-offset-2 group-focus-visible:outline-accent-ink"
        )}
      >
        {image && (
          <Image
            src={image}
            alt=""
            fill
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
            className="object-cover transition-transform duration-[700ms] ease-[cubic-bezier(0.23,1,0.32,1)] group-hover:scale-[1.06]"
          />
        )}

        {/* Sport colour, multiplied into the photo so five different images
            still read as one set. It lifts on hover, revealing the photo. */}
        <span
          aria-hidden
          className="absolute inset-0 mix-blend-multiply opacity-45 transition-opacity duration-[400ms] group-hover:opacity-25"
          style={{ background: sport ?? "var(--color-text)" }}
        />
        {/* Scrim: dense at the foot, clear at the head, so the type holds
            against any photograph without hiding the image. */}
        <span
          aria-hidden
          className="absolute inset-0"
          style={{
            background:
              "linear-gradient(to top, rgb(12 10 8 / 0.92) 0%, rgb(12 10 8 / 0.72) 30%, rgb(12 10 8 / 0.18) 62%, transparent 100%)",
          }}
        />

        <div className="relative flex h-full flex-col justify-end gap-2.5 p-5">
          <div className="flex items-center gap-2.5">
            <span
              aria-hidden
              className="h-2 w-2 rounded-full ring-2 ring-white/25"
              style={{ background: sport ?? "#fff" }}
            />
            <h3 className="font-display text-[1.45rem] font-extrabold tracking-[-0.035em] text-white leading-none">
              {category.name}
            </h3>
          </div>

          {category.description && (
            <p className="text-[0.88rem] leading-snug text-white/75 line-clamp-2 max-w-[40ch]">
              {category.description}
            </p>
          )}

          {/* No count here. Most sports read zero until their first guide is
              published, and the number competed with the photograph for the
              same space. The arrow carries the affordance on its own. */}
          <span
            aria-hidden
            className="stamp mt-0.5 flex items-center gap-1.5 text-white opacity-0 translate-y-1 transition-[opacity,transform] duration-[400ms] ease-[cubic-bezier(0.23,1,0.32,1)] group-hover:opacity-100 group-hover:translate-y-0"
          >
            Browse <span>&rarr;</span>
          </span>
        </div>
      </article>
    </Link>
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

export default async function HomePage() {
  // Fetch posts; falls back to placeholder content if the DB is not yet configured.
  let posts: Post[] = [];
  try {
    posts = await getPublishedPosts({ limit: 4 });
  } catch {
    // Supabase not configured or site not yet seeded; use placeholder posts.
  }
  const displayPosts = posts.length > 0 ? posts : PLACEHOLDER_POSTS;

  // The sport tree drives both the hero picker and the browse grid.
  let categories: Awaited<ReturnType<typeof getCategoryTree>> = [];
  try {
    categories = await getCategoryTree();
  } catch {
    // DB not configured; hide the sport sections.
  }

  return (
    <main className="flex-1">

      {/* § HERO. The thesis: this site publishes what venues actually
          enforce, and the picker shows which sports are covered. */}
      <section className="relative overflow-hidden" aria-labelledby="hero-heading">
        {/* Two offset washes, warmth without a gradient panel. */}
        <div
          aria-hidden
          className="pointer-events-none absolute -top-1/3 -right-[8%] h-[40rem] w-[40rem] rounded-full"
          style={{
            background:
              "radial-gradient(circle, color-mix(in srgb, var(--color-accent) 13%, transparent), transparent 66%)",
          }}
        />
        <Container className="relative pt-14 pb-20 sm:pt-20 sm:pb-24 lg:pt-24 lg:pb-28">
          <div className="grid lg:grid-cols-[minmax(0,1.08fr)_minmax(0,0.92fr)] gap-14 lg:gap-20 items-center">

            <div className="min-w-0 max-w-2xl">
              <p className="stamp text-accent-ink mb-5 inline-flex items-center gap-2.5 rise rise-1">
                <span className="h-px w-6 bg-accent-ink" aria-hidden />
                Independent, not affiliated with any venue
              </p>

              <h1
                id="hero-heading"
                className="font-display text-[2.85rem] sm:text-6xl lg:text-[4.5rem] font-extrabold text-text leading-[0.96] tracking-[-0.042em] text-balance rise rise-2"
              >
                Know exactly what to expect{" "}
                <span className="swipe">before you go</span>.
              </h1>

              <p className="mt-6 text-[1.15rem] text-muted leading-[1.6] max-w-[54ch] rise rise-3">
                Dress codes, tickets, seats and what a day out actually costs. Clear
                guides to the world&rsquo;s best sporting events, written for people going
                in person and checked against what each venue publishes.
              </p>

              <div className="mt-8 flex flex-wrap gap-3 rise rise-4">
                <Button variant="accent" size="lg">
                  <Link href="/category/horse-racing" className="contents">
                    Start with Royal Ascot
                  </Link>
                </Button>
                <Button variant="outline" size="lg">
                  <Link href="/blog" className="contents">
                    Browse all guides
                  </Link>
                </Button>
              </div>

              <ul className="mt-7 flex flex-wrap items-center gap-x-5 gap-y-2 list-none rise rise-5">
                <li className="stamp text-muted inline-flex items-center gap-2">
                  <span
                    className="h-1.5 w-1.5 rounded-full bg-success shadow-[0_0_0_3px_color-mix(in_srgb,var(--color-success)_18%,transparent)]"
                    aria-hidden
                  />
                  Checked against venue guidance
                </li>
                <li className="stamp text-muted">No signup</li>
              </ul>
            </div>

            <div className="min-w-0 w-full rise rise-3">
              <SportPicker />
            </div>
          </div>
        </Container>
      </section>

      {/* ══════════════════════════════════════════════════════════════════
          § BROWSE BY SPORT, driven from the published categories.
          Each card links to its /category/[slug] archive; empty categories
          are hidden. Renders nothing if the DB is unconfigured.
      ══════════════════════════════════════════════════════════════════ */}
      {categories.length > 0 && (
        <section className="py-16 sm:py-24" aria-labelledby="categories-heading">
          <Container>
            
            <div className="mt-10">
              <h2
                id="categories-heading"
                className="font-display text-4xl sm:text-5xl font-extrabold text-text tracking-[-0.035em] mb-4"
              >
                Browse by sport
              </h2>

              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                {categories.map((category) => (
                  <CategoryCard key={category.slug} category={category} />
                ))}
              </div>

              <div className="mt-8 text-center">
                <Link
                  href="/blog"
                  className="text-sm text-primary font-medium hover:underline underline-offset-4"
                >
                  Browse all guides →
                </Link>
              </div>
            </div>
          </Container>
        </section>
      )}

      {/* ══════════════════════════════════════════════════════════════════
          § LATEST FROM THE BLOG
      ══════════════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-24 border-t border-line" aria-labelledby="posts-heading">
        <Container>
          <div className="flex items-baseline justify-between gap-4 mb-10 flex-wrap">
            <div>
              <h2
                id="posts-heading"
                className="font-display text-4xl sm:text-5xl font-extrabold text-text tracking-[-0.035em]"
              >
                Latest guides
              </h2>
            </div>
            <Link
              href="/blog"
              className="stamp text-accent-ink shrink-0 transition-[letter-spacing] duration-200 hover:tracking-[0.16em]"
            >
              All guides
            </Link>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {displayPosts.map((post) => (
              <PostCard
                key={post.id}
                post={post}
                sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 25vw"
              />
            ))}
          </div>

        </Container>
      </section>

      {/* ══════════════════════════════════════════════════════════════════
          § TESTIMONIALS, renders only when real reader quotes are configured.
      ══════════════════════════════════════════════════════════════════ */}
      <Testimonials />

      {/* ══════════════════════════════════════════════════════════════════
          § ABOUT TEASER
      ══════════════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-24 border-t border-line" aria-labelledby="about-heading">
        <Container width="narrow">
          <SectionDivider variant="titled" label="About" spacing="sm" />

          <div className="mt-10 text-center">
            <div className="w-20 h-20 rounded-full border-2 border-text mx-auto mb-7 overflow-hidden relative">
              <Image
                src={siteConfig.author.photo}
                alt={`${siteConfig.author.name}, ${siteConfig.author.role} of ${siteConfig.name}`}
                fill
                sizes="80px"
                className="object-cover"
              />
            </div>

            {/* Pull quote set in display type, the one place body copy is
                allowed to reach headline scale. */}
            <blockquote className="font-display text-2xl sm:text-[2rem] font-extrabold text-text leading-[1.15] tracking-[-0.025em] mb-7 max-w-xl mx-auto text-balance">
              &ldquo;Most coverage tells you what to wear. Almost none tells you which
              enclosure your ticket admits you to, or that the rule you are worried
              about does not exist.&rdquo;
            </blockquote>

            <p id="about-heading" className="stamp text-muted mb-8">
              {siteConfig.author.name}, {siteConfig.author.role}
            </p>

            <Button variant="outline">
              <Link href="/about" className="contents">
                About this site
              </Link>
            </Button>
          </div>
        </Container>
      </section>

    </main>
  );
}

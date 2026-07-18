import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { getPublishedPosts, getCategoriesWithPostCounts, type Post } from "@/lib/queries";
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
    absolute: "Of The Pitch: World Cup 2026, Off the Pitch and On the Ground",
  },
  description:
    "An independent World Cup 2026 fan guide for the United States, Canada and Mexico. Visas and entry rules, ticket prices, fan zones in every host city, cross-border travel, and where to watch every match.",
  alternates: { canonical: "/" },
  openGraph: {
    url: "/",
    type: "website",
    title: "Of The Pitch: World Cup 2026, Off the Pitch and On the Ground",
    description:
      "Independent World Cup 2026 guides for travelling fans: visas, tickets, fan zones, host city travel and match viewing across the USA, Canada and Mexico.",
    images: ogImages(),
  },
  twitter: twitterImages(),
};

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder posts — shown when the DB is not yet configured or has no content.
// These mirror real published articles so the fallback view is representative;
// they link to /blog rather than a slug (see PostCard).
// ─────────────────────────────────────────────────────────────────────────────
const PLACEHOLDER_POSTS: Post[] = [
  {
    id: "ph-1",
    slug: "world-cup-2026-ticket-price-controversy",
    title: "FIFA World Cup 2026 Ticket Price Controversy",
    excerpt:
      "Dynamic pricing, resale platforms and supporter group pushback — what the row over World Cup 2026 ticket prices is actually about, and what it means if you are still trying to buy.",
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
      "Which matches land on broadcast, which sit behind a streaming tier, and how the English and Spanish-language rights split — a plain guide to watching from inside the United States.",
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
// § Hero artifact — the signature element
//
// A matchday team sheet, rendered in HTML. It does the one job a hero must do
// here: show a first-time visitor *exactly* what tournament this site covers and
// how big it is. Every figure below is a published FIFA tournament format fact,
// not an estimate. The faint offset sheet behind it nods to a stack of fixtures.
// ─────────────────────────────────────────────────────────────────────────────

// Dot colors run the site palette plus two neutrals, so each row reads like a
// discrete line on a team sheet rather than an abstract stat.
const TOURNAMENT_ROWS: { label: string; value: string; dot: string }[] = [
  { label: "Teams",       value: "48",  dot: "#0B6B3A" },
  { label: "Groups",      value: "12",  dot: "#1E8A6E" },
  { label: "Host nations", value: "3",  dot: "#F5A524" },
  { label: "Host cities",  value: "16", dot: "#6B8FAE" },
  { label: "Matches",      value: "104", dot: "#C4826E" },
];

function TournamentCard() {
  return (
    <div className="relative w-full max-w-sm mx-auto lg:mx-0">
      {/* Second sheet, peeking out behind — a stack of fixtures. */}
      <div
        aria-hidden
        className="absolute inset-0 translate-x-3 translate-y-3 rounded-3xl bg-surface border-2 border-text rotate-[2.5deg]"
      />

      {/* Team sheet — the same outlined sheet as every Card, at hero scale. */}
      <div className="relative rounded-3xl bg-surface border-2 border-text shadow-[8px_8px_0_var(--color-primary)] overflow-hidden">
        {/* Header strip */}
        <div className="relative bg-primary px-5 py-4 flex items-center justify-between border-b-2 border-text overflow-hidden">
          {/* Amber blob, clipped by the strip — the panel motif in miniature. */}
          <div
            aria-hidden
            className="absolute -top-10 -right-8 w-28 h-28 rounded-full bg-accent/20"
          />
          <div className="relative">
            <p className="font-display text-white font-extrabold text-lg leading-none tracking-[-0.02em]">
              World Cup 2026
            </p>
            <p className="stamp text-white/60 mt-2">USA · Canada · Mexico</p>
          </div>
          <span className="relative stamp text-text bg-accent rounded-full px-2.5 py-1">
            48 Teams
          </span>
        </div>

        {/* Line items */}
        <div className="divide-y-2 divide-line">
          {TOURNAMENT_ROWS.map((row, i) => (
            <div
              key={row.label}
              className={cn(
                "flex items-center justify-between px-5 py-2.5",
                i % 2 === 1 && "bg-text/[0.02]"
              )}
            >
              <span className="flex items-center gap-2.5">
                <span
                  className="w-2.5 h-2.5 rounded-full shrink-0 border border-text"
                  style={{ backgroundColor: row.dot }}
                  aria-hidden
                />
                <span
                  className={cn(
                    "text-sm text-text",
                    row.label === "Teams" && "font-semibold"
                  )}
                >
                  {row.label}
                </span>
              </span>
              <span className="font-mono text-sm text-text tabular-nums">
                {row.value}
              </span>
            </div>
          ))}
        </div>

        {/* Dates — the payoff line. Amber is reserved for the one span of time
            the whole sheet exists to point at. */}
        <div className="bg-accent border-t-2 border-text px-5 py-4 flex items-center justify-between">
          <div>
            <p className="stamp text-text leading-none">Tournament dates</p>
            <p className="text-xs text-text/70 mt-1.5">Across three countries</p>
          </div>
          <span className="font-display text-xl font-extrabold text-text tabular-nums tracking-[-0.03em]">
            Jun 11 – Jul 19
          </span>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// § "What you get" — three plain-language promises, with line-art icons.
//   This is the first-sight clarity layer, directly under the hero.
// ─────────────────────────────────────────────────────────────────────────────
const VALUE_PROPS: { icon: "route" | "ticket" | "check"; title: string; body: string }[] = [
  {
    icon: "route",
    title: "Getting there",
    body: "Visa and entry requirements by nationality, border crossings between the three host countries, and travel between host cities by train, bus and road.",
  },
  {
    icon: "ticket",
    title: "Match day",
    body: "What tickets actually cost and how to buy them, FIFA Fan Festival guides for each host city, and the logistics of getting to a stadium and back.",
  },
  {
    icon: "check",
    title: "Independent",
    body: "Not affiliated with FIFA or any national association. Free to read, no signup — including the coverage of ticket pricing, refereeing and host-country politics.",
  },
];

function ValueIcon({ name }: { name: "route" | "ticket" | "check" }) {
  const common = {
    width: 22, height: 22, viewBox: "0 0 24 24", fill: "none",
    stroke: "currentColor", strokeWidth: 1.6,
    strokeLinecap: "round" as const, strokeLinejoin: "round" as const,
    "aria-hidden": true,
  };
  if (name === "route") {
    // Pin over a route line — travel and entry.
    return (
      <svg {...common}>
        <path d="M12 3a4 4 0 0 1 4 4c0 3-4 7-4 7S8 10 8 7a4 4 0 0 1 4-4Z" />
        <path d="M6 18h4a2 2 0 0 0 0-4M18 18h-4" />
      </svg>
    );
  }
  if (name === "ticket") {
    return (
      <svg {...common}>
        <path d="M4 8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2 2 2 0 0 0 0 4 2 2 0 0 1-2 2H6a2 2 0 0 1-2-2 2 2 0 0 0 0-4Z" />
        <path d="M14 6v10" />
      </svg>
    );
  }
  return (
    <svg {...common}>
      <circle cx="12" cy="12" r="8" />
      <path d="m8.5 12 2.5 2.5 4.5-5" />
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-components (page-local, not exported)
// ─────────────────────────────────────────────────────────────────────────────

function CategoryCard({
  category,
}: {
  category: { slug: string; name: string; description: string | null; postCount: number };
}) {
  return (
    <Link
      href={`/category/${category.slug}`}
      className="group block focus-visible:outline-none"
      aria-label={`Browse ${category.name} posts`}
    >
      <Card
        variant="plain"
        className={cn(
          "h-full flex flex-col gap-2.5",
          // The card presses into its own shadow on hover — see globals.css.
          "hard-press",
          "group-focus-visible:outline-2 group-focus-visible:outline-offset-2 group-focus-visible:outline-primary"
        )}
      >
        <Tag variant="primary" className="self-start">{category.name}</Tag>
        {category.description && (
          <p className="text-[0.95rem] text-text font-medium leading-snug mt-0.5">
            {category.description}
          </p>
        )}
        <p className="mt-auto pt-3 stamp text-primary">
          {category.postCount} {category.postCount === 1 ? "guide" : "guides"} →
        </p>
      </Card>
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

  // Categories for the "Browse by category" section. Empty if DB unconfigured.
  let categories: Array<{
    slug: string;
    name: string;
    description: string | null;
    postCount: number;
  }> = [];
  try {
    categories = await getCategoriesWithPostCounts();
  } catch {
    // DB not configured; hide the category section.
  }

  return (
    <main className="flex-1">

      {/* ══════════════════════════════════════════════════════════════════
          § HERO — the page's thesis.
          A first-time visitor learns three things instantly: what this is
          (a World Cup 2026 fan guide), who it's for (fans travelling to the
          USA, Canada and Mexico), and what to do next (read the guides /
          check entry rules).
      ══════════════════════════════════════════════════════════════════ */}
      <section className="relative overflow-hidden" aria-labelledby="hero-heading">
        <Container className="pt-12 pb-16 sm:pt-16 sm:pb-20 lg:pt-20 lg:pb-24">
          <div className="grid lg:grid-cols-[minmax(0,1.1fr)_auto] gap-12 lg:gap-16 items-center">

            {/* Left, the promise */}
            <div className="min-w-0 max-w-2xl">
              {/* Eyebrow — an amber bar rather than a hairline; the small-scale
                  restatement of the headline's highlight mark. */}
              <p className="stamp text-primary mb-6 inline-flex items-center gap-2.5">
                <span className="h-2 w-7 rounded-full bg-accent border border-text" aria-hidden />
                Independent World Cup 2026 fan guide
              </p>

              {/* The headline is the loudest object on the site: heaviest weight,
                  tightest tracking, and sub-1 line-height so the lines lock into
                  a block. The amber mark lands on the promise, not the subject. */}
              <h1
                id="hero-heading"
                className="font-display text-[2.75rem] sm:text-6xl lg:text-[4.25rem] font-extrabold text-text leading-[0.96] tracking-[-0.035em] text-balance"
              >
                The World Cup happens{" "}
                <span className="mark">off the pitch</span> too.
              </h1>

              <p className="mt-7 text-lg sm:text-xl text-muted leading-[1.55] max-w-xl">
                {siteConfig.name} covers the 2026 World Cup across the United States,
                Canada and Mexico from a travelling fan&rsquo;s point of view: visas and
                border crossings, what tickets really cost, fan zones in every host
                city, and where to watch every match.
              </p>

              <div className="mt-9 flex flex-wrap gap-4">
                <Button size="lg">
                  <Link href="/blog" className="contents">
                    Read the guides
                  </Link>
                </Button>
                <Button variant="outline" size="lg">
                  <Link href="/category/visa-immigration" className="contents">
                    Check entry rules
                  </Link>
                </Button>
              </div>

              {/* Trust line — chips, so the three claims read as discrete
                  objects instead of a run-on sentence. */}
              <ul className="mt-8 flex flex-wrap items-center gap-2.5 list-none">
                {["Free to read", "No signup", "Not affiliated with FIFA"].map((claim) => (
                  <li
                    key={claim}
                    className="stamp text-muted bg-text/[0.05] border border-text/15 rounded-full px-3 py-1.5"
                  >
                    {claim}
                  </li>
                ))}
              </ul>
            </div>

            {/* Right, the artifact */}
            <div className="min-w-0 w-full lg:w-[23rem]">
              <TournamentCard />
            </div>
          </div>
        </Container>
      </section>

      {/* ══════════════════════════════════════════════════════════════════
          § WHAT YOU GET — first-sight clarity, three plain promises.
      ══════════════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-20 border-y-2 border-text" aria-label="What this site covers">
        <Container>
          <div className="grid gap-6 sm:grid-cols-3">
            {VALUE_PROPS.map((vp, i) => (
              <div
                key={vp.title}
                className="bg-surface border-2 border-text rounded-3xl p-6 shadow-[5px_5px_0_var(--color-text)] text-left"
              >
                {/* The icon tile alternates green / amber / green so the row has
                    a rhythm without introducing a third color. */}
                <span
                  className={cn(
                    "w-12 h-12 rounded-2xl border-2 border-text flex items-center justify-center mb-5",
                    i === 1 ? "bg-accent text-text" : "bg-primary text-white"
                  )}
                  aria-hidden
                >
                  <ValueIcon name={vp.icon} />
                </span>
                <h2 className="font-display text-xl font-extrabold text-text tracking-[-0.02em] mb-2">
                  {vp.title}
                </h2>
                <p className="text-sm text-muted leading-relaxed">{vp.body}</p>
              </div>
            ))}
          </div>
        </Container>
      </section>

      {/* ══════════════════════════════════════════════════════════════════
          § BROWSE BY CATEGORY — driven from the published categories.
          Each card links to its /category/[slug] archive; empty categories
          are hidden. Renders nothing if the DB is unconfigured.
      ══════════════════════════════════════════════════════════════════ */}
      {categories.length > 0 && (
        <section className="py-12 sm:py-16" aria-labelledby="categories-heading">
          <Container>
            <SectionDivider variant="titled" label="Browse by category" spacing="sm" />

            <div className="mt-10">
              <h2
                id="categories-heading"
                className="font-display text-4xl sm:text-5xl font-extrabold text-text tracking-[-0.035em] mb-4"
              >
                Start where your trip starts.
              </h2>
              <p className="text-muted text-lg max-w-xl mb-10">
                Visas, tickets, fan zones, cross-border travel, squad reviews and
                the politics around the tournament — every guide is filed by topic.
              </p>

              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
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
      <section className="py-14 sm:py-20 border-t-2 border-text" aria-labelledby="posts-heading">
        <Container>
          <div className="flex items-baseline justify-between gap-4 mb-10 flex-wrap">
            <div>
              <h2
                id="posts-heading"
                className="font-display text-4xl sm:text-5xl font-extrabold text-text tracking-[-0.035em]"
              >
                Latest from the blog
              </h2>
              <p className="text-muted mt-2">
                Host city logistics, entry rules, viewing guides and the stories
                around the tournament.
              </p>
            </div>
            <Link
              href="/blog"
              className="text-sm text-primary font-medium hover:underline underline-offset-4 shrink-0"
            >
              View all →
            </Link>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {displayPosts.map((post) => (
              <PostCard
                key={post.id}
                post={post}
                sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 25vw"
              />
            ))}
          </div>

          {posts.length === 0 && (
            <p className="mt-6 text-center text-xs font-mono text-muted/50 uppercase tracking-widest">
              Showing placeholder content. Connect Supabase to display real posts
            </p>
          )}
        </Container>
      </section>

      {/* ══════════════════════════════════════════════════════════════════
          § TESTIMONIALS — renders only when real reader quotes are configured.
      ══════════════════════════════════════════════════════════════════ */}
      <Testimonials />

      {/* ══════════════════════════════════════════════════════════════════
          § ABOUT TEASER
      ══════════════════════════════════════════════════════════════════ */}
      <section className="py-14 sm:py-20 border-t-2 border-text" aria-labelledby="about-heading">
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

            {/* Pull quote set in display type — the one place body copy is
                allowed to reach headline scale. */}
            <blockquote className="font-display text-2xl sm:text-[2rem] font-extrabold text-text leading-[1.15] tracking-[-0.025em] mb-7 max-w-xl mx-auto text-balance">
              &ldquo;Most World Cup coverage stops at the final whistle. {siteConfig.name}{" "}
              covers the parts that decide whether a trip works — the visa queue, the
              border crossing, the fan zone gate and the broadcaster you actually
              need.&rdquo;
            </blockquote>

            <p id="about-heading" className="stamp text-muted mb-8">
              {siteConfig.author.name}, {siteConfig.author.role}
            </p>

            <Button variant="outline">
              <Link href="/about" className="contents">
                Read our story →
              </Link>
            </Button>
          </div>
        </Container>
      </section>

    </main>
  );
}

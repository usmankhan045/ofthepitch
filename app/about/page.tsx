import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { siteConfig } from "@/lib/site.config";
import { getPageBySlug, getCategoriesWithPostCounts } from "@/lib/queries";
import { Container, Tag, SectionDivider, Card } from "@/components/ui";
import { JsonLd } from "@/components/JsonLd";
import { aboutPageSchema } from "@/lib/schema";
import { ogImages, twitterImages } from "@/lib/metadata";

export const metadata: Metadata = {
  title: "About",
  description: `What ${siteConfig.name} covers, who it is for, and how our World Cup 2026 coverage is researched.`,
  alternates: { canonical: "/about" },
  openGraph: { url: "/about", type: "website", images: ogImages() },
  twitter: twitterImages(),
};

export const revalidate = 3600;

const DEFAULT_INTRO: string = siteConfig.author.longBio;

export default async function AboutPage() {
  let intro = DEFAULT_INTRO;
  try {
    const page = await getPageBySlug("about");
    if (page?.content) intro = page.content;
  } catch {}

  let categories: Awaited<ReturnType<typeof getCategoriesWithPostCounts>> = [];
  try {
    categories = await getCategoriesWithPostCounts();
  } catch {}

  return (
    <main className="flex-1">
      <JsonLd data={[aboutPageSchema()]} />

      {/* ── Hero ───────────────────────────────────────────────────────────── */}
      <section
        className="bg-gradient-to-b from-primary/[0.07] via-primary/[0.03] to-background pt-10 pb-10"
        aria-labelledby="about-hero-heading"
      >
        <Container width="narrow">
          <Tag variant="primary" className="mb-5">About</Tag>
          <h1
            id="about-hero-heading"
            className="font-display text-4xl sm:text-5xl font-bold text-text leading-tight mb-5"
          >
            World Cup 2026,
            <br className="hidden sm:block" />
            off the pitch.
          </h1>
          <p className="text-lg text-muted leading-relaxed">{intro}</p>
        </Container>
      </section>

      {/* ── Why this site exists ───────────────────────────────────────────── */}
      <section className="py-12 sm:py-14" aria-labelledby="story-heading">
        <Container width="narrow">
          <SectionDivider variant="titled" label="Why this site exists" spacing="sm" />

          <div className="mt-10 flex flex-col sm:flex-row gap-8 items-start">
            <div className="shrink-0 w-24 h-24 rounded-full border-2 border-primary/20 overflow-hidden relative">
              <Image
                src={siteConfig.author.photo}
                alt={`${siteConfig.name} ${siteConfig.author.role}`}
                fill
                sizes="96px"
                className="object-cover"
              />
            </div>

            <div className="space-y-4 text-text/85 leading-relaxed">
              <p
                id="story-heading"
                className="font-display text-xl font-semibold text-text"
              >
                An independent guide for fans travelling to the 2026 World Cup.
              </p>

              <p className="text-sm sm:text-base">
                The 2026 tournament is spread across three countries &mdash; the United
                States, Canada and Mexico &mdash; and that changes what following it
                actually involves. A single trip can mean two visas, an international
                border crossing between group games, and a match kicking off in a city
                a thousand miles from where you booked a bed.
              </p>

              <p className="text-sm sm:text-base">
                {siteConfig.name} covers that side of the tournament: entry requirements
                by nationality, how to move between host cities and across borders, what
                tickets cost and how they are sold, where the FIFA Fan Festivals are and
                what to expect at them, and how to watch each match wherever you happen
                to be.
              </p>

              <p className="text-sm sm:text-base">
                We also write about the football itself &mdash; squad reviews ahead of the
                draw and through the group stage &mdash; and about the arguments the
                tournament keeps generating: dynamic ticket pricing, VAR decisions, and
                fans being turned away at the border.
              </p>

              <p className="text-sm sm:text-base">
                Coverage is researched against official sources: FIFA, host city
                authorities, immigration departments and national broadcasters. Rules
                change, prices move and schedules shift, so guides are dated and updated
                as the tournament unfolds. Always confirm visa and entry requirements
                with the relevant government before you book.
              </p>

              <p className="font-medium text-text">
                {siteConfig.author.name}
                <span className="text-muted font-normal"> &middot; {siteConfig.author.role}</span>
              </p>
            </div>
          </div>
        </Container>
      </section>

      {/* ── What we cover ──────────────────────────────────────────────────── */}
      {categories.length > 0 && (
        <section
          className="py-12 sm:py-14 bg-primary/[0.03]"
          aria-labelledby="coverage-heading"
        >
          <Container>
            <SectionDivider variant="titled" label="What we cover" spacing="sm" />
            <h2
              id="coverage-heading"
              className="font-display text-3xl sm:text-4xl font-bold text-text mt-8 mb-3"
            >
              Browse by topic.
            </h2>
            <p className="text-muted mb-10 max-w-lg">
              Coverage is grouped by the decisions a travelling fan actually has to make.
              Pick the one you&rsquo;re stuck on.
            </p>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {categories.map((category) => (
                <Link
                  key={category.id}
                  href={`/category/${category.slug}`}
                  className="group block focus-visible:outline-none"
                  aria-label={`Browse ${category.name}`}
                >
                  <Card
                    className="h-full flex flex-col gap-2 transition duration-200 group-hover:shadow-md group-hover:-translate-y-0.5 group-focus-visible:outline-2 group-focus-visible:outline-offset-2 group-focus-visible:outline-primary"
                  >
                    <Tag variant="primary" className="self-start">{category.name}</Tag>
                    <p className="text-sm text-text font-medium leading-snug mt-0.5">
                      {category.description ??
                        `${category.postCount} ${category.postCount === 1 ? "guide" : "guides"}`}
                    </p>
                    <p className="mt-auto pt-3 text-xs font-mono text-primary/70 font-medium tracking-wide uppercase">
                      Read more →
                    </p>
                  </Card>
                </Link>
              ))}
            </div>
          </Container>
        </section>
      )}

      {/* ── What you'll find here ──────────────────────────────────────────── */}
      <section className="py-12 sm:py-14" aria-labelledby="content-heading">
        <Container width="narrow">
          <SectionDivider variant="titled" label="What you'll find here" spacing="sm" />
          <h2
            id="content-heading"
            className="font-display text-3xl font-bold text-text mt-8 mb-8"
          >
            Practical guides. Checked against the source.
          </h2>

          <ul className="space-y-7">
            {([
              {
                title: "Visa and entry requirements by nationality",
                body: "Which nationalities need a visa for the United States, Canada or Mexico, what the waiver schemes cover, and how long appointments are taking — written per passport, not as one generic checklist.",
              },
              {
                title: "Cross-border and inter-city travel",
                body: "Getting between host cities and across the three host countries: what the border crossing involves, what to carry, and how to plan a route that survives a group-stage schedule.",
              },
              {
                title: "Fan zone and host city guides",
                body: "Where the FIFA Fan Festival is in each host city, what it costs, what you can bring in, and what the surrounding area is like on a matchday.",
              },
              {
                title: "Tickets and how to watch",
                body: "How tickets are sold, what the price tiers actually mean, and — if you're not going — which broadcaster carries each match in your country.",
              },
              {
                title: "Squads and the arguments around the tournament",
                body: "National team reviews as the picture firms up, plus straight coverage of the disputes: ticket pricing, VAR calls, and entry denials at the border.",
              },
            ] as const).map((item) => (
              <li key={item.title} className="flex gap-4">
                <span
                  className="shrink-0 mt-1.5 w-5 h-5 rounded-full bg-primary/15 border border-primary/25 flex items-center justify-center"
                  aria-hidden
                >
                  <span className="w-1.5 h-1.5 rounded-full bg-primary block" />
                </span>
                <div>
                  <p className="font-medium text-text mb-1">{item.title}</p>
                  <p className="text-muted text-sm leading-relaxed">{item.body}</p>
                </div>
              </li>
            ))}
          </ul>
        </Container>
      </section>

      {/* ── Independence notice ────────────────────────────────────────────── */}
      <section className="py-12 bg-primary/[0.03]" aria-label="Independence notice">
        <Container width="narrow">
          <div className="border border-black/[0.08] rounded-xl bg-white p-5">
            <p className="text-xs text-muted leading-relaxed">
              <span className="font-medium text-text">Independence: </span>
              {siteConfig.legal.disclaimer} Visa, ticketing and travel rules change without
              notice &mdash; always confirm details with the relevant official body before
              you book.{" "}
              <Link
                href="/editorial-policy"
                className="text-primary underline underline-offset-3 hover:opacity-80"
              >
                Read our editorial policy →
              </Link>
            </p>
          </div>
        </Container>
      </section>

    </main>
  );
}

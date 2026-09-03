import type { Metadata } from "next";
import Link from "next/link";
import { siteConfig } from "@/lib/site.config";
import { getPageBySlug, getCategoryTree } from "@/lib/queries";
import { Container } from "@/components/ui";
import { MarkdownContent } from "@/components/MarkdownContent";
import { JsonLd } from "@/components/JsonLd";
import { aboutPageSchema } from "@/lib/schema";
import { ogImages, twitterImages } from "@/lib/metadata";

export const metadata: Metadata = {
  title: "About",
  description: `What ${siteConfig.name} covers, who it is for, and how the guides are researched.`,
  alternates: { canonical: "/about" },
  openGraph: { url: "/about", type: "website", images: ogImages() },
  twitter: twitterImages(),
};

export const revalidate = 3600;

export default async function AboutPage() {
  // The body lives in the `pages` table so it can be edited from /admin. The
  // long bio is the fallback when the row is missing or the DB is unreachable.
  let body: string | null = null;
  try {
    const page = await getPageBySlug("about");
    if (page?.content?.trim()) body = page.content;
  } catch {
    // Fall through to the config bio.
  }

  let sports: Awaited<ReturnType<typeof getCategoryTree>> = [];
  try {
    sports = await getCategoryTree();
  } catch {
    // Hide the sport list rather than failing the page.
  }

  return (
    <main className="flex-1">
      <JsonLd data={[aboutPageSchema()]} />

      <section className="pt-14 pb-10 sm:pt-20 sm:pb-12" aria-labelledby="about-heading">
        <Container width="narrow">
          <p className="stamp text-accent-ink mb-5 inline-flex items-center gap-2.5">
            <span className="h-px w-6 bg-accent-ink" aria-hidden />
            About
          </p>
          <h1
            id="about-heading"
            className="font-display text-[2.5rem] sm:text-5xl font-extrabold text-text tracking-[-0.04em] leading-[1.02] text-balance"
          >
            Written for people who are{" "}
            <span className="swipe">actually going</span>.
          </h1>
        </Container>
      </section>

      <section className="pb-14" aria-label="About this site">
        <Container width="narrow">
          {body ? (
            <MarkdownContent content={body} />
          ) : (
            <p className="text-lg text-muted leading-relaxed">
              {siteConfig.author.longBio}
            </p>
          )}
        </Container>
      </section>

      {/* The sports, so the page ends somewhere useful rather than in a wall
          of prose. Counts are omitted: most read zero until launch. */}
      {sports.length > 0 && (
        <section className="border-t border-line py-12 sm:py-14" aria-labelledby="sports-heading">
          <Container width="narrow">
            <h2
              id="sports-heading"
              className="font-display text-2xl font-extrabold text-text tracking-[-0.03em] mb-6"
            >
              What we cover
            </h2>
            <ul className="flex flex-col gap-1 list-none p-0">
              {sports.map((sport) => {
                const colour = siteConfig.theme.sports[sport.slug];
                return (
                  <li key={sport.slug}>
                    <Link
                      href={`/category/${sport.slug}`}
                      className="group flex items-baseline gap-3 rounded-lg px-3 py-3 -mx-3 transition-colors duration-150 hover:bg-text/[0.035] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent-ink"
                    >
                      <span
                        aria-hidden
                        className="h-2 w-2 shrink-0 translate-y-[-1px] rounded-full"
                        style={{ background: colour ?? "var(--color-text)" }}
                      />
                      <span className="min-w-0">
                        <span className="font-semibold text-text">{sport.name}</span>
                        {sport.description && (
                          <span className="block text-sm text-muted leading-snug mt-0.5">
                            {sport.description}
                          </span>
                        )}
                      </span>
                      <span
                        aria-hidden
                        className="ml-auto shrink-0 self-center text-muted opacity-0 -translate-x-1.5 transition-[opacity,transform] duration-200 group-hover:opacity-100 group-hover:translate-x-0"
                      >
                        &rarr;
                      </span>
                    </Link>
                  </li>
                );
              })}
            </ul>
          </Container>
        </section>
      )}
    </main>
  );
}

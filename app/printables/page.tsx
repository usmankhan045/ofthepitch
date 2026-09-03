import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";

import { getPrintables, getCategories } from "@/lib/queries";
import { Container, SectionDivider, Tag } from "@/components/ui";
import { PrintableCard } from "@/components/PrintableCard";
import { JsonLd } from "@/components/JsonLd";
import { collectionPageSchema } from "@/lib/schema";
import { siteConfig } from "@/lib/site.config";

export const revalidate = 3600;

const TITLE = "Free World Cup 2026 Printables";
const DESCRIPTION =
  "Checklists and planners for people going to the sport. Dress code cheat sheets, packing lists and trip planners. Free to download, no email required.";

export const metadata: Metadata = {
  title: TITLE,
  description: DESCRIPTION,
  alternates: { canonical: "/printables" },
  openGraph: {
    title: TITLE,
    description: DESCRIPTION,
    type: "website",
    url: "/printables",
  },
};

export default async function PrintablesPage({
  searchParams,
}: {
  searchParams: Promise<{ category?: string }>;
}) {
  // The printables surface is feature-flagged. Off → this route does not exist,
  // matching the nav item and sitemap entries that the flag also removes.
  if (!siteConfig.features.printables) notFound();

  const { category } = await searchParams;

  let printables: Awaited<ReturnType<typeof getPrintables>> = [];
  let categories: Awaited<ReturnType<typeof getCategories>> = [];

  try {
    [printables, categories] = await Promise.all([
      getPrintables(),
      getCategories(),
    ]);
  } catch (err) {
    // Missing table or unconfigured DB, render the empty state rather than 500.
    console.error("[/printables]", err);
  }

  // Filter client-side off the full list: the set is small, and it keeps the
  // category chips working without a round trip per click.
  const activeCategory = category
    ? categories.find((c) => c.slug === category)
    : undefined;

  const visible = activeCategory
    ? printables.filter((p) => p.category_id === activeCategory.id)
    : printables;

  // Only offer chips for categories that actually have a printable.
  const usedCategoryIds = new Set(
    printables.map((p) => p.category_id).filter(Boolean)
  );
  const chips = categories.filter((c) => usedCategoryIds.has(c.id));

  return (
    <main className="flex-1">
      <JsonLd
        data={collectionPageSchema({
          name: TITLE,
          description: DESCRIPTION,
          slug: "printables",
        })}
      />

      <section className="bg-gradient-to-b from-primary/[0.07] to-background pb-8 pt-10">
        <Container width="narrow">
          <Tag variant="accent" className="mb-4">
            Free downloads
          </Tag>
          <h1 className="mb-4 font-display text-3xl font-bold leading-tight text-text sm:text-4xl lg:text-5xl">
            {TITLE}
          </h1>
          <p className="text-lg leading-relaxed text-muted">{DESCRIPTION}</p>
          <p className="mt-4 text-sm text-muted">
            Print at A4 or US Letter. {siteConfig.name} is an independent fan
            guide. These are not official documents.
          </p>
        </Container>
      </section>

      <Container width="wide" className="py-10">
        {chips.length > 0 && (
          <nav aria-label="Filter printables by category" className="mb-8">
            <ul className="flex flex-wrap gap-2">
              <li>
                <Link
                  href="/printables"
                  aria-current={!activeCategory ? "true" : undefined}
                  className={`inline-block rounded-full border-2 px-4 py-1.5 text-sm font-semibold transition-colors ${
                    !activeCategory
                      ? "border-text bg-accent text-text"
                      : "border-line text-muted hover:border-text hover:text-text"
                  }`}
                >
                  All
                </Link>
              </li>
              {chips.map((c) => (
                <li key={c.id}>
                  <Link
                    href={`/printables?category=${c.slug}`}
                    aria-current={
                      activeCategory?.id === c.id ? "true" : undefined
                    }
                    className={`inline-block rounded-full border-2 px-4 py-1.5 text-sm font-semibold transition-colors ${
                      activeCategory?.id === c.id
                        ? "border-text bg-accent text-text"
                        : "border-line text-muted hover:border-text hover:text-text"
                    }`}
                  >
                    {c.name}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
        )}

        {visible.length === 0 ? (
          <div className="rounded-2xl border-2 border-dashed border-line bg-surface px-6 py-16 text-center">
            <p className="font-display text-lg font-bold">
              {printables.length === 0
                ? "No printables yet"
                : "Nothing in that category"}
            </p>
            <p className="mx-auto mt-2 max-w-md text-sm text-muted">
              {printables.length === 0
                ? "Checklists and planners are on the way."
                : "Try another category, or browse them all."}
            </p>
            {printables.length > 0 && (
              <Link
                href="/printables"
                className="stamp mt-5 inline-block rounded-lg shadow-[inset_0_0_0_1px_var(--color-line)] bg-surface px-4 py-2 transition-colors hover:bg-primary hover:text-white"
              >
                Show all
              </Link>
            )}
          </div>
        ) : (
          <ul className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {visible.map((printable) => (
              <li key={printable.id}>
                <PrintableCard printable={printable} />
              </li>
            ))}
          </ul>
        )}
      </Container>

      <SectionDivider />

      <Container width="narrow" className="py-10">
        <p className="text-sm text-muted">
          Spotted something out of date? Ticket prices, visa rules and fan zone
          details change often.{" "}
          <Link href="/contact" className="text-primary underline">
            tell us
          </Link>{" "}
          and we&apos;ll fix it.
        </p>
      </Container>
    </main>
  );
}

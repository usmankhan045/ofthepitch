import { notFound } from "next/navigation";
import type { Metadata } from "next";
import Link from "next/link";

import {
  getPrintableBySlug,
  getPrintables,
  getPostsForPrintable,
} from "@/lib/queries";
import { Container, SectionDivider, Tag } from "@/components/ui";
import { PrintableCard } from "@/components/PrintableCard";
import { PrintablePreview } from "@/components/PrintablePreview";
import { JsonLd } from "@/components/JsonLd";
import { digitalDocumentSchema, breadcrumbSchema } from "@/lib/schema";
import { absolutePrintableThumbnail } from "@/lib/admin/preview-image";
import { siteConfig } from "@/lib/site.config";
import { postPath } from "@/lib/utils";

export const revalidate = 3600;
export const dynamicParams = true;

export async function generateStaticParams() {
  if (!siteConfig.features.printables) return [];
  try {
    const printables = await getPrintables();
    return printables.map((p) => ({ slug: p.slug }));
  } catch {
    return [];
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;

  try {
    const printable = await getPrintableBySlug(slug);
    if (!printable) return {};

    const description =
      printable.description ??
      `Download the free ${printable.title} from Of The Pitch.`;

    return {
      title: printable.title,
      description,
      alternates: { canonical: `/printables/${slug}` },
      openGraph: {
        title: printable.title,
        description,
        type: "article",
        url: `/printables/${slug}`,
        images: [{ url: absolutePrintableThumbnail(printable) }],
      },
      twitter: {
        card: "summary_large_image",
        title: printable.title,
        description,
        images: [absolutePrintableThumbnail(printable)],
      },
    };
  } catch {
    return {};
  }
}

export default async function PrintableDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  // Feature-flagged surface, off means these detail pages don't exist either.
  if (!siteConfig.features.printables) notFound();

  const { slug } = await params;

  let printable: Awaited<ReturnType<typeof getPrintableBySlug>> = null;
  try {
    printable = await getPrintableBySlug(slug);
  } catch {
    notFound();
  }
  if (!printable) notFound();

  // Non-critical extras, a failure here must not 500 the download page.
  const [relatedPosts, siblings] = await Promise.all([
    getPostsForPrintable(printable.id).catch(() => []),
    getPrintables(printable.category_id ?? undefined).catch(() => []),
  ]);

  const alsoAvailable = siblings.filter((p) => p.id !== printable.id).slice(0, 3);

  return (
    <main className="flex-1">
      <JsonLd
        data={[
          digitalDocumentSchema(printable),
          breadcrumbSchema([
            { name: "Home", slug: "/" },
            { name: "Printables", slug: "/printables" },
            { name: printable.title, slug: `/printables/${printable.slug}` },
          ]),
        ]}
      />

      <section className="bg-gradient-to-b from-primary/[0.07] to-background pb-8 pt-10">
        <Container width="narrow">
          <nav aria-label="Breadcrumb" className="mb-5">
            <ol className="flex flex-wrap items-center gap-2 font-mono text-xs uppercase tracking-wide text-muted/60">
              <li>
                <Link href="/" className="transition-colors hover:text-primary">
                  Home
                </Link>
              </li>
              <li aria-hidden>/</li>
              <li>
                <Link
                  href="/printables"
                  className="transition-colors hover:text-primary"
                >
                  Printables
                </Link>
              </li>
            </ol>
          </nav>

          <div className="mb-5 flex flex-wrap gap-2">
            <Tag variant="accent">Free download</Tag>
            {printable.categories && (
              <Link href={`/category/${printable.categories.slug}`}>
                <Tag variant="primary">{printable.categories.name}</Tag>
              </Link>
            )}
          </div>

          <h1 className="mb-5 font-display text-3xl font-bold leading-tight text-text sm:text-4xl lg:text-5xl">
            {printable.title}
          </h1>

          {printable.description && (
            <p className="mb-6 text-lg leading-relaxed text-muted">
              {printable.description}
            </p>
          )}

          {printable.file_url ? (
            <div className="flex flex-wrap items-center gap-3">
              <a
                href={printable.file_url}
                download
                className="inline-flex items-center justify-center rounded-full shadow-[inset_0_0_0_1px_var(--color-line)] bg-accent px-6 py-3 font-semibold text-text  lift hover:brightness-105"
              >
                Download PDF
              </a>
              <a
                href={printable.file_url}
                target="_blank"
                rel="noreferrer"
                className="stamp rounded-lg border-2 border-line px-4 py-2.5 text-muted transition-colors hover:border-text hover:text-text"
              >
                Open in new tab ↗
              </a>
            </div>
          ) : (
            // A row can exist before its file is uploaded; say so plainly
            // rather than rendering a dead button.
            <p className="rounded-lg shadow-[inset_0_0_0_1px_var(--color-line)] bg-accent/25 px-4 py-3 text-sm font-medium">
              This printable is being prepared. The file isn&apos;t available to
              download yet.
            </p>
          )}

          <p className="mt-4 text-xs text-muted">
            No email required. Prints on A4 or US Letter.
          </p>
        </Container>
      </section>

      {printable.file_url && (
        <Container width="narrow" className="py-8">
          <PrintablePreview
            fileUrl={printable.file_url}
            title={printable.title}
            orientation={printable.orientation}
          />
        </Container>
      )}

      {relatedPosts.length > 0 && (
        <>
          <SectionDivider variant="titled" label="Where this is used" />
          <Container width="narrow" className="pb-10">
            <ul className="space-y-2">
              {relatedPosts.map((post) => (
                <li key={post.id}>
                  <Link
                    href={postPath(post.slug)}
                    className="text-primary underline underline-offset-2 hover:no-underline"
                  >
                    {post.title}
                  </Link>
                </li>
              ))}
            </ul>
          </Container>
        </>
      )}

      {alsoAvailable.length > 0 && (
        <>
          <SectionDivider variant="titled" label="More printables" />
          <Container width="wide" className="py-10">
            <ul className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {alsoAvailable.map((p) => (
                <li key={p.id}>
                  <PrintableCard printable={p} />
                </li>
              ))}
            </ul>
          </Container>
        </>
      )}
    </main>
  );
}

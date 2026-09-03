import { notFound } from "next/navigation";
import type { Metadata } from "next";
import Link from "next/link";
import {
  getCategories,
  getCategoryBySlug,
  getPostsByCategory,
  getCategoryTree,
  getPublishedPosts,
} from "@/lib/queries";
import { Container, Tag } from "@/components/ui";
import { PostCard } from "@/components/PostCard";
import { JsonLd } from "@/components/JsonLd";
import { breadcrumbSchema, collectionPageSchema } from "@/lib/schema";
import { ogImages, twitterImages } from "@/lib/metadata";
import { siteConfig } from "@/lib/site.config";

export const revalidate = 3600;

export async function generateStaticParams() {
  try {
    const categories = await getCategories();
    return categories.map((c) => ({ slug: c.slug }));
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
    const category = await getCategoryBySlug(slug);
    if (!category) return {};
    const title = `${category.name}: Blog`;
    const description =
      category.description ??
      `Browse all ${category.name} articles on ${siteConfig.name}.`;
    return {
      title,
      description,
      alternates: { canonical: `/category/${slug}` },
      openGraph: {
        title,
        description,
        url: `/category/${slug}`,
        type: "website",
        images: ogImages(),
      },
      twitter: twitterImages(),
    };
  } catch {
    return {};
  }
}

export default async function CategoryArchivePage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;

  let category: Awaited<ReturnType<typeof getCategoryBySlug>>;
  let posts: Awaited<ReturnType<typeof getPublishedPosts>> = [];
  let children: Array<{ slug: string; name: string; description: string | null; postCount: number }> = [];
  let parent: { slug: string; name: string } | null = null;

  try {
    category = await getCategoryBySlug(slug);
  } catch {
    notFound();
  }
  if (!category) notFound();

  try {
    // getPostsByCategory rolls a sport's subcategories into its archive, so a
    // top-level sport lists everything filed beneath it rather than only the
    // posts assigned to the sport itself.
    posts = await getPostsByCategory(slug, 50);
  } catch {
    // DB error, show empty state
  }

  try {
    const tree = await getCategoryTree();
    const asParent = tree.find((t) => t.slug === slug);
    if (asParent) {
      children = asParent.children;
    } else {
      // A subcategory shows a link back to the sport it belongs to.
      const owner = tree.find((t) => t.children.some((c) => c.slug === slug));
      if (owner) parent = { slug: owner.slug, name: owner.name };
    }
  } catch {
    // Sections are optional chrome.
  }

  // A subcategory borrows its parent sport's colour so the whole branch of the
  // site reads as one thing.
  const sportColour =
    siteConfig.theme.sports[slug] ??
    (parent ? siteConfig.theme.sports[parent.slug] : undefined) ??
    "var(--color-text)";

  return (
    <main className="flex-1">
      <JsonLd
        data={[
          breadcrumbSchema([
            { name: "Home", slug: "/" },
            { name: "Blog", slug: "/blog" },
            { name: category.name, slug: `/category/${category.slug}` },
          ]),
          collectionPageSchema({
            name: category.name,
            description:
              category.description ??
              `Browse all ${category.name} articles on ${siteConfig.name}.`,
            slug: `category/${category.slug}`,
          }),
        ]}
      />
      {/* ── Header ─────────────────────────────────────────────────────────── */}
      <section
        className="bg-gradient-to-b from-primary/[0.07] via-primary/[0.03] to-background pt-10 pb-10"
        aria-labelledby="category-heading"
      >
        <Container>
          {/* Visible breadcrumb trail */}
          <nav aria-label="Breadcrumb" className="mb-5">
            <ol className="flex items-center gap-2 text-xs font-mono text-muted/60 uppercase tracking-wide flex-wrap">
              <li><Link href="/" className="hover:text-primary transition-colors">Home</Link></li>
              <li aria-hidden>/</li>
              <li><Link href="/blog" className="hover:text-primary transition-colors">Blog</Link></li>
              <li aria-hidden>/</li>
              <li className="text-muted" aria-current="page">{category.name}</li>
            </ol>
          </nav>

          <Tag variant="primary" className="mb-5">
            Category
          </Tag>
          <h1
            id="category-heading"
            className="font-display text-4xl sm:text-5xl font-bold text-text leading-tight mb-5"
          >
            {category.name}
          </h1>
          {category.description && (
            <p className="text-lg text-muted leading-relaxed max-w-xl">
              {category.description}
            </p>
          )}
        </Container>
      </section>

      {/* ── Post grid ──────────────────────────────────────────────────────── */}
      <section className="py-12 sm:py-14">
        <Container>
          {posts.length === 0 ? (
            <div className="py-16 text-center">
              <p className="font-display text-xl font-semibold text-text mb-2">
                No posts yet
              </p>
              <p className="text-muted text-sm">
                Content for this category is coming soon.
              </p>
              <Link
                href="/blog"
                className="inline-block mt-6 text-sm font-medium text-primary hover:underline underline-offset-4"
              >
                ← Browse all posts
              </Link>
            </div>
          ) : (
            <>
              <p className="text-xs font-mono text-muted/60 uppercase tracking-wide mb-6">
                {posts.length} {posts.length === 1 ? "post" : "posts"}
              </p>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                {posts.map((post, i) => (
                  <PostCard
                    key={post.id}
                    post={post}
                    as="h2"
                    meta="date-tags"
                    priority={i === 0}
                  />
                ))}
              </div>
            </>
          )}
        </Container>
      </section>

      {/* Sections. A sport ends with the parts of it a reader can drill into;
          a subcategory ends with a way back up to its sport. */}
      {children.length > 0 && (
        <section className="border-t border-line py-12 sm:py-14" aria-labelledby="sections-heading">
          <Container>
            <h2
              id="sections-heading"
              className="font-display text-2xl font-extrabold text-text tracking-[-0.03em] mb-6"
            >
              Sections
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {children.map((child) => (
                <Link
                  key={child.slug}
                  href={`/category/${child.slug}`}
                  style={{ "--sport": sportColour } as React.CSSProperties}
                  className="group relative flex flex-col gap-2 rounded-xl bg-surface p-5 shadow-[inset_0_0_0_1px_var(--color-line)] transition-[transform,box-shadow] duration-300 ease-[cubic-bezier(0.23,1,0.32,1)] hover:-translate-y-1 hover:shadow-[inset_0_0_0_1px_color-mix(in_srgb,var(--sport)_45%,var(--color-line)),0_16px_32px_-18px_color-mix(in_srgb,var(--sport)_50%,transparent)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent-ink"
                >
                  <span
                    aria-hidden
                    className="absolute left-0 top-5 bottom-5 w-[3px] origin-center scale-y-0 rounded-full transition-transform duration-300 group-hover:scale-y-100"
                    style={{ background: sportColour }}
                  />
                  <span className="font-display text-lg font-extrabold text-text tracking-[-0.03em]">
                    {child.name}
                  </span>
                  {child.description && (
                    <span className="text-sm text-muted leading-snug">{child.description}</span>
                  )}
                  <span className="stamp mt-1 text-muted">
                    {child.postCount} {child.postCount === 1 ? "guide" : "guides"}
                  </span>
                </Link>
              ))}
            </div>
          </Container>
        </section>
      )}

      {parent && (
        <section className="border-t border-line py-10" aria-label="Parent sport">
          <Container>
            <Link
              href={`/category/${parent.slug}`}
              className="stamp inline-flex items-center gap-2 text-accent-ink transition-[gap] duration-200 hover:gap-3.5"
            >
              <span aria-hidden>&larr;</span> All {parent.name}
            </Link>
          </Container>
        </section>
      )}

    </main>
  );
}

import Link from "next/link";
import Image from "next/image";
import { previewImageUrl } from "@/lib/admin/preview-image";
import { CardTitle } from "@/components/ui";
import type { Post } from "@/lib/queries";
import { cn, postPath } from "@/lib/utils";
import { siteConfig } from "@/lib/site.config";

/**
 * The single post card used by every listing surface, homepage, blog index,
 * category archives, audience hubs, and the author archive.
 *
 * This exists because the card was previously copy-pasted five times and had
 * drifted apart: only two of the five rendered the cover image, and they
 * disagreed on hover treatment, focus style, and heading level. Any change to
 * how a post is previewed now happens here, once.
 */

type Meta = "read" | "date" | "date-tags";

interface PostCardProps {
  post: Post;
  /** Heading element for the title, pick the one that fits the page outline. */
  as?: "h2" | "h3" | "p";
  /** What renders under the excerpt. */
  meta?: Meta;
  /** `sizes` for the cover image; set it to match the grid's column count. */
  sizes?: string;
  /**
   * Mark the cover as the LCP image, set it on the first card of an
   * above-the-fold grid so Next preloads it instead of lazy-loading. Without
   * this the first generated card is the largest paint yet loads late.
   */
  priority?: boolean;
  className?: string;
}

function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
}

export function PostCard({
  post,
  as = "h3",
  meta = "read",
  sizes = "(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw",
  priority = false,
  className,
}: PostCardProps) {
  // Placeholder posts (homepage fallback content) have no real detail page.
  const isPlaceholder = post.id.startsWith("ph-");
  const href = isPlaceholder
    ? "/blog"
    : post.slug.startsWith("#")
      ? post.slug
      : postPath(post.slug);

  // Posts saved without a featured image fall back to a generated card built
  // from the title and category, so every listing has artwork. Placeholder
  // posts are excluded, they have no real title to render into a card.
  const coverUrl = isPlaceholder
    ? post.featured_image_url
    : previewImageUrl({
        title: post.title,
        slug: post.slug,
        featured_image_url: post.featured_image_url,
        categories: post.categories,
      });

  // Each sport has a colour. The card's hover shadow and its chip take that
  // hue, so a reader can tell tennis from Formula 1 before reading the label.
  const sport = post.categories?.slug
    ? siteConfig.theme.sports[post.categories.slug]
    : undefined;

  return (
    <Link
      href={href}
      className="group block h-full focus-visible:outline-none"
      style={{ "--sport": sport ?? "var(--color-text)" } as React.CSSProperties}
    >
      <article
        className={cn(
          "relative flex h-full flex-col overflow-hidden rounded-xl bg-surface",
          "shadow-[inset_0_0_0_1px_var(--color-line)]",
          "transition-[transform,box-shadow] duration-300 ease-[cubic-bezier(0.23,1,0.32,1)]",
          "group-hover:-translate-y-1",
          "group-hover:shadow-[inset_0_0_0_1px_color-mix(in_srgb,var(--sport)_40%,var(--color-line)),0_18px_36px_-20px_color-mix(in_srgb,var(--sport)_45%,transparent),0_6px_14px_-10px_rgb(24_21_18/0.18)]",
          "group-focus-visible:outline-2 group-focus-visible:outline-offset-2 group-focus-visible:outline-accent-ink",
          className
        )}
      >
        {coverUrl && (
          <div className="relative aspect-[16/10] overflow-hidden bg-text/[0.04]">
            <Image
              src={coverUrl}
              alt=""
              fill
              className="object-cover transition-transform duration-[600ms] ease-[cubic-bezier(0.23,1,0.32,1)] group-hover:scale-[1.04]"
              sizes={sizes}
              priority={priority}
              // The generated card is produced on demand by /api/og; there is
              // nothing for the image optimiser to improve on.
              unoptimized={!post.featured_image_url}
            />
            {/* A hairline of sport colour along the foot of the image ties the
                photograph to the category without covering it. */}
            <span
              aria-hidden
              className="absolute inset-x-0 bottom-0 h-[3px]"
              style={{ background: sport ?? "var(--color-text)" }}
            />
          </div>
        )}

        <div className="flex flex-1 flex-col gap-2 p-4">
          <div className="flex items-center gap-2">
            <span
              aria-hidden
              className="h-1.5 w-1.5 shrink-0 rounded-full"
              style={{ background: sport ?? "var(--color-text)" }}
            />
            {post.categories && (
              <span className="stamp text-muted">{post.categories.name}</span>
            )}
            {meta !== "read" && post.published_at && (
              <span className="stamp ml-auto text-muted/60">
                {formatDate(post.published_at)}
              </span>
            )}
          </div>

          {/* The title always renders. A real featured image carries no text,
              so hiding it left cards with a photo and an excerpt but no
              headline. */}
          <CardTitle
            as={as}
            className="text-[1.05rem] leading-[1.2] tracking-[-0.025em] line-clamp-2"
          >
            {post.title}
          </CardTitle>

          {post.excerpt && (
            <p className="text-[0.85rem] leading-snug text-muted line-clamp-2">
              {post.excerpt}
            </p>
          )}

          <span className="mt-auto flex items-center gap-1.5 pt-2.5 stamp text-accent-ink">
            Read
            <span
              aria-hidden
              className="transition-transform duration-300 ease-[cubic-bezier(0.23,1,0.32,1)] group-hover:translate-x-1"
            >
              &rarr;
            </span>
          </span>
        </div>
      </article>
    </Link>
  );
}

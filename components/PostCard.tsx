import Link from "next/link";
import Image from "next/image";
import { previewImageUrl } from "@/lib/admin/preview-image";
import { Card, CardTitle, CardBody, Tag } from "@/components/ui";
import type { Post } from "@/lib/queries";
import { cn, postPath } from "@/lib/utils";

/**
 * The single post card used by every listing surface — homepage, blog index,
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
  /** Heading element for the title — pick the one that fits the page outline. */
  as?: "h2" | "h3" | "p";
  /** What renders under the excerpt. */
  meta?: Meta;
  /** `sizes` for the cover image; set it to match the grid's column count. */
  sizes?: string;
  /**
   * Mark the cover as the LCP image — set it on the first card of an
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
  // posts are excluded — they have no real title to render into a card.
  const coverUrl = isPlaceholder
    ? post.featured_image_url
    : previewImageUrl({
        title: post.title,
        slug: post.slug,
        featured_image_url: post.featured_image_url,
        categories: post.categories,
      });

  const hasCover = Boolean(coverUrl);

  return (
    <Link href={href} className="group block h-full focus-visible:outline-none">
      <Card
        className={cn(
          "h-full flex flex-col overflow-hidden",
          // Presses into its own hard shadow on hover — see globals.css.
          "hard-press",
          "group-focus-visible:outline-2 group-focus-visible:outline-offset-2 group-focus-visible:outline-primary",
          className
        )}
      >
        {/* Cover — bleeds to the card's inner edge, under the 2px outline. */}
        {coverUrl && (
          <div className="relative -mt-6 -mx-6 mb-4 aspect-[1200/630] overflow-hidden border-b-2 border-text bg-primary/[0.05]">
            <Image
              src={coverUrl}
              alt=""
              fill
              className="object-cover"
              sizes={sizes}
              priority={priority}
              // The generated card is produced on demand by /api/og; there is
              // nothing for the image optimiser to improve on.
              unoptimized={!post.featured_image_url}
            />
          </div>
        )}

        {post.categories && (
          <Tag variant="default" className="mb-3 self-start">
            {post.categories.name}
          </Tag>
        )}

        {/* The cover already sets the title in type, so the text title is
            visually redundant there — it stays in the DOM (sr-only) for screen
            readers and crawlers. */}
        <CardTitle
          as={as}
          className={cn(hasCover ? "sr-only" : "text-base leading-snug mb-2 line-clamp-3")}
        >
          {post.title}
        </CardTitle>

        {post.excerpt && (
          <CardBody className="flex-1 line-clamp-3 text-sm">{post.excerpt}</CardBody>
        )}

        {meta === "read" && <p className="mt-4 stamp text-primary">Read →</p>}

        {meta === "date" && post.published_at && (
          <p className="mt-4 stamp text-muted/70">{formatDate(post.published_at)}</p>
        )}

        {meta === "date-tags" && (
          <>
            {post.audience_tags.length > 0 && (
              <div className="flex flex-wrap gap-1.5 mt-4">
                {post.audience_tags.map((tag) => (
                  <Tag key={tag} variant="default" className="text-[10px]">
                    {tag.replace(/-/g, " ")}
                  </Tag>
                ))}
              </div>
            )}
            {post.published_at && (
              <p className="mt-3 stamp text-muted/70">{formatDate(post.published_at)}</p>
            )}
          </>
        )}
      </Card>
    </Link>
  );
}

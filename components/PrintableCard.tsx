import Link from "next/link";
import Image from "next/image";

import { Card, CardTitle, CardBody, Tag } from "@/components/ui";
import { printableThumbnail } from "@/lib/admin/preview-image";
import type { Printable } from "@/lib/queries";
import { cn } from "@/lib/utils";

/**
 * Grid card for a printable. Mirrors PostCard's shape so the two listings feel
 * like one system.
 *
 * A printable with no uploaded thumbnail falls back to the same generated card
 * that covers imageless posts, so the grid never has a hole in it.
 */
export function PrintableCard({
  printable,
  className,
  sizes = "(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw",
}: {
  printable: Printable;
  className?: string;
  sizes?: string;
}) {
  const thumb = printableThumbnail(printable);

  return (
    <Link
      href={`/printables/${printable.slug}`}
      className="group block h-full focus-visible:outline-none"
    >
      <Card
        className={cn(
          "flex h-full flex-col overflow-hidden",
          "hard-press",
          "group-focus-visible:outline-2 group-focus-visible:outline-offset-2 group-focus-visible:outline-primary",
          className
        )}
      >
        <div className="relative -mx-6 -mt-6 mb-4 aspect-[1200/630] overflow-hidden border-b-2 border-text bg-primary/[0.05]">
          <Image
            src={thumb}
            alt=""
            fill
            className="object-cover"
            sizes={sizes}
            unoptimized={!printable.thumbnail_url}
          />
        </div>

        <div className="mb-3 flex flex-wrap items-center gap-2">
          <Tag variant="accent">Free download</Tag>
          {printable.categories && (
            <Tag variant="default">{printable.categories.name}</Tag>
          )}
        </div>

        <CardTitle as="h3" className="mb-2 text-base leading-snug">
          {printable.title}
        </CardTitle>

        {printable.description && (
          <CardBody className="line-clamp-3 flex-1 text-sm">
            {printable.description}
          </CardBody>
        )}

        <p className="stamp mt-4 text-primary">View &amp; download →</p>
      </Card>
    </Link>
  );
}

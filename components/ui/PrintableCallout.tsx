import { HTMLAttributes } from "react";

import { Tag } from "./Tag";
import { cn } from "@/lib/utils";

/**
 * The loudest block in the system: a solid Pitch Green panel with a Floodlight
 * Amber blob bleeding out of one corner. The perforation motif survives as the
 * dashed "cut here" rule on the paper glyph.
 *
 * Recovered from the pre-migration template and repointed at /printables.
 * Unlike the original, which hardcoded "Free Printable Worksheet" for every
 * callout, this takes the printable's real title and description, so an inline
 * mention tells the reader what they're actually downloading.
 */

interface PrintableCalloutProps extends HTMLAttributes<HTMLDivElement> {
  title: string;
  description: string;
  href?: string;
  badge?: string;
  /** Label on the button. */
  cta?: string;
}

export function PrintableCallout({
  title,
  description,
  href = "/printables",
  badge = "Free download",
  cta = "Get it",
  className,
  ...props
}: PrintableCalloutProps) {
  return (
    <div
      className={cn(
        "relative overflow-hidden",
        "bg-primary text-white",
        "shadow-[inset_0_0_0_1px_var(--color-line)] rounded-3xl p-7 sm:p-8",
        "",
        "flex flex-col sm:flex-row items-start sm:items-center gap-6",
        className
      )}
      {...props}
    >
      {/* Amber blob bleeding out of the top-right, the panel motif. Low
          opacity and tucked outside the padding box so it never competes with
          the amber CTA sitting in the same corner. */}
      <div
        aria-hidden
        className="pointer-events-none absolute -top-24 -right-24 h-56 w-56 rounded-full bg-accent/15"
      />

      {/* Ruled-paper glyph with a dashed cut line. */}
      <div
        className="relative flex h-16 w-14 shrink-0 flex-col items-center justify-center gap-1.5 rounded-lg shadow-[inset_0_0_0_1px_var(--color-line)] bg-surface px-2"
        aria-hidden
      >
        {[0, 1, 2].map((i) => (
          <span
            key={i}
            className="block h-0.5 rounded-full bg-muted/50"
            style={{ width: i === 0 ? "60%" : "100%" }}
          />
        ))}
        <span className="mt-1 block w-full border-t-2 border-dashed border-text/30" />
      </div>

      <div className="relative min-w-0 flex-1">
        <div className="mb-2.5 flex items-center gap-2">
          <Tag variant="accent">{badge}</Tag>
        </div>
        <p className="mb-1.5 font-display text-xl font-extrabold leading-[1.1] tracking-[-0.02em] text-white">
          {title}
        </p>
        <p className="text-sm leading-relaxed text-white/75">{description}</p>
      </div>

      {/* Plain anchor with button styling, no client JS needed. */}
      <a
        href={href}
        className={cn(
          "relative inline-flex shrink-0 items-center justify-center gap-2",
          "shadow-[inset_0_0_0_1px_var(--color-line)] bg-accent text-text",
          "rounded-full px-6 py-2.5 text-[0.95rem]",
          "font-semibold  lift",
          "hover:brightness-105",
          "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
        )}
      >
        {cta}
      </a>
    </div>
  );
}

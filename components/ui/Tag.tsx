// ── Tag, the chip ────────────────────────────────────────────────────────────
//
// Geist Mono · uppercase · 0.1em letter-spacing · filled · fully rounded.
// In the Bold Daylight system a tag is a solid chip rather than an outline, so
// it holds its own next to the heavy display type instead of disappearing.
// Every variant is a filled surface with ink or white text, never a light
// fill with white text, which is why `accent` (lime) carries ink.

import { HTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export type TagVariant = "default" | "primary" | "accent" | "success";

interface TagProps extends HTMLAttributes<HTMLSpanElement> {
  variant?: TagVariant;
}

const variantClasses: Record<TagVariant, string> = {
  default: "bg-text/[0.06] text-muted   border-text/15",
  primary: "bg-primary     text-white   border-primary",
  accent:  "bg-accent      text-text    border-text",
  success: "bg-success     text-white   border-success",
};

export function Tag({ variant = "default", className, children, ...props }: TagProps) {
  return (
    <span
      className={cn(
        // stamp utility (defined in globals.css): mono, uppercase, letter-spaced
        "stamp",
        "inline-flex items-center",
        "px-2.5 py-[4px]",
        "border rounded-full",
        "whitespace-nowrap",
        variantClasses[variant],
        className
      )}
      {...props}
    >
      {children}
    </span>
  );
}

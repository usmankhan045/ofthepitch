import { HTMLAttributes } from "react";
import { cn } from "@/lib/utils";

// A card in this system is a sheet of paper lifted off the page: a white
// surface, a 2px ink outline, and a solid un-blurred offset shadow beneath it.
// The "ledger" variant casts its shadow in primary, "plain" in ink — the two
// read as the same object at different emphasis.

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  /** "ledger" (default) casts a teal offset shadow — the emphasized sheet.
   *  "plain" casts a plain ink shadow for dense or secondary contexts. */
  variant?: "ledger" | "plain";
  /** Reduces padding for dense list contexts */
  compact?: boolean;
}

export function Card({
  variant = "ledger",
  compact = false,
  className,
  children,
  ...props
}: CardProps) {
  return (
    <div
      className={cn(
        // text-left keeps card interiors left-aligned even under the mobile
        // text-centering rule in globals.css (cards read cleaner left-aligned).
        "bg-surface rounded-2xl text-left",
        "border-2 border-text",
        variant === "ledger"
          ? "shadow-[5px_5px_0_var(--color-primary)] [--shadow-color:var(--color-primary)]"
          : "shadow-[5px_5px_0_var(--color-text)]",
        compact ? "p-4" : "p-6",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

// ── Compound sub-components ───────────────────────────────────────────────────

interface CardHeaderProps extends HTMLAttributes<HTMLDivElement> {}

export function CardHeader({ className, children, ...props }: CardHeaderProps) {
  return (
    <div className={cn("mb-3", className)} {...props}>
      {children}
    </div>
  );
}

interface CardTitleProps extends HTMLAttributes<HTMLHeadingElement> {
  as?: "h2" | "h3" | "h4" | "p";
}

export function CardTitle({ as: Tag = "h3", className, children, ...props }: CardTitleProps) {
  return (
    <Tag
      className={cn(
        "font-display text-xl font-extrabold text-text leading-[1.1] tracking-[-0.02em]",
        className
      )}
      {...props}
    >
      {children}
    </Tag>
  );
}

interface CardBodyProps extends HTMLAttributes<HTMLDivElement> {}

export function CardBody({ className, children, ...props }: CardBodyProps) {
  return (
    <div className={cn("text-muted text-sm leading-relaxed", className)} {...props}>
      {children}
    </div>
  );
}

interface CardFooterProps extends HTMLAttributes<HTMLDivElement> {}

export function CardFooter({ className, children, ...props }: CardFooterProps) {
  return (
    <div className={cn("mt-4 pt-4 border-t-2 border-line", className)} {...props}>
      {children}
    </div>
  );
}

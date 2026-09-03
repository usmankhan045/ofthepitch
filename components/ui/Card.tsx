import { HTMLAttributes } from "react";
import { cn } from "@/lib/utils";

// A card is a white sheet on the paper ground, held by a hairline rule rather
// than a heavy outline. Depth arrives only on hover, via the `lift` utility in
// globals.css, and the shadow it casts is tinted with the card's own sport
// colour. Set `--sport` on the element to colour it; without it the shadow
// falls back to ink.

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  /** Reduces padding for dense list contexts. */
  compact?: boolean;
  /** Adds the hover lift. Leave off for static panels. */
  interactive?: boolean;
}

export function Card({
  compact = false,
  interactive = false,
  className,
  children,
  ...props
}: CardProps) {
  return (
    <div
      className={cn(
        "bg-surface rounded-2xl text-left",
        "shadow-[inset_0_0_0_1px_var(--color-line)]",
        interactive && "lift",
        compact ? "p-4" : "p-6",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

export function CardHeader({ className, children, ...props }: HTMLAttributes<HTMLDivElement>) {
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
        "font-display text-xl font-extrabold text-text leading-[1.1] tracking-[-0.03em]",
        className
      )}
      {...props}
    >
      {children}
    </Tag>
  );
}

export function CardBody({ className, children, ...props }: HTMLAttributes<HTMLDivElement>) {
  return (
    <div className={cn("text-muted text-sm leading-relaxed", className)} {...props}>
      {children}
    </div>
  );
}

export function CardFooter({ className, children, ...props }: HTMLAttributes<HTMLDivElement>) {
  return (
    <div className={cn("mt-4 pt-4 border-t border-line", className)} {...props}>
      {children}
    </div>
  );
}

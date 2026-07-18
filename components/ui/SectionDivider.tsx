import { HTMLAttributes } from "react";
import { cn } from "@/lib/utils";

interface SectionDividerProps extends HTMLAttributes<HTMLDivElement> {
  /** "plain" — a single ruled line (default).
   *  "titled" — the label sits centered between two rules, like a ledger section header. */
  variant?: "plain" | "titled";
  label?: string;
  /** Extra vertical spacing around the divider */
  spacing?: "sm" | "md" | "lg";
}

const spacingClasses = {
  sm: "my-6",
  md: "my-10",
  lg: "my-16",
};

export function SectionDivider({
  variant = "plain",
  label,
  spacing = "md",
  className,
  ...props
}: SectionDividerProps) {
  if (variant === "titled" && label) {
    return (
      <div
        className={cn(
          "flex items-center gap-4",
          spacingClasses[spacing],
          className
        )}
        role="separator"
        aria-label={label}
        {...props}
      >
        <Rule />
        {/* The label sits on a lime bar — the same highlight motif as the hero
            mark, scaled down to a section marker. */}
        <span className="stamp text-text bg-accent px-3 py-1 rounded-full whitespace-nowrap shrink-0">
          {label}
        </span>
        <Rule />
      </div>
    );
  }

  return (
    <div
      className={cn("flex items-center gap-4", spacingClasses[spacing], className)}
      role="separator"
      {...props}
    >
      <Rule />
      {/* A lime dot centered in the rule — the system's punctuation mark. */}
      <span
        className="block w-2 h-2 rounded-full bg-accent border border-text shrink-0"
        aria-hidden
      />
      <Rule />
    </div>
  );
}

function Rule() {
  return <span className="block flex-1 h-0.5 bg-line" />;
}

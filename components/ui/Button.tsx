"use client";

import { ButtonHTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export type ButtonVariant = "primary" | "outline" | "ghost" | "accent";
export type ButtonSize    = "sm" | "md" | "lg";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
}

// Every variant is a pill with a 2px ink outline. Depth comes from the hard
// (un-blurred) offset shadow, which the button presses into on hover via the
// `hard-press` utility — see globals.css. `--shadow-color` tells that utility
// which color to keep while the offset shrinks.
const variantClasses: Record<ButtonVariant, string> = {
  primary:
    "bg-primary text-white border-2 border-text " +
    "shadow-[4px_4px_0_var(--color-text)] hard-press " +
    "hover:bg-primary-dark " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary",

  outline:
    "bg-surface text-text border-2 border-text " +
    "shadow-[4px_4px_0_var(--color-text)] hard-press " +
    "hover:bg-accent " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary",

  ghost:
    "bg-transparent text-text border-2 border-transparent " +
    "hover:bg-text/[0.06] " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary",

  // Lime is a light surface — it always carries ink text, never white.
  accent:
    "bg-accent text-text border-2 border-text " +
    "shadow-[4px_4px_0_var(--color-text)] hard-press " +
    "hover:brightness-105 " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-text",
};

// Pills at every size — the radius is intentionally maxed out rather than
// scaled, so a small and a large button read as the same component.
const sizeClasses: Record<ButtonSize, string> = {
  sm: "px-4 py-1.5 text-sm rounded-full",
  md: "px-6 py-2.5 text-[0.95rem] rounded-full",
  lg: "px-8 py-3.5 text-base rounded-full",
};

export function Button({
  variant = "primary",
  size = "md",
  className,
  children,
  disabled,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        "inline-flex items-center justify-center gap-2",
        "font-body font-semibold",
        "transition duration-150 cursor-pointer",
        "disabled:opacity-50 disabled:pointer-events-none",
        variantClasses[variant],
        sizeClasses[size],
        className
      )}
      disabled={disabled}
      {...props}
    >
      {children}
    </button>
  );
}

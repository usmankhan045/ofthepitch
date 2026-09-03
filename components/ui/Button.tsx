"use client";

import { ButtonHTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export type ButtonVariant = "primary" | "outline" | "ghost" | "accent";
export type ButtonSize    = "sm" | "md" | "lg";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
}

// Buttons are solid shapes with no outline. Gold is a light surface so it
// always carries ink, never white. The press feedback comes from `press` in
// globals.css: a slight shrink that confirms the interface heard the tap.
const variantClasses: Record<ButtonVariant, string> = {
  primary:
    "bg-text text-background press " +
    "hover:bg-primary-dark " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent-ink",

  outline:
    "bg-transparent text-text shadow-[inset_0_0_0_1.5px_var(--color-line)] press " +
    "hover:shadow-[inset_0_0_0_1.5px_var(--color-accent)] " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent-ink",

  ghost:
    "bg-transparent text-text press " +
    "hover:bg-text/[0.05] " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent-ink",

  // Gold carries ink text at every size. White on gold fails contrast.
  accent:
    "bg-accent text-text press " +
    "shadow-[0_1px_0_rgba(255,255,255,0.45)_inset,0_8px_20px_-10px_color-mix(in_srgb,var(--color-accent)_55%,transparent)] " +
    "hover:brightness-[1.04] " +
    "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-text",
};

const sizeClasses: Record<ButtonSize, string> = {
  sm: "px-4 py-1.5 text-sm rounded-lg",
  md: "px-5 py-2.5 text-[0.94rem] rounded-lg",
  lg: "px-7 py-3.5 text-base rounded-xl",
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
        "cursor-pointer",
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

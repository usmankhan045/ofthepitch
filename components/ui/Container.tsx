import { HTMLAttributes } from "react";
import { cn } from "@/lib/utils";

interface ContainerProps extends HTMLAttributes<HTMLDivElement> {
  /** "default", 80rem for most pages. The old 64rem left wide displays with
   *  large empty margins and squeezed three-column grids into the middle.
   *  "narrow" , 45rem for reading-focused content (articles, legal pages),
   *  which keeps a comfortable line length rather than matching the shell.
   *  "wide"   , 96rem for full-bleed grids. */
  width?: "default" | "narrow" | "wide";
}

// "swc-read" marks reading-focused containers so the mobile text-centering rule
// in globals.css leaves their content left-aligned for legibility.
const widthClasses = {
  default: "max-w-[80rem]",
  narrow:  "max-w-[45rem] swc-read",
  wide:    "max-w-[96rem]",
};

export function Container({
  width = "default",
  className,
  children,
  ...props
}: ContainerProps) {
  return (
    <div
      className={cn(
        "w-full mx-auto px-5 sm:px-8 lg:px-12",
        widthClasses[width],
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

"use client";

import { useEffect, useRef, useState } from "react";

/**
 * Scaled preview of a printable.
 *
 * Recovered from the pre-migration template, which framed static HTML files
 * from /public. Here the file is a PDF in Supabase Storage instead, browsers
 * render those inline natively, and next.config.ts already allows it
 * (`frame-src 'self' https://*.supabase.co`, added for exactly this).
 *
 * Rendered with `<object type="application/pdf">` rather than an `<iframe>` for
 * two reasons the iframe version got wrong:
 *
 *  1. An `<iframe sandbox="">` is the *most* restrictive sandbox, it withholds
 *     scripts and same-origin, and Chrome's built-in PDF viewer needs both, so
 *     the preview rendered blank. `<object>` needs no sandbox opt-out to display
 *     a PDF, and the file is one of our own from a CSP-restricted origin.
 *  2. `<iframe onError>` does not fire for a document that fails to load, so the
 *     old fallback was dead code. `<object>` renders its children instead
 *     whenever the browser can't display the PDF inline, a real, browser-driven
 *     fallback with no unreliable JS.
 *
 * The object is rendered at true page size and CSS-scaled down, rather than
 * given a percentage width, so the sheet keeps its real proportions at any
 * container width.
 */

// US Letter at 96dpi.
const PORTRAIT_W = 816;
const PORTRAIT_H = 1056;

export function PrintablePreview({
  fileUrl,
  title,
  orientation = "portrait",
}: {
  fileUrl: string;
  title: string;
  orientation?: "portrait" | "landscape";
}) {
  const contentWidth = orientation === "landscape" ? PORTRAIT_H : PORTRAIT_W;
  const contentHeight = orientation === "landscape" ? PORTRAIT_W : PORTRAIT_H;

  const containerRef = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(0.466);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const update = () => setScale(el.offsetWidth / contentWidth);

    update();
    const ro = new ResizeObserver(update);
    ro.observe(el);
    return () => ro.disconnect();
  }, [contentWidth]);

  return (
    <div
      ref={containerRef}
      className="overflow-hidden rounded-2xl shadow-[inset_0_0_0_1px_var(--color-line)] bg-surface "
      style={{ height: contentHeight * scale }}
    >
      <object
        data={`${fileUrl}#toolbar=0&navpanes=0&view=FitH`}
        type="application/pdf"
        aria-label={`Preview of ${title}`}
        // Rendered at true size then scaled, keeps the sheet's proportions.
        style={{
          display: "block",
          width: contentWidth,
          height: contentHeight,
          transform: `scale(${scale})`,
          transformOrigin: "top left",
          border: 0,
        }}
      >
        {/* Shown by the browser when it can't display the PDF inline
            (common on mobile). Not JS, the <object> swaps to it itself. */}
        <div className="flex h-full flex-col items-center justify-center gap-4 bg-surface px-10 text-center">
          <p className="text-2xl text-muted">
            Preview isn&rsquo;t available in this browser.
          </p>
          <a
            href={fileUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="text-2xl font-semibold text-primary underline underline-offset-4"
          >
            Open the PDF instead
          </a>
        </div>
      </object>
    </div>
  );
}

import { MDXRemote } from "next-mdx-remote/rsc";
import remarkGfm from "remark-gfm";
import type { ComponentPropsWithoutRef } from "react";
import { PrintableCallout } from "@/components/ui";

/**
 * Resolve `{{...}}` shortcodes before MDX sees them.
 *
 * ORDER MATTERS. `{{printable:slug}}` must be expanded FIRST, because the
 * catch-all strip below removes every remaining `{{...}}` token, that strip is
 * why printable mentions silently vanished from migrated content.
 *
 * The catch-all is not optional: MDX parses `{...}` as a JavaScript expression,
 * so an unreplaced placeholder is a hard build failure, not a cosmetic glitch.
 * The migrated WordPress content shipped `{{MID_IMAGE}}` in 15 articles and
 * broke the production build.
 */
function expandShortcodes(content: string): string {
  return (
    content
      // 1. Printable mentions → a real component. Slug is restricted to the
      //    URL-safe charset so nothing can be injected into the JSX attribute.
      .replace(
        /\{\{printable:\s*([a-z0-9-]+)\s*\}\}/gi,
        (_match, slug: string) =>
          `\n\n<InlinePrintable slug="${slug.toLowerCase()}" />\n\n`
      )
      // 2. Everything else that survived → removed, so MDX can't choke on it.
      .replace(/\{\{[^}\n]*\}\}/g, "")
  );
}

/**
 * Inline printable mention.
 *
 * Renders synchronously from the slug alone, MDX component maps can't await,
 * and a per-mention database round trip inside the article body would be a
 * needless N+1. The post page fetches the post's attached printables and passes
 * them down via `printables`, so a mention whose slug is attached shows its real
 * title and description; one that isn't still renders a working link.
 */
function makeInlinePrintable(printables: PrintableRef[]) {
  return function InlinePrintable({ slug }: { slug: string }) {
    const match = printables.find((p) => p.slug === slug);

    return (
      <div className="my-8 not-prose">
        <PrintableCallout
          title={match?.title ?? "Free printable"}
          description={
            match?.description ??
            "Download this checklist and take it with you. No email required."
          }
          href={`/printables/${slug}`}
        />
      </div>
    );
  };
}

export interface PrintableRef {
  slug: string;
  title: string;
  description: string | null;
}

const mdxComponents = {
  h2: ({ children, ...props }: ComponentPropsWithoutRef<"h2">) => (
    <h2
      className="font-display text-2xl sm:text-3xl font-bold text-text mt-12 mb-4 leading-snug"
      {...props}
    >
      {children}
    </h2>
  ),
  h3: ({ children, ...props }: ComponentPropsWithoutRef<"h3">) => (
    <h3
      className="font-display text-xl font-semibold text-text mt-8 mb-3 leading-snug"
      {...props}
    >
      {children}
    </h3>
  ),
  h4: ({ children, ...props }: ComponentPropsWithoutRef<"h4">) => (
    <h4 className="font-semibold text-text mt-6 mb-2" {...props}>
      {children}
    </h4>
  ),
  p: ({ children, ...props }: ComponentPropsWithoutRef<"p">) => (
    <p
      className="text-text/85 leading-relaxed mb-5 text-base sm:text-[1.0625rem]"
      {...props}
    >
      {children}
    </p>
  ),
  ul: ({ children, ...props }: ComponentPropsWithoutRef<"ul">) => (
    <ul
      className="list-disc pl-6 space-y-2 mb-6 text-text/85 leading-relaxed"
      {...props}
    >
      {children}
    </ul>
  ),
  ol: ({ children, ...props }: ComponentPropsWithoutRef<"ol">) => (
    <ol
      className="list-decimal pl-6 space-y-2 mb-6 text-text/85 leading-relaxed"
      {...props}
    >
      {children}
    </ol>
  ),
  li: ({ children, ...props }: ComponentPropsWithoutRef<"li">) => (
    <li className="leading-relaxed" {...props}>
      {children}
    </li>
  ),
  strong: ({ children, ...props }: ComponentPropsWithoutRef<"strong">) => (
    <strong className="font-semibold text-text" {...props}>
      {children}
    </strong>
  ),
  em: ({ children, ...props }: ComponentPropsWithoutRef<"em">) => (
    <em className="italic" {...props}>
      {children}
    </em>
  ),
  a: ({ children, href, ...props }: ComponentPropsWithoutRef<"a">) => (
    <a
      href={href}
      className="text-primary underline underline-offset-2 hover:opacity-80 transition-opacity"
      {...props}
    >
      {children}
    </a>
  ),
  blockquote: ({ children, ...props }: ComponentPropsWithoutRef<"blockquote">) => (
    <blockquote
      className="border-l-4 border-primary/30 pl-5 py-1 my-7 text-muted italic rounded-r-lg bg-primary/[0.03]"
      {...props}
    >
      {children}
    </blockquote>
  ),
  table: ({ children, ...props }: ComponentPropsWithoutRef<"table">) => (
    <div className="overflow-x-auto mb-7 rounded-xl border border-black/[0.08]">
      <table className="w-full text-sm border-collapse" {...props}>
        {children}
      </table>
    </div>
  ),
  thead: ({ children, ...props }: ComponentPropsWithoutRef<"thead">) => (
    <thead className="bg-primary/[0.07]" {...props}>
      {children}
    </thead>
  ),
  th: ({ children, ...props }: ComponentPropsWithoutRef<"th">) => (
    <th
      className="border-b border-black/[0.08] px-4 py-3 text-left font-semibold text-text text-xs uppercase tracking-wide"
      {...props}
    >
      {children}
    </th>
  ),
  td: ({ children, ...props }: ComponentPropsWithoutRef<"td">) => (
    <td className="border-b border-black/[0.05] px-4 py-3 text-text/85" {...props}>
      {children}
    </td>
  ),
  tr: ({ children, ...props }: ComponentPropsWithoutRef<"tr">) => (
    <tr className="hover:bg-primary/[0.02] transition-colors" {...props}>
      {children}
    </tr>
  ),
  img: ({ src, alt, ...props }: ComponentPropsWithoutRef<"img">) => (
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src={src}
      alt={alt ?? ""}
      className="rounded-xl w-full my-7 border border-black/[0.06]"
      loading="lazy"
      {...props}
    />
  ),
  hr: () => <hr className="border-none h-px bg-muted/20 my-10" />,
  code: ({ children, ...props }: ComponentPropsWithoutRef<"code">) => (
    <code
      className="font-mono text-sm bg-primary/[0.08] px-1.5 py-0.5 rounded text-primary"
      {...props}
    >
      {children}
    </code>
  ),
  pre: ({ children, ...props }: ComponentPropsWithoutRef<"pre">) => (
    <pre
      className="bg-text/90 text-background rounded-xl p-5 overflow-x-auto mb-7 text-sm leading-relaxed"
      {...props}
    >
      {children}
    </pre>
  ),
};

interface MarkdownContentProps {
  content: string;
  /**
   * Printables attached to this post. Used to give `{{printable:slug}}`
   * mentions their real title and description; omitting it still renders a
   * working link with generic copy.
   */
  printables?: PrintableRef[];
}

export async function MarkdownContent({
  content,
  printables = [],
}: MarkdownContentProps) {
  const processed = expandShortcodes(content);

  const components = {
    ...mdxComponents,
    InlinePrintable: makeInlinePrintable(printables),
  };

  return (
    <MDXRemote
      source={processed}
      options={{ mdxOptions: { remarkPlugins: [remarkGfm] } }}
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      components={components as any}
    />
  );
}

import type { Metadata } from "next";
import Link from "next/link";
import { siteConfig } from "@/lib/site.config";
import { Container, Tag, SectionDivider } from "@/components/ui";
import { ogImages, twitterImages } from "@/lib/metadata";

export const metadata: Metadata = {
  title: "Editorial Policy",
  description: `How ${siteConfig.name} researches, sources, and updates its World Cup 2026 coverage — and the limits of what we publish.`,
  alternates: { canonical: "/editorial-policy" },
  openGraph: { url: "/editorial-policy", type: "website", images: ogImages() },
  twitter: twitterImages(),
};

const PRINCIPLES: { title: string; body: string }[] = [
  {
    title: "We check coverage against official sources",
    body: "Details that affect a trip — entry requirements, match schedules, venue rules, ticket sale windows, broadcast rights — are checked against the bodies that actually set them: FIFA, national immigration and border agencies, host city and stadium authorities, and national broadcasters. Where a source exists publicly, we link to it so you can confirm it yourself.",
  },
  {
    title: "We separate confirmed detail from expectation",
    body: "A tournament this size runs on announcements that arrive late and change often. When something is officially confirmed we say so. When it is our expectation, a pattern from previous tournaments, or a figure still being reported second-hand, we frame it that way rather than presenting it as settled.",
  },
  {
    title: "We update as the tournament unfolds",
    body: "Prices, queues, transport arrangements and requirements move between now and the final. We revisit guides as new information is published and revise them rather than leaving stale detail in place. Substantive updates are reflected in each article's “Updated” date.",
  },
  {
    title: "We tell you when to verify for yourself",
    body: "For anything with real consequences if it is wrong — visa and entry rules, travel authorisation, official ticket sales — we point you to the official source and encourage you to check it directly before you book or travel. Requirements vary by nationality and change without much notice.",
  },
  {
    title: "We correct mistakes openly",
    body: "If we get something wrong, we fix it. You can flag an error any time via the contact page and we will review it.",
  },
];

export default function EditorialPolicyPage() {
  return (
    <main className="flex-1">
      {/* ── Hero ───────────────────────────────────────────────────────────── */}
      <section
        className="bg-gradient-to-b from-primary/[0.07] via-primary/[0.03] to-background pt-10 pb-10"
        aria-labelledby="editorial-heading"
      >
        <Container width="narrow">
          <Tag variant="primary" className="mb-5">Editorial Policy</Tag>
          <h1
            id="editorial-heading"
            className="font-display text-4xl sm:text-5xl font-bold text-text leading-tight mb-5"
          >
            How we research and check what we publish.
          </h1>
          <p className="text-lg text-muted leading-relaxed">
            {siteConfig.name} publishes guides for fans travelling to the 2026
            World Cup — people booking flights, chasing tickets and crossing
            borders on the strength of what they read. Here is exactly how we
            research, source, and maintain that coverage.
          </p>
        </Container>
      </section>

      {/* ── Principles ─────────────────────────────────────────────────────── */}
      <section className="py-12 sm:py-14" aria-label="Editorial principles">
        <Container width="narrow">
          <ul className="space-y-7">
            {PRINCIPLES.map((p) => (
              <li key={p.title} className="flex gap-4">
                <span
                  className="shrink-0 mt-1.5 w-5 h-5 rounded-full bg-primary/15 border border-primary/25 flex items-center justify-center"
                  aria-hidden
                >
                  <span className="w-1.5 h-1.5 rounded-full bg-primary block" />
                </span>
                <div>
                  <p className="font-medium text-text mb-1">{p.title}</p>
                  <p className="text-muted text-sm leading-relaxed">{p.body}</p>
                </div>
              </li>
            ))}
          </ul>
        </Container>
      </section>

      {/* ── Who writes this + not-advice note ──────────────────────────────── */}
      <section className="py-12 bg-primary/[0.03]" aria-label="Authorship and independence">
        <Container width="narrow">
          <SectionDivider variant="titled" label="Who writes this" spacing="sm" />
          <p className="mt-8 text-text/85 leading-relaxed text-sm sm:text-base">
            Guides are published under{" "}
            <Link href={siteConfig.author.url} className="text-primary font-medium hover:underline underline-offset-4">
              {siteConfig.author.name}
            </Link>
            , the {siteConfig.author.role.toLowerCase()} account we byline all
            coverage to, rather than an individual writer.
          </p>
          <p className="mt-4 text-text/85 leading-relaxed text-sm sm:text-base">
            {siteConfig.legal.disclaimer} We have no commercial or editorial
            relationship with the organisers, and nothing we publish is official
            tournament communication. For entry requirements, ticket sales and
            match scheduling, the official source is always the final word — see
            our{" "}
            <Link href="/affiliate-disclosure" className="text-primary font-medium hover:underline underline-offset-4">
              affiliate disclosure
            </Link>{" "}
            for how we handle commercial links.
          </p>
        </Container>
      </section>
    </main>
  );
}

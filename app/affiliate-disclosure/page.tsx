import type { Metadata } from "next";
import Link from "next/link";
import { siteConfig } from "@/lib/site.config";
import { Container, Tag, SectionDivider } from "@/components/ui";
import { ogImages, twitterImages } from "@/lib/metadata";

export const metadata: Metadata = {
  title: "Affiliate Disclosure",
  description: `How ${siteConfig.name} uses affiliate links, and our promise that recommendations are never influenced by commissions.`,
  alternates: { canonical: "/affiliate-disclosure" },
  openGraph: { url: "/affiliate-disclosure", type: "website", images: ogImages() },
  twitter: twitterImages(),
};

export default function AffiliateDisclosurePage() {
  return (
    <main className="flex-1">
      {/* ── Hero ───────────────────────────────────────────────────────────── */}
      <section
        className="bg-gradient-to-b from-primary/[0.07] via-primary/[0.03] to-background pt-10 pb-10"
        aria-labelledby="affiliate-heading"
      >
        <Container width="narrow">
          <Tag variant="primary" className="mb-5">Affiliate Disclosure</Tag>
          <h1
            id="affiliate-heading"
            className="font-display text-4xl sm:text-5xl font-bold text-text leading-tight mb-5"
          >
            How we make money &mdash; and how we don&rsquo;t.
          </h1>
          <p className="text-lg text-muted leading-relaxed">
            {siteConfig.name} is free to read, and we keep it that way partly
            through affiliate partnerships. Here&rsquo;s exactly what that means,
            in plain language.
          </p>
          <p className="mt-4 text-sm text-muted leading-relaxed">
            {siteConfig.legal.disclaimer}
          </p>
        </Container>
      </section>

      {/* ── Body ───────────────────────────────────────────────────────────── */}
      <section className="py-12 sm:py-14" aria-label="Affiliate disclosure details">
        <Container width="narrow">
          <div className="space-y-6 text-text/85 leading-relaxed text-sm sm:text-base">
            <p>
              Some of our guides contain <span className="font-medium text-text">affiliate links</span>.
              If you click one and sign up for or buy a product, we may earn a small
              commission &mdash; <span className="font-medium text-text">at no extra cost to you</span>.
              You never pay more for using our link.
            </p>
            <p>
              Where they exist, these links sit alongside the kinds of things a
              travelling fan actually books &mdash; flights, accommodation and
              transport; tours and matchday experiences; ticket and hospitality
              resellers; streaming or broadcast subscriptions for watching
              matches; travel insurance and eSIMs; and kit and merchandise. We
              link to a paid option only where we think it genuinely helps, and
              we say plainly when the free or official route is the better one.
            </p>
            <p className="font-medium text-text">
              A commission never changes our recommendation.
            </p>
            <p>
              We do not accept payment to feature a product, and we don&rsquo;t
              recommend anything we wouldn&rsquo;t suggest to a friend making the
              same trip. Nothing on this site is behind a paywall, and you never
              need to buy through us to use our guides.
            </p>
            <p>
              One thing worth stating clearly: for match tickets, the official
              sale channel is the one we point you to first. Where we mention a
              resale or hospitality marketplace, treat it as an option to
              research, not an endorsement &mdash; prices, legitimacy and
              transfer rules vary, and only the official channel is guaranteed.
            </p>
            <p>
              This disclosure is provided in good faith and in line with the U.S.
              Federal Trade Commission&rsquo;s guidance on endorsements. Questions?{" "}
              <Link href="/contact" className="text-primary font-medium hover:underline underline-offset-4">
                Get in touch
              </Link>
              .
            </p>
          </div>

          <div className="mt-10">
            <SectionDivider spacing="sm" />
            <p className="text-sm text-muted mt-6">
              See also our{" "}
              <Link href="/editorial-policy" className="text-primary font-medium hover:underline underline-offset-4">
                editorial policy
              </Link>{" "}
              and{" "}
              <Link href="/terms-of-use" className="text-primary font-medium hover:underline underline-offset-4">
                terms of use
              </Link>
              .
            </p>
          </div>
        </Container>
      </section>
    </main>
  );
}

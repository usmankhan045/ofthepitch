import type { Metadata } from "next";
import { Container, Tag, SectionDivider } from "@/components/ui";
import { ContactForm } from "@/components/ContactForm";
import { JsonLd } from "@/components/JsonLd";
import { contactPageSchema } from "@/lib/schema";
import { ogImages, twitterImages } from "@/lib/metadata";
import { siteConfig } from "@/lib/site.config";

export const metadata: Metadata = {
  title: "Contact",
  description: `Get in touch with ${siteConfig.name}. Corrections, World Cup 2026 topic ideas, or collaboration — we'd love to hear from you.`,
  alternates: { canonical: "/contact" },
  openGraph: { url: "/contact", type: "website", images: ogImages() },
  twitter: twitterImages(),
};

export default function ContactPage() {
  return (
    <main className="flex-1">
      <JsonLd data={[contactPageSchema()]} />

      {/* ── Header ─────────────────────────────────────────────────────────── */}
      <section
        className="bg-gradient-to-b from-primary/[0.07] via-primary/[0.03] to-background pt-10 pb-10"
        aria-labelledby="contact-heading"
      >
        <Container width="narrow">
          <Tag variant="primary" className="mb-5">Contact</Tag>
          <h1
            id="contact-heading"
            className="font-display text-4xl sm:text-5xl font-bold text-text leading-tight mb-5"
          >
            Let&rsquo;s talk.
          </h1>
          <p className="text-lg text-muted leading-relaxed">
            Spotted something out of date in a visa or ticketing guide? Got a host
            city or match you&rsquo;d like covered? Or a collaboration idea?{" "}
            We&rsquo;d love to hear from you.
          </p>
        </Container>
      </section>

      {/* ── Content ────────────────────────────────────────────────────────── */}
      <section className="py-12 sm:py-14">
        <Container>
          <div className="grid sm:grid-cols-[1fr_400px] lg:grid-cols-[1fr_440px] gap-12 lg:gap-16 items-start max-w-5xl mx-auto">

            {/* Left: info ────────────────────────────────────────────────── */}
            <div>
              <SectionDivider variant="titled" label="What to expect" spacing="sm" />

              <div className="mt-8 space-y-7 text-muted leading-relaxed">
                <div>
                  <p className="font-medium text-text mb-1.5">Response time</p>
                  <p className="text-sm">
                    We read every message and reply to the ones that need a reply.
                    Expect a few business days.
                  </p>
                </div>

                <div>
                  <p className="font-medium text-text mb-1.5">Prefer email?</p>
                  <p className="text-sm">
                    Reach us directly at{" "}
                    <a
                      href={`mailto:${siteConfig.contact.email}`}
                      className="text-primary font-medium hover:underline underline-offset-4"
                    >
                      {siteConfig.contact.email}
                    </a>
                    .
                  </p>
                </div>

                <div>
                  <p className="font-medium text-text mb-1.5">What we can help with</p>
                  <ul className="text-sm space-y-2 list-disc pl-4">
                    <li>Corrections and out-of-date guide details</li>
                    <li>Coverage requests: host cities, teams, topics</li>
                    <li>Sponsorship or collaboration inquiries</li>
                    <li>Technical issues with the site</li>
                    <li>Press or media inquiries</li>
                  </ul>
                </div>

                <div>
                  <p className="font-medium text-text mb-1.5">
                    What we can&rsquo;t help with
                  </p>
                  <p className="text-sm">
                    {siteConfig.legal.disclaimer} We can&rsquo;t sell, transfer or
                    troubleshoot match tickets, and we can&rsquo;t advise on your
                    individual visa or immigration case &mdash; check with FIFA or the
                    relevant government authority directly.
                  </p>
                </div>
              </div>
            </div>

            {/* Right: form ───────────────────────────────────────────────── */}
            <div className="bg-white rounded-2xl border border-black/[0.08] shadow-sm p-6 sm:p-8 lg:sticky lg:top-24">
              <p className="font-display text-xl font-semibold text-text mb-1">
                Send a message
              </p>
              <p className="text-sm text-muted mb-6">
                Fill in the form below and we&rsquo;ll get back to you soon.
              </p>
              <ContactForm />
            </div>

          </div>
        </Container>
      </section>

    </main>
  );
}

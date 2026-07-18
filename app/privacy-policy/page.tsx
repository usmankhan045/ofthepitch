import type { Metadata } from "next";
import Link from "next/link";
import { Container, Tag } from "@/components/ui";
import { siteConfig } from "@/lib/site.config";

export const metadata: Metadata = {
  title: "Privacy Policy",
  description: `How ${siteConfig.name} collects, uses, and protects your information.`,
  alternates: { canonical: "/privacy-policy" },
  openGraph: { url: "/privacy-policy", type: "website" },
  robots: { index: false },
};

export default function PrivacyPolicyPage() {
  return (
    <main className="flex-1 py-10 sm:py-12">
      <Container width="narrow">
        <div className="mb-12">
          <Tag variant="default" className="mb-5">Legal</Tag>
          <h1 className="font-display text-4xl font-bold text-text mb-3">
            Privacy Policy
          </h1>
          <p className="text-sm text-muted">Last updated: {siteConfig.legal.lastUpdated}</p>
        </div>

        <div className="space-y-10 text-text/85 leading-relaxed">

          <section>
            <p className="text-sm">
              {siteConfig.name} (&ldquo;we,&rdquo; &ldquo;us,&rdquo; or &ldquo;our&rdquo;)
              operates {siteConfig.domain}. This Privacy Policy explains what information
              we collect when you visit our site, how we use it, and the choices available
              to you. By using the site, you agree to the practices described here.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Information We Collect
            </h2>

            <h3 className="font-semibold text-text text-sm mb-2">
              Information you provide directly
            </h3>
            <ul className="list-disc pl-5 space-y-2 mb-7 text-sm">
              <li>
                <span className="font-medium text-text">Email address</span>, collected if you
                sign up for our email updates
              </li>
              <li>
                <span className="font-medium text-text">Name, email, and message</span>,
                collected when you submit our contact form
              </li>
            </ul>

            <h3 className="font-semibold text-text text-sm mb-2">
              Information collected automatically
            </h3>
            <ul className="list-disc pl-5 space-y-2 text-sm">
              <li>
                <span className="font-medium text-text">Standard server logs</span>, including
                pages requested, referring URLs, browser and device type, and IP address.
                These are generated automatically by our hosting provider as part of
                serving the site
              </li>
              <li>
                <span className="font-medium text-text">Cookies</span>, described in the Cookies
                section below
              </li>
            </ul>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Third-Party Services
            </h2>
            <p className="mb-5 text-sm">
              We use the following third-party services to operate and improve{" "}
              {siteConfig.name}. Each has its own privacy policy governing how it handles
              your data.
            </p>
            <div className="space-y-5">
              {([
                {
                  name: "Supabase",
                  body: "We store subscriber email addresses and contact form submissions in Supabase, a cloud database service. Data is encrypted in transit and at rest. Supabase processes data on our behalf and does not sell or share your information with third parties.",
                },
              ] as const).map((service) => (
                <div
                  key={service.name}
                  className="border-l-2 border-primary/25 pl-5"
                >
                  <p className="font-medium text-text mb-1">{service.name}</p>
                  <p className="text-sm text-muted">{service.body}</p>
                </div>
              ))}
            </div>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Cookies
            </h2>
            <p className="mb-4 text-sm">
              Cookies are small text files placed on your device by your browser. We use
              cookies for:
            </p>
            <ul className="list-disc pl-5 space-y-2 mb-5 text-sm">
              <li>
                <span className="font-medium text-text">Functionality</span>: cookies
                that help the site work correctly (e.g., form state, preferences)
              </li>
              <li>
                <span className="font-medium text-text">Affiliate tracking</span>: if
                you follow an affiliate link from our site, the destination
                merchant or its affiliate network may set a cookie to attribute
                the referral. See our{" "}
                <Link
                  href="/affiliate-disclosure"
                  className="text-primary underline underline-offset-3 hover:opacity-80"
                >
                  affiliate disclosure
                </Link>
                .
              </li>
            </ul>
            <p className="text-sm">
              We do not run advertising or third-party analytics cookies on this site.
              You can disable or delete cookies in your browser settings; doing so may
              affect some site features.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              How We Use Your Information
            </h2>
            <ul className="list-disc pl-5 space-y-2 text-sm">
              <li>To send you the email updates you signed up for (with your consent)</li>
              <li>To respond to your contact form messages</li>
              <li>To analyze site performance and improve content quality</li>
              <li>To comply with applicable legal obligations</li>
            </ul>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Email Communications
            </h2>
            <p className="text-sm">
              If you subscribe to our email updates, we may send you new posts,
              tournament news, travel and ticketing updates, and occasional
              promotional messages. You can unsubscribe at any time using the link
              in any email we send. After unsubscribing, we will stop sending
              marketing emails promptly.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Data Retention
            </h2>
            <p className="text-sm">
              Subscriber data is retained as long as your subscription is active. Contact
              form submissions are retained for up to two years. You may request deletion
              of your data at any time by contacting us at{" "}
              <a
                href={`mailto:${siteConfig.contact.privacyEmail}`}
                className="text-primary underline underline-offset-3 hover:opacity-80"
              >
                {siteConfig.contact.privacyEmail}
              </a>.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Your Rights
            </h2>
            <p className="mb-4 text-sm">
              Depending on where you are located, you may have the right to:
            </p>
            <ul className="list-disc pl-5 space-y-2 mb-5 text-sm">
              <li>Access the personal data we hold about you</li>
              <li>Request correction of inaccurate data</li>
              <li>Request deletion of your personal data</li>
              <li>Opt out of marketing communications at any time</li>
              <li>Lodge a complaint with your local data protection authority</li>
            </ul>
            <p className="text-sm">
              To exercise any of these rights, email us at{" "}
              <a
                href={`mailto:${siteConfig.contact.privacyEmail}`}
                className="text-primary underline underline-offset-3 hover:opacity-80"
              >
                {siteConfig.contact.privacyEmail}
              </a>.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Children&rsquo;s Privacy
            </h2>
            <p className="text-sm">
              {siteConfig.name} is not directed at children under the age of 13. We do not
              knowingly collect personal information from children under 13. If you
              believe we have inadvertently collected such information, please contact us
              immediately at{" "}
              <a
                href={`mailto:${siteConfig.contact.privacyEmail}`}
                className="text-primary underline underline-offset-3 hover:opacity-80"
              >
                {siteConfig.contact.privacyEmail}
              </a>{" "}
              and we will promptly delete it.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Changes to This Policy
            </h2>
            <p className="text-sm">
              We may update this Privacy Policy from time to time. When we do, we will
              update the &ldquo;Last updated&rdquo; date at the top of this page.
              Continued use of the site after any changes constitutes your acceptance
              of the updated policy. We encourage you to review this page periodically.
            </p>
          </section>

          <section>
            <h2 className="font-display text-xl font-semibold text-text mb-5">
              Contact Us
            </h2>
            <p className="text-sm">
              If you have questions or concerns about this Privacy Policy or how we handle
              your data, please email{" "}
              <a
                href={`mailto:${siteConfig.contact.privacyEmail}`}
                className="text-primary underline underline-offset-3 hover:opacity-80"
              >
                {siteConfig.contact.privacyEmail}
              </a>{" "}
              or use our{" "}
              <Link
                href="/contact"
                className="text-primary underline underline-offset-3 hover:opacity-80"
              >
                contact form
              </Link>.
            </p>
          </section>

        </div>
      </Container>
    </main>
  );
}

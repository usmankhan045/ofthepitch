import type { Metadata } from "next";
import "./globals.css";
import { siteConfig } from "@/lib/site.config";
import { getSiteFonts } from "@/lib/fonts";
import { generateThemeCSS } from "@/lib/theme";
import { getSiteSettings } from "@/lib/settings";
import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";
import { JsonLd } from "@/components/JsonLd";
import { websiteSchema, organizationSchema, personSchema } from "@/lib/schema";
import { getCategoriesWithPostCounts, getCategoryTree } from "@/lib/queries";

const fonts = getSiteFonts();
const BASE_URL = `https://${siteConfig.domain}`;

export const metadata: Metadata = {
  title: {
    default: siteConfig.name,
    template: `%s | ${siteConfig.name}`,
  },
  description: siteConfig.tagline,
  metadataBase: new URL(BASE_URL),
  alternates: { canonical: "/" },
  openGraph: {
    siteName: siteConfig.name,
    type: "website",
    locale: "en_US",
    images: [
      {
        url: "/og-default.jpg",
        width: 1200,
        height: 630,
        alt: `${siteConfig.name}: ${siteConfig.tagline}`,
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    images: ["/og-default.jpg"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true },
  },
};

export default async function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  // Drives the navbar "Categories" dropdown. Falls back to [] if DB is unconfigured.
  let categories: { slug: string; name: string }[] = [];
  try {
    categories = (await getCategoriesWithPostCounts()).map(({ slug, name }) => ({
      slug,
      name,
    }));
  } catch {
    // DB not yet configured, render nav without the categories
  }

  // Drives the navigation mega menu: each sport with its subcategories.
  let sports: Awaited<ReturnType<typeof getCategoryTree>> = [];
  try {
    sports = await getCategoryTree();
  } catch {
    // DB not yet configured, sports render as plain links
  }

  // Brand, nav and theme, with admin overrides applied over site.config.ts.
  // getSiteSettings() never throws, it falls back to config on any failure,
  // because an exception in the root layout would take down every page.
  const settings = await getSiteSettings();

  return (
    <html lang="en" className={`${fonts.variables} h-full`}>
      <head>
        {/* Inject theme CSS vars. Defaults come from siteConfig.theme.colors;
            the admin Settings screen can override them per-site at runtime. */}
        <style
          dangerouslySetInnerHTML={{
            __html: `:root { ${generateThemeCSS(settings.themeColors)} }`,
          }}
        />
        {/* Machine-readable content license (RSL 1.0) for AI/LLM crawlers */}
        <link rel="license" href="/rsl.xml" type="application/rsl+xml" />
        <JsonLd data={[websiteSchema(), organizationSchema(), personSchema()]} />
      </head>
      <body className="flex flex-col min-h-full antialiased bg-background text-text">
        <Header categories={categories} sports={sports} nav={settings.nav} name={settings.name} />
        {children}
        <Footer
          name={settings.name}
          tagline={settings.tagline}
          social={settings.social}
          footerLinks={settings.footerLinks}
        />
      </body>
    </html>
  );
}

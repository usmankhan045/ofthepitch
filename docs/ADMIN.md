# Admin Dashboard

The control room for ofthepitch.com lives at `/admin`. It manages posts,
categories, pages, media and site settings without touching the repo.

## Setup

### 1. Environment variables

Add to `.env.local` (all four are required; the first two are new):

```bash
ADMIN_PASSWORD=<the password you log in with>
ADMIN_SESSION_SECRET=<random 32+ byte string, used to sign the session cookie>
ADMIN_API_TOKEN=<random string, for the /api/admin/* REST routes>
REVALIDATION_SECRET=<random string, for cross-site cache revalidation>
```

Generate a secret with:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('base64url'))"
```

`ADMIN_SESSION_SECRET` is **required and dedicated** — it does *not* fall back to
`ADMIN_API_TOKEN`. The API token is sent as a Bearer header to `/api/admin/*`,
where proxies and CDNs may log it; signing session cookies with the same value
would let one leaked log line forge an admin session. It must be at least 16
characters (use the 32-byte generator above). **Changing `ADMIN_SESSION_SECRET`
invalidates every existing session** — that is the way to force a logout
everywhere if a password leaks.

Login is rate-limited per client IP (5 failed attempts / 15 min) by an in-memory
throttle (`lib/admin/throttle.ts`).

### 2. Database migrations

| Migration | Needed for | Status |
|---|---|---|
| `004_site_settings.sql` | Settings screen | Table already exists in the shared project — nothing to run |
| `005_printables.sql` | Attaching printables to posts | **Run this** |

Run `005` in the Supabase SQL editor. It adds the `post_printables` join table
(and an `orientation` column, already present, guarded by `IF NOT EXISTS`).

Everything degrades gracefully without it: the printables listing, detail pages
and inline `{{printable:slug}}` mentions all work. Only *attaching* a printable
to a post is unavailable, and the admin screen says so rather than erroring.

### 3. Media bucket (only needed for the Media library)

Create a **public** Storage bucket named `media` in the Supabase dashboard.
Without it the Media screen explains that it's missing; everything else works,
and posts without an image still get a generated card.

## How auth works

Two independent mechanisms, deliberately kept separate:

| Surface | Mechanism |
|---|---|
| `/admin/*` dashboard | Password login → signed, httpOnly session cookie (12h) |
| `/api/admin/*` REST | `Authorization: Bearer $ADMIN_API_TOKEN` |

The bearer token is never sent to the browser. The cookie is a signed payload
(`base64(json).hmac`) — it asserts "this browser logged in" and carries nothing
secret, so an HMAC is enough and no JWT dependency is needed.

`proxy.ts` (Next 16's replacement for `middleware.ts`) bounces logged-out
browsers away from `/admin`. It is an **optimistic gate, not the security
boundary** — Next's own docs are explicit about this, and Server Actions POST to
their own route where matchers can behave unexpectedly. The real check is
`requireSession()`, called at the top of every Server Action.

## Automatic preview images

A post saved without a featured image gets an on-brand card generated at
`/api/og`, built from its title and category in the Matchday palette.

**`featured_image_url` stays NULL in the database.** The fallback resolves at
render time in `lib/admin/preview-image.ts`. Two reasons:

1. The database keeps telling the truth — `featured_image_url IS NULL` still
   means "nobody chose an image", which is what the dashboard's *missing image*
   count reports on.
2. The card's design can change later without a data migration to rewrite
   dozens of baked-in URLs.

The fallback is applied in three places: the post hero, listing cards
(`PostCard`), and the `og:image` / Twitter meta tags.

## Content is MDX, not plain markdown

`components/MarkdownContent.tsx` renders bodies with `next-mdx-remote`. MDX
parses `{...}` as JavaScript and `<...>` as JSX, so **a stray brace or unclosed
tag is a hard build failure**, not a cosmetic glitch — 15 migrated WordPress
articles took the production build down exactly this way.

Every save therefore compiles the content first (`lib/admin/mdx-validate.ts`)
and refuses the write with a line number if it wouldn't compile. `{{SHORTCODE}}`
tokens are stripped before checking, matching what the renderer does, so
migrated content still validates.

## Multi-tenancy — read before editing `lib/admin/`

This Supabase project is **shared with other live sites**, there is **no RLS**,
and the app runs entirely on the service-role key. Isolation is purely
application-level `site_id` filtering.

Every statement in `lib/admin/mutations.ts` filters on `site_id`. An `UPDATE` or
`DELETE` that reaches Supabase without `.eq("site_id", …)` would hit other
tenants' rows. The site slug, domain and `site_id` are deliberately **not**
editable from the Settings screen for the same reason.

## Settings and where truth lives

`lib/site.config.ts` remains the source of **defaults**. The `site_settings`
table stores **overrides only**, merged over the file by `lib/settings.ts`.

`getSiteSettings()` never throws — it falls back to config on any failure,
because it is read by the root layout and an exception there would take down
every page on the site.

The tradeoff worth knowing: settings edited in the dashboard are **not in git**,
so a bad change can't be reverted by a deploy. Anything you'd want reviewable
should stay in `site.config.ts`.

## Slugs are load-bearing

Post and category slugs were migrated from WordPress and are indexed in Search
Console. Changing one forfeits that page's ranking and 404s the old URL. The
editor warns when you change a slug on an existing post; if you go ahead, add a
redirect in `next.config.ts` alongside the existing migration redirects.

## Screens

| Route | What it does |
|---|---|
| `/admin` | Counts, recently edited, and a worst-first queue of thin posts |
| `/admin/posts` | Search, filter by status/category, paginate, publish/unpublish inline |
| `/admin/posts/new`, `/admin/posts/[id]` | Full editor: body, FAQ, SEO, image, live card preview |
| `/admin/categories` | Inline create/edit/delete (refuses to delete a category that still has posts) |
| `/admin/pages` | DB-backed pages served at `/<slug>` |
| `/admin/printables` | Free downloads: create, upload PDF, attach to posts |
| `/admin/media` | Upload to Supabase Storage, copy URLs, delete |
| `/admin/settings` | Brand, nav, footer links, theme colours, social |

Note that About, Contact and the legal pages are **React components in `app/`**,
not database rows — those are edited in the repo, not the dashboard.


## Printables

Free downloads at `/printables`, managed at `/admin/printables`. Re-introduced
after the WordPress migration stripped them; the callout and preview components
were recovered from the pre-squash git history rather than rewritten.

### Two ways to put one on a post

|  | How | Renders |
|---|---|---|
| **Attach** | Post editor → Printables panel → choose one | Callouts after the article, in the order listed |
| **Mention** | `{{printable:slug}}` in the body (the panel's "Mention" button inserts it at the cursor) | A callout at that exact point |

A mention does **not** require an attachment — the post page resolves mentioned
slugs directly, so the callout still shows the printable's real title and
description. Anything attached *and* mentioned inline renders only at the
mention, never twice.

### Files

Upload the PDF from the printable's own form; it goes to the same Supabase
Storage bucket as the media library. A printable with no file yet shows a
"being prepared" notice rather than a dead download button, so you can create
the entry before the artwork is ready.

Thumbnails are optional — without one, the same generated card that covers
imageless posts is used, labelled "Printable".

### The shortcode ordering trap

`expandShortcodes()` in `components/MarkdownContent.tsx` expands
`{{printable:slug}}` **before** the catch-all `{{...}}` strip. That order is not
incidental: the strip removes every remaining `{{...}}` token (it has to — MDX
would treat one as a JavaScript expression and fail the build). Reverse the two
and every printable mention silently disappears, which is precisely what
happened to the migrated WordPress content.

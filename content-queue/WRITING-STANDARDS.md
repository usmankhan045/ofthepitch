# Writing standards

Every defect found in the first fifteen racing articles and the site audit that
followed, written as a rule so the next batch starts correct rather than being
audited into shape.

Each rule traces to something that actually went wrong. Nothing here is
generic best practice.

**Before committing a batch:**

```bash
node scripts/validate-queue.mjs
```

That catches the mechanical half. The judgement half is rules 1 to 5 and 15,
which no script can check.

---

## Sourcing

### 1. Never invent a number

If a figure cannot be traced to the venue's own published page, it does not go
in the article. Not as an estimate, not as a range, not as "typically around".

Two things this cost us, both correct calls:

- **The £35 that was not a price.** Scraping Ascot's Royal Ascot page returned
  `£25`, `£35` and `£80`. The £35 was a charity donation inside a news
  headline, not a ticket tier. Grepping for `£[0-9]+` and trusting the result
  would have published a fake price.
- **Food, drink and travel in the cost article.** Ascot publishes tickets,
  parking and children's admission but not bar prices, and rail fares vary by
  booking date. Those table rows say what is published and state plainly what
  is not, rather than carrying a guess.

When a fact is unavailable, say so. "Ascot does not publish bar prices" is
useful to a reader and safe to cite. A made-up number is neither.

### 2. Say when a venue has no rule

The site's entire commercial position rests on this. Retailers write dress code
articles because they sell clothes, so they will never lead with "there is no
dress code". We will.

Confirmed and used:

- Cheltenham: the Jockey Club publishes no formal dress code for the Festival.
- Aintree and Epsom: "dress to feel your best", naming jeans and clean trainers.
- Wimbledon: no spectator dress code for grounds admission.

The absence of a rule is a finding, not a gap in the research.

### 3. Verify what the scraper returned before quoting it

`scrapling extract get` returns a nav-and-footer shell on client-rendered
sites. `scrapling extract fetch --network-idle` runs a browser and gets the
body. **Both return HTTP 200, so the status code proves nothing.**

Symptoms of a shell: the title reads `undefined`, the body is only nav links,
the file is suspiciously small.

Where content sits behind tabs or accordions it is often in the page payload
rather than the rendered HTML. Fetch with `--css-selector "body"` and parse
`__NUXT_DATA__`. That is how the 43 Royal Ascot FAQ answers were recovered.

If it is not in the payload either, cite the pages that do render and tell the
reader to check the rest directly. Two places where that was the honest
outcome: Epsom's Queen Elizabeth II Stand dress code, and Ascot's ordinary
raceday dress rules. Never reconstruct from memory.

### 4. Cite sources at the foot

Every article closes with a `**Sources:**` paragraph naming the pages used, the
month they were checked, and a warning that details change between seasons.

This is what makes a passage safe for a model to quote, and it is honest about
the shelf life of a ticket price.

### 5. Check the topic is not already covered

Two migrated WordPress posts covered World Cup VAR controversies under
different slugs and competed for the same query, splitting their own signals.
One had to be 301'd into the other.

Before writing, check the queue and the published set for the same question.
An article that overlaps an existing one should either replace it (301 the old
slug) or be narrowed until it answers something genuinely different.

The validator compares the **H2 questions** two articles ask, not their
titles, and warns when half the smaller article's sections duplicate the
other's. Titles were tried first and produced only false positives, because
comparison pieces legitimately share venue names: an article listing Ascot,
Cheltenham, Aintree and Epsom is not a duplicate of another that does the
same. What makes a piece distinct is the set of questions it answers.

---

## Structure

### 6. Structure for passage extraction

AI systems cite a self-contained passage, not a page. Every H2 must answer its
own question without the reader having seen anything above it.

- **H2s are questions.** 136 of 143 across the racing cluster.
- **The first sentence under an H2 is the answer.** No preamble, no "when it
  comes to dress codes at Ascot". State it, then explain.
- **Name the source in the sentence** where the claim is contestable: "Ascot's
  published dress code requires...".
- **Tables for anything comparative.** They extract whole.
- **`quick_answer`** is a standalone 2 to 3 sentence answer to the title
  question. It renders above the article and is the most-cited block on the
  page.
- **`faq_items`** carries 5 or more genuine questions.

An FAQ question **may** repeat an H2. The H2 body is written for a reader; the
FAQ answer is a condensed standalone version for `FAQPage` extraction, and
that is the point. What is not acceptable is the FAQ **answer** copying the
section's opening sentences, because then the schema adds nothing. The
validator checks for that specifically.

One exception to question-shaped H2s: a comparison article whose sections are
named things ("Royal Ascot: the occasion") is correctly structured that way.
The validator warns rather than errors, so use judgement.

### 7. Link the cluster

The first fifteen articles shipped with **zero** internal links. A cluster that
does not link to itself does not read as a cluster to Google, and gives an AI
system no route from one answer to the adjacent one.

Every article ends with a `## Related guides` block of three links, placed
immediately **before** the `**Sources:**` line so the citation footer stays
last. Anchor text says what the reader gets, never "click here".

No article may end up with zero inbound links. The validator checks this.

### 8. Links to unpublished articles are handled automatically

Articles cross-link a whole cluster but publish days apart, so a piece going
live on the 3rd will link to one that does not exist until the 19th. The
published Ascot article shipped with three real 404s this way.

`unlinkUnpublished()` in `components/MarkdownContent.tsx` now renders links to
unpublished posts as plain text and turns them into live anchors as each target
publishes. **Link freely across a batch; the renderer handles the timing.**

Do not work around this by omitting links, and do not remove the helper.

---

## Style

### 9. No em dashes

Hard rule, no exceptions. Use a full stop, a comma, a colon or parentheses.
Applies to en dashes and to `--`. The validator errors on these, including in
`title`, `excerpt`, `quick_answer` and both SEO fields.

### 10. House style

- Sentence case in headings. Not Title Case.
- Spell out what an abbreviation means on first use.
- British spelling and £ for UK venues.
- No "elevate", "delve", "seamless", "unlock", "in today's world".
- No rule-of-three padding. Two items is fine when there are two.
- Active voice. Name who does the thing.

---

## Fields

### 11. Article fields

| Field | Rule |
|---|---|
| `slug` | Immutable once published. Changing it forfeits the ranking. |
| `title` | The question or claim, front-loaded. |
| `seo_title` | **Under 60 characters.** 14 of the first 15 were over and truncated. |
| `seo_description` | 140 to 160 characters, leads with the concrete number. |
| `excerpt` | Two sentences. Renders on the card. |
| `quick_answer` | Standalone answer, cited before the body. |
| `faq_items` | 5+, answers not copied from the section openings. |
| `category` | Must exist in `CATEGORY_ID` in `scripts/publish-due-posts.mjs`. |
| `featured_image_url` | Leave absent. The card is generated. |

A reframe can change every field above **except `slug`**. When the four World
Cup travel guides were repositioned as evergreen border-crossing content,
titles, excerpts, quick answers and metadata all changed and the slugs stayed.

### 12. Images are generated, never uploaded

Do not set `featured_image_url`. `/api/og` draws the card from the title,
category and sport colour.

Two shapes, and the distinction matters: meta tags get 1200x630 because that is
what social scrapers expect; the on-site card gets `ratio=card` (1200x750,
16:10) because that is the slot it renders into. Sending the 1.91:1 image to a
1.6:1 slot let `object-cover` crop 16% off each side, which cut the first
character off every title and clipped the footer.

---

## Publishing and site hygiene

### 13. A new sport needs content before its category is worth anything

17 of 20 category archives had zero published posts, all returning 200 with
`index, follow` and all sitting in the sitemap. On a freshly verified Search
Console property that is the first thing Google crawls.

This is now handled automatically: `app/sitemap.ts` lists only archives that
list something, and `app/category/[slug]/page.tsx` serves `noindex, follow`
when an archive is empty. Both reverse the moment a post lands.

**What this means for a new sport:** create the categories, then publish into
them. The empty archives stay out of the index until they have content, so
there is no need to stage the category creation.

Same rule applies to `/printables`: the feature flag is on but no printables
exist, so the listing page only enters the sitemap once it has content.

### 14. Retiring a post means a 301, never a 404

Ten World Cup news posts were unpublished after Search Console showed 12
clicks in six months at position 21. Every one 301s to `/category/football`
rather than 404ing, because Google still has those URLs on file and a redirect
passes what little signal exists.

Add the redirect to `next.config.ts` in the same change that unpublishes the
post. If the redirect target is itself later unpublished, update the chain: the
two VAR posts pointed at each other until one was retired, which briefly left a
301 aimed at a 404.

### 15. Judge a post by whether the question still gets asked

The test for keeping or retiring is not word count. Ten of the retired World
Cup posts were 7,000 to 11,600 characters and perfectly well written. Nobody
will ever search "who was already eliminated before a ball was kicked" again.

Four posts from the same batch were kept because border documents, rail routes
and city transport do not expire. The FMM card, NEXUS, the Amtrak Cascades and
the Peace Bridge are the same category of content as a racecourse enclosure
guide: how to physically get to a sporting event.

Write for the question that still gets asked next year.

---

## Infrastructure that must not regress

These were each broken once. They are fixed, and they are easy to break again.

### 16. Check the asset actually exists

Three schema images pointed at files that had never been in `public/`:
`og-default.jpg`, `logo.png` and `images/author-ofthepitch.jpg`. Every article
advertised a 404 as its schema image, and three components rendered a broken
author photo.

Before referencing any static asset, `ls public/<path>`. Before trusting a live
URL, `curl -sI` it.

### 17. Canonical host is www

`siteConfig.domain` is `www.ofthepitch.com`. The apex 308s to it. That one
string builds every canonical, OG image URL, sitemap entry and schema id, so
pointing it at the redirecting host meant OG images never rendered for
scrapers that do not follow redirects.

Verify with `curl -sI https://ofthepitch.com/blog` before changing it.

### 18. llms.txt is generated, not static

It was a file in `public/` written during the WordPress migration, and it
survived the relaunch telling AI crawlers this was a World Cup site, listing
nine dead category archives. It is now `app/llms.txt/route.ts`, built from the
live category tree. Do not replace it with a static file.

### 19. The queue is the source of truth, not the posts table

Articles live as files in `content-queue/`, not as `status='scheduled'` rows.
The publisher inserts an article when its scheduled time passes and it is not
already in the database, which means re-runs and delayed runs never double-post.

An article is therefore reviewable in a diff before it can ever go live, and
nothing half-written sits in the `posts` table waiting on a status flip.

The cron runs every 30 minutes rather than once at the publish time, because
GitHub's scheduler is best-effort and a once-daily tick aimed at the exact
publish minute can miss and leave a post waiting a full extra day.

**Editing a published article means editing both** the queue file and the
database row. The publisher will not overwrite a post that already exists.

---

## Checklist

Before adding a batch to the queue:

- [ ] Every number traceable to a published source, gaps stated as gaps
- [ ] Checked whether any venue has no rule, and said so
- [ ] Scraper output verified as real body content, not a nav shell
- [ ] `**Sources:**` footer with the month checked
- [ ] Topic does not duplicate a queued or published article
- [ ] H2s question-shaped, first sentence answers
- [ ] `quick_answer` standalone, `faq_items` 5+ and not copied
- [ ] `## Related guides` before `**Sources:**`
- [ ] `seo_title` under 60 chars
- [ ] No em dashes anywhere
- [ ] No `featured_image_url`
- [ ] Category exists in the publisher's `CATEGORY_ID`
- [ ] `node scripts/validate-queue.mjs` passes with no errors

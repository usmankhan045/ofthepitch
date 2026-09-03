# Writing standards

Every defect found in the first fifteen racing articles, written as a rule so
the next batch starts correct rather than getting audited into shape.

Check this list before adding an article to the queue. The validator at the
foot of this file catches the mechanical half.

---

## 1. Never invent a number

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

When a fact is unavailable, say so in the article. "Ascot does not publish bar
prices" is useful to a reader and safe to cite. A made-up number is neither.

## 2. Say when a venue has no rule

The site's entire commercial position rests on this. Retailers write dress code
articles because they sell clothes, so they will never lead with "there is no
dress code". We will.

Confirmed and used:

- Cheltenham: the Jockey Club publishes no formal dress code for the Festival.
- Aintree and Epsom: "dress to feel your best", naming jeans and clean trainers.
- Wimbledon: no spectator dress code for grounds admission.

The absence of a rule is a finding, not a gap in the research.

## 3. Verify what the scraper returned before quoting it

`scrapling extract get` returns a nav-and-footer shell on client-rendered
sites. `scrapling extract fetch --network-idle` runs a browser and gets the
body. Both return HTTP 200, so the status code proves nothing.

Symptoms of a shell: the title reads `undefined`, the body is only nav links,
the file is suspiciously small. Compare against the page in a browser.

Where content sits behind tabs or accordions, it is often in the Nuxt payload
rather than the rendered HTML. Fetch with `--css-selector "body"` and parse
`__NUXT_DATA__`. That is how the 43 Royal Ascot FAQ answers were recovered.
If it is not in the payload either, cite the pages that do render and tell the
reader to check the rest directly. Do not reconstruct it from memory.

## 4. Structure for passage extraction

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
- **`faq_items`** carries 5 or more genuine questions. Never restate an H2
  verbatim; use the phrasing someone would type or say.

## 5. Link the cluster

The first fifteen articles shipped with **zero** internal links. A cluster that
does not link to itself does not read as a cluster to Google, and gives an AI
system no route from one answer to the adjacent one.

Every article ends with a `## Related guides` block of three links, placed
immediately **before** the `**Sources:**` line so the citation footer stays
last. Anchor text says what the reader gets, never "click here".

No article may end up with zero inbound links. The validator checks this.

## 6. Cite sources at the foot

Every article closes with a `**Sources:**` paragraph naming the pages used, the
month they were checked, and a warning that details change between seasons.

This is what makes a passage safe for a model to quote, and it is honest about
the shelf life of a ticket price.

## 7. No em dashes

Hard rule, no exceptions. Use a full stop, a comma, a colon or parentheses.
Applies to en dashes too, and to `--`.

## 8. House style

- Sentence case in headings. Not Title Case.
- Spell out what an abbreviation means on first use.
- British spelling and £ for UK venues.
- No "elevate", "delve", "seamless", "unlock", "in today's world".
- No rule-of-three padding. Two items is fine when there are two.
- Active voice. Name who does the thing.

## 9. Article fields

| Field | Rule |
|---|---|
| `slug` | Immutable once published. Changing it forfeits the ranking. |
| `title` | The question or claim, front-loaded. |
| `seo_title` | Under 60 characters or it truncates in the SERP. |
| `seo_description` | 140 to 160 characters, leads with the concrete number. |
| `excerpt` | Two sentences. Renders on the card. |
| `quick_answer` | Standalone answer, cited before the body. |
| `faq_items` | 5+, distinct from the H2s. |
| `category` | Must exist in `CATEGORY_ID` in the publisher. |
| `featured_image_url` | Leave absent. The card is generated. |

## 10. Images are generated, never uploaded

Do not set `featured_image_url`. `/api/og` draws the card from the title,
category and sport colour.

Two shapes, and the distinction matters: meta tags get 1200x630 because that is
what social scrapers expect; the on-site card gets `ratio=card` (1200x750,
16:10) because that is the slot it renders into. Sending the 1.91:1 image to a
1.6:1 slot let `object-cover` crop 16% off each side, which cut the first
character off every title and clipped the footer.

## 11. Check the asset actually exists

Three schema images pointed at files that had never been in `public/`:
`og-default.jpg`, `logo.png` and `images/author-ofthepitch.jpg`. Every article
advertised a 404 as its schema image, and three components rendered a broken
author photo.

Before referencing any static asset, `ls public/<path>`. Before trusting a live
URL, `curl -sI` it.

## 12. Canonical host is www

`siteConfig.domain` is `www.ofthepitch.com`. The apex 308s to it. That one
string builds every canonical, OG image URL, sitemap entry and schema id, so
pointing it at the redirecting host meant OG images never rendered for
scrapers that do not follow redirects.

Verify with `curl -sI https://ofthepitch.com/blog` before changing it.

## 13. llms.txt is generated, not static

It was a file in `public/` written during the WordPress migration, and it
survived the relaunch telling AI crawlers this was a World Cup site, listing
nine dead category archives. It is now `app/llms.txt/route.ts`, built from the
live category tree. Do not replace it with a static file.

---

## Validator

Run before committing a batch:

```bash
node scripts/validate-queue.mjs
```

Checks required fields, slug agreement, category validity, em dashes,
`seo_title` length, FAQ count, internal links, orphans and schedule coverage.

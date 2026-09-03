# Pinterest strategy

Researched 3 September 2026. Every number here is either published by Pinterest
itself or from a named study with a stated sample. Nothing is estimated.

---

## The keyword data

Pinterest publishes search volume on its own `/ideas/` pages as "N people
searched this". These are Pinterest's figures, pulled directly from those
pages. They are the only first-party Pinterest search volumes available
without an ads account.

| Term | Searches | Sport |
|---|---|---|
| formula 1 outfit | **20k** | F1 |
| ascot outfits | **13k** | Racing |
| royal ascot outfit | **12k** | Racing |
| cheltenham races outfits | **12k** | Racing |
| ski trip packing list | **10k** | Skiing |
| royal ascot fashion | 5k | Racing |
| wimbledon outfits | 5k | Tennis |
| cheltenham races outfits women | 4k | Racing |
| horse races outfit casual | 455 | Racing |
| royal ascot ladies day outfits | 404 | Racing |
| what to wear to horse races | 501 | Racing |
| wimbledon spectator outfit | 350 | Tennis |
| f1 spectator outfit | 235 | F1 |
| f1 race weekend outfits | 219 | F1 |
| ascot royal enclosure dresses | 170 | Racing |
| cheltenham races mens fashion | **21** | Racing |

### What this changes

**1. Formula 1 is the biggest single term found, at 20k.** Bigger than any
racing term. The site's plan puts F1 fourth. On Pinterest volume alone it
should be second, and the gap between "formula 1 outfit" (20k) and "f1 race
weekend outfits" (219) says the demand sits on the broad term.

**2. Menswear is dead on Pinterest, and this is now measured.** "Cheltenham
races mens fashion" returns **21 searches** against 4k for the women's
equivalent, a ratio of roughly 190:1. The earlier working assumption that
men's spectator outfit content was underserved is disproven twice over: the
SERP is owned by retailers, and Pinterest demand is close to zero.

Write for women first. Cover men inside the article for completeness and
Google, not as a pin angle.

**3. Broad beats specific by two orders of magnitude.** "Ascot outfits" is 13k
and "ascot royal enclosure dresses" is 170. The precise enclosure language that
makes the articles authoritative is the wrong language for a pin title.

Pin on the broad term, land on the specific answer. The pin says "What to wear
to Royal Ascot"; the page delivers the enclosure-by-enclosure detail.

**4. Cheltenham at 12k has no dress code at all.** The single largest content
gap available: 12k people a month looking for what to wear to an event whose
organiser publishes no dress code. Nobody can answer that with a product page.

**5. Skiing's demand is logistics, not outfits.** "Ski trip packing list" is
10k and "what to pack for ski trip" is 643. No ski outfit term surfaced at
comparable volume. The printables feature is already built, which makes this
the clearest match on the site between existing infrastructure and measured
demand.

"Printable ski packing list" exists as a Pinterest idea page but returned no
published volume figure, so treat it as a real term of unknown size rather
than a measured one.

---

## What actually earns engagement

**Source:** [Tailwind 2025 Benchmark Report Part 2](https://www.tailwindapp.com/pinterest-marketing/research/2025-benchmark-study-part-2).
1.2 million pins across 17,000 accounts, 90-day windows, paid pins excluded.
Vendor-run, so discount accordingly, but it states its sample and method,
which puts it far ahead of everything else in this space.

| Finding | Figure |
|---|---|
| Pins with alt text | **+123% outbound clicks**, +25% impressions, +56% profile visits |
| Viral pins with a title | ~90% |
| Viral pins with target keyword in title | ~80% |
| Viral pins with title 25+ characters | ~60% |
| Best-performing description length | 220 to 232 characters |
| Longer descriptions | Correlated with *lower* performance |
| Format split of viral pins | 89% image, 8% video, 2% collage |
| Viral pins using hashtags | 19% (avg 7.3 when used) |
| Dominant colour of top 100 viral pins | **87 of 100 were white, near-white or light grey** |
| Designed viral pins using a brand palette | **4%** |
| Viral raw-image pins that were amateur quality | over 25% |

### The two findings that should change the design

**Light backgrounds dominate.** 87 of the top 100 dominant colours were white,
near-white or light grey. The site's dark ink OG cards are the opposite of
this. Pins must not reuse the article card design.

**Brand palettes underperform.** Only 4% of designed viral pins used one. The
instinct to make every pin obviously "Of The Pitch" branded is the wrong
instinct on this platform. Brand recognition comes from the wordmark and the
consistent layout system, not from flooding the frame with gold and ink.

---

## Pinterest's own rules

First-party, from Pinterest's help and policy pages.

### Specs
| Spec | Value |
|---|---|
| Aspect ratio | 2:3, **1000 x 1500px** |
| Max file size | 20MB desktop, 32MB in-app |
| Title | 100 chars, but **only the first ~40 show in feed** |
| Description | 800 chars max (not 500), does not display in feed, used for relevance only |

Pinterest publishes **no guidance on text overlay**. Anyone stating a rule
about how much of a pin text should cover is making it up.

### Duplicate creative
> "Try not to repeatedly save the same Pins or upload content that already
> exists on Pinterest. You may get flagged as spam and get temporarily blocked
> from creating Pins."

And from the community guidelines:
> "Don't create or save content that is repetitive, deceptive, or irrelevant in
> an attempt to make money."

This governs **creative**, not destination URL. Multiple genuinely distinct
pins pointing at one article is neither prohibited nor endorsed; Pinterest is
silent on it. A recolour of an existing pin is a duplicate. A different photo,
layout and hook is not.

### The "Visit site" button
Pinterest moves it into the "..." dropdown when the link 404s, **the pin
content does not match the landing page**, the page loads slowly (they name
**sub-4-second**), or the page is unsafe.

This is the strongest documented argument against curiosity-gap pins, stronger
than the policy argument: a pin that overpromises loses the click affordance
mechanically.

---

## Design concept

The article cards (dark ink, gold rail, arc motif) are for social scrapers and
the site itself. **Pins are a separate design system**, built for a light feed
where a brand palette is a measured disadvantage.

### Five templates, one per pin angle

Each article yields 3 to 6 pins depending on how many genuine angles it holds.
Every pin uses a different template AND a different photograph, so no two are
near-duplicates.

**1. The Answer Card**
For a question with a short, surprising answer. Cream or off-white ground,
oversized answer as the hero, question small above it, source line at the foot.

> CHELTENHAM DRESS CODE
> **There isn't one**
> ofthepitch.com

Strongest template on the site because it delivers the answer on the pin. That
matches the page exactly, which is the documented condition for keeping the
Visit site button.

**2. The Comparison**
Two or three vertical panels, one per enclosure or tier, each with its price
and one rule. Photo strip at the top, panels below on white.

> WINDSOR £25 · no dress code
> QUEEN ANNE £80 · suit and tie
> ROYAL Members only · morning dress

**3. The Checklist**
For packing and document pins. White ground, ticked list, 5 to 7 items maximum,
the printable's name at the foot. Directly targets "ski trip packing list"
(10k) and "what to pack for ski trip" (643).

**4. The Photo Overlay**
Full-bleed photograph, light scrim at the bottom third, headline over it. The
only template where the photo leads. Use for outfit and venue-atmosphere pins
where the image is the reason someone stops.

**5. The Number**
One figure at enormous size, one line of context. For cost and price pins.

> £45
> **What parking costs at Royal Ascot**
> (and why it's free every other raceday)

### Rules across all templates

- **1000 x 1500, always.**
- **Light grounds.** Cream `#FAF7F1`, white, or a light photograph. Never the
  site's ink background. This is the 87-of-100 finding.
- **Accent used sparingly**, one element per pin, not the whole frame. This is
  the 4% finding.
- **Hook inside the first 40 characters** of the title.
- **Alt text on every pin, no exceptions.** The single measured lift available.
- **Description 220 to 232 characters.** Longer performs worse.
- **Wordmark small at the foot**, consistent position across every template.
  That is the brand signal, not colour.
- **No curiosity gaps.** The pin promises exactly what the page delivers.

### Generation

Pins are generated in ChatGPT. Each pin needs its own prompt: a different
photographic subject, a different composition, a different template. Do not
generate variations of one image. A recolour or a re-crop is a duplicate under
Pinterest's own wording.

---

## Boards

One board per sport from the start, plus cross-cutting boards for the angles
with their own demand. Boards give Pinterest a container per topic, so a later
switch between sports does not dilute the account.

| Board | Targets |
|---|---|
| Royal Ascot | ascot outfits 13k, royal ascot outfit 12k |
| Cheltenham & Jump Racing | cheltenham races outfits 12k |
| Race Day Style | what to wear to horse races, horse races outfit casual |
| Formula 1 Travel | formula 1 outfit 20k |
| Wimbledon & Tennis | wimbledon outfits 5k |
| Ski Trip Planning | ski trip packing list 10k |
| Printables & Checklists | ski packing list, checklists |

---

## Sequencing

The site's article order is racing first. The Pinterest data argues F1 should
move up, but that is a content decision, not a pin decision, and racing already
has 15 articles written.

**Keep racing first.** Its four terms total 46k, which is more than F1's 20k.
Move **F1 to second**, ahead of tennis, on the strength of that single 20k
term. Skiing's 10k packing-list demand pairs with the printables feature that
already exists, so it can run in parallel as a printables play rather than
waiting for a full article cluster.

---

## What nobody knows

Stated plainly so it does not get treated as settled.

- **No published A/B test** exists on whether giving the answer away on the pin
  helps or hurts outbound clicks. Reasoning in both directions is available;
  evidence is not.
- **No credible organic outbound CTR benchmark exists.** The "0.2 to 0.5%"
  figures circulating trace to a ring of AI-generated stat sites citing each
  other, several dated into the future.
- **Pinterest publishes nothing** on text overlay, whether Rich Pins improve
  CTR, any daily pin limit, or multiple pins per URL.

The opportunity: running the answer-on-pin test properly on our own pins,
holding board, timing and keyword constant and logging impressions, saves and
outbound clicks per variant, would produce the only real data that exists on
it. Start with the first Ascot article's six pins, three of each variant.

### Sources that publish confident Pinterest benchmarks with no methodology
Reject all: `sociavault.com`, `gensumo.com`, `posteverywhere.ai`,
`socialrails.com`, `outfy.com`, `pinfreshly.com`, `madpinmedia.com`,
`84pins.com`, `pintzy.tools`, `apaya.com`, `iqfluence.io`, `webfx.com`.

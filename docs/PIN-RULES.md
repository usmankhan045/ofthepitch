# Pin rules

Every pin on this account must follow these. They exist so the account reads as
one hand, made by a person who cares, rather than a template run ninety times.

Numbers here are verified: Pinterest's own published specs, or the Tailwind
2025 study of 1.2M pins across 17k accounts. Where nobody knows, it says so.

**These are enforced.** Run this before committing any pin, and it must pass:

```bash
node scripts/validate-pins.mjs           # rules
node scripts/validate-pins.mjs --links   # rules + every destination returns 200
```

It fails on a missing quoted headline, a title outside the range, a banned
phrase, a duplicate or templated title, a missing palette, a vague outfit, a
badge in the prompt, a ground that is not #FAF7F1, or more than six pins on one
article. What it cannot judge, the checklist at the foot covers.

Keyword data: [PINTEREST-STRATEGY.md](./PINTEREST-STRATEGY.md).
How a batch gets built: [PIN-PROCESS.md](./PIN-PROCESS.md).

---

## 1. Nothing is formulaic. Ever.

This is the rule the others serve. If a reader could see two of our pins and
guess the shape of the third, we have failed.

**Banned outright**, in titles and in on-image text:

- "X things you need to know", "N ways to", "The ultimate guide to"
- "Everything you need to know about", "Here's what nobody tells you"
- "Read more", "Click here", "Learn more", "Find out more", "Swipe up"
- "Discover", "Unlock", "Elevate", "Level up", "Game changer"
- Any title that is a number followed by a noun
- Any two pins whose titles share a grammatical skeleton

**The test.** Lay the batch's titles in a column. If any two could swap their
subject nouns and still read naturally, one of them is a template. Rewrite it.

A hand-written line sounds like something you would say out loud to a friend
who asked. "Cheltenham has no dress code" is a sentence. "5 Cheltenham Dress
Code Facts" is a slot with words in it.

## 2. Four to six angles per article, never forced

An angle is a question the article answers that a person would actually type
into Pinterest. Take **four to six** per article, from different sections.

Two angles are the same angle if the same sentence answers both. "Which
enclosure should I pick" and "which enclosure is cheapest" are one angle.
"Which enclosure" and "what parking costs" are two.

**Never invent an angle to reach a number.** Four strong pins beat six where
two are stretched, and a stretched angle produces exactly the near-duplicate
this document exists to prevent. A thirteen-section article may carry six
comfortably; a seven-section one often will not.

## 3. Title: 40 to 60 characters

Two measured facts set this range.

Pinterest shows roughly **the first 40 characters** in feed; anything past that
is for relevance rather than for the reader. And **about 60% of viral pins had
titles of 25 or more characters**, so very short titles underperform.

- **Write 40 to 60 characters.** Long enough to carry a real sentence, short
  enough that the whole thing survives the feed truncation
- Hard stop at 100, which is Pinterest's limit
- The pain point, surprise or question lands inside the first 40
- **About 80% of viral pins carried the target keyword in the title.** Include
  the term someone would search, in the words they would use
- Sentence case. Not Title Case, not ALL CAPS

To be clear about what is known: 25 characters is a measured floor and 40 is a
display limit. Nobody has published an optimum. The 40 to 60 range is where
those two facts leave you, not a figure from a study.

Broad beats specific: "ascot outfits" is 13k searches, "ascot royal enclosure
dresses" is 170. Pin on the broad term; the page delivers the precise answer.

## 4. Description: 220 to 232 characters

This one **is** a measured optimum: viral pins averaged 220 to 232 characters,
and longer descriptions correlated with worse performance. The description
never displays in the feed anyway; it exists for relevance.

It must say something the title did not. Never restate the headline.

**This is a separate surface from the text printed on the image.** The image
carries a short answer; the description field carries the fuller one. Do not
copy one into the other.

## 5. On-image text: pain point, short answer, soft CTA

Three parts, and all three vary per pin.

**The headline** grabs attention. A pain point, a surprise, a question, or a
flat statement that contradicts what people assume. Whatever this pin's angle
actually is. There is no house pattern for it.

**One or two lines** underneath give a real answer. Not a teaser, not a
restatement of the headline. Someone who reads only the pin should learn
something true.

**A soft close** that says the rest is in the guide. Written fresh for this
pin, from this pin's subject. Never the same words twice in the account.

These are examples of tone, not a list to reuse:

> The full enclosure breakdown is in the guide.
> Every rule, and the three that catch people out, in the guide.
> What each badge actually admits you to, in the full guide.

If two pins in a batch close the same way, one of them is wrong.

## 6. No curiosity gaps

The pin must deliver what it promises. Give the answer, then name one adjacent
thing the guide resolves that the pin does not.

Pinterest prohibits "sensational clickbait tactics that exploit user
curiosity", and separately moves the Visit site button into the "..." menu
when pin content does not match the landing page. A gap costs distribution and
the click affordance at once.

Honest: "There isn't one. But fancy dress is banned in the Club Enclosure, and
one thing is refused at every British racecourse."

Dishonest: "You won't believe what they banned."

## 7. Every image is different from every other image

Pinterest's wording:

> "Try not to repeatedly save the same Pins or upload content that already
> exists on Pinterest. You may get flagged as spam and get temporarily blocked
> from creating Pins."

That governs **creative**, not destination. Six distinct pins to one article is
fine. A recolour is not.

Across any batch, vary at least three of these per pin:

| Axis | Options |
|---|---|
| Photo position | top, bottom, full bleed, none |
| Photo subject | one person, a group, a detail crop, a flat lay, a place |
| Crop | full figure, waist up, from behind, overhead, close detail |
| Type layout | one large statement, a list, a comparison, a number |
| Palette | per sport and per season |

Two pins that share a photo subject must not also share a crop and a layout.

## 8. The ground stays consistent

The one thing that does not vary. Warm off-white **#FAF7F1** on every pin.

This is measured, not taste: **87 of the top 100 dominant colours in viral pins
were white, near-white or light grey**, and only **4% of designed viral pins
used a brand palette**. The site's dark ink cards are the opposite of both.
Never reuse an article card as a pin.

Burnt orange **#CF5A2E** appears once per pin, never as a field.

## 9. The prompt states every word that will appear

The prompt must contain the exact on-image text, quoted, followed by:

> No other words anywhere on the image.

Do not write "a headline drawn from the pin title" or "supporting lines from
the description". An image model given room to write will write its own copy.
It has already produced pins headlined "Good Style Lasts Longer" and one about
a summer wedding, on an account about racecourse dress codes.

Nothing is left to the model's judgement except the photograph itself.

## 10. The photograph: premium, specific, real

Aesthetics are the priority here. The high-volume searches on this account are
outfit searches, so the clothes carry the pin.

**Specify the outfit** down to garment, fabric, cut, colour and accessories:

> A knee-length herringbone tweed coat in warm brown and oatmeal, worn open
> over a fine-knit charcoal roll neck. A wide-brimmed felt fedora in deep olive
> with a grosgrain band. Small gold drop earrings, a tan leather crossbody bag.

Not "a well-dressed woman". That produces a generic result.

**Name the palette per pin**, tied to the season the article covers, so two
events cannot come out as recolours of each other:

| Meeting | Palette |
|---|---|
| Cheltenham, March | brown, oatmeal, olive, charcoal, overcast light |
| Royal Ascot, June | powder blue, blush, cream, buttermilk, bright sun |
| Aintree, April | camel, forest green, cream, navy, breezy light |
| Racing in the rain | slate, moss, oxblood, cream, flat grey light |

**Every prompt ends with these constraints:**

- Editorial fashion photography, not stock photography
- No logos, no branded clothing, no visible slogans
- No direct-to-camera smiling
- Natural posture and natural hands. Nothing stiff, nothing arranged
- Signage, banners and number plates blurred or out of focus, never legible
- Photograph and type occupy separate zones, joined by a 150 to 220 pixel fade.
  Never text over a photograph. Never a hard rule between them
- No text within 60px of any edge

**Nothing may look AI generated.** Hands, posture, the way fabric falls, the
way people stand in a crowd. If a rendered pin has the tell, discard it and
regenerate rather than shipping it.

## 11. Alt text on every pin, without exception

The only measured lift available: pins with alt text earned **123% more
outbound clicks**, 25% more impressions and 56% more profile visits.

Describe the photograph plainly, as if to someone who cannot see it. Include
the garments. Do not keyword-stuff.

> Woman in a herringbone tweed coat and olive felt fedora at Cheltenham
> racecourse in March, blurred crowd behind her.

## 12. Branding is the url, nothing else

`ofthepitch.com` sits at the foot of every pin. No monogram, no wordmark, no
badge, no logo lockup.

The consistency of the ground, the type and the url is the brand signal. A mark
stamped on every pin adds nothing and costs a corner of the image.

## 13. Never pin before the article is live

Pinterest hides the Visit site button when a link 404s, and fixing the link
afterwards does not restore it. Check before scheduling:

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://www.ofthepitch.com/<slug>
```

Articles publish on a drip schedule; `content-queue/schedule.json` has the
dates.

## 14. Boards: as few as possible

Four right now. A board is created when 15 or more pins are ready for it, never
in advance. An empty board looks abandoned; one board with 90 pins looks like
an authority.

| Board | Holds |
|---|---|
| Race Day Outfits | The dress code and outfit angles |
| Horse Racing Guides | Enclosures, costs, tickets, timings |
| Sports Travel Guides | The catch-all, and future sports before they earn a board |
| World Cup 26 | Existing. 163 pins earning impressions. Left alone |

Each pin goes to its topic board first, then to Sports Travel Guides five or
more days later. Same creative on a second board with a real gap is a second
placement, not duplicate creative.

---

## What nobody knows

Stated so it is not mistaken for settled.

**No published A/B test exists** on whether giving the answer away on the pin
helps or hurts outbound clicks. Reasoning is available in both directions;
evidence is not.

**No credible organic outbound CTR benchmark exists.** The "0.2 to 0.5%" figure
circulating traces to a ring of AI-generated stat sites citing each other,
several dated into the future. Reject any Pinterest statistic without a
traceable origin study.

The test worth running: in one batch, make half the pins answer-complete and
half answer-plus-open-loop, same board, same week, same keyword family. Log
impressions, saves and outbound clicks separately. Two weeks produces the only
real data on the question that will exist.

---

## Checklist, per pin

- [ ] Angle is genuinely distinct from the others for this article
- [ ] Title 40 to 60 characters, hook inside the first 40, sentence case
- [ ] Target keyword present in the title
- [ ] Title shares no skeleton with any other title in the account
- [ ] Description 220 to 232 characters, says something the title did not
- [ ] On-image text: attention, real answer, soft close written for this pin
- [ ] Soft close uses words no other pin uses
- [ ] No banned phrase anywhere
- [ ] Prompt quotes every on-image word and ends "No other words anywhere"
- [ ] Outfit specified to fabric and cut; palette named for the season
- [ ] Varies from its neighbours on three axes minimum
- [ ] Ground is #FAF7F1; accent used once
- [ ] Alt text written, describing the photograph and the garments
- [ ] Footer is the url alone
- [ ] Destination returns 200

# Pin process

How a batch of pins gets made. Follow this and every pin comes out different
from the last, which is the whole point.

Strategy and keyword data: [PINTEREST-STRATEGY.md](./PINTEREST-STRATEGY.md).
Worked example: [PINS-BATCH-01.md](./PINS-BATCH-01.md).

---

## 1. Pick the angles

Read the article. List the questions it answers that a person would genuinely
type into Pinterest. Three to six per article. If you cannot find three
distinct ones, the article gets three pins, not six.

An angle is only an angle if it has its own answer. "Royal Ascot enclosures"
and "which Royal Ascot enclosure is cheapest" are the same angle. "What
enclosure to pick" and "what parking costs" are two.

## 2. Check the destination is live

Articles publish on a drip schedule. `content-queue/schedule.json` has the
dates.

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://www.ofthepitch.com/<slug>
```

Pinterest moves the "Visit site" button into the "..." menu when a link 404s.
Pinning before the article is live throws away the click affordance on that
pin, and you cannot get it back by fixing the link later.

## 3. Write the title by hand

**No formula.** Not "X things you need to know", not "The ultimate guide to",
not "Everything you need to know about". If two titles in the account share a
skeleton, both look automated.

- Hook inside the first 40 characters. That is all the feed shows.
- Include the term someone would search, in the words they would use.
- Write it as a person would say it out loud.

Broad beats specific. "Ascot outfits" is 13k searches, "ascot royal enclosure
dresses" is 170. Pin on the broad term and let the page deliver the specific
answer.

## 4. Write the description by hand

220 to 232 characters. Longer correlates with worse performance, and the
description never displays in the feed anyway: it is for relevance only.

Say something the title did not. Then name one thing the article resolves that
the pin does not. Honest open loop, no curiosity gap.

**Never write a curiosity gap.** Pinterest prohibits "sensational clickbait
tactics that exploit user curiosity", and separately hides the Visit site
button when pin content does not match the landing page. Both cost you the
thing you are optimising for.

## 5. Write alt text

The only measured lift in the entire space: **+123% outbound clicks**, from
the Tailwind 2025 study of 1.2M pins across 17k accounts.

Describe the photograph plainly, as if to someone who cannot see it. Include
the garments. Do not keyword-stuff.

> Woman in a herringbone tweed coat and olive felt fedora at Cheltenham
> racecourse in March, blurred crowd behind her.

## 6. Write the prompt

One complete prompt per pin. Never "same as above but change the colour".

Every prompt must specify:

**The layout**, top to bottom, with the fade between photo and paper. No hard
rules between image and type; they should merge over 120 to 220 pixels.

**The outfit**, in detail. This matters more than anything else on this site,
because the clothes are what people searched for. Name the garment, the
fabric, the cut, the colour, the accessories.

> A knee-length herringbone tweed coat in warm brown and oatmeal, worn open
> over a fine-knit charcoal roll neck. A wide-brimmed felt fedora in deep
> olive with a grosgrain band.

Not "a well-dressed woman". That produces a generic result.

**The palette**, named per pin and matched to the season. Cheltenham in March
is brown, oatmeal, olive, charcoal. Ascot in June is powder blue, blush,
cream, buttermilk. Two events, two palettes, so the pins cannot look like
recolours of each other.

**The constraints**, every time:
- No logos, no branded clothing
- Editorial styling, not stock photography
- No direct-to-camera smiling
- Signage and number plates blurred, never legible
- Footer on clean paper, not over the photograph
- No text within 60px of the edge

## 7. Vary the design deliberately

Pinterest's wording:

> "Try not to repeatedly save the same Pins or upload content that already
> exists on Pinterest. You may get flagged as spam and get temporarily blocked
> from creating Pins."

That governs **creative**, not destination. Six distinct pins to one article is
fine. A recolour is not.

Across any batch, vary at least three of these:

| Axis | Options |
|---|---|
| Photo position | top, bottom, none |
| Photo subject | person, crowd, flat-lay, place |
| Crop | full figure, mid-thigh up, from behind, overhead |
| Type layout | one huge word, a list, a table, a number |
| Palette | per sport and per season |
| Ground | cream #FAF7F1, white, pale tint |

Five pins in a batch should be identifiable as the same publisher and
unmistakable as different pins. The wordmark in the same corner is the brand
signal. Everything else should move.

## 8. Design rules that do not change

From the Tailwind 2025 study:

- **Light grounds.** 87 of the top 100 dominant colours in viral pins were
  white, near-white or light grey. Never use the site's dark ink card design
  as a pin.
- **Accent once per pin.** Only 4% of designed viral pins used a brand
  palette. Restraint is the finding.

From Pinterest's own specs:

- 1000x1500, 2:3
- Title 100 chars, first 40 visible
- Description 800 max, aim 220 to 232

From Pinterest's creative guidance:

> "Stack your story by putting visuals in the middle, then stacking text
> overlay with key messaging at the top and extra details at the bottom."

The "extra details at the bottom" slot is where the open loop and the
"Full guide" line go. Do not leave it empty.

## 9. Boards

Ten for the whole site. Pin to the topic board first, then to the catch-all
"Going To The Sport" a few days later. Same creative on two boards, staggered,
is not a duplicate.

## 10. Log it

Record impressions, saves and outbound clicks per pin, separately.

**Nobody knows whether giving the answer away on the pin helps or hurts
outbound clicks.** There is no published A/B test, and no credible organic
outbound CTR benchmark exists either. Every figure circulating traces to a ring
of AI-generated stat sites citing each other.

So test it: in one batch, make half the pins answer-complete and half
answer-plus-open-loop. Same board, same week, same keyword family. Two weeks of
that produces the only real data on the question, and then you design on your
own numbers instead of anyone's guess.

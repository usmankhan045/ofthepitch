-- ─────────────────────────────────────────────────────────────────────
-- ofthepitch.com — WordPress migration seed
--
-- 76 posts, 7 pages, 9 categories.
-- Post bodies came from the live rendered pages; FAQ prose and squad/event
-- data were lifted out of the JSON-LD the WordPress theme emitted.
--
-- Idempotent: every insert is ON CONFLICT DO UPDATE, keyed on
-- (site_id, slug), and all ids are deterministic uuid5 values.
-- Scoped entirely to this site_id — no other tenant is touched.
-- ─────────────────────────────────────────────────────────────────────

begin;

-- ── Site ──
insert into sites (id, slug, domain, name, niche, deploy_url, theme_config)
values ('ed23c093-ff1e-4355-8e4a-fd1961a03587', 'ofthepitch', 'ofthepitch.com', 'Of The Pitch',
        'World Cup 2026 fan guides, travel, tickets and football culture',
        'https://ofthepitch.com', '{"colors": {"primary": "#0B6B3A", "accent": "#F5A524"}}'::jsonb)
on conflict (id) do update set
  slug = excluded.slug, domain = excluded.domain, name = excluded.name,
  niche = excluded.niche, deploy_url = excluded.deploy_url,
  theme_config = excluded.theme_config;

-- ── Categories (9) ──
insert into categories (id, site_id, slug, name, description) values
  ('520d2f96-59b8-57aa-a01e-3a69136884e0', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'general', 'General', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('dfe9fe4b-9abe-55f9-9449-710248072f33', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fan-zone-guide', 'Fan Zone Guide', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('994ff97d-a052-59c4-85d3-636b8ca8c2b7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'visa-immigration', 'Visa & Immigration', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('27216e93-685b-5f7e-a60a-55260dfb5490', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'tickets-and-hospitality', 'Tickets and Hospitality', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('6a75e67b-e1b2-59c5-b18f-2e23ecce11ff', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fan-travel-logistics', 'Fan Travel & Logistics', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('79ef23c4-19f8-56f0-acdc-4cc2885f40a3', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'viewing-guides', 'Viewing Guides', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('a190ca80-f71c-5fee-a044-6e8df6d7f280', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'team-reviews', 'Team Reviews', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'controversy-and-politics', 'Controversy & Politics', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;
insert into categories (id, site_id, slug, name, description) values
  ('ced3e2d1-82fe-5b9d-b191-c9b225323144', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fan-travel-and-logistics', 'Fan Travel and Logistics', null)
on conflict (site_id, slug) do update set
  name = excluded.name, description = excluded.description;

-- ── Posts (76) ──
-- [full] world-cup-2026-host-country-player-controversy
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('c15483c0-e661-5468-afa1-ad119abf740b', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-host-country-player-controversy',
   'World Cup 2026 Host Country Politics and Player Controversies Explained',
   'FIFA faces an ethics complaint, a Seattle Pride match dispute, and extreme heat concerns. Here is what is actually happening with World Cup 2026 host country politics.',
   'FIFA president Gianni Infantino is facing a formal ethics complaint, now backed by Norway’s football federation, over awarding a peace prize to President Trump and repeatedly praising his political agenda in apparent breach of FIFA’s own neutrality rules. At the same time, a scheduled Seattle match between Egypt and Iran has triggered a diplomatic dispute over Pride celebrations, and extreme heat has already forced teams to cut training short and leave substitutes in locker rooms during preparation events.

These are three separate controversies, but they share the same root cause: a tournament this large, hosted by a politically divided country, was always going to collide with issues bigger than football. Here is what has actually happened in each case.

## FIFA’s Neutrality Rules Collide With Politics

FIFA’s own Code of Ethics requires officials to remain politically neutral when dealing with governments, with Article 15 specifically banning support for individual political leaders or agendas. That rule came under direct pressure on December 5, 2025, when Infantino presented President Trump with the inaugural FIFA Peace Prize at the World Cup draw in Washington, telling him on stage that he definitely deserved the honor and that he could always count on Infantino’s support.

The London based human rights group FairSquare filed an eight page complaint with FIFA’s Ethics Committee three days later, citing four separate instances where Infantino had publicly backed Trump’s political agenda, including a January Instagram video in which Infantino concluded with the line that together they would make not only America great again but also the entire world. FairSquare’s program director argued the complaint was about more than support for one political figure, framing it instead as evidence that FIFA’s governance structure allows its president to act in ways that conflict with the interests of the sport itself.

The complaint gained institutional weight in June 2026 when the Norwegian Football Federation formally backed it just before Norway’s own World Cup departure. Federation president Lise Klaveness, who had already called on FIFA to scrap the peace prize entirely to protect its neutrality, confirmed at a press conference that Norway’s letter of support had been submitted, acknowledging that the move had created friction inside FIFA’s governing structure. Under FIFA’s own rules, a confirmed breach of the neutrality requirement carries a possible ban from football related activity of up to two years, though FIFA’s Ethics Committee does not comment on whether a case is being actively pursued, and no ruling has been announced.

## The Seattle Pride Match Dispute

A separate controversy has nothing to do with Infantino directly and everything to do with how FIFA’s own World Cup draw interacted with a host city’s existing plans. Seattle’s local organizing committee had designated June 26 as a Pride celebration date months before FIFA finalized the match schedule, tying it to the city’s long running annual PrideFest tradition. When the draw placed Egypt against Iran in Group G, FIFA assigned that exact matchup to Seattle on that exact date, creating a Group G game between two countries that both impose severe penalties on same sex relationships landing directly on a celebration built around LGBTQ visibility.

Both federations objected formally. Egypt’s football association sent FIFA a letter categorically rejecting any activities related to supporting homosexuality during the match, citing what it described as a contradiction with the cultural, religious and social values of the region. Iran Football Federation president Mehdi Taj called the scheduling unreasonable and illogical during a state television interview, confirming that a formal complaint had been sent to FIFA and that Iran intended to raise the issue at an upcoming FIFA Council meeting. In Iran, same sex sexual activity can be punished by death under the Islamic Penal Code, and Egypt’s morality laws allow for de facto criminalization of same sex relationships, giving both federations a starkly different starting point than the host city’s own civic tradition.

Seattle’s organizing committee has not backed down. A spokesperson said the city was moving forward as planned with community programming outside the stadium during Pride weekend, describing the Pacific Northwest as home to large Iranian American and Egyptian diaspora communities alongside the broader population the city was hosting for the tournament. The dispute remains unresolved heading into the actual match date, with Seattle continuing its public events while both federations maintain their formal objection on record with FIFA.

## Extreme Heat Is Already Affecting How Teams Prepare

Beyond the governance disputes, a more physical controversy has been building for over a year. Scientists and players union officials have warned that this could be the hottest World Cup on record, with roughly half a dozen venues, including Dallas, Houston and Miami along with the Mexican host cities, considered especially prone to extreme heat during the tournament window.

Those warnings were not theoretical. At the Club World Cup held in the United States the previous summer, conditions reached the high 90s and low 100s Fahrenheit in multiple host cities, and several major clubs altered their own match day approach in response. One team kept its substitutes inside the locker room for the first half of a match rather than have them sit exposed on the bench in direct sunlight, while another coaching staff cut a training session short in Philadelphia as the city baked in temperatures above 37 degrees Celsius. A players union official representing the global players association described conditions during one match as horrendous, noting that the heat and humidity made it incredibly difficult to simply concentrate on the game.

FIFA’s response has been to mandate cooling breaks at the 22nd and 67th minute of every match regardless of conditions, and the published schedule shows a deliberate effort to assign daytime kickoffs to air conditioned, covered stadiums in cities like Dallas, Houston and Atlanta while routing higher risk outdoor venues toward evening kickoffs instead. Whether that scheduling strategy holds up across the full seven week tournament, particularly during the knockout rounds when fixture dates are less flexible, remains one of the more closely watched physical storylines of the competition.

## Why These Controversies Matter Beyond the Headlines

Each of these disputes points to the same underlying tension. A 48 team, three country World Cup staged across wildly different climates, cultures and political relationships was never going to avoid friction, and FIFA’s own decisions, from who receives a peace prize to which cities host which matchups to how aggressively it schedules daytime games in hot climates, have repeatedly turned that friction into a public dispute rather than a quietly managed background issue.

![Seattle waterfront view near the World Cup 2026 host stadium](/images/2026/06/Seattle_stadiums_from_Rizal_Park_at_dusk_01.jpg)

## Watch the Tournament From Wherever You Are

With this many storylines developing in real time across three countries, staying connected to live coverage and full match replays matters more than usual this tournament.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

If you are traveling between host countries or trying to access your home broadcaster’s coverage, a dependable VPN can keep your stream connected wherever you are. [Check current NordVPN plans](https://nordvpn.com) before the next round of matches kicks off.

## Frequently Asked Questions

### What is the ethics complaint against FIFA president Gianni Infantino?

The human rights group FairSquare filed a complaint with FIFA’s Ethics Committee accusing Infantino of repeatedly breaching FIFA’s duty of political neutrality, primarily through awarding President Trump the inaugural FIFA Peace Prize and publicly endorsing his political agenda. The Norwegian Football Federation formally backed the complaint in June 2026.

### Could Infantino actually be banned from football over this complaint?

FIFA’s Code of Ethics allows for a ban from football related activity of up to two years for a confirmed breach of the neutrality requirement under Article 15. FIFA’s Ethics Committee has not commented on whether the case is being pursued, and no ruling has been announced as of this writing.

### Why are Egypt and Iran objecting to their Seattle match?

FIFA scheduled the Egypt versus Iran Group G match in Seattle on June 26, the same date the city had already designated for Pride celebrations tied to its annual PrideFest tradition. Both federations sent formal complaints to FIFA, citing conflicts with their countries’ laws and cultural values around same sex relationships.

### Is Seattle canceling its Pride celebrations because of the complaints?

No. Seattle’s local organizing committee has said it is moving forward as planned with Pride weekend programming outside the stadium, while both Egypt and Iran maintain their formal objections with FIFA. The dispute remains unresolved as the match date approaches.

### How is FIFA handling extreme heat concerns at this World Cup?

FIFA has mandated cooling breaks at the 22nd and 67th minute of every match and has scheduled daytime kickoffs in air conditioned, covered stadiums such as those in Dallas, Houston and Atlanta, while assigning higher heat risk outdoor venues to evening kickoff times where possible.

### Did heat actually disrupt matches before this World Cup started?

Yes. At the Club World Cup held in the United States the previous summer, multiple teams altered their match day routines because of extreme heat, including one club keeping substitutes off the bench during the first half and another cutting short a training session as temperatures exceeded 37 degrees Celsius in Philadelphia.

### Has FIFA responded to the criticism over its political neutrality?

FIFA has not issued a detailed public response to the FairSquare complaint specifically, and its Ethics Committee does not comment on potential ongoing cases. Infantino has continued to publicly praise the Trump administration in subsequent appearances since the complaint was filed.',
   '/images/2026/06/Seattle_Waterfront_-_panoramio.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'World Cup 2026 Host Country Politics and Player Controversies Explained - Of The Pitch',
   'FIFA faces an ethics complaint, a Seattle Pride match dispute, and extreme heat concerns. Here is what is actually happening with World Cup 2026 host country politics.',
   '[]'::jsonb, '2026-06-26T18:50:09Z', '2026-06-26T18:50:11Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] var-referee-controversy-world-cup-2026
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('89f99484-4a2c-5790-941f-5f229e44eeec', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'var-referee-controversy-world-cup-2026',
   'Why VAR Keeps Becoming the Story at the 2026 World Cup',
   'VAR has already decided multiple World Cup 2026 matches, from a three red card opener to a viral referee gesture and a technology glitch fans are still talking about.',
   'VAR has already shaped the outcome of multiple matches in the first week of the 2026 World Cup, from three red cards in the Mexico vs South Africa opener to a delayed penalty review in France vs Senegal that left Kylian Mbappe on the ground for several minutes. The video assistant referee system is being used at a World Cup for the third time, but the scale of this tournament, 48 teams and 104 matches across three countries, has multiplied the number of contested calls fans see every single day.

This guide breaks down exactly what has happened so far, why FIFA’s offside technology has caused confusion, and what fans should expect from officiating for the rest of the tournament. None of this is speculation. Every incident below is tied to a confirmed match, a named official, or a FIFA statement.

## The Opening Night Red Card Chaos

The tournament’s first match between Mexico and South Africa in Mexico City on June 11 produced three red cards, the most issued in a single World Cup match since the 2006 Battle of Nuremberg between Portugal and the Netherlands. Referee Wilton Sampaio of Brazil sent off South Africa’s Sphephelo Sithole and Themba Zwane along with Mexico’s Cesar Montes. The second red card to South Africa only came after Sampaio walked to the pitchside monitor and reviewed the incident himself, a process that took several minutes while both sets of fans waited inside Estadio Azteca.

At the 2022 World Cup in Qatar, only four red cards were shown across the entire tournament. Seeing three in one match immediately set the tone for how central officiating decisions would become to the conversation around this World Cup.

## The VAR Room Gesture Controversy in Houston

During Germany’s match against Curacao in Houston, television cameras cut to the video assistant referee room and caught Australian official Shaun Evans appearing to make a hand gesture that anti discrimination campaigners say resembles a symbol linked to white nationalist movements. The clip spread quickly online, and FIFA faced pressure to explain what fans had seen on a global broadcast.

The incident landed on top of a tournament already dealing with visa disputes and ticketing complaints, and it became one more example of how a single camera angle inside a VAR booth can turn into an international story within hours. FIFA has not announced disciplinary action against Evans, who remains part of the officiating team named for the tournament.

## The Technology Glitch in Qatar vs Switzerland

During the Qatar vs Switzerland match in the San Francisco Bay Area, FIFA’s semi automatic offside technology failed to generate its usual animation graphic before a penalty was awarded to Switzerland in the 14th minute. FIFA uses sensors that send an audio alert to assistant referees when a player is offside by more than 10 centimeters. In this case the margin fell below that threshold, which meant officials needed a manual review instead of an instant automated call.

Because the offside image is normally generated within seconds, fans and commentators expected to see it immediately. When it did not appear for several hours, frustration grew. Former England player turned broadcaster Gary Neville called the delay “like a dictatorship” on live television. FIFA later confirmed the cause was a brief technical outage, not an error in the underlying offside calculation.

## How VAR Actually Works at This World Cup

A separate team of officials watches every match from a video operation room, either inside the stadium or at a centralized facility, using multiple camera angles and slow motion replays. Their job is not to referee the match remotely. They are advisers who alert the on field referee only when they believe a clear and obvious error may have occurred. The final decision always belongs to the referee on the pitch, who can choose to review the replay themselves at the sideline monitor before making a final call.

FIFA named 52 referees, 88 assistant referees, and 30 video assistant referees for this tournament on April 9, 2026. One change came on May 15 when Willy Delajod of France was added as a replacement for Dutch VAR Rob Dieperink, who was dropped after his arrest in England weeks before the tournament began.

![A football referee pictured during a match](/images/2026/06/Deniz_Aytekin_referee.jpg)

## What This Means If You Are Watching Matches

Expect review delays, particularly on close offside calls and penalty decisions. A check that looks instant on social media clips is rarely instant in the stadium. Broadcasters in different countries also handle the delay differently. Some cut away to studio analysis while officials review the monitor, while others hold on a static shot of the stadium, which can make the wait feel even longer for viewers at home. If you are watching from home and want to follow officiating decisions in real time without regional broadcast restrictions or blackouts, a reliable VPN service makes it easier to access the feed of your choice and see replays as they are shown internationally rather than waiting for delayed local coverage.

It is also worth setting expectations correctly going into the knockout rounds. Historically, the closer a tournament gets to its final stages, the more cautious referees become with card decisions and the more frequently VAR is used, since the cost of a wrong call rises with every stage. Fans who found the opening week’s red card numbers unusual should expect officiating scrutiny to increase rather than decrease as the group stage gives way to the round of 16 and beyond.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure). NordVPN is one option many fans use to follow international match feeds. Visit [NordVPN](https://www.nordvpn.com) to compare plans before kickoff.

## Frequently Asked Questions

### Why did three players get sent off in the World Cup opener?

Referee Wilton Sampaio issued red cards to South Africa’s Sphephelo Sithole and Themba Zwane and Mexico’s Cesar Montes during the June 11 opening match in Mexico City. The second South African red card followed a pitchside monitor review, which is standard VAR protocol for serious incidents the referee wants to confirm before issuing a card.

### What was the referee gesture controversy about?

During the Germany vs Curacao match in Houston, VAR official Shaun Evans was filmed appearing to make a hand gesture that anti discrimination groups linked to white nationalist symbolism. The clip went viral and added to a string of off field controversies surrounding the tournament’s opening week.

### Why did the offside review take so long in Qatar vs Switzerland?

FIFA’s semi automatic offside technology relies on sensors that normally generate an animated graphic within seconds. A brief technical outage during that match meant officials had to complete a manual review instead, which delayed the penalty decision and frustrated fans watching the broadcast.

### Does the video assistant referee make the final decision?

No. The VAR team can only recommend a review to the on field referee when they believe a clear and obvious error occurred. The referee retains full authority and can view the replay on the pitchside monitor before making the final call themselves.

### How many officials are working this World Cup?

FIFA named 52 referees, 88 assistant referees, and 30 video assistant referees on April 9, 2026. One replacement was made in May when Willy Delajod of France stepped in for a Dutch VAR official who was dropped from the tournament following an arrest.

### Has VAR caused more controversy at this World Cup than in 2022?

The early numbers suggest yes. Qatar 2022 produced only four red cards across the entire tournament, while the 2026 opening match alone produced three. The larger 48 team format and the higher number of total matches mean more contested decisions are happening within the same opening days compared to previous tournaments.',
   '/images/2026/06/Referee_showing_a_red_card.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'Why VAR Keeps Becoming the Story at the 2026 World Cup - Of The Pitch',
   'VAR has already decided multiple World Cup 2026 matches, from a three red card opener to a viral referee gesture and a technology glitch fans are still talking about.',
   '[]'::jsonb, '2026-06-26T18:49:40Z', '2026-06-26T18:49:41Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-stadium-transit-chaos
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('bdb8f24d-ece8-5d3d-a5b7-63aacccfea26', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-stadium-transit-chaos',
   'World Cup 2026 Stadium Access and Transit Chaos: What Is Actually Happening',
   'Stadium gridlock and stranded fans have already hit World Cup 2026 host cities. Here is what happened at MetLife Stadium and which other cities could see the same chaos.',
   'Getting to a World Cup 2026 stadium has turned into one of the tournament’s biggest complaints, with gridlock, stranded fans and mile long walks reported at the very first matches in New York and New Jersey, and transportation experts warning that several other host cities are even less prepared to absorb the crowds. This is not a single bad night. It is a structural problem tied to how spread out and car dependent many World Cup host cities already are.

Here is what has happened so far at the stadiums where matches have already been played, and what to expect if you still have tickets for a match in the weeks ahead.

## The MetLife Stadium Opener Set the Tone

The opening regional match at MetLife Stadium, officially renamed New York New Jersey Stadium for the tournament, brought more than 80,000 fans into the Meadowlands on June 13. NJ Transit publicly declared the operation a success, posting that it had moved 21,578 fans from the stadium via bus and rail within 90 minutes. That statement was accurate as far as it went, but it left out a large part of what fans actually experienced that day.

Bumper to bumper traffic forced hundreds of spectators and volunteers to abandon their cars and walk a mile or more in 87 degree heat just to reach the stadium on time. One fan who had traveled from Sao Paulo described calling a ride to the nearby American Dream Mall, a trip that should have taken ten minutes without traffic, and instead spending 20 minutes sitting in the car before getting out and walking the rest of the way. A tournament volunteer from Bergen County had to be dropped off by a parent once they crossed onto the grounds of the stadium itself, since no other option got them there on time. Rideshare apps could not handle the surge either, leaving even fans who planned ahead stuck in the same gridlock as everyone else.

Local and federal officials had warned about exactly this risk before the tournament began. New Jersey Congressman Frank Pallone specifically cautioned that weeks of service disruptions on the Northeast Corridor, one of the busiest rail networks in the country, could create what he called another summer of hell for fans and commuters alike, a reference to the chronic delays the region experienced in past years. Persistent issues including power failures, repair backlogs and a recent tunnel fire had already raised doubts about whether the existing infrastructure could handle a tournament of this scale even before the first match was played.

## A Second Match, A Similar Problem

The pattern repeated days later when France played Senegal at the same stadium. City officials declared a Gridlock Alert Day for New York, warning fans and local commuters alike not to drive in Midtown Manhattan. Streets around Penn Station were closed off for hours, with NJ Transit reserving service for ticket holders during peak windows and asking non ticket holders to find an alternate route entirely. The evening rush hour coincided directly with the end of the match, compounding congestion across the region rather than spreading it out.

NJ Transit did show improvement on raw throughput, moving 26,000 people from the stadium in approximately 70 minutes during this second test, an operation officials described as having passed with flying colors. Commuters interviewed at Penn Station the same morning said they expected crowded conditions later in the day, with some cautiously optimistic given how the first match had gone. The bigger structural issue, though, has nothing to do with whether NJ Transit can move large numbers of people once they reach the station. It is that thousands of out of town visitors do not realize MetLife Stadium itself is in New Jersey rather than New York City, and many discover only on arrival that reaching it requires a separate train transfer most first time visitors never accounted for in their planning.

## Why Other Host Cities Are Watching Nervously

New York and New Jersey have one of the most developed rail networks of any World Cup host region, which makes the early stumbles there a warning sign for cities with far less transit infrastructure to rely on. Transportation researchers have specifically flagged Dallas, Houston and Kansas City as car dependent metros with less margin for error, meaning the traffic around AT&T Stadium in Arlington, NRG Stadium in Houston and Arrowhead Stadium in Kansas City is expected to hit harder than in transit rich markets like Atlanta or Seattle.

Arlington, where AT&T Stadium sits, does not have a public transit system of its own, a fact that complicated planning for years before the tournament even arrived. The solution local organizers settled on requires fans to take a regional commuter train to CentrePort Station near Dallas Fort Worth International Airport, then board a connecting bus for the final leg to the stadium, followed by a half mile walk to the entrance once they arrive. Fans are explicitly told they cannot simply be dropped off at the stadium for a match, a restriction that catches many first time visitors off guard. Local residents have been asked to work from home on match days or limit their own driving entirely just to free up road and transit capacity for international visitors who often have no other way to reach the stadium.

Cities with stronger existing infrastructure have tried to get ahead of the problem. Atlanta redesigned parts of its bus network and launched a new rapid transit line specifically before the tournament. Los Angeles County opened a new subway extension, and Seattle completed the final segment of a light rail line that now reaches its downtown stadium directly. Even with those upgrades, transportation officials across nearly every host city have settled on the same working assumption for fans this summer, which is to plan around public transit rather than driving and to build significant extra time into any trip to or from a match.

## What This Means for Your Own Match Day

If you have tickets to an upcoming match, the lesson from New York and New Jersey applies almost everywhere else on the schedule. Do not assume a short rideshare trip will stay short once tens of thousands of fans converge on the same roads at the same time, and do not assume your hotel’s proximity to a stadium on a map translates into an easy walk once security perimeters and road closures are in place. Build in at least 90 to 120 minutes before kickoff, confirm exactly which train or shuttle connection your specific stadium requires, and have a backup plan in mind in case rideshare demand spikes beyond what the local network can absorb.

![New Jersey Transit train used to move World Cup fans to and from MetLife Stadium](/images/2026/06/New_Jersey_Transit_train_1165.jpg)

## Book Accommodation Close to Your Transit Option, Not Just the Stadium

Given how many fans have been caught out by transit and walking distances that looked simple on a map, where you stay matters as much as which match you are attending.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

Booking a hotel near a confirmed transit hub rather than simply near the stadium itself can save you hours of frustration on match day. [Compare hotel options near major transit hubs on Booking.com](https://www.booking.com) or [check availability on Hotels.com](https://www.hotels.com) before you finalize your trip.

## Frequently Asked Questions

### Why were fans stranded after the first MetLife Stadium World Cup match?

Bumper to bumper traffic and overwhelmed rideshare apps forced hundreds of fans and volunteers to abandon their vehicles and walk a mile or more in extreme heat to reach the stadium, even though NJ Transit’s own rail and bus operation successfully moved over 21,000 people in 90 minutes after the match.

### Is MetLife Stadium actually in New York City?

No. MetLife Stadium, renamed New York New Jersey Stadium for the tournament, is located in East Rutherford, New Jersey, in the Meadowlands. Many visiting fans do not realize this and are caught off guard by the additional train transfer required to reach it from Manhattan.

### Which World Cup host cities have the worst transit access to their stadiums?

Transportation researchers have specifically flagged Dallas, Houston and Kansas City as car dependent metros with limited transit capacity. Arlington, home to AT&T Stadium, has no public transit system of its own, requiring fans to combine a commuter train, a connecting bus and a half mile walk to reach the stadium.

### Can I get dropped off directly at AT&T Stadium for a match?

No. Local organizers have explicitly stated that fans cannot be dropped off at the stadium for World Cup matches. The required route involves a train to CentrePort Station followed by a shuttle bus and a walk to the entrance.

### How early should I arrive at a World Cup stadium?

Plan to arrive at least 90 to 120 minutes before kickoff given road closures, security checkpoints and heavy congestion expected around every stadium on match days. This applies even if your hotel appears close to the venue on a map.

### Are any host cities better prepared for World Cup crowds?

Atlanta, Los Angeles and Seattle have all made specific transit upgrades ahead of the tournament, including a new bus rapid transit line in Atlanta, a subway extension in Los Angeles and a completed light rail connection to the stadium in Seattle, putting them in a stronger position than car dependent host cities.

### Should I drive to a World Cup match if I have a rental car?

Most host committees are actively discouraging driving to stadiums, citing road closures, limited parking and traffic that overwhelms even rideshare apps on match days. Public transit, where available, is consistently recommended as the more reliable option even when it requires extra connections.',
   '/images/2026/06/Metlife_stadium-1.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'World Cup 2026 Stadium Access and Transit Chaos: What Is Actually Happening - Of The Pitch',
   'Stadium gridlock and stranded fans have already hit World Cup 2026 host cities. Here is what happened at MetLife Stadium and which other cities could see the same chaos.',
   '[]'::jsonb, '2026-06-26T18:49:21Z', '2026-06-26T18:49:23Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-visa-entry-denial-controversy
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('dcabfd89-2770-598f-b722-59f1c909c53b', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-entry-denial-controversy',
   'World Cup 2026 Visa and Entry Denial Controversy Explained',
   'Referees, players, and fans have all been denied entry to the World Cup 2026 host countries this year. Here is what happened with the visa and ESTA controversy.',
   'Dozens of World Cup 2026 ticket holders, team staff and even a match referee have been denied entry to the United States in the weeks surrounding the tournament, despite holding valid visas, ESTA approvals or FIFA accreditation. The cases span a Somali referee turned away in Miami, an Iraqi team photographer held for hours in Chicago, and Scottish fans whose previously approved travel authorizations were revoked days before kickoff.

This is not a single isolated incident. It is a pattern that has played out across multiple countries and multiple categories of World Cup traveler, and it is directly tied to United States immigration policy under the current administration.

## A Somali Referee Denied Entry to Officiate His First World Cup

Omar Abdulkadir Artan, a 34 year old Somali official named the Confederation of African Football’s Best Male Referee for 2025, was set to become the first Somali referee in World Cup history. Instead his tournament ended at Miami International Airport, where United States Customs and Border Protection determined he was inadmissible due to what officials described as vetting concerns, despite Artan holding a valid US visa and being listed among FIFA’s official roster of 52 World Cup referees.

Somalia sits on the current United States travel ban list, and Artan was flown back to Istanbul rather than allowed to continue to his assignment. FIFA confirmed in a statement that Artan would be unable to train or officiate at the tournament following the denial. A FIFA representative later said his visa issues had been fully resolved, though by that point the World Cup had already moved on without him. Professor Jules Boykoff, author of a book examining the politics surrounding this World Cup, described the situation as a paradox: a tournament built around inclusion and global participation running directly into immigration policies that excluded some of its own officials before a single one of their matches kicked off.

## Iraq’s Team Staff Held and Questioned at the Border

Iraq’s national team experienced its own entry problems on arrival in the United States. The team’s photographer, Talal Salah, was denied entry after being held for more than ten hours at Chicago’s O’Hare International Airport, with his phone inspected before he was ultimately turned away. Iraq’s key striker, Aymen Hussein, was separately questioned for nearly seven hours at the same airport and had his own phone searched before he was permitted to enter the country.

These incidents happened to playing and supporting members of a team that had already secured its place in the tournament through normal qualification, underscoring that valid accreditation and a legitimate reason for travel did not guarantee a smooth border experience for delegations from certain countries.

## Iran’s Restricted Travel Arrangement

Iran’s situation has been treated differently from other affected countries because of the broader diplomatic relationship between Washington and Tehran. Iran’s players were granted visas only ten days before their first match, and the team has been operating under a tightly restricted travel plan, entering the United States the day before each of its matches and returning afterward to a base across the border in Tijuana, Mexico, rather than remaining in the US between games. President Trump had previously said he did not consider it appropriate for the Iranian team to stay in the United States, citing what he described as concerns for their own safety.

Iran had already clashed with the tournament’s organizing process months earlier, boycotting the official World Cup draw in Washington after the United States denied visas to several members of its delegation, including federation president Mehdi Taj. The administration’s travel ban announced earlier had named twelve countries for full denial of entry, including Iran and Haiti, with a stated exception for athletes, coaches and support staff traveling specifically for major sporting events such as the World Cup. Whether that exception extended to delegation members attending the draw itself, rather than the tournament, became a point of dispute that was never fully resolved before Iran chose to stay home from the draw entirely.

## Scottish Fans Lost Travel Authorization Days Before Kickoff

The visa problems have not been limited to countries on formal travel ban or restriction lists. Scotland qualified for its first World Cup since 1998, and a number of Scottish fans who had already booked flights, hotels and match tickets found their Electronic System for Travel Authorization status changed without warning in the days immediately before departure, shifting from approved to pending and finally to travel not authorized.

Michael Wright, a Scottish fan preparing to fly from England, had his ESTA revoked roughly one hour before his scheduled takeoff from Manchester Airport. Scott Braid, an engineer from Kirkcaldy who was due to fly to Boston with his wife and two children to watch Scotland face Haiti, saw his status flip from approved to pending and then to not authorized within hours, despite having applied months earlier and received quick approval. Kenny Smith, a business owner from Inverness whose ESTA had reportedly been valid until 2027, had his authorization pulled with no explanation given, forcing him into an urgent and expensive visa application process with only days to spare.

Scotland’s First Minister John Swinney addressed the issue directly in the Scottish Parliament, saying he was aware the United States Embassy had advised affected individuals that they could apply for a visa through the FIFA PASS system and confirming his office had reached out to the United States Consul General in Scotland to try to resolve the situation before Scotland’s opening match against Haiti in Boston. The White House had separately announced plans to incorporate social media screening into the travel authorization process, and some affected fans have speculated that this expanded screening, rather than any change in their own circumstances, triggered the sudden revocations.

## What This Means If You Are Still Planning to Travel

An approved ESTA or an issued visa is necessary but it is not, on its own, a guarantee of entry. United States Customs and Border Protection retains final discretion at the port of entry regardless of what was approved in advance, and recent cases show that approval can be revoked with little or no notice even for people with a long travel history to the country on the same authorization. If you have any uncertainty about your status, checking it regularly in the days before departure and having a backup plan, including knowledge of how to request an expedited visa appointment through your country’s US embassy, is no longer optional for anyone traveling from an affected country or category.

![Passport control at Budapest Airport showing an international arrivals checkpoint](/images/2026/06/Budapest_Airport_Passport_Control_T2.jpg)

## Protect Your Trip Against the Unexpected

Given how unpredictable entry decisions have proven to be this tournament, travel insurance that covers trip cancellation and interruption is worth serious consideration if you have already committed money to flights, hotels or hospitality packages.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

World Nomads offers travel insurance plans that can cover certain trip interruption scenarios for international travelers. [Check World Nomads coverage options](https://www.worldnomads.com) before your trip, particularly if your visa or ESTA status has changed at any point during the approval process.

## Frequently Asked Questions

### Why was a World Cup referee denied entry to the United States?

Somali referee Omar Artan was denied entry at Miami International Airport due to what US Customs and Border Protection described as vetting concerns, even though he held a valid US visa and was on FIFA’s official list of World Cup referees. Somalia is currently on the United States travel ban list, which appears to have been a factor despite his individual visa approval.

### Can a valid visa or ESTA still be revoked before I travel to the World Cup?

Yes. Multiple Scottish fans reported their previously approved ESTA status changing to pending or travel not authorized in the days or even hours before their scheduled flights, despite no apparent change in their personal circumstances. United States authorities have not been required to provide a specific reason for these revocations.

### Why is Iran’s team not staying in the United States between matches?

Iran’s national team has been entering the United States the day before each match and returning to a base in Tijuana, Mexico, afterward, rather than remaining in the US for the duration of the group stage. This arrangement followed comments from President Trump questioning whether it was appropriate for the team to stay in the country.

### What is the FIFA PASS system and does it guarantee a visa?

FIFA PASS is a priority scheduling system for ticket holders who applied for a B1 or B2 visa after purchasing tickets directly through FIFA, allowing access to earlier interview slots at ustraveldocs.com. It does not guarantee visa approval. It only provides faster access to the interview stage of the standard process.

### Are these entry denials only affecting countries on the formal travel ban list?

No. While Somalia and Iran are both subject to formal United States travel restrictions, Scottish fans, who come from a Visa Waiver Program country with no such restrictions, have also reported sudden ESTA revocations, suggesting the issue extends beyond the published list of restricted nations.

### What should I do if my ESTA status changes before I travel?

Apply for a visa appointment as soon as possible, since an ESTA denial or revocation typically requires moving to the standard visa application process. Contact your country’s US embassy directly, since several governments, including Scotland’s First Minister, have intervened to request expedited appointments for affected World Cup travelers.

### Has FIFA commented on these entry denial cases?

FIFA has generally distanced itself from individual immigration decisions, stating that it is not involved in host country visa adjudications and that those decisions rest with national authorities. FIFA did confirm Omar Artan’s inability to officiate following his denial of entry and has pointed affected ticket holders toward the FIFA PASS priority scheduling system as one available resource.',
   '/images/2026/06/JFK_International_Airport_Passport.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'World Cup 2026 Visa and Entry Denial Controversy Explained - Of The Pitch',
   'Referees, players, and fans have all been denied entry to the World Cup 2026 host countries this year. Here is what happened with the visa and ESTA controversy.',
   '[]'::jsonb, '2026-06-26T18:45:39Z', '2026-06-26T18:45:40Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-referee-var-controversy
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('b5b305b3-45d3-5263-b197-634780221476', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-referee-var-controversy',
   'FIFA World Cup 2026 Referee and VAR Controversies Explained',
   'VAR got more power at World Cup 2026 and controversy followed fast. Here is what happened with the Switzerland offside call, a referee hate symbol accusation, and red card chaos.',
   'The 2026 FIFA World Cup expanded VAR’s powers for the first time, giving video assistant referees the ability to intervene on second yellow cards and corner kick decisions. Within the opening week, those expanded powers were already at the center of multiple disputes, including a contested offside call in Switzerland’s opener and a viral accusation that an Australian video assistant referee had made a hate symbol on camera.

This guide walks through what actually happened in each major incident, what FIFA changed about VAR for this tournament, and why referees have already become one of the most talked about storylines of the competition.

## VAR Has More Power Than Ever at This World Cup

Before the tournament started, FIFA confirmed it was expanding VAR’s authority beyond its original mandate of correcting clear and obvious errors on goals, penalties, red cards and mistaken identity. For 2026, VAR officials can now intervene when a second yellow card has been incorrectly awarded and can weigh in on corner kick decisions, both new additions pushed through by the International Football Association Board.

Not everyone in football welcomed the change. England’s Football Association chief executive Mark Bullingham, who sits on the IFAB board, publicly opposed extending VAR’s remit further, arguing there was no real need for it. Critics across European leagues had already complained for years about time delays and decisions that seemed to contradict what fans could see live on broadcast, and expanding VAR’s scope just before the biggest tournament in the sport’s history added pressure rather than reducing it.

## The Switzerland vs Qatar Offside Controversy

One of the clearest examples of how VAR can still frustrate fans came in Switzerland’s opening match against Qatar at the stadium in Santa Clara, California. Switzerland was awarded a penalty after midfielder Remo Freuler was brought down in the box by Qatari goalkeeper Mahmud Abunada, a decision referee Said Martinez had little trouble making. Breel Embolo converted the penalty for Switzerland’s opening goal of the tournament.

The real controversy came from what was not reviewed rather than what was. Replay angles suggested Freuler may have been in an offside position before the ball reached him, a situation close enough that it looked offside to the naked eye on the broadcast feed. Despite FIFA’s semi automated offside technology being available specifically to catch borderline calls like this one, the offside question was not given the same level of scrutiny as the penalty decision itself, leaving commentators and fans confused about why one part of the sequence received full VAR treatment while the other did not. Switzerland went on to draw the match one goal apiece after Qatar leveled through a Miro Muheim own goal deep in second half stoppage time, meaning the disputed sequence directly affected the final result.

## The Australian Referee Accused of a Hate Symbol Gesture

The most explosive refereeing controversy of the opening week did not involve a contested call at all. During the broadcast cut to the video operation room before Germany’s seven to one win over Curacao, cameras caught Australian official Shaun Evans, who was working as a support video assistant referee for the match, appearing to form a circle with his thumb and index finger while extending his other three fingers outward.

That gesture, an upside down version of the common okay sign, has been adopted by some far right groups as a coded symbol, and the organization known as the Anti Defamation League formally added it to its list of hate symbols in 2019. Clips of Evans making the gesture spread rapidly online, with the anti discrimination monitoring group Fare accusing him of intentionally transmitting what it called a far right neo Nazi symbol and calling on FIFA to intervene immediately.

Evans denied any intended meaning once the backlash reached him. He stated publicly that he did not intentionally make a hand gesture or symbol to communicate any message, affiliation, game or belief. FIFA’s independent Disciplinary Committee opened an investigation and, after reviewing the matter, found no evidence of a breach of the FIFA Disciplinary Code, while noting Evans’s own statement on the record. FIFA cleared him to continue working at the tournament, though the episode reignited a long running debate about how easily ambiguous hand gestures can be read as coded messages on a broadcast watched by hundreds of millions of people.

## Red Cards and a Chaotic Opening Match

Referees were already under scrutiny before the Evans controversy because of what happened in the tournament opener itself. Mexico’s home match against South Africa in Mexico City produced three red cards, the most shown in any World Cup match since 2006, when four players were sent off in a game that became known as the Battle of Nuremberg.

South Africa’s Sphephelo Sithole was given a straight red card for denying a clear goalscoring opportunity after bringing down Brian Gutierrez near the edge of the penalty area. Later in the match, referee Wilton Sampaio initially showed Themba Zwane a yellow card for an off the ball incident with Mexico’s Roberto Alvarado, then upgraded it to a red card for violent conduct after a VAR review prompted him to check the pitchside monitor. Mexico’s Cesar Montes also picked up a red card before the final whistle. Under FIFA’s disciplinary rules, each of those players faced an automatic one match suspension, with the South African pair ruled out of a must win second group match against Czechia and Montes missing Mexico’s game against South Korea.

The pattern continued into other group matches, with VAR reviews becoming a near constant feature of broadcast coverage as officials worked through the expanded protocol for the first time on this stage. ESPN’s own match by match VAR review coverage noted incidents ranging from disputed penalty calls between France and Senegal to mistaken identity card reversals in the United States opener against Paraguay, where a yellow card initially shown to the wrong player had to be corrected on review.

![Aerial view of Levi''s Stadium in Santa Clara California during the World Cup 2026 group stage](/images/2026/06/Levis_Stadium_from_air.jpg)

## Why This Matters for the Rest of the Tournament

Every additional power given to VAR creates another category of decision that can be second guessed, and FIFA’s gamble in expanding the system right before the largest World Cup ever staged means referees are operating under more scrutiny than at any previous tournament. With 104 matches across three host countries and dozens of different broadcast angles available to fans in real time, incidents like the Switzerland offside call or the Evans gesture controversy are likely to keep surfacing as the competition moves into the knockout rounds, where a single contested decision carries even more weight.

## Watch Every Match and Every Replay Yourself

If you want to judge these calls for yourself rather than relying on secondhand clips, the best way is to watch matches live through an official broadcaster in your country, which typically offers full match replays and VAR review breakdowns that short social clips leave out.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

If your usual broadcaster is geo restricted while you travel for the tournament, a reliable VPN can help you access your home country’s coverage from anywhere in the United States, Canada or Mexico. [Check current NordVPN plans](https://nordvpn.com) before your next match day.

## Frequently Asked Questions

### What new powers does VAR have at the 2026 World Cup?

FIFA expanded VAR’s authority to include reviewing incorrectly awarded second yellow cards and corner kick decisions, in addition to its existing role covering goals, penalties, straight red cards and mistaken identity. These changes were approved by the International Football Association Board ahead of the tournament.

### What happened with the Switzerland vs Qatar offside call?

Switzerland was awarded a penalty for a foul on Remo Freuler, but replay angles suggested Freuler may have been offside before the ball reached him. That part of the sequence did not receive the same VAR scrutiny as the penalty itself, leading to criticism that the review was inconsistent given FIFA’s semi automated offside technology.

### Did FIFA punish the referee accused of the hate symbol gesture?

No. FIFA’s independent Disciplinary Committee investigated Australian official Shaun Evans after he appeared to make the gesture during Germany’s match against Curacao and found no evidence of a breach of the FIFA Disciplinary Code. Evans stated he had no intention of communicating any message through the gesture.

### Why were three red cards shown in the tournament’s opening match?

South Africa’s Sphephelo Sithole and Themba Zwane and Mexico’s Cesar Montes were all sent off during the Mexico vs South Africa opener. Sithole received a straight red for denying a clear goalscoring opportunity, Zwane’s yellow card was upgraded to red after a VAR review for violent conduct, and Montes also received a red card before the final whistle.

### How long is a World Cup red card suspension?

A red card results in an automatic one match suspension under FIFA’s rules. FIFA retains the right to impose additional sanctions if it judges the offense severe enough, and suspensions carry over between group stage and knockout matches, including the possibility of missing a final if the card comes in the semifinal.

### Is VAR actually making World Cup officiating more accurate?

FIFA has previously cited internal testing showing referee accuracy rising from around 93 percent to 99 percent with VAR support. Critics counter that expanding VAR’s scope, as happened for 2026, introduces new categories of subjective decisions that can themselves be disputed, which is part of why incidents like the Switzerland offside call still generate controversy even with VAR involved.

### Where can I find official explanations of disputed VAR decisions?

FIFA and major broadcasters typically publish post match VAR explainers breaking down exactly what was reviewed and why a decision was made or overturned. These are more reliable than short social media clips, which often leave out the full review process and the referee’s reasoning.',
   '/images/2026/06/Entering_Levis_Stadium.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'FIFA World Cup 2026 Referee and VAR Controversies Explained - Of The Pitch',
   'VAR got more power at World Cup 2026 and controversy followed fast. Here is what happened with the Switzerland offside call, a referee hate symbol accusation, and red card chaos.',
   '[]'::jsonb, '2026-06-26T18:45:15Z', '2026-06-26T18:45:16Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-ticket-price-controversy
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('6d4129f4-e880-58b7-a71b-528725d17f57', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-ticket-price-controversy',
   'FIFA World Cup 2026 Ticket Price Controversy: What Actually Happened',
   'FIFA World Cup 2026 ticket prices sparked a government investigation. Here is what actually happened with the pricing, the lawsuits, and the $60 supporter tier.',
   'FIFA World Cup 2026 tickets became the most expensive in the tournament’s history, with the cheapest final ticket reaching above five thousand dollars and some resale listings hitting more than two million dollars for a single seat. New York and New Jersey attorneys general have subpoenaed FIFA over its ticketing practices, and a $60 “Supporter Entry Tier” was added in response to the backlash, though it covers only a small fraction of total seats.

This is not a minor pricing complaint. It is a formal government investigation into how FIFA built and sold its ticket inventory for the biggest sporting event on the planet, and it is still unfolding as the tournament plays out across the United States, Canada and Mexico.

## How Expensive Did Tickets Actually Get

When the United States, Canada and Mexico submitted their joint bid to host this tournament, organizers told FIFA that a final ticket would cost no more than 1,550 dollars. That promise did not survive contact with FIFA’s new dynamic pricing model. By April 2026 the cheapest standard final ticket had climbed to 5,785 dollars. The most expensive standard seats reached 10,990 dollars before that figure roughly tripled on FIFA’s own resale platform.

Group stage tickets were not cheap either. Prices for the first round of games ranged from 120 to 265 dollars, a level that shocked fans used to World Cup group games costing closer to 50 or 100 dollars at past tournaments. The German Football Association published price sheets showing group stage tickets running from 180 to 700 dollars depending on the matchup, and the England Supporters Travel Club calculated that following the Three Lions from the group stage through to a hypothetical final would cost a fan just over 7,000 dollars in tickets alone, before flights, hotels or anything else.

FIFA also introduced a brand new “Front Category” tier in April, offering front row seats at every stadium for a price well above the existing top tier. A front row seat in the lower bowl for the final has been listed above 30,000 dollars. None of this includes resale prices, where four tickets for the final were spotted listed at close to 2.3 million dollars each before FIFA president Gianni Infantino dismissed the figure publicly and joked that he would personally deliver a hot dog to anyone who actually paid it.

## Why Prices Jumped So Much From Past World Cups

The core change is dynamic pricing, a system borrowed from airlines and concert ticketing where the price of a seat moves up or down based on real time demand rather than staying fixed once it is announced. FIFA had never used this model for a men’s World Cup before 2026. At the 2022 tournament in Qatar, the most expensive tickets topped out around 1,600 dollars. The jump to a starting price of 6,730 dollars for the most expensive 2026 final tickets, before any resale markup, represents roughly a four times increase in just four years.

Research cited by academics covering the controversy found that World Cup ticket prices, adjusted for inflation, had stayed broadly stable for three decades before this tournament. England’s semifinal and final allocations reportedly did not sell out at the prices FIFA set, even though every fan who applied through the official England Supporters Travel Club received a seat. The cheapest final ticket through that channel still cost 3,613 euros, compared with 96 euros for an equivalent seat at Euro 2024 in Berlin two years earlier.

FIFA has defended the pricing by pointing to demand. The federation received more than 20 million ticket requests during a single phase of its random selection draw, and Infantino has argued repeatedly that the market simply reflects what people are willing to pay for the first 48 team World Cup in history. He has also said that revenue generated through ticketing flows back into football development in countries that otherwise could not sustain the sport, framing the high prices as part of a redistribution model rather than pure profit taking.

## The Government Investigation Into FIFA’s Ticketing Practices

The backlash moved from social media complaints to a formal legal matter on May 27, 2026, when New York Attorney General Letitia James and New Jersey Attorney General Jennifer Davenport jointly announced they had subpoenaed FIFA. The subpoena specifically targets ticketing practices for the eight World Cup matches at MetLife Stadium in East Rutherford, New Jersey, including the July 19 final.

The two attorneys general say their investigation follows press reports that fans were misled about the location of seats they purchased after FIFA adjusted its stadium zone maps following the initial sales. Fans who bought tickets for one seating zone found themselves reassigned to less desirable seats, including locations far from the field or directly behind the goals, without the kind of clear notice consumers expect when paying thousands of dollars for a single match.

Davenport did not soften her language when announcing the probe. She accused FIFA of turning ticket buying into what she called a gauntlet of confusion, fake scarcity and impossibly high prices, adding that hosting the World Cup is not an invitation to exploit residents and visitors. James focused on the seat reassignment issue specifically, saying fans deserve to trust that the tickets they purchase are the ones they actually receive. The investigation is examining whether FIFA’s release schedule, public statements and other conduct contributed to the price increases, which according to the attorneys general averaged 34 percent across the three main ticket categories between October and April alone.

Separately, Football Supporters Europe and the consumer group Euroconsumers filed a formal complaint accusing FIFA of abusing a monopoly position to set ticket prices, arguing that the limited batch of discounted tickets released in December sold out before the general public ever had a real chance at them.

## What FIFA Changed in Response

FIFA’s main concession has been the Supporter Entry Tier, a 60 dollar ticket option introduced for every one of the 104 matches, including the final. The tier is allocated to national football associations rather than sold directly by FIFA, and each association is expected to distribute its share to fans with a demonstrated long term connection to the national team. In practice this tier represents roughly 10 percent of each association’s overall allocation, which works out to a few hundred seats per match in stadiums that hold up to 80,000 people. Some reporting has put the Supporter Entry Tier at closer to 1.6 percent of total tickets across the tournament once every category is counted, which explains why so many fans who wanted a cheap seat still could not find one.

![Stadium entrance gate at MetLife Stadium where World Cup ticket holders enter](/images/2026/06/Verizon_Gate_at_MetLife_Stadium.jpg)

New York City stepped in separately from FIFA’s own response. Mayor Zohran Mamdani announced a city level initiative offering 50 dollar tickets to city residents, a direct attempt to give locals a path into matches at MetLife Stadium that did not depend on FIFA’s pricing structure at all.

Infantino has stood by the overall pricing strategy in public appearances, including at the Milken Institute Global Conference and the World Sports Summit in Dubai, while acknowledging the criticism as feedback he takes seriously. He has repeatedly drawn a line between the headline grabbing resale prices, which FIFA does not directly control once a ticket changes hands, and the face value prices FIFA itself sets, arguing that the vast majority of seats at any given match are priced far below the figures that generate outrage online.

## Plan Your Trip With Less Financial Risk

If you already have tickets or are still trying to secure them, the financial exposure of a World Cup trip goes well beyond the ticket price itself. Flights, hotels and the possibility of a cancelled or rescheduled match all carry real cost, and travel insurance is one of the few tools that protects you if something goes wrong between now and matchday.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

World Nomads offers travel insurance plans built for international trips like this one, covering trip interruption, medical emergencies abroad and lost luggage. Given how much uncertainty has already surrounded this tournament’s logistics, it is worth checking a policy before you commit thousands of dollars to flights and hotels. [Compare World Nomads travel insurance plans](https://www.worldnomads.com) before you finalize your World Cup trip.

## Frequently Asked Questions

### Why are FIFA World Cup 2026 tickets so expensive?

FIFA introduced dynamic pricing for the first time at a men’s World Cup, allowing prices to rise with demand rather than staying fixed. Combined with record breaking demand for the first 48 team tournament, this pushed prices for the most expensive seats to roughly four times what they were at the 2022 World Cup in Qatar.

### Is FIFA actually under investigation over ticket prices?

Yes. The attorneys general of New York and New Jersey subpoenaed FIFA on May 27, 2026, specifically over ticketing practices for matches at MetLife Stadium, including the final. The investigation covers both pricing and complaints that fans were reassigned to worse seats than the ones they paid for.

### What is the Supporter Entry Tier and how do I get one?

It is a 60 dollar ticket tier FIFA introduced after the initial backlash, available for every match including the final. These tickets are distributed through national football associations to fans with a strong connection to that team, not sold directly through FIFA’s general ticketing platform, so you typically need to apply through your own country’s federation or supporters club.

### Did the final really almost cost two million dollars for one ticket?

Resale listings for four final tickets reached close to 2.3 million dollars each, a figure that generated global headlines and a public joke from FIFA president Gianni Infantino. The official face value prices set by FIFA are far lower, with cheapest standard final seats around 5,785 dollars, though that is still roughly four times the 2022 World Cup’s top price.

### Can I still find affordable tickets this close to the tournament?

It is harder than it would have been months ago, but the Supporter Entry Tier and any remaining national association allocations are worth checking first. Local initiatives, such as New York City’s 50 dollar resident ticket program for MetLife Stadium matches, may also offer a path in if you qualify and act quickly.

### Why did fans get reassigned to different seats than the ones they bought?

According to the New York and New Jersey attorneys general, FIFA adjusted its stadium zone maps after some fans had already purchased tickets for specific zones, resulting in those fans being placed in less desirable seats, including locations far from the field or behind the goals, without clear advance notice.

### Has FIFA admitted any wrongdoing?

No. FIFA and Infantino have defended the pricing as a response to unprecedented demand and have stated that ticket revenue supports football development globally. The investigation by the New York and New Jersey attorneys general is ongoing, and no findings of wrongdoing have been announced as of this writing.',
   '/images/2026/06/MetLife_Stadium_Exterior.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'FIFA World Cup 2026 Ticket Price Controversy: What Actually Happened - Of The Pitch',
   'FIFA World Cup 2026 ticket prices sparked a government investigation. Here is what actually happened with the pricing, the lawsuits, and the $60 supporter tier.',
   '[]'::jsonb, '2026-06-26T18:44:39Z', '2026-06-26T18:44:41Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-weakest-squads-brutal-truth
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('1d150648-1f6d-550d-b76f-7c96f9020dd7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-weakest-squads-brutal-truth',
   'World Cup 2026 Weakest Squads: The Brutal Truth About Who Was Already Eliminated Before a Ball Was Kicked',
   'World Cup 2026 weakest squads. Curacao, Haiti, Jordan, and Uzbekistan face near-impossible groups. The brutal honest truth about which teams were eliminated before a ball was kicked.',
   'The 2026 World Cup has 48 teams. The previous two editions had 32. The extra 16 spots had to come from somewhere, and some of them came from nations that, on paper, have essentially no chance of advancing past the group stage. This is not an insult. It is an honest assessment of what happens when a tournament expands by 50 percent. Not every new qualifier is a Curacao or a Jordan. Some of them are genuinely competitive sides who earned their place. But some are not, and the gap between those teams and the elite is the widest it has ever been at a World Cup.

What follows is an honest look at the teams most likely to finish last in their groups and go home after three games, based on their squad quality, group draw difficulty, and pre-tournament form.

## Curacao: History Made, Reality Awaited

Curacao are the smallest nation in World Cup history by population. Qualifying for this tournament is genuinely one of the great football stories of the 2026 cycle. They have an island population of roughly 160,000 people and they earned a spot at the biggest sporting event on earth. The group they drew, however, is Group E with Germany, Ecuador, and Ivory Coast. Germany are a four-time World Cup winner. Ecuador finished second in CONMEBOL qualifying. Ivory Coast won the Africa Cup of Nations in 2023. Curacao have a 9 percent chance of advancing according to statistical models, the lowest of any team in the tournament. That does not make their story less worth telling. It just means the story ends after three games.

## Haiti: First World Cup Since 1974, Hardest Group Available

Haiti have not been at a World Cup since 1974. Making it back after 52 years is remarkable. They have a squad of players based largely in lower European leagues and North American football. Their group is Brazil, Morocco, and Scotland. Brazil and Morocco are both top-fifteen sides. Scotland reached their first World Cup in 24 years. Haiti’s realistic hope is maximum three points from three games, most likely from the Scotland fixture. Whether they get even that is uncertain. Finishing bottom of Group C with zero points would not be a failure. Just being there, after 52 years, is the story.

## Jordan: Carrying a Historic First Appearance into Group J

Jordan qualified through the Asian play-off route and are in Group J with Argentina, Algeria, and Austria. Argentina are the defending champions. Jordan have never been to a World Cup before. The group is the toughest draw they could have received. A first-ever World Cup appearance in the same group as Messi and a team ranked in the world’s top ten is the full weight of the moment. A point from the Austria game is the realistic target. Zero points and three defeats would not be surprising.

## Uzbekistan: Asia’s Qualifier in Group K

Uzbekistan are in Group K with Portugal, DR Congo, and Colombia. Portugal are ranked fifth in the world and have Ronaldo, Fernandes, and Vitinha. Colombia finished top of CONMEBOL qualifying. Uzbekistan qualified through the AFC pathway and have a squad built largely on players from the Uzbek league and a handful of players in lower European leagues. Progressing from this group requires winning two games against far superior opposition. Most models give Uzbekistan around a 15 to 20 percent chance of advancing.

## New Zealand: Playing Their First World Cup Since 2010

New Zealand are in Group G with Belgium, Egypt, and Iran. Belgium are a top-ten side. Egypt have Mohamed Salah. New Zealand’s squad is built on players from the A-League and a handful of players in lower European leagues. The All Whites qualified through the OFC playoff route and the intercontinental playoff. Getting a point from Iran is possible. Advancing from the group requires something extraordinary.

## The Brutally Honest Assessment

The expansion to 48 teams means the average quality gap between the top and bottom of the field is wider than at any previous World Cup. Haiti vs Brazil, Curacao vs Germany, and Jordan vs Argentina are not competitive fixtures in the way that previous World Cups’ smaller mismatches were. They are genuinely one-sided games where the outcome is predictable before a ball is kicked.

That said, this is football. Minnows have beaten giants before. CONCACAF and CONMEBOL qualifying produces upsets constantly. The round of 32 format means even a third-place finish in a group can advance a team. Some of these sides will surprise. The point is simply that going in, the evidence says they will not. Being honest about that is not dismissing them. It is reading the data correctly.

## Travel Insurance for Fans of Any Team

Whether you are following Haiti to Miami, Jordan to Kansas City, or Curacao to Houston, World Nomads travel insurance covers medical emergencies, trip cancellations, and gear across the US, Canada, and Mexico.

![Argentina vs France 2018 World Cup action](/images/2026/06/Argentina_vs_France_2018_World_Cup_08-7.jpg)

[Get travel insurance from World Nomads before you fly.](https://www.worldnomads.com)

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

## Frequently Asked Questions

### Who are the weakest teams at the 2026 World Cup?

Based on squad quality and group draw difficulty, Curacao, Haiti, Jordan, Uzbekistan, and New Zealand face the most difficult paths. Curacao have the lowest statistical probability of advancing at around 9 percent according to pre-tournament models.

### Why is Curacao considered the weakest team at the 2026 World Cup?

Curacao have a population of 160,000 and drew Group E with Germany, Ecuador, and Ivory Coast. The combination of a tiny talent pool and three strong opponents gives them a 9 percent chance of advancing, the lowest of any team in the tournament.

### When did Haiti last play at a World Cup?

Haiti last appeared at the World Cup in 1974 in West Germany. Their 2026 qualification ends a 52-year absence. They play in Group C with Brazil, Morocco, and Scotland.

### How does the expanded 48-team format affect the quality gap?

The extra 16 spots have included nations that would not have qualified under the previous 32-team format. This widens the quality gap between the top and bottom of the field. Some group games in 2026 are significantly more one-sided than typical World Cup fixtures have been historically.

### Can any of the weakest teams win a World Cup game?

Yes. Football is unpredictable and upsets happen at every tournament. Haiti beating Scotland, New Zealand beating Iran, or Jordan taking a point from Austria are all realistic outcomes. The point is that on the balance of evidence, they are unlikely rather than impossible.

### What is the new round of 32 format and does it help weaker teams?

The 2026 format includes a new Round of 32, where the top two from each group plus the eight best third-placed teams advance. This means finishing third can still be enough to qualify. It gives weaker teams more margin for error than the previous format, where only two teams advanced from each group of four.',
   '/images/2026/06/France_champion_of_the_Football_World_Cup_Russia_2018-6.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'World Cup 2026 Weakest Squads: The Brutal Truth About Who Was Already Eliminated Before a Ball Was Kicked - Of The Pitch',
   'World Cup 2026 weakest squads. Curacao, Haiti, Jordan, and Uzbekistan face near-impossible groups. The brutal honest truth about which teams were eliminated before a ball was kicked.',
   '[]'::jsonb, '2026-06-26T18:44:18Z', '2026-06-26T18:44:19Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-most-overrated-teams
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('3f5dff7c-7830-5b43-bbea-b6f47df7a204', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-most-overrated-teams',
   'World Cup 2026 Most Overrated Teams: Who the Media Is Talking Up Too Much',
   'World Cup 2026 most overrated teams. Brazil, Belgium, and Uruguay get more credit than their squads deserve. An honest pre-tournament assessment of who the media is talking up too much.',
   'Every World Cup has them. The teams that get talked up relentlessly in the build-up, whose odds tighten based on reputation rather than current form, and who then go home before the quarterfinals while the analysts explain why it was complicated. In 2026 there are several candidates. Being overrated is not the same as being bad. It means the expectation placed on a team exceeds what an honest assessment of their squad, form, and tournament path actually suggests. Here are the four teams that get talked about as genuine contenders but probably are not.

## Brazil: The Weight of 220 Million Expectations

Brazil are listed at around +800 to win the tournament at most bookmakers. They have not won a World Cup since 2002. Their manager Carlo Ancelotti has never managed a national team before. Their best player, Vinicius Jr, has scored eight goals in 43 Brazil appearances while averaging 16 per season in La Liga. Neymar is 34 and has barely played in three years. Casemiro is 34 and had a poor season at Manchester United.

None of this means Brazil cannot reach the quarterfinal. It means that the combination of a first-time international manager, a star player who does not perform at international level the way he performs at club level, an ageing midfield anchor, and a striker carried entirely by hope rather than evidence, is not a recipe for winning seven games in five weeks. Brazil are talked about as a title contender because they are Brazil. The squad they have in 2026 is not a title-contending squad.

## Belgium: The End of a Golden Generation That Never Won Anything

Belgium were ranked number one in the world for most of a decade. They had Kevin De Bruyne, Eden Hazard, Romelu Lukaku, Thibaut Courtois, and Jan Vertonghen all in their primes at the same time. They reached the World Cup semifinal in 2018. They went out in the round of 16 in 2022. They have never won a major tournament. De Bruyne is 35. Lukaku is 32. Hazard retired. The squad in 2026 has experience but not the depth or creative quality of the generation that peaked between 2018 and 2021. They are in Group G with Egypt, Iran, and New Zealand. Getting out of that group is the most they should realistically be expected to achieve.

## Uruguay: Dangerous but Not a Title Contender

Uruguay are ranked in the top 15 and have real quality in attacking areas with Darwin Nunez, Rodrigo Bentancur, and Federico Valverde. They are a hard team to beat and Marcelo Bielsa’s organisation makes them competitive against better sides. But they are in Group H with Spain, Saudi Arabia, and Cape Verde, which means their path out of the group is complicated. Getting past Spain to top the group, then navigating a likely round-of-16 match against a side from Group G, leaves them needing to beat multiple top-ten sides to reach the final. That is asking more than their squad genuinely warrants.

## Italy: The Nation Not at This Tournament

Italy are not at the 2026 World Cup. They failed to qualify through UEFA, making it their third absence from the tournament in the last four editions after missing 2018 and coming back for 2022 then missing 2026. The fact that Italy is absent from a 48-team tournament should alone register as a significant structural failure. The Azzurri are talked about constantly in football media, generate enormous engagement online, and are entirely irrelevant to what happens in North America this summer. Their absence is a story worth telling but they are not overrated at this tournament because they are not at it.

## The Pattern Worth Noting

What connects Brazil, Belgium, and Uruguay in 2026 is a version of the same problem: squads built around players who were genuinely world-class three to five years ago and whose best days are behind them. Sentiment, reputation, and previous tournament results drive the media coverage. The reality of what these squads can do against France, Spain, or Argentina in a knockout game in July is a different calculation.

The teams most likely to overperform relative to expectations are Japan, Morocco, and possibly Germany. The teams most likely to underperform relative to the hype are Brazil and Belgium. That is not a guaranteed outcome. It is what the evidence suggests before a ball has been kicked.

## Travel Insurance for Fans Following Any of These Teams

If you are travelling to follow Brazil in Miami or Belgium in New York, World Nomads travel insurance covers medical emergencies, trip cancellations, and gear across the US, Canada, and Mexico.

![Germany World Cup 2014 trophy celebration](/images/2026/06/Germany_lifts_the_2014_FIFA_World_Cup-7.jpg)

[Get travel insurance from World Nomads before you fly.](https://www.worldnomads.com)

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

## Frequently Asked Questions

### Which teams are overrated at the 2026 World Cup?

Brazil, Belgium, and Uruguay are all talked about as serious contenders but have legitimate weaknesses that the pre-tournament coverage underweights. Brazil have a first-time international manager, a star forward who underperforms for the national team, and ageing key players. Belgium are at the end of a golden generation that never won anything. Uruguay face a difficult group path.

### Why is Brazil considered overrated in 2026?

Brazil have not won the World Cup since 2002. Their best player Vinicius Jr scores eight goals in 43 national team appearances despite averaging 16 per season for Real Madrid. Their manager Carlo Ancelotti has never coached an international team before. Neymar is 34 and largely injury-prone. The combination of these factors makes +800 odds shorter than an honest assessment suggests.

### Has Belgium ever won the World Cup?

No. Despite being ranked number one in the world for years and having one of the most talented generations of players the country has ever produced, Belgium have never won a World Cup or European Championship. Their best result was third place at the 2018 World Cup in Russia.

### Are there any genuinely underrated teams at the 2026 World Cup?

Yes. Japan, Morocco, and Germany are all capable of going deeper than their pre-tournament coverage suggests. Japan beat Germany and Spain at the 2022 World Cup. Morocco reached the 2022 semifinal. Germany have a young, technically excellent squad that may peak at exactly the right time.

### Did Italy qualify for the 2026 World Cup?

No. Italy failed to qualify for the 2026 World Cup, their third absence from the tournament in four editions after also missing 2018. Despite qualifying for 2022, they failed again through UEFA qualification. Their absence from a 48-team tournament is a significant failure of Italian football.

### Which team has the best odds to win the 2026 World Cup?

France are the outright favourites at most bookmakers, typically listed at around +350. Argentina are second at around +500 or +600. Spain and Portugal are third and fourth. Germany and England are typically fifth and sixth in the market.',
   '/images/2026/06/France_champion_of_the_Football_World_Cup_Russia_2018-5.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'World Cup 2026 Most Overrated Teams: Who the Media Is Talking Up Too Much - Of The Pitch',
   'World Cup 2026 most overrated teams. Brazil, Belgium, and Uruguay get more credit than their squads deserve. An honest pre-tournament assessment of who the media is talking up too much.',
   '[]'::jsonb, '2026-06-26T18:43:42Z', '2026-06-26T18:43:44Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-most-underrated-teams
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('e1166407-9566-550f-b957-3ddafed1111f', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-most-underrated-teams',
   'World Cup 2026 Most Underrated Teams: The Nations Nobody Is Talking About Who Could Go Deep',
   'World Cup 2026 most underrated teams. Japan, Germany, and Colombia are all capable of going deep but barely get mentioned as title threats. The case for each dark horse.',
   'Every World Cup has a team that nobody is talking about seriously in the build-up that ends up reaching the quarterfinal or beyond. In 2022 it was Morocco. In 2018 it was Croatia. In 2014 it was Costa Rica. The pattern is consistent: one team, usually from outside the traditional European and South American elite, executes a tactical system with collective discipline, gets a favourable draw in one or two rounds, and keeps eliminating sides that were supposed to be significantly better. In 2026 there are at least three teams with the characteristics that have produced these runs before.

## Japan: The Most Dangerous Non-Favourite in the Tournament

Japan beat Germany and Spain in the 2022 group stage. Both were upsets of historic proportions at the time. Neither was a fluke. They were the product of Hajime Moriyasu’s capacity to analyse opponents, identify structural weaknesses, and execute a half-time tactical shift with a precision that international teams very rarely manage. Japan are ranked 18th and listed at around +5000 to win the tournament. Their group contains the Netherlands, Sweden, and Tunisia. If they beat the Netherlands in the opener on June 14 in Dallas, and they can do it, the entire tournament is reoriented around them.

The squad has Takefusa Kubo, Wataru Endo, Daichi Kamada, and Ayase Ueda all operating at the top level of European football. They are technically accomplished, collectively organised, and have the tournament experience that most teams in the bracket lack. They are not dark horses in the way they were in 2022. They are known. But they are still being listed at odds that imply they have almost no chance. That is wrong.

## Germany: The Country That Is Angry and Has the Players to Match

Germany went out in the group stage in 2018 and 2022. Two consecutive early exits for a four-time World Cup winner creates something that matters in tournament football: genuine collective motivation to prove that those failures were anomalies rather than the new normal. Julian Nagelsmann has a squad with Florian Wirtz, Jamal Musiala, Joshua Kimmich, and Manuel Neuer at 40 choosing to come back. Group E against Curacao, Ivory Coast, and Ecuador is extremely favourable.

Germany at +1000 odds feels undervalued for a team with that attacking midfield combination and that group draw. They will not win the tournament outright from those odds but a deep run to the semifinal or final would not be a surprise if Wirtz and Musiala both perform. This is the first tournament where those two play at the same time at the peak of their powers.

## Colombia: The Team Nobody Is Watching

Colombia finished top of CONMEBOL qualifying, above Brazil and Argentina. Luis Diaz at Liverpool, James Rodriguez at Rayo Vallecano, and Richard Rios provide genuine quality across the team. They are in Group K with Portugal, DR Congo, and Uzbekistan. Getting out of the group behind Portugal is realistic. Once in the knockout rounds, Colombia have beaten bigger sides before.

The media coverage of this World Cup is dominated by the European giants and the traditional South American powers. Colombia get a fraction of the attention their qualifying record and squad depth deserve. That indifference is actually an advantage in tournament football. No opponent is going to prepare for Colombia the way they prepare for Argentina or France.

## What to Look For in the First Round

The sign that one of these teams is having a genuine tournament run is usually visible in their first group game. Japan beating the Netherlands, Germany winning in Houston by three or more, or Colombia beating one of the stronger Group K sides comfortably would all signal that the tournament has an upset threat forming. Watch those early results carefully. They tell you more than the pre-tournament odds do.

The honest prediction is that at least one of Japan, Germany, or Colombia reaches the quarterfinal from this list, and one of them reaches the semifinal. Which one depends on the bracket and on form across the group stage. But somebody on this list is going to make the World Cup interesting in July, and it is going to come as a shock to people who did not read this article in June.

## Travel Insurance for Fans of the Underrated Teams

Japan fans travelling to Dallas, Germany fans travelling to Houston, and Colombia fans following their team through the knockout rounds will all need comprehensive North American coverage. World Nomads travel insurance covers medical emergencies, trip cancellations, and gear across the US, Canada, and Mexico.

![Germany players celebrate 2014 FIFA World Cup win](/images/2026/06/Germany_players_celebrate_winning_the_2014_FIFA_World_Cup-4.jpg)

[Get travel insurance from World Nomads before you fly.](https://www.worldnomads.com)

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

## Frequently Asked Questions

### Which team is the biggest dark horse at the 2026 World Cup?

Japan are the strongest case. They beat Germany and Spain at the 2022 World Cup from behind in both games, demonstrating a tactical sophistication that most international teams cannot replicate. They open against the Netherlands in Dallas on June 14 and a win there would signal that the tournament has a genuine surprise in progress.

### Why is Germany considered underrated at the 2026 World Cup?

Two consecutive group stage exits have suppressed expectations. But Florian Wirtz and Jamal Musiala are now 21 and 22, at the age where elite players peak in tournaments. Group E is very favourable. Germany at +1000 odds is more attractive than the pre-tournament narrative suggests.

### Can Colombia surprise at the 2026 World Cup?

Yes. They finished top of CONMEBOL qualifying above Brazil and Argentina. Luis Diaz, James Rodriguez, and Richard Rios provide world-class quality. They are in Group K with Portugal and should advance to the knockout rounds. From there, their ceiling is genuinely unclear.

### Which team surprised everyone at the 2022 World Cup?

Morocco. They became the first African and Arab nation to reach the World Cup semifinal, beating Belgium, Spain, and Portugal along the way. They arrived ranked 22nd in the world. Their run is the model for what underrated teams can achieve when tactical organisation, collective spirit, and a favourable draw align.

### What makes a team a genuine dark horse at a World Cup?

The combination of tactical sophistication above their ranking, a group draw that is navigable, at least two or three individually world-class players, and a coaching setup that has demonstrated the capacity to beat elite opponents. All three teams on this list have all four characteristics.

### Are there any African dark horses at the 2026 World Cup?

Morocco are the strongest African contender but they are no longer an underdog. Senegal have Sadio Mane and a disciplined defensive structure. DR Congo qualified through the playoff and will face Portugal in Group K, which means a potential upset is not impossible if their squad arrives in form.',
   '/images/2026/06/Argentina_vs_France_2018_World_Cup_08-6.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'World Cup 2026 Most Underrated Teams: The Nations Nobody Is Talking About Who Could Go Deep - Of The Pitch',
   'World Cup 2026 most underrated teams. Japan, Germany, and Colombia are all capable of going deep but barely get mentioned as title threats. The case for each dark horse.',
   '[]'::jsonb, '2026-06-26T18:43:21Z', '2026-06-26T18:43:22Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] nigeria-world-cup-2026-super-eagles-failed-to-qualify
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('daf0d6b6-7b06-54bc-b6a9-e25c28f1b40c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'nigeria-world-cup-2026-super-eagles-failed-to-qualify',
   'Nigeria World Cup 2026: The Super Eagles and the Talent That Never Quite Delivers',
   'Nigeria World Cup 2026 review. Why the Super Eagles failed to qualify despite having Osimhen, Lookman, and more elite European talent than most teams that did. An honest post-mortem.',
   'Nigeria did not qualify for the 2026 World Cup. The Super Eagles lost to DR Congo 4-3 on penalties in the African playoff final following a 1-1 draw over 120 minutes. It is their second consecutive absence from the tournament after also failing to qualify for Qatar 2022. They have Victor Osimhen, one of the most prolific strikers in European football. They have Ademola Lookman, the reigning African Footballer of the Year. They have more elite European talent than any other African nation that did qualify. And they are not going. That says something honest about the structural problems in Nigerian football that individual talent has never managed to overcome.

The qualification failure came in the CAF playoff final in Morocco, where Nigeria needed only a draw to advance after levelling in extra time, and then lost on penalties. The Nigerian Football Federation subsequently filed a protest alleging passport irregularities involving some DR Congo players. FIFA dismissed the petition in March 2026. DR Congo are at the World Cup. Nigeria are not.

## The Talent That Should Have Been There

The squad that came agonisingly close to qualifying included Victor Osimhen, who scored 24 Serie A goals at Napoli this season before moving to Galatasaray, where he continued in similar form. He is 25 years old and at the peak of his powers. Missing a World Cup at 25 with his goal-scoring record is one of the most absurd underachievements in African football this decade.

Ademola Lookman won the 2024 African Footballer of the Year award. He scored 30 goals in all competitions for Atalanta and was one of the best wide forwards in Serie A. He is 27. He has never played at a World Cup. Neither has the Atalanta teammate or the generation of Nigerians who came of age while the federation managed to miss consecutive tournaments.

Samuel Chukwueze at AC Milan, Victor Boniface at Bayer Leverkusen, Alex Iwobi at Fulham, and Wilfred Ndidi at Leicester City are players who operate regularly in the top six European leagues. The depth of Nigerian talent playing at the highest club levels in Europe is extraordinary. It does not translate into results because the Nigerian Football Federation and the national team coaching setup have failed to convert individual quality into collective consistency.

## The History of Underperformance

Nigeria has qualified for the World Cup six times: 1994, 1998, 2002, 2010, 2014, and 2018. They reached the round of 16 in 1994 and 1998. Since then, they have never progressed past the group stage. They missed 2006, 2022, and now 2026. Three absences in six tournaments, despite consistently producing more elite European talent than almost any African nation outside Morocco.

The pattern is familiar to anyone who watches African football. Qualification campaigns stall because of administrative dysfunction, coaching changes at the wrong moments, player disputes over bonuses and conditions, and the difficulty of organising a squad of players based across different European leagues and timezones. Nigeria has all of these problems at once and has had them since at least 2006.

## The DR Congo Loss

The playoff final loss was particularly bitter. Nigeria had the better squad on paper. DR Congo are a talented side but their squad lacks the European depth Nigeria carry. Over two legs, the better team for roughly 80 percent of the aggregate time did not win. Penalty shootouts are random enough that this can happen. The question is why Nigeria were in a position where a shootout was needed against a side they should have beaten in 90 minutes.

Coach Eric Chelle, appointed in early 2025, had limited time to implement a system and was working with a squad whose qualifying campaign had been inconsistent long before his arrival. Whether a different coach at an earlier stage could have changed the outcome is genuinely uncertain. What is certain is that the outcome was unacceptable given the talent available.

## What This Means for Nigerian Football

Nigeria’s best players are now in their mid-to-late twenties. Osimhen is 25. Lookman is 27. Chukwueze is 25. Boniface is 24. The window for this generation to appear at a World Cup together is narrowing. The 2030 World Cup will be held in Spain, Portugal, Morocco, and potentially South America. Nigeria would need to qualify through the standard CAF process. If the structural issues in Nigerian football are not addressed before 2030 qualification begins, there is no reason to expect a different result.

The brutal truth about Nigeria is that this is not a talent problem. It has never been a talent problem. The talent has always been there. The problem is everything around the talent, and that has been true for twenty years.

![France 2018 World Cup champions Russia](/images/2026/06/France_champion_of_the_Football_World_Cup_Russia_2018-4.jpg)

## Travel Insurance for Nigerian Fans Watching at Home or Abroad

Nigerian fans watching the 2026 World Cup from abroad, whether following other African teams or simply attending as neutrals, will need comprehensive coverage across the US, Canada, and Mexico. World Nomads travel insurance covers medical emergencies, trip cancellations, and gear.

[Get travel insurance from World Nomads before you fly.](https://www.worldnomads.com)

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

## Frequently Asked Questions

### Did Nigeria qualify for the 2026 World Cup?

No. Nigeria failed to qualify after losing to DR Congo 4-3 on penalties in the CAF African playoff final. It is their second consecutive absence from the World Cup after also failing to qualify for Qatar 2022.

### Why did Nigeria fail to qualify for the 2026 World Cup?

Nigeria lost to DR Congo in the African playoff final on penalties. Their qualification campaign was inconsistent throughout, with coaching changes and administrative problems undermining a squad that had more elite European talent than most sides that did qualify.

### Is Victor Osimhen at the 2026 World Cup?

No. Despite scoring prolifically in Serie A and continuing his form at Galatasaray, Osimhen is not at the 2026 World Cup. Nigeria’s failure to qualify means their most dangerous striker misses the tournament at 25 years old, at the peak of his powers.

### Is Ademola Lookman at the 2026 World Cup?

No. Lookman, who won the 2024 African Footballer of the Year award and scored 30 goals for Atalanta, does not appear at the 2026 World Cup. He has never played at a World Cup despite being one of the best wide forwards in European football.

### Which African teams did qualify for the 2026 World Cup?

Africa received nine places at the 2026 World Cup. The qualified nations include Morocco, Senegal, Egypt, Ivory Coast, DR Congo, Ghana, Tunisia, Algeria, and South Africa. Nigeria, despite having arguably the most elite European-based squad of any African nation, did not qualify.

### When did Nigeria last qualify for the World Cup?

Nigeria last qualified for the 2018 World Cup in Russia. Before that they appeared in 2014, 2010, 2002, 1998, and 1994. They missed the 2006, 2022, and 2026 editions. The back-to-back absences from 2022 and 2026 represent their worst qualifying run since the 1990s.',
   '/images/2026/06/Germany_lifts_the_2014_FIFA_World_Cup-6.jpg', '4a8e3ae4-c7d5-5b72-8d26-db1660ca9d10', '{}', 'published',
   'Nigeria World Cup 2026: The Super Eagles and the Talent That Never Quite Delivers - Of The Pitch',
   'Nigeria World Cup 2026 review. Why the Super Eagles failed to qualify despite having Osimhen, Lookman, and more elite European talent than most teams that did. An honest post-mortem.',
   '[]'::jsonb, '2026-06-26T18:42:44Z', '2026-06-26T18:42:45Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] watch-france-vs-norway-world-cup-2026-free
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('55b6b7eb-7896-5ac1-8b88-6d98a7b97f8b', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'watch-france-vs-norway-world-cup-2026-free',
   'How to Watch France vs Norway World Cup 2026 Free Right Now',
   'Watch France vs Norway World Cup 2026 free today. Full guide by country: UK on ITV, Australia on SBS, USA free trials on YouTube TV and Fubo. VPN guide for Pakistan, India and global fans.',
   'France vs Norway is live today at 3pm ET (8pm UK, 7pm Pakistan) at Gillette Stadium in Foxborough, Boston. Both Kylian Mbappe and Erling Haaland are confirmed to start, and you can watch the France vs Norway FIFA World Cup 2026 match completely free depending on where you are in the world. No subscription required in several countries. This guide tells you exactly which option to use based on your situation.

This is Group I matchday 3. France and Norway are both already through to the Round of 32, but first place is still up for grabs, and so is the Golden Boot. Mbappe has four World Cup 2026 goals. Haaland has four. The winner of the group gets a better knockout bracket path. Every minute of this match matters.

## France vs Norway World Cup 2026: Quick Facts

Before you find your stream, here are the key details for the France vs Norway FIFA World Cup 2026 match:

Kickoff: 3pm ET / 8pm BST / 7pm GMT / midnight Pakistan Standard Time (technically June 27 for PST viewers)

Venue: Gillette Stadium, Foxborough, Massachusetts (the Boston World Cup venue)

Group: Group I, Matchday 3

What is at stake: Group I top spot. France win or draw keeps them first. Norway need a win to top the group.

## Completely Free: No Account, No Card, No VPN Needed

If you own a TV antenna and live in the United States, this is your easiest option. FOX is broadcasting France vs Norway in English and FOX is available over the air in every major US city. Plug in an antenna, scan for channels, and you get the France vs Norway World Cup 2026 stream at zero cost, forever. No trial period, no cancellation reminder, no credit card entered anywhere. This works in Dallas, Houston, Boston, Atlanta, Los Angeles, New York, Miami, and every other host city.

FOX One also offers a free 7-day trial if you want a digital option with no antenna. Sign up today, watch France vs Norway live, and cancel before day 7 if you do not want to keep it.

## Free Streams by Country: Where France vs Norway Is Available at No Cost

The France vs Norway FIFA World Cup 2026 match is free to stream in the following countries without any subscription:

**United Kingdom**: ITV1 (TV) and ITVX (free streaming app). You need a UK postcode for the ITVX account and a valid TV licence. Coverage of the France vs Norway match starts around 7pm BST. This is the cleanest free stream available globally for English-language viewers.

**Australia**: SBS On Demand has every single 2026 FIFA World Cup match free. France vs Norway is included. Download the SBS On Demand app, make a free account, and watch. No payment required at any stage.

**Brazil**: TV Globo and Globoplay are broadcasting France vs Norway free. Globoplay’s free tier covers World Cup matches without a subscription.

**Belgium**: RTBF (French language) and VRT (Dutch language) both carry France vs Norway free on their public broadcast platforms.

**Netherlands**: NPO Sport broadcasts the France vs Norway World Cup 2026 match free via npo.nl and the NPO app.

**Ireland**: RTE Two and the RTE Player app carry France vs Norway free for viewers in the Republic of Ireland.

**Switzerland**: SRF and RTS both carry the France vs Norway match free on their public platforms depending on which language region you are in.

**Turkey**: TRT Sport carries France vs Norway free on its broadcast platform and streaming app.

**Norway itself**: NRK, Norway’s public broadcaster, has rights to all Norway World Cup 2026 matches and is streaming France vs Norway for free. Obviously.

## Free Trials: Watch France vs Norway Today at No Cost in the US

If you are in the United States and do not have a TV antenna, these streaming services all carry France vs Norway via FOX and all offer free trials to new subscribers:

**YouTube TV**: Free 21-day trial. This is the longest free trial of any service carrying the France vs Norway FIFA World Cup 2026 match. Sign up today, watch France vs Norway, then use the remaining 20 days to watch the entire Round of 32 and quarterfinals before deciding whether to keep the subscription. YouTube TV carries FOX, FS1, Telemundo, and Universo, meaning you get every remaining World Cup 2026 match during your trial.

![Erling Haaland in Norway kit June 2025](/images/2026/06/Erling_Haaland_June_2025.jpg)

**Fubo**: Free 7-day trial. Fubo carries FOX and has been advertising France vs Norway specifically on its platform. New subscribers get full access immediately after signing up.

**DirecTV Stream**: Free 5-day trial. Includes FOX, FS1, and Telemundo. The Entertainment tier starts at $59.99 after trial.

**FOX One**: Free 7-day trial. This is FOX’s own streaming app, launched this year. $19.99 per month or $199.99 annually after the trial. Sign up, watch France vs Norway, cancel within 7 days if you do not want to continue.

You only need one of these. The YouTube TV 21-day trial is the best value if you want to watch multiple World Cup matches beyond today’s France vs Norway game.

## Spanish Language: Free Peacock via Walmart Plus

Telemundo and Universo carry France vs Norway in Spanish, and both stream on Peacock. An ad-supported Peacock subscription costs $11 per month, but Walmart Plus subscribers get Peacock included at no extra cost. If you or anyone in your household already has Walmart Plus, activate Peacock through your Walmart Plus account and watch France vs Norway in Spanish for free right now.

## Outside These Countries? How to Watch France vs Norway Free With a VPN

If you are in Pakistan, India, South Africa, the Middle East, Southeast Asia, or anywhere else not listed above, a VPN is the cleanest legal solution for watching France vs Norway free. Here is exactly how it works.

A VPN makes your internet connection appear to come from a different country. Connect to a UK server and you appear to be in the UK. ITV thinks you are a UK viewer and grants you access to the free France vs Norway FIFA World Cup 2026 stream on ITVX. Connect to an Australian server and SBS On Demand opens. The stream is the same quality. The match is live. The process takes about three minutes to set up.

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

We recommend [NordVPN](https://www.nordvpn.com) for watching France vs Norway and the rest of FIFA World Cup 2026. NordVPN has servers in the UK, Australia, Ireland, Netherlands, and every other country with a free World Cup stream. Connections are fast enough that HD streaming runs without buffering. There is a 30-day money-back guarantee, which means you can use it for every remaining World Cup 2026 match through the final on July 19 and get a full refund if you are not satisfied.

Step one: Sign up for NordVPN. Step two: Download the app on your phone, laptop, or smart TV. Step three: Connect to a UK or Australian server. Step four: Open ITVX or SBS On Demand and watch France vs Norway live.

## France vs Norway: What You Are Tuning In For

This is the most anticipated group stage match of FIFA World Cup 2026. France are the tournament favourites. Norway are the dark horses who have not been at a World Cup in 28 years. Kylian Mbappe has four goals in two matches and is two goals behind Lionel Messi’s World Cup scoring record. Erling Haaland also has four goals. They are tied for second in the Golden Boot race heading into France vs Norway at Gillette Stadium.

France are managed today by assistant coach Guy Stephan after Didier Deschamps left the camp to attend his mother’s funeral. Norway’s Erling Haaland reportedly started on the bench according to some reports before kickoff, though multiple projections had both strikers starting. Whoever plays and whoever scores, the France vs Norway World Cup 2026 clash is a match worth every effort to watch live.

## Frequently Asked Questions

### What channel is France vs Norway on in the United States?

France vs Norway is on FOX in English and Telemundo in Spanish. You can stream FOX via Fubo, YouTube TV, DirecTV Stream, Hulu with Live TV, or FOX One. All of these offer free trials for new subscribers.

### Can I watch France vs Norway World Cup 2026 for free without a subscription?

Yes. A TV antenna picks up FOX over the air completely free in the United States. In the UK, ITV1 and ITVX carry the match free. In Australia, SBS On Demand is free. In Brazil, TV Globo and Globoplay carry it free. In Ireland, RTE Player is free.

### What time is France vs Norway kickoff?

France vs Norway kicks off at 3pm Eastern Time on June 26, 2026. That is 8pm BST in the UK, 9pm in Central Europe, midnight in Pakistan, and 5am on June 27 in Australia’s eastern time zone.

### Is Erling Haaland playing in France vs Norway today?

Reports before kickoff suggested Haaland may start on the bench with Norway resting players, but most projected lineups had both Haaland and Mbappe starting. Check the live lineup announcements about an hour before kickoff on FIFA.com for confirmation.

### How do I watch France vs Norway from Pakistan or India?

The most reliable legal option for viewers in Pakistan, India, and most of South Asia is a VPN connected to a UK or Australian server, then watching on ITVX or SBS On Demand, both of which are free. NordVPN works for this and comes with a 30-day money-back guarantee.

### Where is France vs Norway being played?

France vs Norway is being played at Gillette Stadium in Foxborough, Massachusetts, which is the Boston area World Cup 2026 venue. The stadium holds over 65,000 fans. It is about 20 miles southwest of downtown Boston.

### Who is winning Group I at World Cup 2026?

Before the France vs Norway match, both teams had six points from two wins each. France held the top spot on goal difference with plus five compared to Norway’s plus four. The France vs Norway result determines who finishes first and who finishes second in Group I.',
   '/images/2026/06/Kylian_Mbappe_2017.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch France vs Norway World Cup 2026 Free Right Now - Of The Pitch',
   'Watch France vs Norway World Cup 2026 free today. Full guide by country: UK on ITV, Australia on SBS, USA free trials on YouTube TV and Fubo. VPN guide for Pakistan, India and global fans.',
   '[]'::jsonb, '2026-06-26T18:42:21Z', '2026-06-26T18:42:22Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-group-stage-road-trip-argentina-england-brazil
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('78e68e2c-dee0-51b6-8c85-56e167235298', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-group-stage-road-trip-argentina-england-brazil',
   'World Cup 2026 Group Stage Road Trip: How to Follow Argentina, England or Brazil Across Multiple Cities',
   'How to follow Argentina, England or Brazil across all three World Cup 2026 group stage cities. Full schedules, travel connections, costs and booking tips for multi-city match trips.',
   'Argentina, England, and Brazil each play three group stage matches in different host cities. Following any of these teams across the full group stage means planning a multi-city trip across the largest World Cup in history. This guide maps the exact match schedules for each team, the cities involved, the travel connections between them, and the practical decisions you need to make to see all three group games in person.

The realistic approach for most fans is to pick one or two group stage matches rather than all three, unless you have the time and budget for a dedicated three-week trip. Group stage games are spread over two weeks with four to five days between each match for each team. That gap is enough time to see the next city, but it requires accommodation and travel planning for each leg.

## Following Argentina Across Three Cities

Argentina is in Group J alongside Algeria, Austria, and Jordan. Their three group stage matches are spread across Kansas City and Dallas. Argentina opens against Algeria in Kansas City on June 16, then faces Austria in Dallas on June 22, and plays Jordan again in Dallas on June 27. If Argentina top their group, they proceed to the knockout rounds which are held across multiple cities.

For fans following Argentina through the group stage, the journey is: Kansas City for the opener, then Dallas for the final two group games. Kansas City and Dallas are 490 miles apart, about 8.5 hours by car or a 2-hour flight. The gap between the June 16 Kansas City match and the June 22 Dallas match gives fans six days, more than enough time to make the journey and settle in before the next game.

The practical road trip: fly or drive into Kansas City for June 16. After that match, you have until June 22 in Dallas. The drive south on I-35 takes about 8.5 hours. Most fans would drive or fly this on June 17 or 18, giving several days in Dallas before the Argentina vs Austria match. Kansas City flights into Dallas Fort Worth start around $130 to $200 booked in advance. The drive is cheaper if you are splitting costs with others.

If Argentina advance as group winners or runners-up, their Round of 32 could be in Miami or another Eastern city depending on their finish. The Full schedule through the knockout rounds depends on results. Booking refundable accommodation for potential knockout venues is worth doing alongside group stage planning.

## Following England Across Three Cities

England is in Group L alongside Croatia, Ghana, and Panama. Their group stage schedule takes fans to Dallas, Boston, and New York. England plays Croatia in Dallas on June 17, then Ghana in Boston on June 23, and finally Panama in New York on June 27. Three cities, three different regions, over the course of 10 days.

This is one of the more complex group stage schedules for travel. Dallas to Boston is a full cross-country flight, about 3.5 to 4 hours in the air and 6 to 8 hours door to door. Boston to New York is 4 hours by Amtrak or 4 to 5 hours by bus. The gaps between matches give enough time but the distances are significant. Dallas to Boston cannot be driven in a day; plan a flight.

The England fan road trip sequence: arrive Dallas for June 17, watch England vs Croatia at AT&T Stadium in Arlington. Then fly or make your way to Boston by June 20 or 21 to be ready for the June 23 match at Gillette Stadium in Foxborough. After Boston, the train to New York is the best option for June 27. Accommodation in all three cities should be booked well in advance. England matches historically draw enormous travelling support, and hotels in Dallas, Boston, and New York will be expensive and scarce near match dates.

The Boston to Foxborough leg needs specific planning. Gillette Stadium is 22 miles south of Boston city center in Foxborough. The Boston host committee has arranged matchday transport services from South Station, with pricing significantly above standard fares. Check the official World Cup Boston transport guide for current schedules closer to the dates.

## Following Brazil Across Three Cities

Brazil is in Group C alongside Morocco, Haiti, and Scotland. Their group stage matches are in New York, Philadelphia, and Miami. Brazil opens against Morocco in New York on June 13, then plays Haiti in Philadelphia on June 19, and faces Scotland in Miami on June 24. The three cities happen to be in the Eastern cluster, meaning this is one of the most manageable multi-city itineraries of any major team in the tournament.

New York to Philadelphia is 94 miles and under 90 minutes by Amtrak from Penn Station to 30th Street Station. No need to fly this leg. Philadelphia to Miami is 1,200 miles and does require a flight, about 2.5 hours in the air with door-to-door time around 5 hours. The gap between the June 19 Philadelphia match and the June 24 Miami match gives five days, plenty of time for the trip south.

![Rainbow Bridge crossing Niagara River between New York and Ontario](/images/2026/06/Rainbow_Bridge_Canada_side.jpg)

The Brazil fan road trip sequence: arrive New York for June 13, watch Brazil vs Morocco at MetLife Stadium in East Rutherford. Remember MetLife requires NJ Transit or an official shuttle from Manhattan, which costs around $150 round trip on match days and must be purchased in advance. Take the Amtrak from New York Penn Station to Philadelphia by June 17 to prepare for the June 19 match. Fly Philadelphia to Miami or Fort Lauderdale for the June 24 match. Miami’s Hard Rock Stadium is about 14 miles south of the city center; plan for rideshare or official shuttles on match day.

## Budgeting a Multi-City Group Stage Trip

The realistic budget for following a single team through all three group stage matches varies enormously by team and travel style. For England fans flying from the UK, transatlantic flights to Dallas followed by domestic connections to Boston and New York will be the largest cost. For Brazil fans already in the US or traveling from South America, the Eastern cluster is relatively contained in travel costs but New York and Miami accommodation on match weekends is expensive.

Key cost categories: match tickets (already purchased separately through FIFA), flights between cities, accommodation for 10 to 14 days including match day nights, ground transport in each city, and food. The stadium transport costs for New York (NJ Transit at $150 round trip) and Boston (premium matchday fares) are additional line items many fans overlook until too late.

## Booking Accommodation and Activities

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

Book accommodation in every city as early as possible. Match weekend hotels near Kansas City, Dallas, Boston, New York, Philadelphia, and Miami are already filling for tournament dates. Stay near transit hubs where possible: Penn Station in New York, South Station in Boston, 30th Street Station in Philadelphia. Booking.com and Hotels.com both have inventory across all host cities: [Booking.com](https://www.booking.com) and [Hotels.com](https://www.hotels.com). For activities and experiences in each city during your days between matches, Viator has options across all host cities including [New York](https://www.viator.com/New-York-City/d687-ttd?pid=P00300604&mcid=42383&medium=link&campaign=philadelphia-fan-zone-guide), [Dallas](https://www.viator.com/Dallas/d918-ttd?pid=P00300604&mcid=42383&medium=link&campaign=dallas-fan-zone-guide), and [Miami](https://www.viator.com/Miami/d662-ttd?pid=P00300604&mcid=42383&medium=link&campaign=atlanta-fan-zone-guide).

## Frequently Asked Questions

### Which team has the easiest group stage travel itinerary?

Brazil’s group stage schedule across New York, Philadelphia, and Miami is among the most compact. New York to Philadelphia takes under 90 minutes by Amtrak, and Philadelphia to Miami is a 2.5-hour flight. The three cities are connected and the trip can be done with one flight and one train. Argentina’s schedule in Kansas City and Dallas is similarly manageable with an 8.5-hour drive or short flight between the two cities.

### How much time is between group stage matches for each team?

Each team plays three group stage matches over about 11 to 13 days, with 4 to 6 days between each game. That is enough time to travel between cities and settle in before the next match. The England itinerary from Dallas to Boston is the most demanding leap, covering roughly 1,800 miles between the first and second match.

### Do I need to book knockout round accommodation in advance?

Booking refundable accommodation in likely knockout round venues is worth doing even before you know if your team advances. For Argentina, if they top Group J they would likely play Round of 32 in Miami. For Brazil, knockout round progression paths lead toward the Eastern elimination bracket. Book the first few knockout nights with free cancellation, then cancel if your team exits.

### Is it better to fly or take the train between New York and Philadelphia for Brazil matches?

Take the train. The Amtrak Northeast Regional or Acela from New York Penn Station to Philadelphia 30th Street Station takes 75 to 90 minutes. There are no direct flights between the two cities. The train is faster, cheaper, and deposits you in the center of Philadelphia without airport transfer time.

### How should England fans plan the Dallas to Boston leg?

Fly. Dallas to Boston is about 2,000 miles and a 3.5-hour flight. Flying into Boston Logan is the standard approach. There are no practical train or bus options for this distance within a sensible timeframe. Book domestic flights between the England match dates well in advance, as prices on those specific travel days between Dallas and Boston will be high given tournament demand.',
   '/images/2026/06/Niagara_falls_panorama.jpg', '6a75e67b-e1b2-59c5-b18f-2e23ecce11ff', '{}', 'published',
   'World Cup 2026 Group Stage Road Trip: How to Follow Argentina, England or Brazil Across Multiple Cities - Of The Pitch',
   'How to follow Argentina, England or Brazil across all three World Cup 2026 group stage cities. Full schedules, travel connections, costs and booking tips for multi-city match trips.',
   '[]'::jsonb, '2026-06-26T18:41:48Z', '2026-06-26T18:41:49Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] world-cup-2026-three-country-border-crossing-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('64e33371-0074-5bd1-9f4c-512b20f8106d', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-three-country-border-crossing-guide',
   'Following Your Team Across All Three World Cup Host Countries: The Complete Border Crossing Guide',
   'Complete border crossing guide for World Cup 2026 fans traveling across the USA, Canada, and Mexico. Documents, timing, ESTA, eTA, FMM card, NEXUS and match day crossing tips.',
   'World Cup 2026 spans three countries and 16 host cities across North America. Fans crossing between the USA, Canada, and Mexico face three distinct border situations, each with its own documents, procedures, and timing risks. This guide covers what you need at every crossing, which borders fans are most likely to use, and how to avoid the most common mistakes that cost people time or keep them out of a match.

The short version: carry your full passport book everywhere. A passport card works only at US-Canada and US-Mexico land crossings for US citizens and only in limited circumstances. Every other nationality needs a full passport book for every border. Mexico does not accept passport cards at all.

## USA to Canada: What Fans Need to Know

Entering Canada requires a passport. For the 42 Visa Waiver Program countries traveling by air, Canada requires an eTA (Electronic Travel Authorization), which costs CAD $7 and is applied for online at canada.ca. The eTA is linked electronically to your passport and takes minutes to get in most cases. You do not need an eTA to cross by land from the USA into Canada. At land crossings, a valid passport alone is sufficient for most nationalities.

Exceptions apply. Citizens of countries that are not on Canada’s visa-exempt list need a Temporary Resident Visa (TRV) to enter Canada regardless of how they arrive. There is one notable exception to the TRV rule: if you have held a valid Canadian visitor visa in the last 10 years, or if you currently hold a valid US non-immigrant visa, you may be eligible to apply for an eTA instead. This matters for fans from countries like Pakistan, India, and others whose nationals normally need a TRV. Check canada.ca/immigrer for your specific situation.

The practical land crossings are Peace Arch at Blaine, Washington (Vancouver), and the Peace Bridge at Fort Erie (Toronto). At both crossings, a Canadian Border Services Agency officer will ask the purpose of your visit, how long you plan to stay, and whether you have match tickets. Having your FIFA ticket confirmation on your phone is useful and demonstrates the purpose of your trip clearly.

## USA to Mexico: What Fans Need to Know

Mexico requires a passport book and a free FMM tourist card. Most nationalities enter Mexico visa-free for tourism. The FMM is issued at the border crossing or on arriving flights. You fill it in, keep it for your entire stay, and hand it back when you leave. The critical mistake fans make is losing the FMM mid-trip. Keep it clipped inside your passport.

The FMM applies everywhere in Mexico, not just near the border. Immigration checkpoints exist on Mexican highways, and having your passport and FMM on your person at all times while in Mexico is legally required. If you are driving into Mexico beyond the immediate border zone, you will also need a Temporary Vehicle Import Permit from Banjercito. Most US rental car companies do not allow their vehicles into Mexico, so confirm your rental terms before assuming you can drive across.

The main crossing points for World Cup fans heading to Monterrey are the Nuevo Laredo bridge at Laredo, Texas, and the Reynosa crossing at McAllen. Monterrey is approximately 145 miles south of Laredo on Highway 85D, about 2 to 2.5 hours driving once across. Guadalajara and Mexico City are deep inland and flying is strongly recommended over driving for those cities.

## Canada to Mexico: Going Through the USA

There is no direct land route from Canada to Mexico that does not pass through the USA. Canadian fans heading to Mexico will either fly directly or cross into the USA first and then proceed south. If flying, the Canadian entry requirements on return apply: Canadian citizens just need their passport; permanent residents need their PR card. If traveling overland from Canada through the US and then into Mexico, you clear US Customs when entering the USA from Canada (Peace Arch, Peace Bridge, etc.) and then clear Mexican Customs when crossing from Texas or another US border state.

For Canadian citizens, entering the USA requires no ESTA and no visa. A Canadian passport is sufficient at both land and air crossings. For non-Canadian nationals living in Canada who want to cross into the USA and then Mexico, check both US and Mexican requirements for their specific nationality. A valid US visa or ESTA allows entry into the USA. From there, entry into Mexico follows Mexican rules, which are generally more lenient for most nationalities.

## ESTA, NEXUS, and Global Entry: Which Expedited Programs Help

ESTA is the USA’s pre-travel authorization for 42 Visa Waiver Program countries. It costs $21 and is valid for two years, covering multiple entries. Apply at esta.cbp.dhs.gov. ESTA is required for air travel into the USA but not for land crossings from Canada or Mexico if you are otherwise eligible to cross. NEXUS is the joint US-Canada trusted traveler program, costing $50 and valid for 5 years. NEXUS card holders use dedicated lanes at land crossings and have minimal wait times. The Whirlpool Bridge at Niagara Falls is NEXUS-only. Global Entry covers expedited US airport arrival for pre-approved travelers. Processing for all these programs takes weeks to months.

![Vancouver city skyline at sunrise with BC Place stadium](/images/2026/06/Vancouver_cityscape_sunrise.jpg)

## Timing Your Border Crossings Around Match Days

Border wait times spike when matches are scheduled in nearby cities. The Peace Arch crossing between Vancouver and Seattle will be busiest when both cities have matches on consecutive days. The Niagara Falls Rainbow Bridge will be busier on Toronto match days when New York fans are also crossing for matches. The Laredo-Nuevo Laredo crossing will be busiest on Monterrey match days and surrounding periods. Cross early in the morning when possible. Check live wait times at bwt.cbp.gov for the US side and the CBSA CanBorder app for the Canadian side.

Build buffer time into any itinerary that involves a border crossing on a match day. A crossing that normally takes 30 minutes can take 2 hours on a busy day. If your match kicks off at 1pm and you need to be in the city 2 hours early, crossing a border at 10am on that day is too late. Plan to cross the evening before or very early on match morning.

## Travel Insurance Across Three Countries

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

A multi-country trip covering the USA, Canada, and Mexico over several weeks involves real logistical risks: missed flights, border delays, lost documents, and medical incidents. Travel insurance that covers all three countries with trip interruption, medical cover, and missed departure protection is essential for anyone building a complex three-country itinerary. [World Nomads](https://www.worldnomads.com) covers travel across all three host countries in a single policy.

## Frequently Asked Questions

### Do I need three different visas to watch matches in all three host countries?

Not necessarily. Many nationalities can enter all three countries without visas for tourist visits. US citizens need no visa for either Canada or Mexico. Citizens of the 42 ESTA countries need an eTA for Canada (by air), an ESTA for the USA, and no visa for Mexico. Citizens of countries not on those lists need to check requirements for each country individually at each country’s official immigration website.

### Can I use the same passport for all three countries?

Yes, your passport book works for all three countries. Mexico does not accept passport cards, so always carry your full passport book. Ensure your passport is valid for the full duration of your trip and has sufficient blank pages for stamps.

### What is the most complicated border crossing for fans doing all three countries?

The US-Mexico land crossing at Laredo is the most complex for fans unfamiliar with the route, mainly because of the FMM card requirement, potential vehicle import permits, and US rental car restrictions on Mexico crossings. The US-Canada crossings are simpler. Air travel between countries avoids most border complexity since you clear customs at the arrival airport.

### How early should I be at the border on World Cup match days?

Plan to cross at least 3 to 4 hours before you need to be at your match venue, especially at land crossings near host cities. On Vancouver-Seattle crossing days when both cities have matches, queues could run 2 hours or more. The Laredo crossing during Monterrey match days may also see significant delays. Early morning crossings before 7am typically have the shortest queues at most points.

### What happens if I lose my FMM card while in Mexico?

You should report the loss to the Instituto Nacional de Migración (INM) in Mexico as soon as possible and obtain a replacement. There may be a small fee. Attempting to leave Mexico without an FMM or its replacement can cause delays at the border. Keep the card with your passport throughout your trip to avoid this situation.',
   '/images/2026/06/Spring_arrives_at_Peace_Arch_USA-Canada_Border_Crossing_-_panoramio.jpg', '6a75e67b-e1b2-59c5-b18f-2e23ecce11ff', '{}', 'published',
   'Following Your Team Across All Three World Cup Host Countries: The Complete Border Crossing Guide - Of The Pitch',
   'Complete border crossing guide for World Cup 2026 fans traveling across the USA, Canada, and Mexico. Documents, timing, ESTA, eTA, FMM card, NEXUS and match day crossing tips.',
   '[]'::jsonb, '2026-06-26T18:41:16Z', '2026-06-26T18:41:17Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] usa-to-mexico-world-cup-2026-border-crossing-monterrey-guadalajara
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('eb797563-27b1-5bb0-8273-6fd05613cce9', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'usa-to-mexico-world-cup-2026-border-crossing-monterrey-guadalajara',
   'How to Cross From the USA Into Mexico for World Cup Matches in Monterrey and Guadalajara',
   'How to cross from the USA into Mexico for World Cup 2026 matches in Monterrey and Guadalajara. Laredo border crossing, FMM card, driving, buses from Texas, and city transport.',
   'Crossing from the USA into Mexico for World Cup 2026 is straightforward for most nationalities but requires a passport, an FMM tourist card, and realistic expectations about timing. Mexico will host matches in Monterrey, Guadalajara, and Mexico City. Monterrey is the closest Mexican host city to the US border, sitting 3 to 4 hours from Laredo or McAllen depending on your border crossing. Guadalajara and Mexico City are significantly further inland and require either a longer drive or a domestic flight.

The entry rule that catches people off guard is the FMM card. This is Mexico’s tourist card, called the Forma Migratoria Multiple. You get it at the border on arrival, fill it out, and must keep it for the duration of your stay. It is free. Losing it can cause complications when you leave Mexico, so keep it with your passport from the moment you receive it.

## What Documents You Need to Enter Mexico

A valid passport book is required for all nationalities entering Mexico. Mexico does not accept passport cards for entry. Your passport must be valid for the entire duration of your stay. Most nationalities do not need a visa to enter Mexico as a tourist, including citizens of the USA, UK, EU countries, Canada, Australia, and many others. The full list is on Mexico’s official consular websites and at visitmex.com.

If you are driving into Mexico beyond the free zone, you will also need a Temporary Vehicle Import Permit, known as a TIP. This is obtained at Banjercito windows at the border crossing itself and requires a cash deposit or credit card hold. If you are driving only to Monterrey and staying within the northern zone, confirm whether a TIP is required for your specific route with Banjercito before you travel, as the rules vary by zone. Most US rental car companies do not permit their vehicles to be taken into Mexico. If you are renting a car, read the terms carefully. Returning the car at the US side of the border and using Mexican transport or a separate Mexican rental from the border is often the better option.

## Border Crossings for Monterrey

The main crossing point for Monterrey is Nuevo Laredo, directly across the Rio Grande from Laredo, Texas. From Laredo International Bridge, Monterrey is about 145 miles south on Highway 85D, a well-maintained toll highway. The drive takes 2 to 2.5 hours once across the border. McAllen to Monterrey via Reynosa is another option, adding roughly the same distance. Laredo is the more commonly recommended crossing because the toll highway to Monterrey is faster and cleaner than the Reynosa route.

Laredo is 160 miles south of San Antonio on I-35. From Dallas it is about 370 miles, roughly 5.5 hours. Fans attending Dallas matches who want to cross into Monterrey could feasibly drive the Dallas to Laredo to Monterrey route in a single long day, though most would break it up with an overnight stop in Laredo or San Antonio.

Cross early in the day. The Nuevo Laredo crossing is busiest between 8 am and noon due to commercial truck traffic. Early morning crossings can be significantly faster. From the Texas side, the wait in normal conditions is 30 minutes to 2 hours. On days surrounding World Cup matches in Monterrey, expect longer queues as a large volume of fans and Mexican nationals returning home will all be crossing at similar times.

## Border Crossings for Guadalajara and Mexico City

Guadalajara and Mexico City are much further from the US border than Monterrey. Guadalajara is about 600 miles from the Laredo crossing, requiring roughly 8 to 9 hours of driving on Mexican highways after the border. Mexico City is around 700 miles from Laredo, adding another 1 to 2 hours. For these cities, flying is the strongly recommended option. Direct flights from Dallas, Houston, Miami, New York, and Los Angeles all serve Guadalajara International Airport (GDL) and Mexico City Benito Juarez International Airport (MEX). The drive from Texas to Mexico City or Guadalajara involves multiple toll highways, and driving in Mexico at night is not recommended due to safety concerns on certain routes.

The US Embassy in Mexico advises visitors to research road safety by state before driving. Not all Mexican states carry the same road safety conditions, and travel advisories vary. Check the current state-level travel advisories at travel.state.gov before planning a road trip deep into Mexico. For Monterrey specifically, the city itself and the main highway from Laredo are generally considered safer than other routes, but conditions can change.

## Bus Services From Texas to Monterrey

Several Mexican bus companies and cross-border operators run services from Laredo and other Texas border cities directly to Monterrey. Autobuses Americanos and Tornado Bus are among the operators serving this corridor. Tickets cost approximately $15 to $25 USD and the journey takes 2.5 to 3 hours after the border crossing. The bus handles the border stop and passengers clear customs on the bus or at the crossing. This is a genuinely practical option for budget travelers coming from San Antonio or Dallas, where connecting to a bus heading south is straightforward.

![Cerro de las Mitras mountain range above Monterrey Mexico](/images/2026/06/Cerro_de_las_mitras_Monterrey_Mexico.jpg)

From the wider US, Greyhound connects to Laredo from major Texas cities, and from Laredo you transfer to a Mexican line heading south. The full Dallas to Monterrey bus journey runs around 10 to 12 hours total. Not fast, but cheap, and it handles the border formalities as part of the route.

## Getting Around Monterrey and Guadalajara

Monterrey has Metrorrey, a metro system with three lines covering the central city. Line 1 has a stop near Estadio BBVA. Uber operates throughout Monterrey and is widely used by visitors. Rental cars are available at Monterrey International Airport but are optional since the metro and Uber cover most of the city. Guadalajara has an expanding metro system and Uber is available. Neither city requires a car for a typical match-day visit.

## Travel Insurance for Mexico Matches

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

Medical care in major Mexican cities is available and generally good, but travel insurance covering health emergencies is still worth having, particularly if you are driving or spending extended time in Mexico. Check policy details carefully: some travel insurance products exclude certain regions based on travel advisories. [World Nomads](https://www.worldnomads.com) covers travel in Mexico and includes trip interruption and medical coverage for short-term visitors.

## Frequently Asked Questions

### Do I need a visa to enter Mexico for the World Cup?

Most nationalities including US, UK, EU, Canadian, and Australian passport holders do not need a visa to enter Mexico as a tourist. You will need a valid passport book and must obtain a free FMM tourist card at the border or on arrival. Check Mexico’s official immigration requirements at gob.mx for your specific nationality before traveling.

### What is the FMM tourist card and where do I get it?

The Forma Migratoria Multiple is Mexico’s tourist card. It is free and issued at the border crossing or given on incoming flights. You fill in your name, nationality, passport number, and Mexican accommodation address. You must keep this card for the duration of your stay and surrender it when you exit Mexico. Losing it can cause delays at departure. Some airlines and online portals allow you to fill it in ahead of travel.

### Can I drive a US rental car into Mexico?

Most major US rental car companies prohibit their vehicles from being taken into Mexico. Check the terms of your specific rental agreement before assuming you can cross. The standard approach is to return the rental at the US side of the border and either walk across or arrange separate transport on the Mexican side. Some specialty rental companies and cross-border services do offer vehicles cleared for Mexico.

### How far is Monterrey from the Texas border?

Monterrey is about 145 miles from the Nuevo Laredo crossing at Laredo, Texas, and about 150 miles from the McAllen-Reynosa crossing. Once across the border the drive to Monterrey on Highway 85D takes approximately 2 to 2.5 hours. Laredo itself is 160 miles south of San Antonio and about 370 miles from Dallas.

### Is it safe to drive to Monterrey for the World Cup?

The main highway from Laredo to Monterrey is a modern toll road and is generally considered among the safer driving routes into Mexico. The US Embassy recommends researching state-level advisories at travel.state.gov before any road trip into Mexico. Driving at night on Mexican highways is not recommended. Arriving during daylight and not stopping on the highway outside of official rest areas are standard safety precautions.',
   '/images/2026/06/Texas-Mexican_Railway_Bridge.jpg', '6a75e67b-e1b2-59c5-b18f-2e23ecce11ff', '{}', 'published',
   'How to Cross From the USA Into Mexico for World Cup Matches in Monterrey and Guadalajara - Of The Pitch',
   'How to cross from the USA into Mexico for World Cup 2026 matches in Monterrey and Guadalajara. Laredo border crossing, FMM card, driving, buses from Texas, and city transport.',
   '[]'::jsonb, '2026-06-26T18:39:19Z', '2026-06-26T18:39:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [full] canada-to-usa-world-cup-2026-border-crossing-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('d8649494-9863-5e3c-a042-331283b4e7a7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'canada-to-usa-world-cup-2026-border-crossing-guide',
   'How to Travel From Canada to USA for World Cup Matches: Vancouver to Seattle and Toronto to Buffalo',
   'Complete guide for fans crossing the US border for World Cup 2026. Vancouver to Seattle by Amtrak Cascades, train, bus and car. Toronto to Buffalo via Niagara Falls or Peace Bridge.',
   'Fans traveling between Canada and the USA for World Cup 2026 matches cross a real international border, and that means passports, border queues, and planning your timing carefully. The two practical crossings for World Cup fans are Vancouver to Seattle via the Peace Arch at Blaine, Washington, and Toronto to Buffalo via the Peace Bridge or Niagara Falls Rainbow Bridge. Both routes are manageable with the right preparation, but neither should be treated as a routine city-to-city hop.

Every person crossing any Canada-US border point by land needs a passport book or an accepted NEXUS card. A passport card works for US citizens crossing by land, but international fans from outside North America must carry a full passport book. Real ID driver’s licenses do not work for border crossings into Canada. Check your documents before you arrive at the crossing.

## Vancouver to Seattle: The Amtrak Cascades Option

Vancouver and Seattle are 143 miles apart and are the two closest World Cup host cities on the map. The Amtrak Cascades train is the cleanest way to make this crossing. There are two daily round trips between Vancouver Pacific Central Station and Seattle King Street Station, with a scheduled journey time of about 4 hours. Tickets run approximately $34 to $56 USD. The train crosses the border at Blaine and passengers clear US Customs on board or at the border stop. BC Preclearance facilities at Pacific Central are being upgraded ahead of the tournament, which should reduce delays on the southbound journey.

The train works well because you avoid driving across the Peace Arch border crossing, which during normal summer periods runs 30 minutes to 2 hours and during World Cup match weekends is expected to be significantly longer. The Amtrak Cascades also lets you travel without a car, which simplifies things once you arrive in Seattle, where transit is the recommended way to reach Lumen Field on match days.

Driving is a realistic alternative. The route is I-5 South from Vancouver to Blaine, then straight on into Seattle. Under normal conditions the drive takes 2.5 to 3 hours including the border stop. On World Cup match days, particularly days when Vancouver and Seattle both have matches in close succession, border wait times could double or triple. Check live wait times at bwt.cbp.gov and the CBSA CanBorder app before you leave. Cross early in the morning to avoid peak queues. The Peace Arch crossing is open 24 hours.

Bus services also operate between Vancouver and Seattle. Greyhound, FlixBus, and others run the route, with journey times of 3 to 5 hours including the border stop. Prices start around $25 to $50. The bus stops at the border and passengers must clear customs, which adds time if queues are long.

## Toronto to Buffalo: Peace Bridge and Niagara Falls Crossings

Toronto is roughly 100 miles from Buffalo via the QEW and Peace Bridge crossing at Fort Erie. Under normal conditions the drive takes about 90 minutes to 2 hours including the border stop. Toronto’s World Cup matches at BMO Field include Canada vs Qatar on June 18, Switzerland vs Canada on June 24, and Panama vs Croatia on June 27. Buffalo does not host matches, but it sits between Toronto and the New York area, and many fans use the Buffalo route to connect from flights at Buffalo Niagara International Airport to Toronto.

The Peace Bridge at Fort Erie and Buffalo is the main vehicle crossing. The Niagara Falls crossings are the Rainbow Bridge at Niagara Falls city center and the Lewiston-Queenston Bridge further north. The Rainbow Bridge is open to pedestrians and vehicles 24 hours a day. The Lewiston-Queenston Bridge handles more commercial traffic and tends to have longer waits. NEXUS card holders can use the Whirlpool Bridge at Niagara Falls, which is a dedicated NEXUS-only crossing with minimal to no delays. If you are a frequent Canada-US traveler, a NEXUS card costs $50 USD and is valid for 5 years.

Megabus and Greyhound both run coach services between Buffalo and Toronto. The journey takes about 2 hours including the border stop and tickets start around $20 to $40. FlixBus also serves the route from Niagara Falls, Ontario, directly to Toronto’s Union Station. If you are flying into Buffalo Niagara International Airport for matches in Toronto, this coach option is genuinely practical and cheaper than renting a car for a single trip.

## Documents Every Fan Needs at the Border

For the US side: all travelers entering the USA by land need a valid passport book or NEXUS card. US citizens can also use a passport card or enhanced driver’s license from eligible states. Fans on a Visa Waiver Program (ESTA) crossing by land still need their ESTA but it is not stamped at land crossings. Fans who need a B1/B2 visa for the USA must carry their visa documentation. The FIFA PASS program can assist with expedited visa scheduling but does not change the requirements at the border itself.

![Rainbow Bridge border crossing between New York and Ontario at Niagara Falls](/images/2026/06/Rainbow_Bridge_between_New_York_and_Ontario.jpg)

For the Canadian side: returning to Canada requires the same passport documentation. Canadian citizens need a Canadian passport. Permanent residents need their PR card. Non-residents who entered Canada originally by air needed an eTA, but eTA is not required for land crossings. If you entered Canada on a Temporary Resident Visa and are returning, carry your TRV documentation.

## Travel Insurance for Cross-Border Match Trips

This post contains affiliate links. If you purchase through our links we may earn a small commission at no extra cost to you. See our [affiliate disclosure](/affiliate-disclosure).

Border delays during World Cup peak periods are a real risk to match day schedules. Travel insurance covering missed events and trip interruption gives you a financial safety net if a long queue means you miss a kickoff. [World Nomads](https://www.worldnomads.com) offers policies covering missed departures and cancellations for travel across multiple countries.

## Frequently Asked Questions

### Do I need a passport to cross from Vancouver to Seattle for the World Cup?

Yes. Every person crossing the Canada-US land border by any mode of transport needs a valid passport book or NEXUS card. A driver’s license alone is not sufficient. US citizens can also use a passport card or an enhanced driver’s license from certain states. International fans from outside North America must carry their full passport book plus any US entry documents such as an ESTA or B1/B2 visa.

### How long does the Vancouver to Seattle border crossing take during the World Cup?

Under normal summer conditions, vehicle queues at the Peace Arch crossing run 30 minutes to 1.5 hours. During World Cup match weekends with back-to-back games in both cities, expect significantly longer waits. The Amtrak Cascades train avoids most of this uncertainty by handling customs at the border stop without the vehicle queue. Check live wait times at bwt.cbp.gov before driving.

### Can I take the train from Toronto to Buffalo for the World Cup?

There is no direct passenger train between Toronto and Buffalo. The options are driving via the QEW to the Peace Bridge at Fort Erie, taking a Megabus or Greyhound coach, or flying. The bus from Buffalo to Toronto takes about 2 hours and is the most convenient transit option for fans without a car.

### What is the NEXUS card and is it worth getting for the World Cup?

NEXUS is a joint US-Canada trusted traveler program. Members use dedicated lanes at land crossings and can use the NEXUS-only Whirlpool Bridge at Niagara Falls, which typically has zero to minimal wait times. The card costs $50 USD and takes 3 to 6 months to process. Global Entry and TSA PreCheck benefits are included. Applying now for June 2026 is feasible if you act immediately.

### Which Vancouver to Seattle crossing should I use?

The Peace Arch crossing at Blaine is the main crossing for passenger vehicles and is open 24 hours. Pacific Highway is the second option nearby and sometimes has shorter queues during peak periods. Check the CBSA CanBorder app for live wait time comparisons before you depart.

### Are there direct flights between Vancouver and Seattle for the World Cup?

Yes. Air Canada, Alaska Airlines, and Delta all serve the Vancouver-Seattle route. The flight takes about 45 minutes, though door-to-door time with two airports and check-in makes the total experience around 4 hours, similar to taking the Amtrak Cascades train. Flights will be significantly more expensive on match days.',
   '/images/2026/06/Canada_and_US_Border-Peace_Arch_Park_-_panoramio.jpg', '6a75e67b-e1b2-59c5-b18f-2e23ecce11ff', '{}', 'published',
   'How to Travel From Canada to USA for World Cup Matches: Vancouver to Seattle and Toronto to Buffalo - Of The Pitch',
   'Complete guide for fans crossing the US border for World Cup 2026. Vancouver to Seattle by Amtrak Cascades, train, bus and car. Toronto to Buffalo via Niagara Falls or Peace Bridge.',
   '[]'::jsonb, '2026-06-26T18:38:50Z', '2026-06-26T18:38:52Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-youngest-squads-next-generation
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('73301217-87e9-5192-98bd-9e0b0baac4c6', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-youngest-squads-next-generation',
   'World Cup 2026 Youngest Squads: The Nations Built for 2030 Who Could Surprise in 2026',
   'World Cup 2026 youngest squads. Yamal, Endrick, Cubarsi and the generation making their debut. Which nations are built for 2030 and who could surprise in 2026.',
   'World Cup 2026 youngest squads. Yamal, Endrick, Cubarsi and the generation making their debut. Which nations are built for 2030 and who could surprise in 2026.',
   '/images/2026/06/Sergio_Ramos_Euro_2012_vs_France_02-2.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'World Cup 2026 Youngest Squads: The Nations Built for 2030 Who Could Surprise in 2026 - Of The Pitch',
   'World Cup 2026 youngest squads. Yamal, Endrick, Cubarsi and the generation making their debut. Which nations are built for 2030 and who could surprise in 2026.',
   '[{"question": "Which World Cup 2026 squad has the youngest average age?", "answer": "Argentina’s 2026 squad averages 26.3 years, making them the second youngest of the big nations. Spain has the youngest squad among serious contenders at 25.8 years average."}, {"question": "Is Lamine Yamal the youngest player at World Cup 2026?", "answer": "Lamine Yamal, born 13 July 2007, is among the youngest players at World Cup 2026. He turned 19 during the tournament. Several other teenagers are in squads."}, {"question": "Which teams are building for 2030?", "answer": "Spain, Argentina, France, England, and the USA all have squads with a significant number of players under 24. These teams are genuinely competitive in 2026 while building toward 2030."}, {"question": "How old is Endrick at World Cup 2026?", "answer": "Endrick was born on 21 July 2006 and turns 20 during the 2026 tournament. He is one of the youngest players Brazil have ever taken to a World Cup."}, {"question": "What is the youngest age a player can be at the World Cup?", "answer": "There is no minimum age restriction for the FIFA World Cup. Players must simply be registered by their national federation and eligible to play for that country."}, {"question": "Which World Cup 2026 squad has the most players under 21?", "answer": "Spain and France lead in under-21 representation. Both nations have called up multiple teenage or 20-year-old players who are already starting for top European clubs."}]'::jsonb, '2026-06-14T13:01:27Z', '2026-06-22T07:38:19Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] south-korea-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('b70fdddb-db7a-5633-b837-56c6f5166ebb', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'south-korea-world-cup-2026-squad-review',
   'South Korea World Cup 2026 Squad Review: Asia’s Best Chance Since 2002',
   'South Korea World Cup 2026 squad review. Son Heung-min’s fourth World Cup, Kim Min-jae, Lee Kang-in and Group A against Mexico and Czech Republic. Full breakdown.',
   'South Korea World Cup 2026 squad review. Son Heung-min’s fourth World Cup, Kim Min-jae, Lee Kang-in and Group A against Mexico and Czech Republic. Full breakdown.

## Squad and Coach

| | |
| --- | --- |
| **Team** | South Korea national football team |
| **Nickname** | Taegeuk Warriors |
| **Head coach** | Hong Myung-bo |

### Players to watch

- Son Heung-min
- Kim Min-jae
- Lee Kang-in
- Hwang Hee-chan
- Cho Gue-sung',
   '/images/2026/06/Sergio_Ramos_Euro_2012_vs_France_02-1.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'South Korea World Cup 2026 Squad Review: Asia''s Best Chance Since 2002 - Of The Pitch',
   'South Korea World Cup 2026 squad review. Son Heung-min''s fourth World Cup, Kim Min-jae, Lee Kang-in and Group A against Mexico and Czech Republic. Full breakdown.',
   '[]'::jsonb, '2026-06-13T15:00:15Z', '2026-06-22T07:27:57Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-oldest-players-last-tournament
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('0282035a-2d3d-5152-81c3-495fc9a84296', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-oldest-players-last-tournament',
   'World Cup 2026 Oldest Players: Who Is Playing Their Last Tournament and Why It Matters',
   'World Cup 2026 oldest players. Craig Gordon 43, Ronaldo 41, Ochoa 41, Modric 40, Neuer 40. Who is playing their last tournament and what the generation of veterans means.',
   'World Cup 2026 oldest players. Craig Gordon 43, Ronaldo 41, Ochoa 41, Modric 40, Neuer 40. Who is playing their last tournament and what the generation of veterans means.',
   '/images/2026/06/Lionel_Messi_WC2022-2.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'World Cup 2026 Oldest Players: Who Is Playing Their Last Tournament and Why It Matters - Of The Pitch',
   'World Cup 2026 oldest players. Craig Gordon 43, Ronaldo 41, Ochoa 41, Modric 40, Neuer 40. Who is playing their last tournament and what the generation of veterans means.',
   '[{"question": "Who is the oldest player at World Cup 2026?", "answer": "Craig Gordon of Scotland is the oldest confirmed player at World Cup 2026 at 43 years old. He is Scotland’s starting goalkeeper and has been capped over 70 times."}, {"question": "Is Ronaldo playing at World Cup 2026?", "answer": "Yes. Cristiano Ronaldo is 41 years old at World Cup 2026 and is in the Portugal squad. He has stated this will be his final World Cup."}, {"question": "How old is Luka Modric at World Cup 2026?", "answer": "Luka Modric is 40 years old at World Cup 2026. He has been included in Croatia’s squad and is widely expected to announce his international retirement after the tournament."}, {"question": "Is Manuel Neuer playing at World Cup 2026?", "answer": "Yes. Manuel Neuer is 40 years old at World Cup 2026 and remains Germany’s first-choice goalkeeper under Julian Nagelsmann."}, {"question": "What age is too old to play at the World Cup?", "answer": "There is no age limit for World Cup participation. FIFA imposes no maximum age restriction. Selection is purely at the discretion of the national team manager."}]'::jsonb, '2026-06-13T12:54:00Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] netherlands-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('e6220dd3-20cd-5780-9ccc-6687afea406a', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'netherlands-world-cup-2026-squad-review',
   'Netherlands World Cup 2026 Squad Review: The Nearly Men of World Football Try Again',
   'Netherlands World Cup 2026 squad review. Van Dijk, De Jong, Gakpo and three World Cup finals with zero trophies. Full squad breakdown, Group F fixtures, and honest title verdict.',
   'Netherlands World Cup 2026 squad review. Van Dijk, De Jong, Gakpo and three World Cup finals with zero trophies. Full squad breakdown, Group F fixtures, and honest title verdict.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Netherlands national football team |
| **Nickname** | Oranje |
| **Head coach** | Ronald Koeman |

### Players to watch

- Virgil van Dijk
- Frenkie de Jong
- Cody Gakpo
- Ryan Gravenberch
- Memphis Depay',
   '/images/2026/06/Harry_Kane_2015-1.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Netherlands World Cup 2026 Squad Review: The Nearly Men of World Football Try Again - Of The Pitch',
   'Netherlands World Cup 2026 squad review. Van Dijk, De Jong, Gakpo and three World Cup finals with zero trophies. Full squad breakdown, Group F fixtures, and honest title verdict.',
   '[]'::jsonb, '2026-06-12T16:17:05Z', '2026-06-22T07:27:55Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] australia-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('291ab6ad-54b1-5d0a-a48c-aedc45afd6b9', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'australia-world-cup-2026-squad-review',
   'Australia World Cup 2026 Squad Review: The Socceroos and Their Realistic Path to the Knockout Rounds',
   'Australia World Cup 2026 squad review. Mathew Ryan, Leckie, and the Socceroos in Group D against USA and Turkey. Full breakdown and honest assessment of their knockout round chances.',
   'Australia World Cup 2026 squad review. Mathew Ryan, Leckie, and the Socceroos in Group D against USA and Turkey. Full breakdown and honest assessment of their knockout round chances.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Australia national football team |
| **Nickname** | Socceroos |
| **Head coach** | Tony Popovic |

### Players to watch

- Mathew Ryan
- Mat Leckie
- Mitchell Duke
- Aaron Mooy
- Harry Souttar',
   '/images/2026/06/Vinicius_Jr_2021-1.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Australia World Cup 2026 Squad Review: The Socceroos and Their Realistic Path to the Knockout Rounds - Of The Pitch',
   'Australia World Cup 2026 squad review. Mathew Ryan, Leckie, and the Socceroos in Group D against USA and Turkey. Full breakdown and honest assessment of their knockout round chances.',
   '[]'::jsonb, '2026-06-12T14:12:28Z', '2026-06-22T07:27:54Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] portugal-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('342ce745-2459-59d4-9681-e9ebb9b444b1', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'portugal-world-cup-2026-squad-review',
   'Portugal World Cup 2026 Squad Review: After Ronaldo What Are They Actually Worth',
   'Portugal World Cup 2026 squad review. Ronaldo at 41, Bruno Fernandes, Vitinha, and Group K. Full breakdown and honest verdict on whether Portugal can finally win it after Ronaldo.',
   'Portugal World Cup 2026 squad review. Ronaldo at 41, Bruno Fernandes, Vitinha, and Group K. Full breakdown and honest verdict on whether Portugal can finally win it after Ronaldo.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Portugal national football team |
| **Nickname** | A Selecao das Quinas |
| **Head coach** | Roberto Martinez |

### Players to watch

- Cristiano Ronaldo
- Bruno Fernandes
- Vitinha
- Ruben Dias
- Rafael Leao',
   '/images/2026/06/Lionel_Messi_WC2022-1.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Portugal World Cup 2026 Squad Review: After Ronaldo What Are They Actually Worth - Of The Pitch',
   'Portugal World Cup 2026 squad review. Ronaldo at 41, Bruno Fernandes, Vitinha, and Group K. Full breakdown and honest verdict on whether Portugal can finally win it after Ronaldo.',
   '[]'::jsonb, '2026-06-11T16:54:41Z', '2026-06-22T07:27:53Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] japan-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('6f7571fc-f9e7-5371-adbf-7fde0b38d69d', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'japan-world-cup-2026-squad-review',
   'Japan World Cup 2026 Squad Review: Asia’s Best Team and Why They Could Surprise Everyone',
   'Japan World Cup 2026 squad review. Kubo, Endo, and the Blue Samurai. Full breakdown, Group F fixtures, and why Japan could break their round-of-16 curse at the biggest World Cup in history.',
   'Japan World Cup 2026 squad review. Kubo, Endo, and the Blue Samurai. Full breakdown, Group F fixtures, and why Japan could break their round-of-16 curse at the biggest World Cup in history.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Japan national football team |
| **Nickname** | Samurai Blue |
| **Head coach** | Hajime Moriyasu |

### Players to watch

- Takefusa Kubo
- Wataru Endo
- Daichi Kamada
- Shuichi Gonda
- Ritsu Doan',
   '/images/2026/06/Argentina_vs_France_2018_World_Cup_08-4.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Japan World Cup 2026 Squad Review: Asia''s Best Team and Why They Could Surprise Everyone - Of The Pitch',
   'Japan World Cup 2026 squad review. Kubo, Endo, and the Blue Samurai. Full breakdown, Group F fixtures, and why Japan could break their round-of-16 curse at the biggest World Cup in history.',
   '[]'::jsonb, '2026-06-10T09:20:59Z', '2026-06-22T07:27:52Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] canada-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('ff352836-592d-5e0c-8312-d84ade41a418', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'canada-world-cup-2026-squad-review',
   'Canada World Cup 2026 Squad Review: The Host Nation and What They Are Actually Capable Of',
   'Canada World Cup 2026 squad review. Davies, Jonathan David, and the host nation’s best ever chance. Full squad breakdown, Group B fixtures, and honest verdict on what Canada can actually achieve.',
   'Canada World Cup 2026 squad review. Davies, Jonathan David, and the host nation’s best ever chance. Full squad breakdown, Group B fixtures, and honest verdict on what Canada can actually achieve.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Canada national soccer team |
| **Nickname** | Les Rouges |
| **Head coach** | Jesse Marsch |

### Players to watch

- Alphonso Davies
- Jonathan David
- Tajon Buchanan
- Jonathan Osorio
- Milan Borjan',
   '/images/2026/06/France_champion_of_the_Football_World_Cup_Russia_2018-3.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Canada World Cup 2026 Squad Review: The Host Nation and What They Are Actually Capable Of - Of The Pitch',
   'Canada World Cup 2026 squad review. Davies, Jonathan David, and the host nation''s best ever chance. Full squad breakdown, Group B fixtures, and honest verdict on what Canada can actually achieve.',
   '[]'::jsonb, '2026-06-10T08:50:59Z', '2026-06-22T07:27:49Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] morocco-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('f622cd26-ad09-588a-8d04-a9570176c771', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'morocco-world-cup-2026-squad-review',
   'Morocco World Cup 2026 Squad Review: Can the Atlas Lions Reach the Final Again',
   'Morocco World Cup 2026 squad review. Hakimi, Brahim Diaz and the Atlas Lions in Group C. Full breakdown, key players, and honest verdict on whether they can repeat their 2022 semifinal run.',
   'Morocco World Cup 2026 squad review. Hakimi, Brahim Diaz and the Atlas Lions in Group C. Full breakdown, key players, and honest verdict on whether they can repeat their 2022 semifinal run.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Morocco national football team |
| **Nickname** | Atlas Lions |
| **Head coach** | Walid Regragui |

### Players to watch

- Achraf Hakimi
- Brahim Diaz
- Hakim Ziyech
- Yassine Bounou
- Noussair Mazraoui',
   '/images/2026/06/HakimiAchraf.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Morocco World Cup 2026 Squad Review: Can the Atlas Lions Reach the Final Again - Of The Pitch',
   'Morocco World Cup 2026 squad review. Hakimi, Brahim Diaz and the Atlas Lions in Group C. Full breakdown, key players, and honest verdict on whether they can repeat their 2022 semifinal run.',
   '[]'::jsonb, '2026-06-09T15:54:46Z', '2026-06-22T07:27:48Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] usa-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('9d9c821b-3ad0-5b6d-a2e9-04e1aad749a6', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'usa-world-cup-2026-squad-review',
   'USA World Cup 2026 Squad Review: Playing at Home for the First Time Since 1994',
   'USA World Cup 2026 squad review. Pulisic, Reyna, and Pochettino’s host nation squad. Full breakdown, Group D fixtures, and honest assessment of how far the USMNT can go on home soil.',
   'USA World Cup 2026 squad review. Pulisic, Reyna, and Pochettino’s host nation squad. Full breakdown, Group D fixtures, and honest assessment of how far the USMNT can go on home soil.

## Squad and Coach

| | |
| --- | --- |
| **Team** | United States national soccer team |
| **Nickname** | USMNT |
| **Head coach** | Mauricio Pochettino |

### Players to watch

- Christian Pulisic
- Gio Reyna
- Tyler Adams
- Matt Turner
- Weston McKennie',
   '/images/2026/06/Germany_lifts_the_2014_FIFA_World_Cup-2.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'USA World Cup 2026 Squad Review: Playing at Home for the First Time Since 1994 - Of The Pitch',
   'USA World Cup 2026 squad review. Pulisic, Reyna, and Pochettino''s host nation squad. Full breakdown, Group D fixtures, and honest assessment of how far the USMNT can go on home soil.',
   '[]'::jsonb, '2026-06-09T13:46:47Z', '2026-06-22T07:27:46Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] brazil-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('cd2a7bed-eeb9-572b-b287-97f8824fd59c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'brazil-world-cup-2026-squad-review',
   'Brazil World Cup 2026 Squad Review: The New Generation and the Weight of Expectation',
   'Brazil World Cup 2026 squad review. Vinicius Jr, Neymar, and Ancelotti’s mission. Full squad breakdown, Group C fixtures, and honest verdict on Brazil’s title chances.',
   'Brazil World Cup 2026 squad review. Vinicius Jr, Neymar, and Ancelotti’s mission. Full squad breakdown, Group C fixtures, and honest verdict on Brazil’s title chances.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Brazil national football team |
| **Nickname** | A Selecao |
| **Head coach** | Carlo Ancelotti |

### Players to watch

- Vinicius Jr
- Rodrygo
- Casemiro
- Marquinhos
- Alisson Becker',
   '/images/2026/06/Vinicius_Jr_2021.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Brazil World Cup 2026 Squad Review: The New Generation and the Weight of Expectation - Of The Pitch',
   'Brazil World Cup 2026 squad review. Vinicius Jr, Neymar, and Ancelotti''s mission. Full squad breakdown, Group C fixtures, and honest verdict on Brazil''s title chances.',
   '[]'::jsonb, '2026-06-08T14:51:09Z', '2026-06-22T07:27:45Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] spain-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('bf68be02-6299-5691-9b15-bdd72f709bcd', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'spain-world-cup-2026-squad-review',
   'Spain World Cup 2026 Squad Review: Back to Back Champions or One Tournament Too Many',
   'Spain World Cup 2026 squad review. Yamal, Pedri, Rodri and Euro 2024 champions. Full breakdown of La Roja squad, Group H fixtures, and honest assessment of their title chances.',
   'Spain World Cup 2026 squad review. Yamal, Pedri, Rodri and Euro 2024 champions. Full breakdown of La Roja squad, Group H fixtures, and honest assessment of their title chances.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Spain national football team |
| **Nickname** | La Roja |
| **Head coach** | Luis de la Fuente |

### Players to watch

- Lamine Yamal
- Pedri
- Rodri
- Dani Olmo
- Alvaro Morata',
   '/images/2026/06/Sergio_Ramos_Euro_2012_vs_France_02.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Spain World Cup 2026 Squad Review: Back to Back Champions or One Tournament Too Many - Of The Pitch',
   'Spain World Cup 2026 squad review. Yamal, Pedri, Rodri and Euro 2024 champions. Full breakdown of La Roja squad, Group H fixtures, and honest assessment of their title chances.',
   '[]'::jsonb, '2026-06-07T14:51:41Z', '2026-06-22T07:27:44Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] germany-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('d6d37c51-c456-5acc-ac82-06551f0771cb', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'germany-world-cup-2026-squad-review',
   'Germany World Cup 2026 Squad Review: Rebuilding Under Nagelsmann at the Right Moment',
   'Germany World Cup 2026 squad review. Wirtz, Musiala, Neuer and Nagelsmann rebuild. Full squad breakdown, Group E fixtures, and whether Germany can end their group stage curse.',
   'Germany World Cup 2026 squad review. Wirtz, Musiala, Neuer and Nagelsmann rebuild. Full squad breakdown, Group E fixtures, and whether Germany can end their group stage curse.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Germany national football team |
| **Nickname** | Die Mannschaft |
| **Head coach** | Julian Nagelsmann |

### Players to watch

- Florian Wirtz
- Jamal Musiala
- Manuel Neuer
- Kai Havertz
- Toni Kross',
   '/images/2026/06/Germany_lifts_the_2014_FIFA_World_Cup.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Germany World Cup 2026 Squad Review: Rebuilding Under Nagelsmann at the Right Moment - Of The Pitch',
   'Germany World Cup 2026 squad review. Wirtz, Musiala, Neuer and Nagelsmann rebuild. Full squad breakdown, Group E fixtures, and whether Germany can end their group stage curse.',
   '[]'::jsonb, '2026-06-06T09:21:48Z', '2026-06-22T07:27:42Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] england-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('c7dbc1be-cef0-561c-85b2-476b2b7cbda2', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'england-world-cup-2026-squad-review',
   'England World Cup 2026 Squad Review: Good Enough to Finally Win It',
   'England World Cup 2026 squad review. Kane, Bellingham, Saka, and Tuchel’s controversial picks. Full breakdown and honest verdict on whether England can finally win it.',
   'England World Cup 2026 squad review. Kane, Bellingham, Saka, and Tuchel’s controversial picks. Full breakdown and honest verdict on whether England can finally win it.

## Squad and Coach

| | |
| --- | --- |
| **Team** | England national football team |
| **Nickname** | The Three Lions |
| **Head coach** | Thomas Tuchel |

### Players to watch

- Harry Kane
- Jude Bellingham
- Bukayo Saka
- Phil Foden
- Declan Rice',
   '/images/2026/06/Harry_Kane_2015.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'England World Cup 2026 Squad Review: Good Enough to Finally Win It - Of The Pitch',
   'England World Cup 2026 squad review. Kane, Bellingham, Saka, and Tuchel''s controversial picks. Full breakdown and honest verdict on whether England can finally win it.',
   '[]'::jsonb, '2026-06-06T09:17:36Z', '2026-06-22T07:27:40Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] france-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('c657ac37-d45c-5152-963d-562bb91efb2b', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'france-world-cup-2026-squad-review',
   'France World Cup 2026 Squad Review: The Most Talented Squad in the Tournament',
   'France World Cup 2026 squad review. Mbappe, Dembele, and the world favourites. Full breakdown of Les Bleus squad, key players, Group I fixtures, and title verdict.',
   'France World Cup 2026 squad review. Mbappe, Dembele, and the world favourites. Full breakdown of Les Bleus squad, key players, Group I fixtures, and title verdict.

## Squad and Coach

| | |
| --- | --- |
| **Team** | France national football team |
| **Nickname** | Les Bleus |
| **Head coach** | Didier Deschamps |

### Players to watch

- Kylian Mbappe
- Ousmane Dembele
- Antoine Griezmann
- Adrien Rabiot
- Mike Maignan',
   '/images/2026/06/Argentina_vs_France_2018_World_Cup_08-1.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'France World Cup 2026 Squad Review: The Most Talented Squad in the Tournament - Of The Pitch',
   'France World Cup 2026 squad review. Mbappe, Dembele, and the world favourites. Full breakdown of Les Bleus squad, key players, Group I fixtures, and title verdict.',
   '[]'::jsonb, '2026-06-06T08:51:48Z', '2026-06-22T07:27:41Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] argentina-world-cup-2026-squad-review
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('a8c870a1-1ef8-5b2d-bece-de5d5806426e', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'argentina-world-cup-2026-squad-review',
   'Argentina World Cup 2026 Squad Review: Can Messi Win It One Last Time',
   'Argentina World Cup 2026 squad review. Can Messi win it one last time at 38? Full squad breakdown, key players, Group J fixtures, and honest assessment of their title chances.',
   'Argentina World Cup 2026 squad review. Can Messi win it one last time at 38? Full squad breakdown, key players, Group J fixtures, and honest assessment of their title chances.

## Squad and Coach

| | |
| --- | --- |
| **Team** | Argentina national football team |
| **Nickname** | La Albiceleste |
| **Head coach** | Lionel Scaloni |

### Players to watch

- Lionel Messi
- Julian Alvarez
- Rodrigo De Paul
- Emiliano Martinez
- Lautaro Martinez',
   '/images/2026/06/Lionel_Messi_WC2022.jpg', 'a190ca80-f71c-5fee-a044-6e8df6d7f280', '{}', 'published',
   'Argentina World Cup 2026 Squad Review: Can Messi Win It One Last Time - Of The Pitch',
   'Argentina World Cup 2026 squad review. Can Messi win it one last time at 38? Full squad breakdown, key players, Group J fixtures, and honest assessment of their title chances.',
   '[]'::jsonb, '2026-06-06T08:47:36Z', '2026-06-22T07:27:38Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] boston-to-new-york-world-cup-2026-travel
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('95511447-46f3-5c82-b85f-8c8462b77776', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'boston-to-new-york-world-cup-2026-travel',
   'Boston to New York World Cup 2026: Train, Bus and Drive Which Is Fastest on Match Days',
   'Boston to New York for World Cup 2026: Amtrak takes 3.5 to 4 hours. Complete guide to train, bus, and driving, with match day advice for both cities and stadium transit tips.',
   'Boston to New York for World Cup 2026: Amtrak takes 3.5 to 4 hours. Complete guide to train, bus, and driving, with match day advice for both cities and stadium transit tips.',
   '/images/2026/06/Amtrak_Northeast_Regional_train_at_Ruggles_March_2025.jpg', 'ced3e2d1-82fe-5b9d-b191-c9b225323144', '{}', 'published',
   'Boston to New York World Cup 2026: Train, Bus and Drive Which Is Fastest on Match Days - Of The Pitch',
   'Boston to New York for World Cup 2026: Amtrak takes 3.5 to 4 hours. Complete guide to train, bus, and driving, with match day advice for both cities and stadium transit tips.',
   '[{"question": "How long does Amtrak take from Boston to New York?", "answer": "Amtrak Northeast Regional takes 3 hours 45 minutes to 4 hours 15 minutes. The Acela takes 3 hours 30 minutes but costs significantly more."}, {"question": "Can I take the bus from Boston to New York for World Cup matches?", "answer": "Yes. FlixBus, Greyhound, and Peter Pan all operate Boston to New York. Journey time is 4 to 5 hours depending on traffic. Fares are typically under $30 booked in advance."}, {"question": "How far is it from Boston to New York by car?", "answer": "Boston to New York is approximately 215 miles by road. Drive time is 3.5 hours in normal conditions but 5 to 6 hours on match days due to traffic around MetLife Stadium."}, {"question": "Where does England play at World Cup 2026?", "answer": "England plays their group stage matches at MetLife Stadium in New Jersey, near New York. That makes a Boston to New York trip viable for England fans attending both Boston and New York games."}]'::jsonb, '2026-06-05T20:18:51Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] los-angeles-to-seattle-world-cup-2026-travel
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('78e004e1-d6e4-5938-adc9-ce769afd66b7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'los-angeles-to-seattle-world-cup-2026-travel',
   'Los Angeles to Seattle World Cup 2026: Flights, Amtrak Coast Starlight and Road Trip',
   'Los Angeles to Seattle for World Cup 2026: fly in 2h45m, drive 18 hours, or take the scenic Coast Starlight in 35 hours. Prices, tips and match schedule for both cities.',
   'Los Angeles to Seattle for World Cup 2026: fly in 2h45m, drive 18 hours, or take the scenic Coast Starlight in 35 hours. Prices, tips and match schedule for both cities.',
   '/images/2026/06/The_Coast_Starlight_at_Emeryville_California_-_panoramio.jpg', 'ced3e2d1-82fe-5b9d-b191-c9b225323144', '{}', 'published',
   'Los Angeles to Seattle World Cup 2026: Flights, Amtrak Coast Starlight and Road Trip - Of The Pitch',
   'Los Angeles to Seattle for World Cup 2026: fly in 2h45m, drive 18 hours, or take the scenic Coast Starlight in 35 hours. Prices, tips and match schedule for both cities.',
   '[{"question": "How long is the flight from Los Angeles to Seattle?", "answer": "Flights from LAX to SEA take 2 hours 30 minutes to 2 hours 50 minutes. Multiple airlines operate this route including Alaska, Delta, United, and Southwest."}, {"question": "Can I take the train from Los Angeles to Seattle for the World Cup?", "answer": "Yes. Amtrak Coast Starlight runs Los Angeles to Seattle in approximately 35 hours. It is a scenic overnight route but not practical for same-day match travel."}, {"question": "How far is it from Los Angeles to Seattle by car?", "answer": "Los Angeles to Seattle is approximately 1,135 miles by road via I-5. Drive time is 17 to 19 hours non-stop, making it a multi-day road trip rather than a day trip."}, {"question": "Which teams play in Seattle at World Cup 2026?", "answer": "Lumen Field in Seattle hosts multiple group stage matches. Check the official FIFA schedule for confirmed team assignments to Seattle matches."}]'::jsonb, '2026-06-05T19:48:51Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] new-york-to-philadelphia-world-cup-2026-travel
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('7d943fab-03f6-5838-bfc4-23f4820703c8', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'new-york-to-philadelphia-world-cup-2026-travel',
   'New York to Philadelphia World Cup 2026: The Easiest Cross-City Trip of the Tournament',
   'New York to Philadelphia for World Cup 2026: Amtrak takes under 90 minutes. Complete guide to train, bus, and driving between the two closest tournament host cities.',
   'New York to Philadelphia for World Cup 2026: Amtrak takes under 90 minutes. Complete guide to train, bus, and driving between the two closest tournament host cities.',
   '/images/2026/06/Acela_Express_Amtrak_at_Newark_Penn_Station.jpg', 'ced3e2d1-82fe-5b9d-b191-c9b225323144', '{}', 'published',
   'New York to Philadelphia World Cup 2026: The Easiest Cross-City Trip of the Tournament - Of The Pitch',
   'New York to Philadelphia for World Cup 2026: Amtrak takes under 90 minutes. Complete guide to train, bus, and driving between the two closest tournament host cities.',
   '[{"question": "How long does Amtrak take from New York to Philadelphia?", "answer": "Amtrak Northeast Regional takes 1 hour 5 minutes to 1 hour 20 minutes. The Acela takes around 55 minutes. Both run frequently from Penn Station."}, {"question": "Is there a bus from New York to Philadelphia for World Cup?", "answer": "Yes. Greyhound, FlixBus, and Megabus all operate the route. Journey time is 2 to 2.5 hours. Fares start from around $10 booked in advance."}, {"question": "How far is MetLife Stadium from Philadelphia?", "answer": "MetLife Stadium in East Rutherford, New Jersey is approximately 90 miles from Philadelphia. Drive time is 1.5 to 2 hours in normal conditions."}, {"question": "Which teams play in Philadelphia at World Cup 2026?", "answer": "Lincoln Financial Field in Philadelphia hosts multiple matches including group stage games and knockout round fixtures. Check the official FIFA schedule for confirmed match assignments."}]'::jsonb, '2026-06-05T19:18:51Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] dallas-to-kansas-city-world-cup-2026-travel
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('fa3385a7-de99-56eb-adfd-eb5b9ca68daf', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'dallas-to-kansas-city-world-cup-2026-travel',
   'Dallas to Kansas City for the World Cup: Flights, Trains and Road Trip Guide',
   'How to get from Dallas to Kansas City for World Cup 2026 matches. Flight time 2 hours, drive 8.5 hours, bus 11 to 13 hours. Prices, tips and match schedule for both cities.',
   'How to get from Dallas to Kansas City for World Cup 2026 matches. Flight time 2 hours, drive 8.5 hours, bus 11 to 13 hours. Prices, tips and match schedule for both cities.',
   '/images/2026/06/Union_Station_Kansas_City_2008.jpg', 'ced3e2d1-82fe-5b9d-b191-c9b225323144', '{}', 'published',
   'Dallas to Kansas City for the World Cup: Flights, Trains and Road Trip Guide - Of The Pitch',
   'How to get from Dallas to Kansas City for World Cup 2026 matches. Flight time 2 hours, drive 8.5 hours, bus 11 to 13 hours. Prices, tips and match schedule for both cities.',
   '[{"question": "How long is the flight from Dallas to Kansas City?", "answer": "Flights from Dallas to Kansas City take approximately 1 hour 45 minutes to 2 hours. American Airlines and Southwest operate direct routes from DFW and DAL."}, {"question": "Can I drive from Dallas to Kansas City for World Cup?", "answer": "Yes. Dallas to Kansas City is approximately 500 miles via I-35. Drive time is 7.5 to 8.5 hours in normal conditions."}, {"question": "Is there a train from Dallas to Kansas City?", "answer": "Amtrak does not offer a direct route from Dallas to Kansas City. The Texas Eagle connects Dallas to Chicago but does not serve Kansas City directly."}, {"question": "What World Cup matches are in Kansas City?", "answer": "Arrowhead Stadium in Kansas City hosts multiple group stage and knockout matches. Check the official FIFA 2026 schedule for confirmed team assignments."}]'::jsonb, '2026-06-05T19:15:08Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] miami-to-atlanta-world-cup-2026-travel
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('a57b3efc-606e-505f-b004-e9cb8b317796', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'miami-to-atlanta-world-cup-2026-travel',
   'Miami to Atlanta World Cup 2026: How to Get Between the Two Closest Host Cities',
   'Miami to Atlanta for World Cup 2026: flight 4 to 5 hours, drive 10.5 hours, bus 12 to 15 hours. Full guide with prices, match schedule, and transport tips for both cities.',
   'Miami to Atlanta for World Cup 2026: flight 4 to 5 hours, drive 10.5 hours, bus 12 to 15 hours. Full guide with prices, match schedule, and transport tips for both cities.',
   '/images/2026/06/Aerial_view_of_Miamis_skyline.jpg', 'ced3e2d1-82fe-5b9d-b191-c9b225323144', '{}', 'published',
   'Miami to Atlanta World Cup 2026: How to Get Between the Two Closest Host Cities - Of The Pitch',
   'Miami to Atlanta for World Cup 2026: flight 4 to 5 hours, drive 10.5 hours, bus 12 to 15 hours. Full guide with prices, match schedule, and transport tips for both cities.',
   '[{"question": "How long is the flight from Miami to Atlanta?", "answer": "Flights from Miami to Atlanta take 1 hour 40 minutes to 2 hours. Delta, American, and Spirit operate this route frequently from MIA and FLL."}, {"question": "Can I drive from Miami to Atlanta for World Cup matches?", "answer": "Yes. Miami to Atlanta is approximately 660 miles via I-75. Drive time is 9 to 10 hours in normal conditions, longer on match days."}, {"question": "Is there a bus from Miami to Atlanta?", "answer": "Yes. Greyhound and FlixBus operate Miami to Atlanta. Journey time is 12 to 15 hours. This is the slowest option but the cheapest, with fares from around $25."}, {"question": "Which teams play in Atlanta at World Cup 2026?", "answer": "Mercedes-Benz Stadium in Atlanta hosts multiple group stage and knockout matches. Check the official FIFA 2026 schedule for confirmed team assignments."}]'::jsonb, '2026-06-05T18:48:51Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-travel-between-host-cities
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('9d5d1f08-5324-591e-8a7f-ec0f739c42f0', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-travel-between-host-cities',
   'How to Travel Between World Cup 2026 Host Cities: The Complete Inter-City Guide',
   'Complete guide to traveling between all 11 World Cup 2026 US host cities by flight, Amtrak, bus, and road trip. Prices, times, and cluster strategy for multi-city fans.',
   'Complete guide to traveling between all 11 World Cup 2026 US host cities by flight, Amtrak, bus, and road trip. Prices, times, and cluster strategy for multi-city fans.',
   '/images/2026/06/Amtrak_Northeast_Regional_train_at_South_Station.jpg', 'ced3e2d1-82fe-5b9d-b191-c9b225323144', '{}', 'published',
   'How to Travel Between World Cup 2026 Host Cities: The Complete Inter-City Guide - Of The Pitch',
   'Complete guide to traveling between all 11 World Cup 2026 US host cities by flight, Amtrak, bus, and road trip. Prices, times, and cluster strategy for multi-city fans.',
   '[{"question": "Which host cities are closest together at World Cup 2026?", "answer": "New York and Philadelphia are the closest pair at approximately 90 miles apart, connected by Amtrak in around 70 minutes. Boston and New York are also close at 215 miles."}, {"question": "Can I fly between all World Cup 2026 host cities?", "answer": "Yes. All 11 US host cities have major airports with direct or connecting flights. Flying is the fastest option for long-distance pairs like Los Angeles to Boston or Miami to Seattle."}, {"question": "Is there a train route covering multiple World Cup host cities?", "answer": "Amtrak Northeast Corridor covers New York, Philadelphia, and Boston. Other routes are limited. Flying is recommended for cities outside the northeast corridor."}, {"question": "Which World Cup 2026 host city is easiest to reach by car?", "answer": "Dallas, Kansas City, and Houston form a triangle in the south-central US that is driveable within a day for fans following teams playing across those cities."}]'::jsonb, '2026-06-05T18:45:08Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-south-africa-supersport-sabc-free
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('8ee56c61-cf64-5978-b25a-cdaf73ff0f4f', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-south-africa-supersport-sabc-free',
   'How to Watch World Cup 2026 in South Africa: SuperSport, SABC and Free Options',
   'SABC broadcasts 34 World Cup 2026 matches free in South Africa including all Bafana Bafana games and the Final. SuperSport has all 104 on DStv Access. SportyTV is a new streaming option.',
   'SABC broadcasts 34 World Cup 2026 matches free in South Africa including all Bafana Bafana games and the Final. SuperSport has all 104 on DStv Access. SportyTV is a new streaming option.',
   '/images/2026/06/Table_Mountain_Cape_Town.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in South Africa: SuperSport, SABC and Free Options - Of The Pitch',
   'SABC broadcasts 34 World Cup 2026 matches free in South Africa including all Bafana Bafana games and the Final. SuperSport has all 104 on DStv Access. SportyTV is a new streaming option.',
   '[{"question": "Is the World Cup 2026 free to watch in South Africa?", "answer": "SABC broadcasts 34 matches free on SABC 3, including all Bafana Bafana games if they qualify and selected group stage and knockout matches. SuperSport has all 104 matches on DStv."}, {"question": "Which channel has World Cup 2026 in South Africa?", "answer": "SuperSport has all 104 World Cup 2026 matches on DStv. SABC 3 has 34 free-to-air matches. Streaming is available via DStv App for SuperSport subscribers."}, {"question": "Can I watch World Cup 2026 on SABC for free in South Africa?", "answer": "Yes. SABC 3 broadcasts 34 World Cup 2026 matches free with no subscription. The remaining 70 matches are exclusive to SuperSport on DStv."}, {"question": "What time do World Cup 2026 matches kick off in South Africa?", "answer": "Most World Cup 2026 group stage matches kick off at 3pm, 6pm, or 9pm Eastern Time USA. South Africa is 6 hours ahead, meaning 9pm, midnight, or 3am SAST."}]'::jsonb, '2026-06-03T18:00:52Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-germany-ard-zdf-magentatv
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('b86839cc-c49b-5fa6-b0cb-b0e69b1ec8b8', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-germany-ard-zdf-magentatv',
   'How to Watch World Cup 2026 in Germany: ARD, ZDF and Free Live Streaming',
   'MagentaTV has all 104 World Cup 2026 matches in Germany. ARD and ZDF share 60 free matches including all Germany games. Complete guide with match times in CEST and streaming setup.',
   'MagentaTV has all 104 World Cup 2026 matches in Germany. ARD and ZDF share 60 free matches including all Germany games. Complete guide with match times in CEST and streaming setup.',
   '/images/2026/06/Berlin_Brandenburg_Gate.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in Germany: ARD, ZDF and Free Live Streaming - Of The Pitch',
   'MagentaTV has all 104 World Cup 2026 matches in Germany. ARD and ZDF share 60 free matches including all Germany games. Complete guide with match times in CEST and streaming setup.',
   '[{"question": "Is World Cup 2026 free to watch in Germany?", "answer": "ARD and ZDF broadcast 60 World Cup 2026 matches free in Germany, shared between the two public broadcasters. MagentaTV has all 104 matches for subscribers."}, {"question": "Which channel shows World Cup 2026 in Germany?", "answer": "ARD (Das Erste) and ZDF share 60 free matches. MagentaTV (Telekom) has exclusive rights to all 104 matches. Sky has no World Cup 2026 rights in Germany."}, {"question": "Can I stream World Cup 2026 free in Germany?", "answer": "Yes. ARD and ZDF matches stream free on ARD Mediathek and ZDF Mediathek with no subscription. MagentaTV streaming requires a Telekom subscription."}, {"question": "What time do World Cup 2026 matches kick off in Germany?", "answer": "Group stage matches kick off at 9pm, midnight, or 3am CEST (Central European Summer Time). Germany is 6 hours ahead of Eastern Time USA."}]'::jsonb, '2026-06-02T17:22:36Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-canada-ctv-tsn-free-stream
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('5f52ace1-a184-5065-854d-1a7774bba1cf', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-canada-ctv-tsn-free-stream',
   'How to Watch World Cup 2026 in Canada: CTV, TSN and Every Free Stream',
   'CTV broadcasts Canada World Cup 2026 games free. TSN has all 104 matches. Bell Media holds exclusive rights. DAZN has no coverage. Complete guide for Canadian fans including TSN Direct pricing and kickoff times.',
   'CTV broadcasts Canada World Cup 2026 games free. TSN has all 104 matches. Bell Media holds exclusive rights. DAZN has no coverage. Complete guide for Canadian fans including TSN Direct pricing and kickoff times.',
   '/images/2026/06/Skyline_Toronto.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in Canada: CTV, TSN and Every Free Stream - Of The Pitch',
   'CTV broadcasts Canada World Cup 2026 games free. TSN has all 104 matches. Bell Media holds exclusive rights. DAZN has no coverage. Complete guide for Canadian fans including TSN Direct pricing and kickoff times.',
   '[{"question": "Is World Cup 2026 free to watch in Canada?", "answer": "CTV broadcasts Canada World Cup 2026 matches free with no subscription. TSN and RDS have all 104 matches but require a cable or streaming subscription."}, {"question": "Which channel shows World Cup 2026 in Canada?", "answer": "TSN has all 104 matches on English language channels. RDS covers French language broadcasts. CTV broadcasts select matches including all Canada games free."}, {"question": "Can I stream World Cup 2026 free in Canada?", "answer": "Yes. Canada’s games are free on CTV and streamable via CTV.ca. TSN+ streaming requires a subscription."}, {"question": "What time do World Cup 2026 matches kick off in Canada?", "answer": "Match times vary by time zone. Toronto and Montreal are on Eastern Time. Vancouver is 3 hours behind. Group stage matches kick off at 3pm, 6pm, or 9pm ET."}]'::jsonb, '2026-06-01T18:38:11Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-nigeria-supersport-dstv
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('afd63938-85a8-5c4d-a849-9beb696b80fb', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-nigeria-supersport-dstv',
   'How to Watch World Cup 2026 in Nigeria: SuperSport, DSTV and Free Options',
   'SuperSport broadcasts all 104 World Cup 2026 matches in Nigeria on DStv and GOtv including the Access tier for the first time. New World TV provides 34 free matches. Full guide for Nigerian fans.',
   'SuperSport broadcasts all 104 World Cup 2026 matches in Nigeria on DStv and GOtv including the Access tier for the first time. New World TV provides 34 free matches. Full guide for Nigerian fans.',
   '/images/2026/05/AbujaNationalMosque-1.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in Nigeria: SuperSport, DSTV and Free Options - Of The Pitch',
   'SuperSport broadcasts all 104 World Cup 2026 matches in Nigeria on DStv and GOtv including the Access tier for the first time. New World TV provides 34 free matches. Full guide for Nigerian fans.',
   '[{"question": "Is World Cup 2026 free to watch in Nigeria?", "answer": "SuperSport on DStv and GOtv has all 104 World Cup 2026 matches in Nigeria. There is no confirmed free-to-air broadcaster for all matches. GOtv offers a lower-cost subscription option."}, {"question": "Which channel shows World Cup 2026 in Nigeria?", "answer": "SuperSport is the official rights holder in Nigeria with all 104 matches across DStv and GOtv packages. The Access package on GOtv is the most affordable entry point."}, {"question": "Can I watch World Cup 2026 without DStv in Nigeria?", "answer": "GOtv Access is a lower-cost alternative to DStv with SuperSport match access. No confirmed free-to-air broadcaster has been announced for Nigeria as of mid-2026."}, {"question": "What time do World Cup 2026 matches kick off in Nigeria?", "answer": "Nigeria is on West Africa Time (WAT), 5 hours ahead of Eastern Time USA. Group stage matches kick off at 8pm, 11pm, or 2am WAT."}]'::jsonb, '2026-05-31T14:44:02Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-without-cable-free-paid-streaming
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('d43af5af-12be-504c-8736-d225380aa75c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-without-cable-free-paid-streaming',
   'How to Watch World Cup 2026 Without Cable: Every Free and Paid Streaming Option',
   'Watch World Cup 2026 without cable using a TV antenna plus FOX One or Peacock in the US. Free options in the UK and Australia. Full cord-cutter guide with VPN advice for every market.',
   'Watch World Cup 2026 without cable using a TV antenna plus FOX One or Peacock in the US. Free options in the UK and Australia. Full cord-cutter guide with VPN advice for every market.',
   '/images/2026/05/Metlife_stadium-2.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 Without Cable: Every Free and Paid Streaming Option - Of The Pitch',
   'Watch World Cup 2026 without cable using a TV antenna plus FOX One or Peacock in the US. Free options in the UK and Australia. Full cord-cutter guide with VPN advice for every market.',
   '[{"question": "Can I watch World Cup 2026 without cable?", "answer": "Yes. In the USA, 70 matches are free on FOX broadcast network with a TV antenna. FOX One app streams matches with no cable subscription required, though some features need a subscription."}, {"question": "Is World Cup 2026 on Peacock?", "answer": "Telemundo Deportes streams all Spanish-language World Cup 2026 coverage on Peacock. A Peacock Premium subscription is required for streaming access."}, {"question": "Can I watch World Cup 2026 on YouTube?", "answer": "No. YouTube has no live World Cup 2026 broadcasting rights in the USA. FOX One and Telemundo’s apps are the official digital streaming options."}, {"question": "Is World Cup 2026 on Amazon Prime Video?", "answer": "Amazon Prime Video has no World Cup 2026 broadcasting rights in the USA. FOX Sports and Telemundo hold exclusive rights for English and Spanish language coverage respectively."}]'::jsonb, '2026-05-30T14:28:28Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-usa-fox-sports-telemundo-streaming
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('f243e161-756f-534e-b652-45e1a40b7a2f', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-usa-fox-sports-telemundo-streaming',
   'How to Watch World Cup 2026 in the USA: Fox Sports, Telemundo and Every Streaming Option',
   'FOX Sports and Telemundo cover all 104 World Cup 2026 matches in the USA. 70 matches free on FOX. Stream in 4K on FOX One. Full guide to every English and Spanish streaming option.',
   'FOX Sports and Telemundo cover all 104 World Cup 2026 matches in the USA. 70 matches free on FOX. Stream in 4K on FOX One. Full guide to every English and Spanish streaming option.',
   '/images/2026/05/Metlife_stadium-1.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in the USA: Fox Sports, Telemundo and Every Streaming Option - Of The Pitch',
   'FOX Sports and Telemundo cover all 104 World Cup 2026 matches in the USA. 70 matches free on FOX. Stream in 4K on FOX One. Full guide to every English and Spanish streaming option.',
   '[{"question": "Is World Cup 2026 free on FOX in the USA?", "answer": "70 of 104 World Cup 2026 matches are free on the FOX broadcast network. The remaining 34 are exclusive to FS1. A TV antenna picks up FOX free of charge."}, {"question": "Can I watch World Cup 2026 in 4K in the USA?", "answer": "Yes. FOX Sports streams select World Cup 2026 matches in 4K HDR via the FOX One app. FS1 4K coverage is available for some matches on compatible streaming devices."}, {"question": "What channel is World Cup 2026 on in the USA?", "answer": "English language: FOX (broadcast) and FS1 (cable). Spanish language: Telemundo (broadcast) and UNIVERSO (cable). FOX and Telemundo are both available free over the air."}, {"question": "Is World Cup 2026 on ESPN or ABC in the USA?", "answer": "No. ESPN and ABC do not hold World Cup 2026 broadcasting rights in the USA. FOX Sports and Telemundo are the exclusive rights holders for this tournament."}, {"question": "Can I stream World Cup 2026 on Fubo or Sling in the USA?", "answer": "Yes. FuboTV includes FOX and FS1 in its packages. Sling includes FOX with its Blue plan. Both require a subscription but include all World Cup 2026 matches on FOX and FS1."}]'::jsonb, '2026-05-29T16:42:44Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-india-jiocinema-sports18-free-streaming
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('a4fbcc9d-7ee6-580a-b79d-3514e0f0f6fb', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-india-jiocinema-sports18-free-streaming',
   'How to Watch World Cup 2026 in India: JioCinema, Sports18 and Free Streaming Guide',
   'No confirmed broadcaster for World Cup 2026 in India as of May 2026. JioCinema and Sports18 do not hold rights. Doordarshan in talks. Full viewing options for Indian fans updated May 12 2026.',
   'No confirmed broadcaster for World Cup 2026 in India as of May 2026. JioCinema and Sports18 do not hold rights. Doordarshan in talks. Full viewing options for Indian fans updated May 12 2026.',
   '/images/2026/05/Gateway_of_India_-_September_2016.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in India: JioCinema, Sports18 and Free Streaming Guide - Of The Pitch',
   'No confirmed broadcaster for World Cup 2026 in India as of May 2026. JioCinema and Sports18 do not hold rights. Doordarshan in talks. Full viewing options for Indian fans updated May 12 2026.',
   '[{"question": "Where can I watch World Cup 2026 in India?", "answer": "As of June 2026, no official broadcaster has been confirmed for World Cup 2026 in India. JioCinema and Sports18, which held rights for Qatar 2022, have not confirmed renewal."}, {"question": "Will JioCinema show World Cup 2026 in India?", "answer": "JioCinema held rights for FIFA World Cup 2022. As of mid-2026, a new rights deal for World Cup 2026 in India has not been publicly confirmed. Check JioCinema’s app for updates."}, {"question": "Can I use a VPN to watch World Cup 2026 in India?", "answer": "Using a VPN to access geo-restricted content may violate terms of service of the streaming platform. BBC iPlayer, ITV, and SBS have geo-restrictions. Legal local options are recommended."}, {"question": "What time do World Cup 2026 matches kick off in India?", "answer": "India is on IST, 9.5 hours ahead of Eastern Time USA. Group stage matches kick off at 12:30am, 3:30am, or 6:30am IST."}]'::jsonb, '2026-05-28T16:53:40Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-pakistan-ptv-sports-ary-live-stream
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('d7169db9-9fac-5914-9f75-e3e38a27506c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-pakistan-ptv-sports-ary-live-stream',
   'How to Watch World Cup 2026 in Pakistan: PTV Sports, ARY and Free Live Stream Options',
   'No confirmed broadcaster for World Cup 2026 in Pakistan as of May 2026. PTV Sports and ARY do not hold rights. Full options guide for Pakistani fans including FIFA Plus, VPN, and timing guide.',
   'No confirmed broadcaster for World Cup 2026 in Pakistan as of May 2026. PTV Sports and ARY do not hold rights. Full options guide for Pakistani fans including FIFA Plus, VPN, and timing guide.',
   '/images/2026/05/Blue_Hour_Pakistan_Monument-1.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in Pakistan: PTV Sports, ARY and Free Live Stream Options - Of The Pitch',
   'No confirmed broadcaster for World Cup 2026 in Pakistan as of May 2026. PTV Sports and ARY do not hold rights. Full options guide for Pakistani fans including FIFA Plus, VPN, and timing guide.',
   '[{"question": "Where can I watch World Cup 2026 in Pakistan?", "answer": "As of June 2026, no official broadcaster has been confirmed for World Cup 2026 in Pakistan. PTV Sports and ARY held some rights in past tournaments but have not confirmed 2026."}, {"question": "Will PTV Sports show World Cup 2026?", "answer": "PTV Sports broadcast some World Cup content in previous cycles. No confirmed deal for 2026 has been announced as of June 2026. Check PTV Sports’ official channels for updates."}, {"question": "What time do World Cup 2026 matches kick off in Pakistan?", "answer": "Pakistan is on PKT, 9 hours ahead of Eastern Time USA. Group stage matches kick off at midnight, 3am, or 6am PKT."}, {"question": "Can I watch World Cup 2026 free in Pakistan?", "answer": "No confirmed free broadcaster has been announced for World Cup 2026 in Pakistan. Fans should monitor PTV Sports and ARY for any last-minute rights announcements."}]'::jsonb, '2026-05-27T16:36:58Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-australia-sbs-free-streaming
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('e908b554-d9ca-5e41-ad39-712f82582aff', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-australia-sbs-free-streaming',
   'How to Watch World Cup 2026 in Australia: Optus Sport, SBS and Free Streaming Guide',
   'SBS broadcasts all 104 World Cup 2026 matches free in Australia. No Optus. No subscription. Stream on SBS On Demand. Full kick-off times in AEST and VPN guide for Australians traveling abroad.',
   'SBS broadcasts all 104 World Cup 2026 matches free in Australia. No Optus. No subscription. Stream on SBS On Demand. Full kick-off times in AEST and VPN guide for Australians traveling abroad.',
   '/images/2026/05/Sydney_Opera_House_-_Dec_2008.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in Australia: Optus Sport, SBS and Free Streaming Guide - Of The Pitch',
   'SBS broadcasts all 104 World Cup 2026 matches free in Australia. No Optus. No subscription. Stream on SBS On Demand. Full kick-off times in AEST and VPN guide for Australians traveling abroad.',
   '[{"question": "Is World Cup 2026 free in Australia?", "answer": "Yes. SBS has all 104 World Cup 2026 matches free in Australia on SBS and SBS On Demand. No subscription is required."}, {"question": "Which channel shows World Cup 2026 in Australia?", "answer": "SBS is the official free-to-air broadcaster with all 104 matches. Optus Sport, which had World Cup 2022 rights, does not hold 2026 rights. SBS On Demand streams all matches free."}, {"question": "Can I stream World Cup 2026 free in Australia?", "answer": "Yes. SBS On Demand streams every match live and on-demand for free. No account or subscription is required to watch."}, {"question": "What time do World Cup 2026 matches kick off in Australia?", "answer": "AEST is 14 hours ahead of Eastern Time USA. Group stage matches kick off at 5am, 8am, or 11am AEST. Sydney and Melbourne are AEST. Perth is AWST, 2 hours behind."}]'::jsonb, '2026-05-26T16:42:42Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-uk-bbc-itv-free
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('7dea9337-c215-5409-8cc8-7ff0e69cd9f7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-uk-bbc-itv-free',
   'How to Watch World Cup 2026 in the UK: BBC, ITV and Every Free Option',
   'Every World Cup 2026 match is free in the UK on BBC and ITV. Stream live on BBC iPlayer and ITVX with no subscription. England and Scotland fixtures, kick-off times, and VPN guide.',
   'Every World Cup 2026 match is free in the UK on BBC and ITV. Stream live on BBC iPlayer and ITVX with no subscription. England and Scotland fixtures, kick-off times, and VPN guide.',
   '/images/2026/05/London_-_Broadcasting_House.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 in the UK: BBC, ITV and Every Free Option - Of The Pitch',
   'Every World Cup 2026 match is free in the UK on BBC and ITV. Stream live on BBC iPlayer and ITVX with no subscription. England and Scotland fixtures, kick-off times, and VPN guide.',
   '[{"question": "Is World Cup 2026 free in the UK?", "answer": "Yes. Every match is free in the UK. BBC and ITV share all 104 matches. Stream on BBC iPlayer and ITVX with no subscription. A TV licence is required for live BBC viewing."}, {"question": "Which channel shows World Cup 2026 in the UK?", "answer": "BBC and ITV share all 104 World Cup 2026 matches. BBC One and ITV 1 broadcast matches on TV. BBC iPlayer and ITVX stream all matches for free online."}, {"question": "Can I watch World Cup 2026 on ITVX for free?", "answer": "Yes. ITVX streams all ITV matches live for free with no subscription. You need a free ITVX account to watch. No paid tier is required for World Cup content."}, {"question": "What time do World Cup 2026 matches kick off in the UK?", "answer": "The UK is BST during the World Cup, 5 hours ahead of Eastern Time USA. Group stage matches kick off at 8pm, 11pm, or 2am BST. Midnight and 2am kick-offs are for the later games."}, {"question": "Do I need a TV licence to watch World Cup 2026 on BBC?", "answer": "You need a TV licence to watch live BBC broadcasts. BBC iPlayer live streaming also requires a licence. ITV and ITVX have no licence requirement."}]'::jsonb, '2026-05-25T15:50:15Z', '2026-06-22T07:38:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-moroccan-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('72785704-e76c-53a1-8e60-96adc900f247', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-moroccan-fans',
   'World Cup 2026 Visa Guide for Moroccan Fans: US Visa, Canada eTA Shortcut and Mexico Entry',
   'Moroccan fans need a B1/B2 US visa with FIFA PASS priority. Canada eTA available if you have US visa. Mexico is visa-free. Best alternative if US visa is denied: fly directly to Mexico.',
   'Moroccan fans need a B1/B2 US visa with FIFA PASS priority. Canada eTA available if you have US visa. Mexico is visa-free. Best alternative if US visa is denied: fly directly to Mexico.',
   '/images/2026/05/Djemaa_el_Fna_1.jpg', '520d2f96-59b8-57aa-a01e-3a69136884e0', '{}', 'published',
   'World Cup 2026 Visa Guide for Moroccan Fans: US Visa, Canada eTA Shortcut and Mexico Entry - Of The Pitch',
   'Moroccan fans need a B1/B2 US visa with FIFA PASS priority. Canada eTA available if you have US visa. Mexico is visa-free. Best alternative if US visa is denied: fly directly to Mexico.',
   '[{"question": "Do Moroccan fans need a visa for World Cup 2026 in the USA?", "answer": "Yes. Moroccan passport holders need a B1/B2 US tourist visa. Morocco is not in the Visa Waiver Program. FIFA PASS can help prioritise visa processing."}, {"question": "Can Moroccan fans attend matches in Canada?", "answer": "Yes. Moroccan fans who hold a valid US visa can apply for a Canadian eTA instead of a full Canadian visa. The eTA costs CAD $7 and is processed online."}, {"question": "Is Mexico visa-free for Moroccan fans?", "answer": "Yes. Moroccan passport holders can enter Mexico visa-free for up to 180 days as tourists. Mexico City is not a World Cup 2026 host city but Guadalajara and Monterrey are."}, {"question": "What is FIFA PASS and how does it help Moroccan fans?", "answer": "FIFA PASS is a prioritisation system for World Cup 2026 ticketholders applying for US visas. It does not guarantee a visa but signals to consulates that you have a confirmed match booking."}]'::jsonb, '2026-05-25T14:14:27Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-watch-world-cup-2026-every-broadcaster-every-country
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('5d565fd6-83c6-5345-945e-0396abac2f4e', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-watch-world-cup-2026-every-broadcaster-every-country',
   'How to Watch World Cup 2026 From Anywhere: Every Broadcaster in Every Country',
   'Find every confirmed World Cup 2026 broadcaster by country. The UK and Australia are free. India and Pakistan have no deal yet. Full global guide updated May 2026.',
   'Find every confirmed World Cup 2026 broadcaster by country. The UK and Australia are free. India and Pakistan have no deal yet. Full global guide updated May 2026.',
   '/images/2026/05/Metlife_stadium.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'How to Watch World Cup 2026 From Anywhere: Every Broadcaster in Every Country - Of The Pitch',
   'Find every confirmed World Cup 2026 broadcaster by country. The UK and Australia are free. India and Pakistan have no deal yet. Full global guide updated May 2026.',
   '[{"question": "Which countries can watch World Cup 2026 for free?", "answer": "UK fans get all 104 matches free on BBC and ITV. Australian fans get all 104 matches free on SBS. South African fans get 34 matches free on SABC. US fans get 70 matches free on FOX."}, {"question": "Who has the broadcasting rights for World Cup 2026?", "answer": "Rights vary by country. FOX and Telemundo in USA, BBC and ITV in UK, SBS in Australia, MagentaTV in Germany, TSN and CTV in Canada, and SuperSport across much of Africa."}, {"question": "Is World Cup 2026 on Netflix?", "answer": "No. Netflix has no live sports broadcasting rights for World Cup 2026 in any country. Broadcasting is through traditional TV rights holders and their streaming apps."}, {"question": "Which countries have no confirmed World Cup 2026 broadcaster?", "answer": "As of June 2026, India and Pakistan do not have confirmed broadcasters for World Cup 2026. Fans in those countries should monitor official FIFA announcements for updates."}]'::jsonb, '2026-05-24T14:24:01Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-nigerian-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('9e0eba2b-ea8a-50ca-b5e3-b2afdd563fb4', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-nigerian-fans',
   'World Cup 2026 Visa Guide for Nigerian Fans: US Travel Ban, Canada TRV and Mexico Alternatives',
   'Nigerian fans cannot get US tourist visas due to partial travel ban. Attend Canada (TRV required) or Mexico (Mexican visa required) instead. Dual passport holders use their non-Nigerian passport.',
   'Nigerian fans cannot get US tourist visas due to partial travel ban. Attend Canada (TRV required) or Mexico (Mexican visa required) instead. Dual passport holders use their non-Nigerian passport.',
   '/images/2026/05/AbujaNationalMosque.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for Nigerian Fans: US Travel Ban, Canada TRV and Mexico Alternatives - Of The Pitch',
   'Nigerian fans cannot get US tourist visas due to partial travel ban. Attend Canada (TRV required) or Mexico (Mexican visa required) instead. Dual passport holders use their non-Nigerian passport.',
   '[{"question": "Can Nigerian fans get a US visa for World Cup 2026?", "answer": "Nigerian citizens face a partial US travel ban affecting B1/B2 tourist visas. Attend via Canada, which requires a TRV, or Mexico which is visa-free for Nigerian passport holders."}, {"question": "Can Nigerian fans attend World Cup matches in Canada?", "answer": "Yes. Canadian Temporary Resident Visas are available to Nigerian citizens. Canada hosts 13 matches including group stages in Toronto and Vancouver."}, {"question": "Is Mexico visa-free for Nigerian fans?", "answer": "Yes. Nigerian passport holders can enter Mexico visa-free. Guadalajara and Monterrey are Mexican host cities for World Cup 2026 group stage matches."}, {"question": "What is the US travel ban for Nigerian citizens?", "answer": "The US has imposed restrictions on B1/B2 tourist visa issuance for Nigerian citizens due to overstay and immigration concerns. Alternative host countries Canada and Mexico are accessible."}]'::jsonb, '2026-05-24T12:05:49Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] seattle-world-cup-2026-fan-zone-honest-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('49001afc-dbaa-5018-9c74-94209234503a', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'seattle-world-cup-2026-fan-zone-honest-guide',
   'Seattle World Cup 2026 Fan Zone: The Honest Guide to What Actually Happened',
   'Seattle’s World Cup fan zone was cut from a 74-acre campus to distributed downtown sites after federal funding froze. The matches at Lumen Field are happening. Honest guide to what actually exists.',
   'Seattle’s World Cup fan zone was cut from a 74-acre campus to distributed downtown sites after federal funding froze. The matches at Lumen Field are happening. Honest guide to what actually exists.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Seattle — World Cup 2026 |
| **Venue** | Downtown Seattle Sites |
| **Address** | Downtown Seattle, Seattle, WA, 98101 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Artistic_Design_on_Exterior_of_Lumen_Field_Stadium-1.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Seattle World Cup 2026 Fan Zone: The Honest Guide to What Actually Happened - Of The Pitch',
   'Seattle''s World Cup fan zone was cut from a 74-acre campus to distributed downtown sites after federal funding froze. The matches at Lumen Field are happening. Honest guide to what actually exists.',
   '[]'::jsonb, '2026-05-23T14:28:44Z', '2026-06-22T07:27:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-uk-england-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('16f4fa90-122d-5884-a68b-8456f156ef99', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-uk-england-fans',
   'World Cup 2026 Visa Guide for UK and England Fans: ESTA, Canada eTA and Mexico Entry',
   'UK fans use ESTA for the US (no interview, ~$21), Canada eTA for CAD $7, and Mexico is visa-free. England plays group stage in Dallas. Total documentation cost under $30.',
   'UK fans use ESTA for the US (no interview, ~$21), Canada eTA for CAD $7, and Mexico is visa-free. England plays group stage in Dallas. Total documentation cost under $30.',
   '/images/2026/05/Wembley_Stadium_during_London_2012_Olympic_Games.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for UK and England Fans: ESTA, Canada eTA and Mexico Entry - Of The Pitch',
   'UK fans use ESTA for the US (no interview, ~$21), Canada eTA for CAD $7, and Mexico is visa-free. England plays group stage in Dallas. Total documentation cost under $30.',
   '[{"question": "Do England or Scotland fans need a visa for World Cup 2026 in the USA?", "answer": "No. The United Kingdom is in the US Visa Waiver Program. Apply for ESTA at esta.cbp.dhs.gov. Cost is $21. Approved in most cases within minutes."}, {"question": "Do UK fans need anything for Canada matches?", "answer": "Yes. A Canadian eTA is required for flights into Toronto or Vancouver. Apply at canada.ca/eta. Cost is CAD $7. Processing is usually instant."}, {"question": "Do UK fans need a visa for Mexico?", "answer": "No. UK passport holders enter Mexico visa-free for up to 180 days."}, {"question": "Does my UK GHIC cover me in the USA?", "answer": "No. The Global Health Insurance Card does not cover medical treatment in the United States. Travel insurance with US medical coverage is strongly recommended."}, {"question": "Where do England and Scotland play at World Cup 2026?", "answer": "England plays in New York and Miami in the group stage. Scotland plays in Boston. England’s matches at MetLife Stadium in New Jersey and Hard Rock Stadium in Miami."}]'::jsonb, '2026-05-23T12:03:43Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-south-korean-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('2886ad7a-87f0-52b3-93bf-e0a3cc17e141', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-south-korean-fans',
   'World Cup 2026 Visa Guide for South Korean Fans: ESTA, Canada eTA and Mexico Entry',
   'South Korean fans use ESTA for the US (no interview, ~$21), Canada eTA for CAD $7, and Mexico is visa-free. Total documentation cost under $30, all handled online.',
   'South Korean fans use ESTA for the US (no interview, ~$21), Canada eTA for CAD $7, and Mexico is visa-free. Total documentation cost under $30, all handled online.',
   '/images/2026/05/Seoul_Skyline_Night_2018.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for South Korean Fans: ESTA, Canada eTA and Mexico Entry - Of The Pitch',
   'South Korean fans use ESTA for the US (no interview, ~$21), Canada eTA for CAD $7, and Mexico is visa-free. Total documentation cost under $30, all handled online.',
   '[{"question": "Do South Korean fans need a visa for World Cup 2026 in the USA?", "answer": "No. South Korea is in the US Visa Waiver Program. Apply for ESTA at esta.cbp.dhs.gov. Cost is $21. Most applications are approved within minutes."}, {"question": "Do South Korean fans need anything for Canada?", "answer": "Yes. South Korean passport holders need a Canadian eTA for air travel into Canada. Apply at canada.ca/eta. Cost is CAD $7."}, {"question": "Is Mexico visa-free for South Korean fans?", "answer": "Yes. South Korean passport holders enter Mexico visa-free for tourist stays. Guadalajara and Monterrey host World Cup 2026 group matches."}, {"question": "Where does South Korea play at World Cup 2026?", "answer": "Check the official FIFA 2026 schedule for South Korea’s confirmed group stage host cities and match venues."}]'::jsonb, '2026-05-22T15:48:37Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-esta-guide-european-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('24a4e0c7-3edd-5b20-9230-e3bad8170ab0', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-esta-guide-european-fans',
   'European Fans: Your Complete ESTA and Entry Guide for World Cup 2026',
   'European fans with UK, French, German, Spanish, Dutch and other qualifying passports travel to World Cup 2026 USA on ESTA. $21, approved in minutes. Full guide covering ESTA rules, Canada eTA, Mexico entry, and border tips.',
   'European fans with UK, French, German, Spanish, Dutch and other qualifying passports travel to World Cup 2026 USA on ESTA. $21, approved in minutes. Full guide covering ESTA rules, Canada eTA, Mexico entry, and border tips.',
   '/images/2026/05/Wembley-Stadion_2013.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'European Fans: Your Complete ESTA and Entry Guide for World Cup 2026 - Of The Pitch',
   'European fans with UK, French, German, Spanish, Dutch and other qualifying passports travel to World Cup 2026 USA on ESTA. $21, approved in minutes. Full guide covering ESTA rules, Canada eTA, Mexico entry, and border tips.',
   '[{"question": "Do European fans need a visa for World Cup 2026 in the USA?", "answer": "Most European fans qualify for ESTA under the US Visa Waiver Program. Apply at esta.cbp.dhs.gov. Cost is $21. 40+ European countries are VWP members."}, {"question": "Which European countries are NOT in the US Visa Waiver Program?", "answer": "Albania, Kosovo, North Macedonia, and several other Balkan nations are not in the VWP. Fans from these countries need a B1/B2 visa for the USA."}, {"question": "Do European fans need a visa for Canada at World Cup 2026?", "answer": "Most EU and EEA passport holders need a Canadian eTA for air travel. Cost is CAD $7. Apply at canada.ca/eta. Some nationalities may require a full TRV."}, {"question": "Is Mexico visa-free for European fans?", "answer": "Yes. All EU and most European passport holders enter Mexico visa-free for tourist stays up to 180 days."}]'::jsonb, '2026-05-22T13:34:39Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-german-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('7d927afc-b423-5d94-9fe8-3c1ca7f47948', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-german-fans',
   'World Cup 2026 Visa Guide for German Fans: ESTA, Canada eTA and Mexico Entry',
   'German fans use ESTA for the US (~$21), Canada eTA for CAD $7 (Germany plays in Toronto June 20), and Mexico is visa-free. All handled online, total cost under $30.',
   'German fans use ESTA for the US (~$21), Canada eTA for CAD $7 (Germany plays in Toronto June 20), and Mexico is visa-free. All handled online, total cost under $30.',
   '/images/2026/05/Berlin_Brandenburg_Gate.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for German Fans: ESTA, Canada eTA and Mexico Entry - Of The Pitch',
   'German fans use ESTA for the US (~$21), Canada eTA for CAD $7 (Germany plays in Toronto June 20), and Mexico is visa-free. All handled online, total cost under $30.',
   '[{"question": "Do German fans need a visa for World Cup 2026 in the USA?", "answer": "No. Germany is in the US Visa Waiver Program. Apply for ESTA at esta.cbp.dhs.gov. Cost is $21. German passports are approved quickly."}, {"question": "Do German fans need anything for Canada?", "answer": "Yes. German passport holders need a Canadian eTA for air travel into Canada. Cost is CAD $7. Germany plays in Toronto on June 20."}, {"question": "Is Mexico visa-free for German fans?", "answer": "Yes. German passport holders enter Mexico visa-free for up to 180 days."}, {"question": "Where does Germany play at World Cup 2026?", "answer": "Germany plays their group stage matches including a fixture in Toronto, Canada. Check the official FIFA schedule for all confirmed German match venues."}]'::jsonb, '2026-05-21T16:16:29Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-us-visa-guide-pakistan-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('23f7af06-bf1a-5c22-9349-509c7b4ab2f7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-us-visa-guide-pakistan-fans',
   'US Visa Guide for Pakistani Fans: How to Get to World Cup 2026',
   'Pakistani fans need a B1/B2 visa for World Cup 2026 in the USA. Pakistan is NOT on the travel ban list. FIFA PASS priority appointments available. Full guide with documents, wait times, and Canada and Mexico entry rules.',
   'Pakistani fans need a B1/B2 visa for World Cup 2026 in the USA. Pakistan is NOT on the travel ban list. FIFA PASS priority appointments available. Full guide with documents, wait times, and Canada and Mexico entry rules.',
   '/images/2026/05/Blue_Hour_Pakistan_Monument.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'US Visa Guide for Pakistani Fans: How to Get to World Cup 2026 - Of The Pitch',
   'Pakistani fans need a B1/B2 visa for World Cup 2026 in the USA. Pakistan is NOT on the travel ban list. FIFA PASS priority appointments available. Full guide with documents, wait times, and Canada and Mexico entry rules.',
   '[{"question": "Do Pakistani fans need a US visa for World Cup 2026?", "answer": "Yes. Pakistani passport holders need a B1/B2 US tourist visa. Pakistan is not on the travel ban list but wait times for interviews can be long. Apply immediately."}, {"question": "Is Pakistan on the US travel ban list?", "answer": "No. Pakistan is not on any US travel ban list as of 2026. B1/B2 tourist visas are available but approval is not guaranteed and wait times vary."}, {"question": "Can Pakistani fans attend World Cup matches in Canada?", "answer": "Yes. Canadian Temporary Resident Visas are available to Pakistani citizens. Canada hosts 13 matches. Apply well in advance as processing times vary."}, {"question": "Is Mexico visa-free for Pakistani fans?", "answer": "No. Pakistani passport holders require a Mexican visa. Mexico does not grant visa-free entry to Pakistani citizens for tourist visits."}]'::jsonb, '2026-05-21T14:16:54Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-canadian-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('16b72195-d895-5089-91f3-1e62a8fef4e3', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-canadian-fans',
   'World Cup 2026 Travel Guide for Canadian Fans: No Visa Needed for US or Mexico',
   'Canadian fans need no visa, ESTA, or advance authorization for the US or Mexico. Canada co-hosts 13 matches in Toronto and Vancouver. Just bring your Canadian passport.',
   'Canadian fans need no visa, ESTA, or advance authorization for the US or Mexico. Canada co-hosts 13 matches in Toronto and Vancouver. Just bring your Canadian passport.',
   '/images/2026/05/Skyline_Toronto.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Travel Guide for Canadian Fans: No Visa Needed for US or Mexico - Of The Pitch',
   'Canadian fans need no visa, ESTA, or advance authorization for the US or Mexico. Canada co-hosts 13 matches in Toronto and Vancouver. Just bring your Canadian passport.',
   '[{"question": "Do Canadian fans need a visa or ESTA for USA World Cup 2026 matches?", "answer": "No. Canadian citizens do not need a visa, ESTA, or any advance travel authorisation to enter the United States. You can cross by land, air, or sea freely."}, {"question": "Do Canadian fans need a visa for Mexico?", "answer": "No. Canadian passport holders enter Mexico visa-free for tourist stays up to 180 days. Guadalajara and Monterrey are Mexican host cities."}, {"question": "Where does Canada play at World Cup 2026?", "answer": "Canada plays their home group stage matches in Toronto (BMO Field) and Vancouver (BC Place). Away matches may be in US or Mexican host cities."}, {"question": "Can Canadian fans attend all 11 US host cities without any border documents?", "answer": "Yes. Canadian citizens need no advance permission to travel to any US city. A valid Canadian passport is sufficient for all US border crossings."}]'::jsonb, '2026-05-20T16:27:28Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] boston-world-cup-2026-fan-zone-city-hall-plaza-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('4edc5b58-31ca-5a66-b880-29a8d13c8cf1', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'boston-world-cup-2026-fan-zone-city-hall-plaza-guide',
   'Boston World Cup 2026 Fan Zone: The Complete City Hall Plaza Guide',
   'Boston’s free FIFA Fan Festival runs 16 days at City Hall Plaza, June 12 to 27. Scotland plays twice here. Registration required. Cambridge fan zones across 7 neighborhoods. MBTA stadium train to Gillette $80 return.',
   'Boston’s free FIFA Fan Festival runs 16 days at City Hall Plaza, June 12 to 27. Scotland plays twice here. Registration required. Cambridge fan zones across 7 neighborhoods. MBTA stadium train to Gillette $80 return.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Boston — World Cup 2026 |
| **Venue** | City Hall Plaza |
| **Address** | 1 City Hall Ave, Boston, MA, 02201 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Boston_Skyline_with_Prudential_Tower.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Boston World Cup 2026 Fan Zone: The Complete City Hall Plaza Guide - Of The Pitch',
   'Boston''s free FIFA Fan Festival runs 16 days at City Hall Plaza, June 12 to 27. Scotland plays twice here. Registration required. Cambridge fan zones across 7 neighborhoods. MBTA stadium train to Gillette $80 return.',
   '[]'::jsonb, '2026-05-20T13:44:51Z', '2026-06-22T07:27:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-mexican-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('7b254e69-405a-5cf4-81db-29148b4a8945', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-mexican-fans',
   'World Cup 2026 Visa Guide for Mexican Fans: Home Matches, US Entry and Canada Requirements',
   'Mexican fans need a B1/B2 US visa for knockout matches in the US. Mexico home matches need no documents. Canada requires an eTA if you have a US visa. Apply for the US visa now.',
   'Mexican fans need a B1/B2 US visa for knockout matches in the US. Mexico home matches need no documents. Canada requires an eTA if you have a US visa. Apply for the US visa now.',
   '/images/2026/05/Mexico_city_Estadio_Azteca_estadio_banorte_fifa_world_cup_2026_4.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for Mexican Fans: Home Matches, US Entry and Canada Requirements - Of The Pitch',
   'Mexican fans need a B1/B2 US visa for knockout matches in the US. Mexico home matches need no documents. Canada requires an eTA if you have a US visa. Apply for the US visa now.',
   '[{"question": "Do Mexican fans need a US visa for World Cup 2026 knockout matches?", "answer": "Yes. Mexican citizens need a B1/B2 US tourist visa for matches in US host cities. Mexico co-hosts group stage matches so some fixtures require no US visa."}, {"question": "Do Mexican fans need anything for Canada World Cup matches?", "answer": "Yes. Mexican passport holders need a Canadian Temporary Resident Visa (TRV) for matches in Toronto or Vancouver. Apply well in advance."}, {"question": "Which World Cup 2026 matches are in Mexico?", "answer": "Mexico hosts group stage matches at Estadio Azteca in Mexico City, Estadio Akron in Guadalajara, and Estadio BBVA in Monterrey."}, {"question": "Do Mexican fans need a visa to watch Mexico home games?", "answer": "No. Mexican citizens need no documentation to attend matches at Mexican stadiums. US visa is only required for matches played on US soil."}]'::jsonb, '2026-05-19T16:19:23Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] houston-world-cup-2026-fan-zone-eado-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('942e79b7-564d-5e4e-a787-af181f43b72c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'houston-world-cup-2026-fan-zone-eado-guide',
   'Houston World Cup 2026 Fan Zone: The Complete EaDo Guide',
   'Houston’s EaDo fan zone runs free for all 39 days of World Cup 2026. Germany, Portugal twice, Netherlands in Houston. METRORail Red Line direct to NRG Stadium. July 4 Round of 16. Ronaldo plays here twice.',
   'Houston’s EaDo fan zone runs free for all 39 days of World Cup 2026. Germany, Portugal twice, Netherlands in Houston. METRORail Red Line direct to NRG Stadium. July 4 Round of 16. Ronaldo plays here twice.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Houston — World Cup 2026 |
| **Venue** | EaDo District |
| **Address** | 2200 Texas Ave, Houston, TX, 77003 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Downtown_Houston_Skyline_Night.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Houston World Cup 2026 Fan Zone: The Complete EaDo Guide - Of The Pitch',
   'Houston''s EaDo fan zone runs free for all 39 days of World Cup 2026. Germany, Portugal twice, Netherlands in Houston. METRORail Red Line direct to NRG Stadium. July 4 Round of 16. Ronaldo plays here twice.',
   '[]'::jsonb, '2026-05-19T13:57:33Z', '2026-06-22T07:27:02Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] new-york-world-cup-2026-fan-zone-complete-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('b84bc44a-7d5a-5924-8a38-4b4dcf1ce57c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'new-york-world-cup-2026-fan-zone-complete-guide',
   'New York World Cup 2026 Fan Zones: The Complete Guide to Every Borough',
   'New York City World Cup 2026 fan zones across all 5 boroughs. Free with registration. USTA Queens June 11 to 27. Rockefeller Center July 6 to 19. Brooklyn Bridge Park June 13 to July 19. MetLife Stadium hosts the Final.',
   'New York City World Cup 2026 fan zones across all 5 boroughs. Free with registration. USTA Queens June 11 to 27. Rockefeller Center July 6 to 19. Brooklyn Bridge Park June 13 to July 19. MetLife Stadium hosts the Final.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival New York — World Cup 2026 |
| **Venue** | USTA Billie Jean King National Tennis Center |
| **Address** | Flushing Meadows Corona Park, New York, NY, 11368 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Entrance_of_Rockefeller_Center-1.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'New York World Cup 2026 Fan Zones: The Complete Guide to Every Borough - Of The Pitch',
   'New York City World Cup 2026 fan zones across all 5 boroughs. Free with registration. USTA Queens June 11 to 27. Rockefeller Center July 6 to 19. Brooklyn Bridge Park June 13 to July 19. MetLife Stadium hosts the Final.',
   '[]'::jsonb, '2026-05-18T14:34:55Z', '2026-06-22T07:27:01Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] fifa-world-cup-2026-final-tickets
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('a65d69ae-1908-52c2-b239-60907ce4adf7', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fifa-world-cup-2026-final-tickets',
   'FIFA World Cup 2026 Final Tickets Guide',
   'FIFA World Cup 2026 Final tickets at MetLife Stadium on July 19. Prices from USD 1490, hospitality from USD 2500, resale options, and how to get there from Manhattan.',
   'FIFA World Cup 2026 Final tickets at MetLife Stadium on July 19. Prices from USD 1490, hospitality from USD 2500, resale options, and how to get there from Manhattan.',
   '/images/2026/05/View_of_the_MetLife_Stadium_-_ARG_v_CAN_-_2024-07-09_tilt_corrected.jpg', '27216e93-685b-5f7e-a60a-55260dfb5490', '{}', 'published',
   'FIFA World Cup 2026 Final Tickets Guide - Of The Pitch',
   'FIFA World Cup 2026 Final tickets at MetLife Stadium on July 19. Prices from USD 1490, hospitality from USD 2500, resale options, and how to get there from Manhattan.',
   '[{"question": "How much do World Cup 2026 Final tickets cost?", "answer": "Official Final tickets at MetLife Stadium start from USD 1490 for Category 3. Category 1 tickets cost USD 7875. Hospitality packages start from USD 15000 per person."}, {"question": "Where is the World Cup 2026 Final?", "answer": "The FIFA World Cup 2026 Final takes place at MetLife Stadium in East Rutherford, New Jersey, near New York City on 19 July 2026."}, {"question": "Can I still buy World Cup 2026 Final tickets?", "answer": "Official tickets may still be available via FIFA.com/tickets and the Official Resale Marketplace. Check both for availability. Resale prices are significantly higher than face value."}, {"question": "Are World Cup 2026 Final tickets sold out?", "answer": "Official allocation may be exhausted but the FIFA Official Resale Marketplace lists tickets from fans who can no longer attend. Prices reflect market demand and can be very high."}]'::jsonb, '2026-05-16T14:22:22Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] los-angeles-world-cup-2026-fan-zone-complete-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('bdc1540b-1cc8-5886-a837-8e0c6faed6ae', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'los-angeles-world-cup-2026-fan-zone-complete-guide',
   'Los Angeles World Cup 2026 Fan Zones: The Complete Guide to All 10 Locations',
   'Los Angeles has 10 official World Cup 2026 fan zones across the region. Coliseum opens June 11 to 15. Then Venice Beach, Farmers Market, Union Station and more through July 19. USA plays twice in LA.',
   'Los Angeles has 10 official World Cup 2026 fan zones across the region. Coliseum opens June 11 to 15. Then Venice Beach, Farmers Market, Union Station and more through July 19. USA plays twice in LA.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Los Angeles — World Cup 2026 |
| **Venue** | Los Angeles Memorial Coliseum |
| **Address** | 3911 S Figueroa St, Los Angeles, CA, 90037 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Los_Angeles_Memorial_Coliseum-1.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Los Angeles World Cup 2026 Fan Zones: The Complete Guide to All 10 Locations - Of The Pitch',
   'Los Angeles has 10 official World Cup 2026 fan zones across the region. Coliseum opens June 11 to 15. Then Venice Beach, Farmers Market, Union Station and more through July 19. USA plays twice in LA.',
   '[]'::jsonb, '2026-05-16T11:56:40Z', '2026-06-22T07:26:59Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] fifa-world-cup-2026-resale-tickets
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('152fda46-ea7f-5ce2-aa8a-45e2b3548027', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fifa-world-cup-2026-resale-tickets',
   'FIFA World Cup 2026 Resale Tickets Guide',
   'FIFA World Cup 2026 resale tickets guide. How the Official FIFA Resale Marketplace works, fees, pricing rules in the USA versus Mexico, and whether StubHub is safe.',
   'FIFA World Cup 2026 resale tickets guide. How the Official FIFA Resale Marketplace works, fees, pricing rules in the USA versus Mexico, and whether StubHub is safe.',
   '/images/2026/05/Brooklyn_Bridge_from_Brooklyn_Bridge_Park.jpg', '27216e93-685b-5f7e-a60a-55260dfb5490', '{}', 'published',
   'FIFA World Cup 2026 Resale Tickets Guide - Of The Pitch',
   'FIFA World Cup 2026 resale tickets guide. How the Official FIFA Resale Marketplace works, fees, pricing rules in the USA versus Mexico, and whether StubHub is safe.',
   '[{"question": "Is it safe to buy World Cup 2026 resale tickets?", "answer": "The FIFA Official Resale Marketplace is the safest option. Third-party platforms like StubHub and Viagogo carry risk of fraud. Avoid private sellers on social media."}, {"question": "How does the FIFA Official Resale Marketplace work?", "answer": "Fans list unwanted tickets on FIFA.com/tickets at prices up to 110% of face value. Buyers purchase through FIFA and receive official mobile tickets to the FIFA app."}, {"question": "Can I sell my World Cup 2026 tickets?", "answer": "Yes. List tickets on the FIFA Official Resale Marketplace at up to 110% of face value. Selling outside official channels violates FIFA terms and tickets may be cancelled."}, {"question": "What fees does FIFA charge on resale tickets?", "answer": "FIFA charges a service fee on resale transactions. The exact fee is shown at checkout. There are no hidden fees beyond what is displayed during purchase."}]'::jsonb, '2026-05-15T15:13:14Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] kansas-city-world-cup-2026-fan-zone-wwi-museum-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('f01e62d6-91ad-51fa-a45b-0e2a85a9944b', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'kansas-city-world-cup-2026-fan-zone-wwi-museum-guide',
   'Kansas City World Cup 2026 Fan Zone: The Complete WWI Museum Guide',
   'Kansas City’s FIFA Fan Festival sits below the Liberty Memorial at the WWI Museum. Free with ConnectKC26 Pass, 18 match days. Argentina vs Algeria June 16. Full guide with transport, hotels, and match schedule.',
   'Kansas City’s FIFA Fan Festival sits below the Liberty Memorial at the WWI Museum. Free with ConnectKC26 Pass, 18 match days. Argentina vs Algeria June 16. Full guide with transport, hotels, and match schedule.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Kansas City — World Cup 2026 |
| **Venue** | WWI Museum and Memorial |
| **Address** | 2 Memorial Dr, Kansas City, MO, 64108 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/National_WWI_Museum_and_Memorial-1.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Kansas City World Cup 2026 Fan Zone: The Complete WWI Museum Guide - Of The Pitch',
   'Kansas City''s FIFA Fan Festival sits below the Liberty Memorial at the WWI Museum. Free with ConnectKC26 Pass, 18 match days. Argentina vs Algeria June 16. Full guide with transport, hotels, and match schedule.',
   '[]'::jsonb, '2026-05-15T12:59:17Z', '2026-06-22T07:26:58Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-indian-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('e832fc06-a0ea-5f74-87bd-45ad7cb153e9', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-indian-fans',
   'World Cup 2026 Visa Guide for Indian Fans: US Wait Times, Canada TRV and Mexico Options',
   'Indian fans face 6 to 14 month US visa wait times. Apply immediately. FIFA PASS can help prioritise slots. Canada needs TRV with biometrics. Mexico is accessible via US visa or separate e-visa.',
   'Indian fans face 6 to 14 month US visa wait times. Apply immediately. FIFA PASS can help prioritise slots. Canada needs TRV with biometrics. Mexico is accessible via US visa or separate e-visa.',
   '/images/2026/05/India_Gate_in_New_Delhi_03-2016.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'World Cup 2026 Visa Guide for Indian Fans: US Wait Times, Canada TRV and Mexico Options - Of The Pitch',
   'Indian fans face 6 to 14 month US visa wait times. Apply immediately. FIFA PASS can help prioritise slots. Canada needs TRV with biometrics. Mexico is accessible via US visa or separate e-visa.',
   '[{"question": "How long does a US visa take for Indian fans?", "answer": "US B1/B2 visa wait times for Indian applicants range from 6 to 14 months depending on the consulate. Apply immediately. FIFA PASS can help prioritise processing."}, {"question": "Can Indian fans attend World Cup 2026 in Canada?", "answer": "Yes. Indian passport holders can apply for a Canadian Temporary Resident Visa. Canada hosts 13 matches and processing times are typically faster than US visas."}, {"question": "Is Mexico visa-free for Indian fans?", "answer": "No. Indian passport holders require a Mexican tourist visa. Apply through the Mexican consulate in India well in advance."}, {"question": "What is FIFA PASS and how does it help Indian fans?", "answer": "FIFA PASS is a program for ticketholders to request priority visa processing from US consulates. It does not guarantee approval but may accelerate appointment scheduling."}]'::jsonb, '2026-05-15T07:43:45Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-colombian-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('69b1580a-1709-5dff-ab27-0d535b87e338', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-colombian-fans',
   'World Cup 2026 Visa Guide for Colombian Fans: US, Canada and Mexico Entry Requirements',
   'Colombian fans need a B1/B2 US visa, a Canadian TRV with biometrics, and Mexico is visa-free. Apply at US Embassy Bogota, Panama City, or Brazil consulates for priority slots.',
   'Colombian fans need a B1/B2 US visa, a Canadian TRV with biometrics, and Mexico is visa-free. Apply at US Embassy Bogota, Panama City, or Brazil consulates for priority slots.',
   '/images/2026/05/Cartagena_skyline_from_the_city_walls.jpg', '79ef23c4-19f8-56f0-acdc-4cc2885f40a3', '{}', 'published',
   'World Cup 2026 Visa Guide for Colombian Fans: US, Canada and Mexico Entry Requirements - Of The Pitch',
   'Colombian fans need a B1/B2 US visa, a Canadian TRV with biometrics, and Mexico is visa-free. Apply at US Embassy Bogota, Panama City, or Brazil consulates for priority slots.',
   '[{"question": "Do Colombian fans need a US visa for World Cup 2026?", "answer": "Yes. Colombian citizens need a B1/B2 US tourist visa. Apply immediately as wait times can be 3 to 6 months. FIFA PASS may help accelerate processing."}, {"question": "Do Colombian fans need a visa for Canada?", "answer": "Yes. Colombian citizens need a Canadian Temporary Resident Visa with biometrics to attend matches in Toronto or Vancouver."}, {"question": "Is Mexico visa-free for Colombian fans?", "answer": "Yes. Colombian passport holders enter Mexico visa-free for tourist stays. Guadalajara and Monterrey host group stage matches."}, {"question": "How long does a US visa take for Colombian fans?", "answer": "US B1/B2 visa processing for Colombian citizens typically takes 3 to 6 months including the interview appointment wait. Apply as soon as tickets are confirmed."}]'::jsonb, '2026-05-15T07:13:45Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] how-to-buy-fifa-world-cup-2026-tickets
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('2ee41431-1f37-5ca7-a596-65227fbeea85', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'how-to-buy-fifa-world-cup-2026-tickets',
   'How to Buy FIFA World Cup 2026 Tickets Right Now',
   'How to buy FIFA World Cup 2026 tickets right now. Last-minute sales, official resale, mobile ticket delivery, and what to know about third-party platforms.',
   'How to buy FIFA World Cup 2026 tickets right now. Last-minute sales, official resale, mobile ticket delivery, and what to know about third-party platforms.',
   '/images/2026/05/CenturyLink_Field_Seattle_WA.jpg', '27216e93-685b-5f7e-a60a-55260dfb5490', '{}', 'published',
   'How to Buy FIFA World Cup 2026 Tickets Right Now - Of The Pitch',
   'How to buy FIFA World Cup 2026 tickets right now. Last-minute sales, official resale, mobile ticket delivery, and what to know about third-party platforms.',
   '[{"question": "How do I buy FIFA World Cup 2026 tickets?", "answer": "Go to FIFA.com/tickets. Create a FIFA account, link a payment method, and enter the ticket lottery or buy from the Official Resale Marketplace. Mobile tickets are delivered to the FIFA app."}, {"question": "Are there still World Cup 2026 tickets available?", "answer": "Official last-minute tickets may still be available on FIFA.com/tickets. The FIFA Official Resale Marketplace lists tickets from fans who cannot attend at up to 110% of face value."}, {"question": "How do I avoid World Cup 2026 ticket scams?", "answer": "Only buy from FIFA.com/tickets or the Official Resale Marketplace. Avoid private sellers, WhatsApp groups, and third-party sites not linked from the official FIFA website."}, {"question": "What is the FIFA ticket app?", "answer": "The FIFA Tickets app is the official mobile wallet for World Cup 2026 tickets. All tickets are delivered digitally to this app. Download it on iOS or Android before match day."}]'::jsonb, '2026-05-14T15:18:45Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] philadelphia-world-cup-2026-fan-zone-lemon-hill-fairmount-park-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('aba1a243-ebd9-55ab-849e-f2d883f533f3', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'philadelphia-world-cup-2026-fan-zone-lemon-hill-fairmount-park-guide',
   'Philadelphia World Cup 2026 Fan Zone: The Complete Lemon Hill Guide',
   'The only US city hosting a free 39-day FIFA Fan Festival. Philadelphia’s Lemon Hill in Fairmount Park runs June 11 to July 19 with registration required. Brazil, France, and a July 4 Round of 16 inside.',
   'The only US city hosting a free 39-day FIFA Fan Festival. Philadelphia’s Lemon Hill in Fairmount Park runs June 11 to July 19 with registration required. Brazil, France, and a July 4 Round of 16 inside.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Philadelphia — World Cup 2026 |
| **Venue** | Lemon Hill, Fairmount Park |
| **Address** | 1 Lemon Hill Dr, Philadelphia, PA, 19130 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/A586_Lemon_Hill_Mansion_Fairmount_Park_Philadelphia_Pennsylvania_United_States_2017.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Philadelphia World Cup 2026 Fan Zone: The Complete Lemon Hill Guide - Of The Pitch',
   'The only US city hosting a free 39-day FIFA Fan Festival. Philadelphia''s Lemon Hill in Fairmount Park runs June 11 to July 19 with registration required. Brazil, France, and a July 4 Round of 16 inside.',
   '[]'::jsonb, '2026-05-14T12:57:36Z', '2026-06-22T07:26:57Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] fifa-world-cup-2026-hospitality-packages
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('7eaa2e6b-9dde-5080-96a8-96f9f3fa246a', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fifa-world-cup-2026-hospitality-packages',
   'FIFA World Cup 2026 Hospitality Packages Complete Guide',
   'FIFA World Cup 2026 hospitality packages start at USD 2500 per person. On Location is the only official provider. Guide to single match, venue series, and private suite packages.',
   'FIFA World Cup 2026 hospitality packages start at USD 2500 per person. On Location is the only official provider. Guide to single match, venue series, and private suite packages.',
   '/images/2026/05/Gillette_Stadium.jpg', '27216e93-685b-5f7e-a60a-55260dfb5490', '{}', 'published',
   'FIFA World Cup 2026 Hospitality Packages Complete Guide - Of The Pitch',
   'FIFA World Cup 2026 hospitality packages start at USD 2500 per person. On Location is the only official provider. Guide to single match, venue series, and private suite packages.',
   '[{"question": "How much do World Cup 2026 hospitality packages cost?", "answer": "FIFA World Cup 2026 hospitality packages start from approximately USD 2500 per person for group stage matches. Final hospitality starts from USD 15000 per person."}, {"question": "Who is the official hospitality provider for World Cup 2026?", "answer": "On Location is the official and exclusive hospitality provider for FIFA World Cup 2026. Only packages purchased through On Location or FIFA.com/hospitality are officially licensed."}, {"question": "What is included in World Cup 2026 hospitality packages?", "answer": "Typical inclusions are premium match ticket, hospitality lounge access, food and beverages, exclusive merchandise, and official programme. Specific inclusions vary by package tier."}, {"question": "Can I get a refund on hospitality packages if my team fails to qualify?", "answer": "On Location’s refund policy for non-qualified team scenarios varies by package. Check the terms and conditions at time of purchase. Most premium packages are non-refundable."}]'::jsonb, '2026-05-13T15:43:25Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] atlanta-world-cup-2026-fan-zone-centennial-olympic-park-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('5fc3f3e2-05bf-5665-a1a8-b0cdcb9c9d57', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'atlanta-world-cup-2026-fan-zone-centennial-olympic-park-guide',
   'Atlanta World Cup 2026 Fan Zone: The Complete Centennial Olympic Park Guide',
   'Everything you need to know about the Atlanta FIFA Fan Festival at Centennial Olympic Park for World Cup 2026. Free with registration, 17 match days, June 12 to July 15 including a Semifinal. Transport, tips, and full match schedule inside.',
   'Everything you need to know about the Atlanta FIFA Fan Festival at Centennial Olympic Park for World Cup 2026. Free with registration, 17 match days, June 12 to July 15 including a Semifinal. Transport, tips, and full match schedule inside.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Atlanta — World Cup 2026 |
| **Venue** | Centennial Olympic Park |
| **Address** | 265 Park Ave W NW, Atlanta, GA, 30313 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Centennial_Olympic_Park_Atlanta_Ga._IMG_7415-scaled.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Atlanta World Cup 2026 Fan Zone: The Complete Centennial Olympic Park Guide - Of The Pitch',
   'Everything you need to know about the Atlanta FIFA Fan Festival at Centennial Olympic Park for World Cup 2026. Free with registration, 17 match days, June 12 to July 15 including a Semifinal. Transport, tips, and full match schedule inside.',
   '[]'::jsonb, '2026-05-13T14:31:12Z', '2026-06-22T07:26:56Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] fifa-world-cup-2026-ticket-prices
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('bb07183e-b7c0-5bd6-b931-d6442a13ec6b', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'fifa-world-cup-2026-ticket-prices',
   'FIFA World Cup 2026 Ticket Prices Complete Guide',
   'FIFA World Cup 2026 ticket prices start at USD 120 for general sale and reach USD 7875 for the Final. Complete price guide by stage, category, and how to buy tickets now.',
   'FIFA World Cup 2026 ticket prices start at USD 120 for general sale and reach USD 7875 for the Final. Complete price guide by stage, category, and how to buy tickets now.',
   '/images/2026/05/Washington_Football_Team_entering_empty_MetLife_Stadium-scaled.jpg', '27216e93-685b-5f7e-a60a-55260dfb5490', '{}', 'published',
   'FIFA World Cup 2026 Ticket Prices Complete Guide - Of The Pitch',
   'FIFA World Cup 2026 ticket prices start at USD 120 for general sale and reach USD 7875 for the Final. Complete price guide by stage, category, and how to buy tickets now.',
   '[{"question": "How much do World Cup 2026 tickets cost?", "answer": "General sale tickets start from USD 120 for Category 3 group stage matches. Category 1 group stage tickets are USD 390. Final tickets start from USD 1490 and reach USD 7875."}, {"question": "Are World Cup 2026 tickets sold out?", "answer": "The main allocation is exhausted but the FIFA Official Resale Marketplace lists returned tickets. Check FIFA.com/tickets regularly as new inventory appears."}, {"question": "What are the World Cup 2026 ticket categories?", "answer": "There are three ticket categories: Category 3 is the most affordable and furthest from the pitch. Category 1 offers the best views closest to the action. Category 2 is the mid-tier option."}, {"question": "How do I buy last-minute World Cup 2026 tickets?", "answer": "Check FIFA.com/tickets for any remaining official inventory and the FIFA Official Resale Marketplace for fan-to-fan sales at up to 110% of face value."}]'::jsonb, '2026-05-12T15:40:15Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-argentine-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('b89304b3-3427-511a-a1cc-29c0cd41704c', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-argentine-fans',
   'World Cup 2026 Visa Guide for Argentine Fans: US, Canada and Mexico Entry Requirements',
   'Argentine fans use ESTA for the US, get the CAD $7 Canada eTA after ESTA approval, and enter Mexico visa-free. Total documentation cost under $30 for most fans.',
   'Argentine fans use ESTA for the US, get the CAD $7 Canada eTA after ESTA approval, and enter Mexico visa-free. Total documentation cost under $30 for most fans.',
   '/images/2026/05/Obelisco_en_Buenos_Aires-scaled.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for Argentine Fans: US, Canada and Mexico Entry Requirements - Of The Pitch',
   'Argentine fans use ESTA for the US, get the CAD $7 Canada eTA after ESTA approval, and enter Mexico visa-free. Total documentation cost under $30 for most fans.',
   '[{"question": "Do Argentine fans need a US visa for World Cup 2026?", "answer": "No. Argentine passport holders qualify for ESTA under the US Visa Waiver Program. Apply at esta.cbp.dhs.gov. Cost is $21. Most applications are approved within minutes."}, {"question": "Do Argentine fans need anything for Canada?", "answer": "Yes. Argentine passport holders who have an approved ESTA or US visa can apply for a Canadian eTA instead of a full TRV. Cost is CAD $7."}, {"question": "Is Mexico visa-free for Argentine fans?", "answer": "Yes. Argentine passport holders enter Mexico visa-free for tourist stays. Argentina’s group stage fixtures include matches in the USA and potentially Mexico."}, {"question": "Where does Argentina play at World Cup 2026?", "answer": "Argentina’s group stage venues are confirmed in the official FIFA schedule. Check FIFA.com for the full fixture list with confirmed city assignments."}]'::jsonb, '2026-05-12T13:09:28Z', '2026-06-22T07:40:03Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [faq] world-cup-2026-visa-guide-brazilian-fans
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('ce38c2f8-fc37-598e-8b1f-64ef36f5ecf0', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'world-cup-2026-visa-guide-brazilian-fans',
   'World Cup 2026 Visa Guide for Brazilian Fans: US, Canada and Mexico Entry Requirements',
   'Brazilian fans need a B1/B2 US visa, a Canadian eTA if you have a US visa, and Mexico is covered by your US visa. Apply for the US B1/B2 now as wait times are 3 to 6 weeks.',
   'Brazilian fans need a B1/B2 US visa, a Canadian eTA if you have a US visa, and Mexico is covered by your US visa. Apply for the US B1/B2 now as wait times are 3 to 6 weeks.',
   '/images/2026/05/Outside_Maracana_Stadium_from_the_avenue-scaled.jpg', '994ff97d-a052-59c4-85d3-636b8ca8c2b7', '{}', 'published',
   'World Cup 2026 Visa Guide for Brazilian Fans: US, Canada and Mexico Entry Requirements - Of The Pitch',
   'Brazilian fans need a B1/B2 US visa, a Canadian eTA if you have a US visa, and Mexico is covered by your US visa. Apply for the US B1/B2 now as wait times are 3 to 6 weeks.',
   '[{"question": "Do Brazilian fans need a US visa for World Cup 2026?", "answer": "Yes. Brazilian passport holders need a B1/B2 US tourist visa. Brazil is not in the Visa Waiver Program. Apply immediately as wait times can be 6 to 12 months."}, {"question": "Can Brazilian fans use an eTA for Canada?", "answer": "Brazilian passport holders who have a valid US visa can apply for a Canadian eTA instead of a full TRV. Without a US visa, a full Canadian TRV with biometrics is required."}, {"question": "Is Mexico visa-free for Brazilian fans?", "answer": "Yes. Brazilian passport holders enter Mexico visa-free under the bilateral agreement. Guadalajara and Monterrey host group stage matches."}, {"question": "What is FIFA PASS for Brazilian fans?", "answer": "FIFA PASS is a prioritisation tool for World Cup ticketholders seeking US visas. It signals to US consulates that you have confirmed match bookings, potentially accelerating interview scheduling."}]'::jsonb, '2026-05-12T08:17:32Z', '2026-06-22T07:40:04Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] miami-world-cup-2026-fan-zone-bayfront-park-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('ed67934d-8787-5bdf-aeef-2c0bbb44a1cc', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'miami-world-cup-2026-fan-zone-bayfront-park-guide',
   'Miami World Cup 2026 Fan Zone: The Complete Bayfront Park Guide',
   'Everything you need to know about the Miami FIFA Fan Festival at Bayfront Park for World Cup 2026. Free entry, 23 days, waterfront location, June 13 to July 5. Transport, heat tips, and full match schedule inside.',
   'Everything you need to know about the Miami FIFA Fan Festival at Bayfront Park for World Cup 2026. Free entry, 23 days, waterfront location, June 13 to July 5. Transport, heat tips, and full match schedule inside.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Miami — World Cup 2026 |
| **Venue** | Bayfront Park |
| **Address** | 301 Biscayne Blvd, Miami, FL, 33132 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |',
   '/images/2026/05/Bayfront_Park_Miami_FL_-_IMG_8004-scaled.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Miami World Cup 2026 Fan Zone: The Complete Bayfront Park Guide - Of The Pitch',
   'Everything you need to know about the Miami FIFA Fan Festival at Bayfront Park for World Cup 2026. Free entry, 23 days, waterfront location, June 13 to July 5. Transport, heat tips, and full match schedule inside.',
   '[]'::jsonb, '2026-05-11T11:11:21Z', '2026-06-22T07:26:54Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- [data] dallas-world-cup-2026-fan-zone-fair-park-guide
insert into posts (id, site_id, slug, title, excerpt, content,
  featured_image_url, category_id, audience_tags, status,
  seo_title, seo_description, faq_items, published_at, updated_at) values
  ('63c9f833-a8e4-59dc-b02a-66b85459fb89', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'dallas-world-cup-2026-fan-zone-fair-park-guide',
   'Dallas World Cup 2026 Fan Zone: The Complete Fair Park Guide',
   'Everything you need to know about the Dallas FIFA Fan Festival at Fair Park for World Cup 2026. Free entry, 34 days, 35,000 capacity, no registration needed. Dates, transport, heat tips, and match schedule inside.',
   'Everything you need to know about the Dallas FIFA Fan Festival at Fair Park for World Cup 2026. Free entry, 34 days, 35,000 capacity, no registration needed. Dates, transport, heat tips, and match schedule inside.

## Event Details

| | |
| --- | --- |
| **Event** | FIFA Fan Festival Dallas — World Cup 2026 |
| **Venue** | Fair Park — The Pavilion |
| **Address** | 3809 Grand Ave, Dallas, TX, 75210 |
| **Starts** | 2026-06-11 |
| **Ends** | 2026-07-19 |
| **Organiser** | FIFA |

Free public FIFA Fan Festival at Fair Park, Dallas. Watch all 104 World Cup 2026 matches on giant screens.',
   '/images/2026/05/image.jpg', 'dfe9fe4b-9abe-55f9-9449-710248072f33', '{}', 'published',
   'Dallas World Cup 2026 Fan Zone: The Complete Fair Park Guide - Of The Pitch',
   'Everything you need to know about the Dallas FIFA Fan Festival at Fair Park for World Cup 2026. Free entry, 35,000 capacity, all 34 match days.',
   '[]'::jsonb, '2026-05-11T10:29:54Z', '2026-06-22T07:25:40Z')
on conflict (site_id, slug) do update set
  title = excluded.title, excerpt = excluded.excerpt,
  content = excluded.content, featured_image_url = excluded.featured_image_url,
  category_id = excluded.category_id, status = excluded.status,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  faq_items = excluded.faq_items, published_at = excluded.published_at,
  updated_at = excluded.updated_at;

-- ── Pages (7) ──
insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('dadfaec2-a76b-595f-ba1b-11244fda2fad', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'affiliate-disclosure', 'Affiliate Disclosure',
   '## FTC Disclosure

Off The Pitch discloses the following about affiliate relationships per FTC guidelines.

## Affiliate Relationships

Some links are affiliate links. Purchasing through them may earn us a small commission at no additional cost to you.

## Editorial Independence

Affiliate partnerships do not influence our editorial content. We only recommend what we believe provides value.

## Sponsored Content

Sponsored posts are always clearly identified.

## Questions

Contact us at info@ofthepitch.com.

**Last Updated:** May 2026',
   'Affiliate Disclosure - Of The Pitch', 'Off The Pitch discloses the following about affiliate relationships per FTC guidelines.', '2026-05-10T12:46:55Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('e873bf2b-3b97-55c5-aad0-3982bf934d68', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'privacy-policy-2', 'Privacy Policy',
   '## Who We Are

Off The Pitch operates this website. This Privacy Policy explains how we collect, use, and safeguard your information.

## Information We Collect

We may collect personal information you voluntarily provide when you subscribe, comment, or contact us, including your name and email address.

## Automatically Collected Information

When you visit, we collect your IP address, browser type, operating system, and interaction data through cookies and similar technologies.

## How We Use Your Information

We use collected information to operate our website, improve your experience, send newsletters (if opted in), respond to inquiries, and display relevant advertisements through Google AdSense.

## Third-Party Services

We use Google Analytics and Google AdSense, which may collect visit information for targeted advertising and analytics. You may opt out via Google Ads Settings.

## Cookies

Our website uses cookies. You can refuse cookies via your browser settings.

## Data Security

We implement reasonable security measures but cannot guarantee absolute security.

## Your Rights

You may have rights to access, correct, or delete your personal information.

## Children’s Privacy

Our website is not intended for children under 13.

## Changes

We may update this policy by posting changes on this page.

## Contact Us

Email us at info@ofthepitch.com or visit our Contact page.

**Last Updated:** May 2026',
   'Privacy Policy - Of The Pitch', 'Off The Pitch operates this website. This Privacy Policy explains how we collect, use, and safeguard your information.', '2026-05-10T12:46:55Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('5bbfb414-f830-5e61-bac5-5fb984ad3ee0', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'terms-of-service', 'Terms of Service',
   '## Acceptance of Terms

By using Off The Pitch, you agree to these Terms.

## Use of Content

All content is for informational and entertainment purposes only.

## Intellectual Property

All content is property of Off The Pitch and protected by copyright laws.

## User Comments

By posting comments, you grant us a non-exclusive license to use and display such content.

## Affiliate Links

Our website may contain affiliate links. We may earn commissions at no extra cost to you.

## Third-Party Links

We may link to third-party sites and are not responsible for their content.

## Disclaimer

This website is provided “as is” without warranties of any kind.

## Limitation of Liability

Off The Pitch shall not be liable for damages arising from use of the website.

## Changes

We may modify these Terms at any time.

## Contact

Email info@ofthepitch.com.

**Last Updated:** May 2026',
   'Terms of Service - Of The Pitch', 'By using Off The Pitch, you agree to these Terms.', '2026-05-10T12:46:55Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('40de1e08-a7ee-5223-9f1a-840c4e3b53e6', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'contact', 'Contact',
   null,
   'Contact - Of The Pitch', 'info@ofthepitch.com', '2026-05-10T13:34:46Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('edcad445-79a8-5793-9d4f-d81a53388d41', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'offerings', 'Offerings',
   '## What We Provide For Fans​

Explore our diverse range of insights, guides, and analyses crafted for the passionate football fan seeking deeper engagement.​

![pexels photo 29348229.jpeg](/images/2026/05/pexels-photo-29348229-1.jpeg)

01

### In-Depth Analysis​

In-depth match analysis that goes beyond the surface, providing tactical breakdowns, statistics, and insights you won''t find in mainstream coverage.

[Get Started](/offerings/)

02

### Fan Guides​

City-by-city guides featuring essential travel tips, fan experiences, and hidden gems to enhance your World Cup journey like never before.

[Get Started](/offerings/)

![pexels photo 26832707.jpeg](/images/2026/05/pexels-photo-26832707-1.jpeg)

![pexels photo 2435290.jpeg](/images/2026/05/pexels-photo-2435290-1.jpeg)

03

### Controversial Insights​

Comprehensive coverage of controversies and scandals, shining a light on political issues and realities affecting the tournament and its fans.

[Get Started](/offerings/)

Off The Pitch is my go-to for understanding the depth of the World Cup. The insights are truly unmatched.

![testimonial skip 02.jpeg](/images/2026/05/testimonial-skip-02.jpeg)

Sarah Johnson

## Why Choose Off The Pitch?​

We offer unparalleled coverage and unique perspectives on the FIFA World Cup, diving into aspects other media overlook, ensuring fans stay informed.​

![pexels photo 10095953.jpeg](/images/2026/05/pexels-photo-10095953-1.jpeg)

### Unique Perspectives​

We highlight the stories and angles that mainstream media often overlook, giving you a complete picture of the World Cup experience.

![pexels photo 18256095.jpeg](/images/2026/05/pexels-photo-18256095-1.jpeg)

### Community-Driven Content​

Our platform thrives on contributions from passionate fans worldwide, ensuring that you find your voice and experience reflected in our coverage.

## Stay Updated with Us​

Don''t miss out on the latest insights and stories. Subscribe now to become part of our vibrant football community.

[Join the Conversation](#)',
   'Offerings - Of The Pitch', null, '2026-05-09T13:57:30Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('99f0b942-5474-5b41-a074-d3aeadf14948', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'about', 'About',
   '## The Story Behind Of The Pitch

![pexels photo 31160149.jpeg](/images/2026/05/pexels-photo-31160149-1.jpeg)

### Of The Pitch stands out by delving into the stories mainstream media often overlook, focusing on the political, economic, and social aspects of the World Cup. We are committed to delivering insightful analyses, captivating player stories, and city-by-city guides that enhance the overall tournament experience.​

Founded by a group of football enthusiasts in early 2023, Of The Pitch emerged from a desire to provide comprehensive coverage of the World Cup that goes beyond the surface level. Our mission is to empower fans with knowledge and perspective.

We have served a diverse array of football fans globally, connecting them through compelling content that illuminates the true essence of the World Cup. Our readership includes passionate supporters aged 18 to 45, eager for in-depth insights.

## Our Core Values​

At Of The Pitch, our values shape every piece of content we create, guiding our commitment to excellence and fan engagement.​

### Integrity​

We prioritize accurate and honest reporting, striving to build trust with our audience by highlighting genuine stories and uncovering the truth behind the headlines.

### Passion​

Our love for football drives us to explore every facet of the game, from the dirty truths to the stunning victories that make the sport unforgettable.

### Community​

We believe in the power of football to connect people. Our platform fosters a community where fans can share their experiences and insights, enriching the global football conversation.

## Stay Updated with Us​

Don''t miss out on the latest insights and stories. Subscribe now to become part of our vibrant football community.

[Join the Conversation](#)',
   'About - Of The Pitch', 'Founded by a group of football enthusiasts in early 2023, Of The Pitch emerged from a desire to provide comprehensive coverage of the World Cup that goes', '2026-06-21T22:41:15Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

insert into pages (id, site_id, slug, title, content, seo_title, seo_description, updated_at) values
  ('88fee67f-1848-5a20-840c-6fb4e41c66be', 'ed23c093-ff1e-4355-8e4a-fd1961a03587', 'home', 'Home',
   'Dive deep into the politics, scandals, and stories behind the FIFA World Cup 2026 like never before.

## What We Provide For Fans

Explore our diverse range of insights, guides, and analyses crafted for the passionate football fan seeking deeper engagement.

![pexels photo 31744929.jpeg](/images/2026/05/pexels-photo-31744929-1.jpeg)

### In-Depth Analysis​​

Our expert analysts go beyond match reports, providing you with intricate breakdowns of player performances and tactical insights, ensuring you understand every nuance.

![pexels photo 31160149.jpeg](/images/2026/05/pexels-photo-31160149-1.jpeg)

### Fan Guides​​

Navigate the tournament with our comprehensive guides, from city explorations to must-see local experiences tailored for die-hard fans like you.

![pexels photo 33914251.jpeg](/images/2026/05/pexels-photo-33914251-1.jpeg)

### Controversial Insights​​

Stay informed about the controversies shaping the tournament, from political climates to ticket pricing scandals, ensuring you''re never out of the loop.

![pexels photo 16651577.jpeg](/images/2026/05/pexels-photo-16651577-1.jpeg)

## The Story Behind Of The Pitch

At Of The Pitch, we bring years of industry expertise and a deep passion for football to our coverage of the FIFA World Cup 2026. Our team consists of seasoned journalists, analysts, and fervent football fans who understand the game from every angle, ensuring our content resonates with fans worldwide.

[Explore our 2026 World Cup Guides](/blog/)

## Why Choose Of The Pitch?

We offer unparalleled coverage and unique perspectives on the FIFA World Cup, diving into aspects other media overlook, ensuring fans stay informed.

![pexels photo 3991976.jpeg](/images/2026/05/pexels-photo-3991976-1.jpeg)

### Unique Perspectives​

We highlight the stories and angles that mainstream media often overlook, giving you a complete picture of the World Cup experience.

### Community-Driven Content​

Our platform thrives on contributions from passionate fans worldwide, ensuring that you find your voice and experience reflected in our coverage.

![pexels photo 36024834.jpeg](/images/2026/05/pexels-photo-36024834-1.jpeg)

## Stay Updated with Us​

Don''t miss out on the latest insights and stories. Subscribe now to become part of our vibrant football community.',
   'Of The Pitch — FIFA World Cup 2026 Fan Guide: Visa, Tickets & Travel', 'Heading to FIFA World Cup 2026? Find visa guides, ticket info, fan zone locations, viewing guides, and squad reviews for all 48 teams across North America.', '2026-06-21T22:42:20Z')
on conflict (site_id, slug) do update set
  title = excluded.title, content = excluded.content,
  seo_title = excluded.seo_title, seo_description = excluded.seo_description,
  updated_at = excluded.updated_at;

commit;

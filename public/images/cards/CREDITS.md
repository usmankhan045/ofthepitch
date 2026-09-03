# Card photographs

Cropped to 1200x750 at quality 68 for the preview card at /api/og. They sit
under a heavy scrim, so the quality drop is invisible.

Sourced from Pexels, which allows commercial use with no attribution required.
Photographers credited anyway.

- horse-racing-1: existing migrated image
- horse-racing-2: Pexels 12950446, horses leaving the starting gates
- horse-racing-3: Pexels 15466766, race in progress with crowd
- horse-racing-4: Pexels 18531123, horse and handler before a race
- tennis, formula-1, skiing, football: see ../sports/CREDITS.md

Adding more: drop `<sport>-N.jpg` into this directory and raise the count in
PHOTO_COUNT in app/api/og/route.tsx. A count higher than the files present
produces cards with no photograph.

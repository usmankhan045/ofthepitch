# Brand assets

## Profile picture

`profile-1000.png` is the one to upload. The 600 and 180 versions are the same
image at smaller sizes if a platform wants them.

Cream Didot "OP" on burnt orange (#CF5A2E), optically centred rather than
metrically, because a serif cap sits high in its line box and drifts upward
once the square is cropped to a circle.

**Why not the ticket mark.** The favicon in `app/icon.svg` is a gold ticket
stub on ink. It works at 16px in a browser tab, where it sits on the browser's
own chrome. It fails as a profile picture for two reasons: Pinterest renders
profile pictures as a circle at roughly 48px in feeds, where the notches and
perforation collapse into a smudge, and a dark circle recedes against
Pinterest's white background instead of standing out from it.

Five other directions were built and tested at 48px before this one: a stacked
wordmark, a roundel with a strapline, a ring, a ticket holding the monogram,
and the monogram over a ticket. Every version carrying a strapline or a small
ticket lost it entirely at feed size. Anything that needs to survive 32px can
hold two letters and nothing else.

Test any replacement by cropping it to a circle and viewing it at 48px before
uploading. If you cannot read it there, it does not work.

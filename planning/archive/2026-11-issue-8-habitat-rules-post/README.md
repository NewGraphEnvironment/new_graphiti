## Outcome

The internal draft became the public post `posts/2026-11-01-habitat-rules-tested/`: the text, its bibliography, seven figures, nine stickers and the two scripts that draw the maps. During the work the owner took the site theme from purple to hot pink, reworded two headings, moved the collaboration section to the end, started the expected-use ramp at pale blue and added a thin outline to that map. What was learned: a post with no R chunks and `engine: knitr` still freezes and publishes without R, but `freeze: true` serves the frozen text whatever the source says, so any edit to `index.qmd` needs a re-render and a recommit, and the freeze `hash` (md5 of the source) is the check. Checking a colour or a claim on the copy that prompted the check kept missing the other copies, which is what the review rounds kept finding.

## Measurement

- **Publish without R:** a clean clone on Quarto 1.10.20, the version CI installs, with no `Rscript` on the `PATH`: exit 0, no warnings. Moved the issue's "commit `_freeze/`" from an instruction to a measured requirement.
- **Maps reproduce:** six maps redraw byte-identical from the post's directory in about 2 min; the Elk floodplain step takes about 7 min. Reproducing still needs a PostgreSQL fwapg and knowledge's comparison GeoPackages, and the flow map has no script here.
- **Ungraded floodplain:** 29,675 of 179,471 cells (16.5 %) on the Bulkley window are not drawn on the expected-use map. Changed the caption and alt text.
- **Thin strips:** 1,742 of 149,796 drawn cells (1.2 %) are one cell wide, so the outline reads as dotted lines on some tributaries. Left as the owner approved it.
- **Theme:** no purple-hued colour on any element across five rendered pages, with a control that fires on the earlier build.
- **Wrong turns kept:**
  - The first theme check searched for two hex values and reported no purple left, while inline code held a third. Corrected by review round 2 and the computed-style scan.
  - Five posts with empty pages were first read as a defect, and turned out to be `draft: true`.
  - The first byte-identical redraw also reproduced an opaque map, because the check compares against the same defect.
- **Code check:** four rounds, ended on an enumeration of 23 facts held in more than one place (`review-round3.md`, `review-round4.md`).

## Owed

- On your word, merge; wait on the merge's SHA for the Quarto Publish run and the Pages run
- Fetch `https://www.newgraphenvironment.com/new_graphiti/posts/2026-11-01-habitat-rules-tested/` and the listing, and compare with the source; the deploy commit is not yet a served page
- Replace the internal draft with a link to the post plus the short text proposals adapt, and change its "source private" wording to public

Closed by: the pull request that carries this archive, with `Fixes #8`

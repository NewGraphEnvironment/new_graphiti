## Checklist read

Reviewed at 95c7fe8, clean tree. Non-Mechanisms sections were read up to about 1,100 characters each; the Mechanisms prose was read in full, without table rows.

- `code-check.md`: every H3 under `## Mechanisms` (14), plus Documentation Staleness; A link to a repo-hosted artifact must be *tracked*; Test the cold/create path; Bare `y`, `n`, `on`, `off`, `yes`, `no`. 19 of 37 H3s not read.
- `code-check-r.md`: Moving prose into a code chunk; Regenerated binaries churn git; A database driver's value; `paste()` with a zero-length argument; A library call that dispatches on a global option; `match()` treats NA; `[[` on a named ATOMIC vector; `sprintf("%g", x)`; Rscript reads a script as it runs; `c(name = x)`; `ifelse()` with an all-NA test. 104 of 115 not read.
- `code-check-spatial.md`: bcdata `filter()`; sf `st_intersection()`; terra `plot(type = "classes")`; A name is not a key; terra integer rasters; `st_union()` fails; A GDAL failure partway through `st_read()`; The BC WFS caps; FWA main flow; `terra::plot()` and `plotRGB()`; A nodata value written to PNG. 83 of 94 not read.
- `code-check-shell.md`: Paths. 69 of 70 not read: the diff has no shell.

## The mechanism

**One fact is held in several places and kept in step by hand, and each check ran on the copy that prompted it.** Each change assumed its set had one source and one shape:

- Round 1: "every palette gets alpha" was checked on the named palette. The unnamed one took a different path through `see()`.
- Round 2: "the theme's purple" was checked as two hex values. Quarto holds a third, separately.

The same assumption reaches the places below. Three of them disagree today and are the findings.

| Fact | Where it is held | Verdict at 95c7fe8 |
|---|---|---|
| A class's colour on the map and in its legend | `see(cols)` at script:225 vs plain `cols` at :234; `paste0(cols, "B3")` at :215 vs `cols` at :217 | **Finding 1** (grade map). The rule and scenario maps have the same split, but their classes are nominal, so no class reads as another |
| Palette matches knowledge | comment at :35 vs `col_rule`, `col_grade` vs `R/compare_map.R` | **Finding 2** (grade). `col_rule` matches, and the plum departure is commented at :38 |
| Which cells a map draws | rule map: an NA grade falls to `neither`; grade map: `grade %in% i` drops it; knowledge has a sixth "not graded" class | **Finding 3** |
| Ramp, labels and breaks have equal length | :41, :42, the breaks at :96 | All 5. Nothing derives one from another, but `seq_along` at :98 and :107 only drops classes if the lengths change, and they do not |
| Grade class bins | `findInterval` at :96 vs the `grade_class` column in the gpkg | Agree on all but 7 of 852,431 graded segments province-wide, at the boundaries. Not visible on a map. `rightmost.closed` closes at 0.8, not 1, which puts only an exact 0.8 in class 4; none is in the window |
| Class name strings | :30, :38-40, :70-71, :228, :240, :243, :245, :255-274 | All agree |
| Alpha values | :29, :30, :215, comment at :27 | B3 is 70 %, 73 is 45 %. Agree |
| Colour words in prose | index.qmd:103, 105, 175, 177 (orange, green), 139 (three colours), 108 ("darkest") | Agree with `col_rule` and the images I viewed (grade, chinook existing) |
| "Purple" in the theme | Pulse's variables, `$code-color`, Bootstrap's `$indigo` | See "Checked" below: clean in both Quarto versions |
| Freeze text vs source | freeze `hash` vs `index.qmd` | md5 `0cf86662...`, unchanged by 95c7fe8, per the accepted measurement |
| Script's claim about knowledge's join | header :8 vs `R/floodplain_ha.R:81` | Agree: `flooded::fl_valley_join()` |

## Findings

- **[severity: bug]** posts/2026-11-01-habitat-rules-tested/scripts/habitat-rules_fig-build.R:234 (also :217) — The grade legend's top two swatches do not match what the map draws. Fill goes through `see()` at :225, at 70 % alpha, and the legend gets plain `cols`.
  - Round 2 called this "slightly stronger". Measured on the committed `fig/habitat-rules_chinook-grade.jpg`, it is larger than that:
    - Two samples of the High class on the mainstem read about RGB (58,81,115) and (62,82,115).
    - The High swatch reads (11,34,88) and the fourth swatch (28,92,166). The first High sample is 72 from High and 60 from the fourth swatch, so it is nearer the wrong one.
    - By the same blend over sampled ground colours, class 4 sits about as close to swatch 3 as to swatch 4.
    - So the High swatch's colour appears nowhere on the map, and the top of an ordered ramp reads one class low. This is worst for the mainstem, the map's main subject.
  - Bound: the order of the classes holds, and only Low and High are labelled, so no number is misread. I sampled two High pixels by position and computed the other classes rather than sampling them.
  - Fix tested: `tm_add_legend(fill = unname(see(cols)))` is honoured by tmap 4.2.0.9000, in a small test map. Blended over the white legend, High becomes (82,110,151), 52 from the drawn colour, against 122 for class 4, so the order comes right. Redraws the images whose legends change, and `index.qmd` does not change, so no refreeze.
  - **Rule:** code-check.md "One fact derived twice"

- **[severity: fragile]** posts/2026-11-01-habitat-rules-tested/scripts/habitat-rules_fig-build.R:35 — The comment "knowledge's comparison palette (R/compare_map.R), so these maps read like its articles" stopped being true of `col_grade` at 95c7fe8.
  - knowledge's `.compare_grade_cols` (`R/compare_map.R:149`, same on origin's default branch) is `#f7fbff #c6dbef #6baed6 #2171b5 #08306b`, with `#c6dbef` meaning 0.2-0.4. The script now has `#c6dbef` as its lowest class (0-0.2), and `#9ecae1`, which knowledge's grade palette does not hold, as 0.2-0.4.
  - index.qmd:160 links the chinook article, whose interactive map has a grade layer with knowledge's colours and a numeric legend. So one shade now means different classes in the post and the article it sends readers to.
  - The change is the owner's decision and stands. What is wrong is the comment, whose stated reason no longer holds for the grade ramp. Line 38 records the plum departure this way; the ramp's has no such note.
  - **Rule:** code-check.md "Documentation Staleness"

- **[severity: fragile]** posts/2026-11-01-habitat-rules-tested/index.qmd:108 — The alt text says "the same floodplain shaded from low to high expected use", but 16.5 % of those floodplain cells are not drawn, and neither the legend nor the caption says so.
  - Measured by running the script's own `cells_of()` over the Bulkley window in a temp session: 179,471 cells carry a rule class and 149,796 carry a grade. The other 29,675 (about 27 km²) belong to segments with no grade: 29,651 are "neither" and 24 are "both".
  - The rule maps beside it draw these cells plum. `grade %in% i` at script:98 is FALSE for every class when the grade is NA, so the grade map leaves them as bare basemap, which reads as "not floodplain" rather than "not graded".
  - knowledge gives this state its own class ("not graded" = `#d9d9d9`, `R/compare_map.R:150`), so `col_grade` is also one class short of the palette it cites.
  - Round 1 checked this caption by eye, and no round counted the cells. The commit that changed Low was made because Low "read as a hole"; these cells really are holes.
  - Either draw them as a sixth class, or say in the caption and alt text that only graded streams are shaded. Whichever the owner prefers. Editing `index.qmd` needs a refreeze.
  - **Rule:** code-check.md "A proxy is not the property"

## Checked, nothing to report

- **What depended on the old palette.** Besides findings 1 to 3: `lab_grade` is positional and has five entries. The caption has no colour word. "Darkest along the Bulkley River mainstem" still holds on the new image. `git grep` finds the old hex only in the dated round 1 record. `planning/active/findings.md:42` already records the change.
- **Theme.** Fresh clones rendered in the scratchpad with Quarto 1.4.553 and 1.10.20, both exit 0.
  - In the 1.10.20 CSS, `#7d12ba`, `#593196` and `#a991d4` have 0 hits, and `--bs-code-color` is `#FF00CE` (plus `white` in one scoped rule).
  - A computed-style scan cannot see `:hover`, `:focus` or `:active`, so I scanned the CSS text by hue. The purple-hued values left are `#6610f2` and Bootstrap's gradient utilities derived from it, and `#17141f`, near-black body text with its tints. In 1.10.20, no `:hover`, `:focus` or `:active` rule uses `#6610f2`.
  - No `quarto-*` stylesheet carries a purple hue (scanned in both builds; 1.4.553 also its other non-widget CSS). `styles.css` sets no colour.
- **Rule and scenario legends.** Same alpha split as finding 1, but the classes are nominal. On the chinook existing map, blue, orange and plum stay clearly apart, and the caption's colour words hold. I viewed this one rule map at this round.
- **Not reachable or not harmful.** `classify()` with a one-row matrix is two-column from/to. The `sprintf` `%1$s` key list ran on the cold path. `file.rename` return is checked at elk:73. GNIS names shared across BC are clipped to the window first.
- **Public text.** I read the post, both scripts, `planning/` and the theme. No host, local path, client or private repo name. `gh api` read knowledge's file as public. `findings.md` and `task_plan.md` say "an internal repo" without naming it.

## Not checked

- Links and DOIs were not re-probed: 95c7fe8 does not touch `index.qmd` or the `.bib`.
- The two westslope cutthroat maps were not viewed at this round, and their NA-grade share is not relevant since neither is a grade map.

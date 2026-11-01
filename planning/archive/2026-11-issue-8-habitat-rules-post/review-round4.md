## Checklist read

Reviewed at 8315e2a, clean tree. Line numbers below are at that commit. Mechanisms prose was read in full without table rows. Other sections were read in full, except the two marked.

- `code-check.md`: every H3 under `## Mechanisms` (14), plus Documentation Staleness; A link to a repo-hosted artifact must be *tracked*; Bare `y`, `n`, `on`, `off`, `yes`, `no`. 20 of 37 H3s not read.
- `code-check-r.md`: Moving prose into a code chunk; Regenerated binaries churn git (first 2,600 of 3,740 characters); `paste()` with a zero-length argument; A library call that dispatches on a global option (first 2,600 of 3,088); `match()` treats NA; `[[` on a named ATOMIC vector; Rscript reads a script as it runs; `c(name = x)`. 107 of 115 not read.
- `code-check-spatial.md`: sf `st_intersection()`; terra `plot(type = "classes")`; A name is not a key; A raster's drawn footprint; `terra::rast()` on a SpatRaster; terra integer rasters; `sf::st_read()` promotes; terra `unique()` and `freq()`; FWA main flow; `terra::plot()` and `plotRGB()`. 84 of 94 not read.
- `code-check-shell.md`: Paths. 69 of 70 not read: the diff has no shell.

## Findings

Both are comments that state something false or partial about a sibling package. Neither changes a map or the page, and neither needs a redraw or a refreeze.

- **[severity: fragile]** posts/2026-11-01-habitat-rules-tested/scripts/habitat-rules_fig-build.R:125 — The comment "gq has no stream label yet; its blue italic water label is the lake entry's" is false.
  - gq's registry has a `stream_labels` layer (`inst/registry/reg_main.json:532`), in the installed gq 0.16.1 and on gq's default branch. It has been there since 2026-02-22 by `git log -S`.
  - Its label `color` and `style`, the only two fields the script reads (:188), are `identical()` to the lake entry's. So the drawn labels are right today, and only the stated reason is wrong.
  - Round 3's table did not hold this row. It checked the script's claim about knowledge's join, not its claims about gq.
  - Fix: read `gq::gq_reg_main()$layers$stream_labels$label` and drop the comment. The same two values go in, so the maps should not change.
  - **Rule:** code-check.md "A guard's scope, escape hatches, and remedies"

- **[severity: fragile]** posts/2026-11-01-habitat-rules-tested/scripts/habitat-rules_fig-build.R:41 — This is the fix for round 3's finding 2, and it is true only of the case it names. "knowledge's blues with its near-white low class replaced" describes one change, and two classes changed.
  - knowledge (`R/compare_map.R:149`, same on its default branch): `#f7fbff #c6dbef #6baed6 #2171b5 #08306b`.
  - Script (:42): `#c6dbef #9ecae1 #6baed6 #2171b5 #08306b`.
  - So class 2 (0.2-0.4) also changed, to `#9ecae1`, which knowledge's palette does not hold. `#c6dbef` moved down a class, so it means 0-0.2 here and 0.2-0.4 in the chinook article index.qmd:160 sends readers to. That is what round 3 raised, and the new comment leaves it out.
  - The palette is the owner's decision and stands. Only the sentence is short. Suggested wording: "knowledge's blues with its near-white dropped: `#c6dbef` moves down to the lowest class, and `#9ecae1`, not knowledge's, takes 0.2-0.4".
  - **Rule:** code-check.md "A guard's scope, escape hatches, and remedies"

## The fixes in 8315e2a

No defect found in the code of the fixes.

- **`see(cols)` in the scenario legend (:218).** `cols` is unnamed there, so `names(cols) %in% "neither"` is `logical(0)` and `a` stays all `B3`, the same as the cells at :216. That is the path round 1 got wrong, and it now gives the right length.
- **Legends took the alpha in all six images.** I sampled all 20 swatches by position. Each sits within 15 per channel of its colour blended over white at the stated alpha, and far from the plain colour. For example, High reads (82,100,138), against (82,110,151) blended and (8,48,107) plain. Plum reads (186,159,200), against (195,168,209) and (123,63,152). The blend's small gap is expected, because the legend panel is 90 % white over the basemap.
- **Outline (:237).** `as.polygons(ifel(is.na(r), NA, 1L))` dissolves to the graded footprint only, so ungraded floodplain has no outline. That agrees with the new caption. It is drawn only for the grade map (:266).
- **New caption and alt text.** They are in the freeze markdown and on the page rendered from a clean clone at 8315e2a (1 hit). The freeze `hash` equals md5 of `index.qmd`, `6aac0961...`. The frozen body differs from the source only by 3 added blank lines.
- **Commit message and findings.md.** "All six images changed" holds: `git show --stat` lists all six jpgs.

## The mechanism, walked at 8315e2a

Rows 1 to 11 are round 3's. The rest are new, and each one's verdict is from this round.

| # | Fact | Where it is held | Verdict | What was read or measured |
|---|---|---|---|---|
| 1 | A class's colour on the map and in its legend | cells :216, :226; legend :218, :240 | **Agree** | Read all four. 20 swatches sampled, as above. Bound: a legend swatch blends over white and a cell over the ground, so the two can never be identical. Stream lines (:232) stay opaque and have no legend entry |
| 2 | Palette matches knowledge | comments :35, :38, :41; `col_rule` :37; `col_grade` :42; knowledge `R/compare_map.R:147-150` | **Finding 2** (grade). `col_rule` agrees | Read knowledge on its default branch. The three shared rule colours match. `neither` is `#cccccc` there and plum here, and :38 says so |
| 3 | Which cells a map draws | `rule %in% i`, `grade %in% i` :98-99; caption and alt text index.qmd:108 | **Agree** | Re-ran `cells_of()` on a temp copy: 179,471 class cells and 149,796 graded, so 29,675 or 16.53 %. Rasterizing `all_ff04` alone gives 179,471 floodplain cells in the window, so no third group of undrawn cells exists on the rule maps. On the grade map the plum lake east of the highway is bare basemap, as the caption says |
| 4 | Ramp, labels and breaks have equal length | :42, :43, :97 | **Agree**, all 5 | Read. Five swatches on the image |
| 5 | Grade class bins | `findInterval` :97 vs `grade_class` in the gpkg | **Agree** but for 7 | Re-measured on `CH_rear.gpkg`: 852,431 graded, 7 off the diagonal, each one class up from its label. Maximum grade is 1.0. No exact 0.8 in the whole table, since class `0.8-1` has no row in bin 4 and `0.6-0.8` none in bin 5 |
| 6 | Class name strings | :30, :37-40, :71-72, :229, :246, :251, :252, :261-264, :278-281 | **Agree** | Read each |
| 7 | Alpha values | comment :27; :29, :30, :216 | **Agree** | `B3` = 179/255 = 70.2 %, `73` = 115/255 = 45.1 %. :216 repeats `B3` by hand, and :218 reaches it through `see()`. Same value, two expressions |
| 8 | Colour words in prose | index.qmd:103, 105, 175, 177, 139, 108 | **Agree** | Viewed all six maps. Orange on the existing maps, green on the tuned, three colours on the scenarios, darkest on the Bulkley mainstem |
| 9 | "Purple" in the theme | `theme-pink.scss`; built CSS | **Agree** | No diff to `theme-pink.scss`, `_quarto.yml` or `styles.css` since 95c7fe8. Clean-clone CSS at 8315e2a: `#7d12ba`, `#593196` and `#a991d4` have 0 hits, and `--bs-code-color` is `#FF00CE` and `white` |
| 10 | Freeze text vs source | freeze `hash` vs `index.qmd` | **Agree** | md5 computed: `6aac0961...` both. Round 3's `0cf86662...` is its own commit's value |
| 11 | Script's claim about knowledge's join | header :8 vs `R/floodplain_ha.R:81` | **Agree** | Read: `flooded::fl_valley_join(valleys, bl, sg, group = "blue_line_key", cols = flags)` |
| 12 | Script's claims about gq | comments :35-36, :125 vs gq's registry | **Finding 1** (:125). :35-36 agrees | `names(gq_reg_main()$layers)` matching flood, rule or grade returns only `floodplains`, the province's mapped floodplain polygons, not a flood factor layer |
| 13 | Outline colour vs the ramp | `edge = "#2171b5"` :266; `col_grade[4]` :42 | **Same hex, by the owner's design. No finding.** | At full opacity the outline is class 4's colour, and it nearly covers a one-cell-wide strip. Measured: 1,742 of 149,796 drawn cells (1.2 %) are one cell wide, 1,363 of them Low. By eye they read as dotted blue lines on narrow tributaries (left edge of the image). Reported so the owner has the number. Using `#6baed6` or a grey would remove it |
| 14 | Scenario order and labels | :206 and layer list :211 vs floodplains' `base_scenarios` | **Agree** | ff02 active channel margin, ff04 functional floodplain, ff06 valley bottom, in `scripts/run_region.R` |
| 15 | "Nested inside the next" | index.qmd:139 vs the layers | **Agree** | Rasterized on the map's window: 150,664, 178,349 and 187,288 cells. ff02 outside ff04: 0. ff04 outside ff06: 0 |
| 16 | Elk parameters are the catalogue's | elk script :60-63, header :2-3 vs floodplains config | **Agree**, compared with the Bulkley | `all_ff02/04/06` in `config/bulk/flood_scenarios.csv`: order 2, slope 9, width 2000, cost 2500, size 5000, hole 2500. floodplains has no Elk config to compare with, which is what the post's "drawn for this map" says |
| 17 | Catalogue layers vs the script's reads | header :4-5, :88, :90, :211 vs the gpkgs | **Agree** | `ogrinfo` on the `kotl` asset and the Elk output: `all_ff02`, `all_ff04`, `all_ff04_by_blue_line_key`, `all_ff06`. The item id is `kotl_all_ff04`, as the header says |
| 18 | Figure names | script :262-281, index.qmd, git | **Agree** | Six names match. All 16 `fig/` paths in `index.qmd` are tracked (7 figures, 9 stickers, the counts in task_plan.md) |
| 19 | Citation keys | index.qmd vs the `.bib` | **Agree** | 17 keys, none missing, none uncited |
| 20 | Places named in captions | index.qmd:103, 139, 175 vs the images | **Agree** | Telkwa and Houston, Creston, Elkford and Sparwood are labelled on the images. The window's frame runs from town to town |
| 21 | Basemap credit | index.qmd:249 vs :54-55 | **Agree** | Esri World Topographic and World Shaded Relief. The flow map, also viewed, has no basemap, so "the maps" does not misdescribe it |
| 22 | Numbers in planning text | findings.md, task_plan.md | **One line is stale, no finding** | 29,675, 179,471 and 16.5 % reproduce. task_plan.md Phase 1 says "Committed images stay the draft's", but all six maps are now redraws. It records that step as it was then. The archive README should not repeat it |
| 23 | Issue numbers the branch cites | task_plan.md, findings.md, progress.md | **Agree** | #8 is this post's issue and is open. #5 is the earlier post, merged, as task_plan.md says |

## Checked, nothing to report

- **Public text.** I read the post, both scripts, `planning/` and the theme, and grepped them for local paths, hosts, ports and tunnels: no real hit. I also grepped them as whole words for each of the org's 71 private repo names. There is one hit, at `.bib:60`, a third party's public URL (answers 200) whose last segment shares a name. It is not a link to anything of ours.
- **Mechanism checks on the rest of the diff.** `rast(valleys)` at :103 and `rast(grid_of(w))` at :208 are the "empty template" trap used on purpose: both then assign values. `match(own$class, ...)` at :96 has no NA, since `class` is built from logicals. `sg[sg$class != "neither", ]` at :229 likewise. The `rivers` query's edge types include all five of the main flow list, and it only places labels.
- **CI and origin.** `git log HEAD..origin/main` is empty after a fetch. The latest Quarto Publish and Pages runs succeeded.

## Not checked

- Links and DOIs, beyond the one URL above: 8315e2a changes no link.
- I did not redraw the maps. The image checks are on the committed files, with swatches sampled by position.
- Row 13's reading of thin strips is by eye. The cell count is measured, and I did not sample what each strip's pixels finally show.
- Row 16 compares the Elk script with the Bulkley's config, since no Elk config exists.

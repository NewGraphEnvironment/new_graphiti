## Checklist read

Sections were read up to about 1,800 characters each (the Mechanisms prose in full).

- `code-check.md`: every H3 under `## Mechanisms` (14), skipping table rows, plus Documentation Staleness, A link to a repo-hosted artifact must be *tracked*, Percent-encode a URL at construction, Test the cold/create path of idempotent code, Credentials. 18 of 37 H3s not read.
- `code-check-r.md`: `paste()` with a zero-length argument; A database driver's value; `$` on a list partial-matches; Postgres row order; `sprintf("%g", x)`; Regenerated binaries churn git; `c(name = x)`; `[[` on a named ATOMIC vector; `ifelse()` with an all-NA test; Rscript reads a script as it runs; `match()` treats NA; A library call that dispatches on a global option. 103 of 115 not read.
- `code-check-spatial.md`: terra integer rasters; A name is not a key; bcdata `filter()`; The BC WFS caps; FWA main flow; sf `st_intersection()`; sf reproject the polygon; `st_union()` fails; A GDAL failure partway through `st_read()`; sf name validation; Writing KML; GeoJSON in a projected CRS; `terra::plot()` and `plotRGB()`; A Freshwater Atlas main stem; bcdata all-missing column; A nodata value written to PNG; terra keeps a result in memory; `atan2(0, 0)`; `terra::cells()`. 75 of 94 not read.
- `code-check-shell.md`: Paths. 69 of 70 not read: the diff has no shell.

## Tree reviewed

`branch.diff` is older than HEAD. Commit 406687e landed at 15:33 (-07:00) on 2026-11-01, after the diff was taken: it moves the Collaboration section and rewords two headings in `index.qmd`, and refreezes. I reviewed that commit's diff as well. Line numbers below are at 406687e. Its changes are prose only, and the freeze `hash` still equals md5 of `index.qmd` (0cf86662...). The frozen markdown differs from the source only by three blank lines.

## Findings

- **[severity: bug]** posts/2026-11-01-habitat-rules-tested/scripts/habitat-rules_fig-build.R:28-31 — `see()` silently adds no alpha to an unnamed palette, so the published chinook-grade map is opaque, against the script's own comment at line 27 ("the ground shows through"). `col_grade` (line 40) has no names, so `names(cols) %in% "neither"` is `logical(0)`, `ifelse()` returns `logical(0)`, and `paste0(cols, logical(0))` returns `cols` unchanged. Measured: `see(c("#f7fbff","#c6dbef"))` returns `"#f7fbff" "#c6dbef"`, while the named palette gets `B3` and `73`. The call at line 258 (through `map_cells()`, line 224) therefore draws all five grade classes opaque. In the committed `fig/habitat-rules_chinook-grade.jpg`, the Low class (`#f7fbff`) shows as near-white patches that hide the basemap and look like holes in the map, and the three rule maps let the ground through. The map's reading stays correct: the legend and the caption hold. The harm is the hidden ground and a comment that is false for this figure. Either fix means a decision on the image: give `see()` a default alpha for an unnamed palette (for example `if (is.null(names(cols)))`) and redraw this one image (no refreeze, since `index.qmd` does not change), or keep the opaque look on purpose and say so in the comment. The byte-identical redraw could not catch this, because it reproduces the defect.
  - **Rule:** code-check.md "Zero-length, empty, and unset are three different things" ; code-check-r.md "`paste()` with a zero-length argument returns length ONE, not zero"

## Checked, nothing to report

- Public text: read `index.qmd`, the `.bib`, both scripts and `planning/`. A grep of those plus the freeze found no local paths or hosts, and the read found no private repo, client or project name. `planning/` says "an internal repo" without naming it. No path or software metadata turned up in a `strings` scan of the seven figures and one sticker. Commit messages are clean. gq, flooded, knowledge, floodplains and stac_floodplains_bc all read PUBLIC.
- Links: all 18 URLs in `index.qmd` answer 200. The five Zenodo DOIs in the `.bib` were not covered by the earlier URL probe, because those entries' `url` is GitHub; each resolves to the right package title. All seven figures and nine stickers the post names are in the diff.
- Script header claims: `kotl_all_ff04/floodplain.gpkg`, read live, carries `all_ff02`, `all_ff04`, `all_ff04_by_blue_line_key` and `all_ff06`, as `habitat-rules_fig-build.R` needs. The Elk parameters match the published `all_ff0N` rows in floodplains' `flood_scenarios.csv` (9, 2000, 2500, 5000, 2500), and `anchor_order`, which the Elk query does not use, is documentation-only in that repo per `region_config-check.R`.
- Not reachable or not harmful in these scripts: `IN ()` on empty `keys` (ELKR has waterbodies, and the script ran); the `gnis_name` lookup on names shared across BC (labels are clipped to the window first); `edge_type` adding 1100 and 1150 (labels only).
- Figure captions checked by eye on the grade, Elk existing and scenarios images: towns, rivers, colours and legend agree with the text.
- Not exercised: the cold path of the `rivers.gpkg` cache, which needs a live fwapg. I have no evidence either way on whether it ran.

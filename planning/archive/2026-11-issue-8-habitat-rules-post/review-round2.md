## Checklist read

Reviewed at b2ca83a (`git log -1` in the tree). Sections read up to about 1,300 characters each (the Mechanisms prose in full).

- `code-check.md`: every H3 under `## Mechanisms` (14), skipping table rows, plus Documentation Staleness; A link to a repo-hosted artifact must be *tracked*; Bare `y`, `n`, `on`, `off`, `yes`, `no`. 20 of 37 H3s not read.
- `code-check-r.md`: `paste()` with a zero-length argument; `ifelse()` with an all-NA test; `c(name = x)`; Regenerated binaries churn git; Rscript reads a script as it runs; A library call that dispatches on a global option. 109 of 115 not read.
- `code-check-spatial.md`: terra integer rasters; `terra::plot()` and `plotRGB()`; A nodata value written to PNG. 91 of 94 not read: round 1 read the spatial sections, and nothing spatial changed but `see()`.
- `code-check-shell.md`: none read. 70 of 70 not read: the diff has no shell.

## Clean

No issues found.

## Checked, nothing to report

- **`see()`, every caller.** It has one call site, `map_cells()` at `scripts/habitat-rules_fig-build.R:225`, which is reached with three palettes. I ran the function in a temp script:
  - grade (unnamed): all five `B3`, and `setNames(unname(.), 1:5)` keeps them in order
  - existing rule, `col_rule[c(1,2,4)]`: `B3 B3 73`, `neither` last
  - tuned rule, `col_rule[c(1,3,4)]`: `B3 B3 73`, mapped to levels 1, 3, 4
  - `character(0)`: returns `character(0)`
  `map_scenarios()` does not call it. It sets its own `B3` at line 215. `B3` is 70 % and `73` is 45 %, as the comment at line 27 says.
- **The redrawn grade map.** I viewed it beside the prior image from git.
  - The ground now shows through all five classes.
  - The alt text's "darkest along the Bulkley River mainstem" still holds, as does the caption's "shaded by how likely chinook are to use the stream beside it".
  - The legend swatches stay opaque, so they read slightly stronger than the map. The other maps do the same (line 234 passes the plain `cols`).
  - By eye, the Low class is less separate from the basemap's pale clearings than when it was solid. It is still lighter than the forest and the map still reads. This is a look to judge, not a defect, and it is what was asked for.
- **The moved section and reworded headings.**
  - A grep of `index.qmd` for "above", "below", "earlier", "later", "previous", "following" and "next section" finds only "below X % gradient", "above Y m wide" and "resident populations above falls". None points at a section.
  - "The same steps" (line 155) and "All of it" (line 199) do not depend on what the moved section used to neighbour.
  - The Collaboration text reads correctly after the tools section, and the intro's closing line (34-35) still matches it.
  - "auditable offsets" agrees with line 192, and "what the evidence supports" agrees with both species paragraphs.
- **Freeze.** The `hash` equals md5 of `index.qmd` (0cf86662...). The frozen markdown carries both new headings, has no "defensible", and puts Collaboration after the packages section. b2ca83a touches no text the freeze holds.
- **Theme.**
  - `theme-pink.scss` carries the `scss:defaults` marker, and its variables reach the build: `#FF00CE` appears 107 times and `#FF80E7` 41 times in `_site/site_libs/bootstrap/bootstrap.min.css`.
  - No rule in the built CSS sets text to `#FF80E7`. It reaches mermaid as the edge colour (`--mermaid-edge-color`), which is a line, not text.
  - Mermaid node text stays `#444`. Its label colour is the primary pink, the 3.4:1 already reported.
  - `css: styles.css` is kept, and the logo it names is tracked.
  - No post sets its own `theme:`.
- **For the owner, not a defect.** Inline code stays purple: `--bs-code-color: #7d12ba` is in the built CSS. I believe this is Quarto's default rather than Pulse's purple, but I did not trace its source, so the earlier grep for `#593196` and `#a991d4` could not see it. Set `$code-color` in `theme-pink.scss` if purple should go everywhere. Nothing breaks either way.
- **Public text in the new commits.** A grep of `planning/`, both scripts, `index.qmd`, `theme-pink.scss` and `_quarto.yml` for local paths and hosts finds no real hit; the only match is `.localcode_ltree` in the Elk SQL. I read `planning/active/review-round1.md`, the added file, and it names no private repo or host. Its "Not exercised: the cold path of `rivers.gpkg`" line was true when written and is overtaken by the later measurement. It is a dated round record, so it stands.

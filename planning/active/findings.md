# Findings - Post: habitat rules, tested and carried onto the floodplain (#8)

## Issue context

**If we do it:** one public post tells how knowledge, link, wet, fresh and flooded test fish habitat rules against fish evidence province-wide and carry them from the stream line onto the floodplain, as areas for conservation, restoration and policy planning, and proposals and reviewers can link to it. **If we never do:** the story stays in an internal draft and package READMEs, and nobody outside sees how the pieces fit.

## Problem

knowledge went public on 2026-11-01, so its documentation can now be linked. A draft of this post was written while it was private and kept in an internal repo, because a branch here is already public. The draft is about 2,700 words of Quarto with a bibliography and maps built by an R script: flood factors on the Kootenay flats, chinook on the Bulkley, westslope cutthroat in the Elk Valley upstream of Fernie, each rule shown as existing and tuned.

## Proposed

- [ ] `posts/2026-11-01-habitat-rules-tested/index.qmd` from the draft, with its `.bib`, the map images (and the script that draws them, if it can run from here) and a listing `image`; front matter as the other posts (`author`, `date`, `categories`, `params`)
- [ ] Read for public text before the first push: no client or project names, no links to private repos, no hosts or local paths. Every repo and catalogue it links resolves without a login
- [ ] Links point to the public documentation: knowledge's pkgdown site and articles, link, fresh, wet, flooded, and the stac-floodplains-bc catalogue
- [ ] Render locally with `quarto render` and commit `_freeze/`: posts freeze (`posts/_metadata.yml`) and the publish workflow installs Quarto only, no R
- [ ] Push to `main`; confirm the Quarto Publish run passed and the page is served at <https://newgraphenvironment.com/new_graphiti/>, by fetching it

The draft's own rules carry over: scale and method rather than counts that move when the evidence is rebuilt, no comparison with other groups, a limit given a clause where it matters, and an open invitation to shape the next steps.

## What exploration found

- **Links:** every URL in the post and its `.bib` answers 200 with curl, except two Wiley DOIs (`10.1111/1752-1688.12643`, `10.1111/j.1752-1688.2007.00063.x`), which answer 403 to curl. Those two still need a browser check.
- **Repos:** all 17 repos checked read PUBLIC, including knowledge, the five `stac_*` catalogues and the fwapg fork.
- **Public text:** a word scan of the post finds no internal repo, client, funder, host or local path. The two map scripts hit only on `samples/` paths and hex colours. A scan does not replace reading, so Phase 2 reads it through.
- **R on CI:** the post has no R chunks but sets `engine: knitr`, and the publish workflow has no R. `posts/_metadata.yml` sets `freeze: true`, so a post with no frozen result would try to run R on CI. It is unmeasured whether Quarto writes `_freeze/` for a post with no chunks. Phase 3 tests this rather than assuming it.
- **Map scripts:** `habitat-rules_fig-build.R` needs the catalogue cache, knowledge's comparison GeoPackages and a PostgreSQL fwapg. The Elk script also needs the `fresh_default` schema. On this machine the GeoPackages are present, and `towns_gns.gpkg` and `elkr_floodplain.gpkg` were not found. No script for `habitat-rules_flow-sources.png` turned up.
- **Preview script:** the draft's `habitat-rules_post-preview.R` already holds the post's header, and strips `custom.css`. `_quarto.yml` names `custom.css`, the repo has only `custom.scss`, and the last publish still passed.

## Errors Encountered

| Error | Resolution |
|-------|------------|

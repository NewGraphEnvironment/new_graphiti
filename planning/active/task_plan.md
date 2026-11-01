# Task: Post: habitat rules, tested and carried onto the floodplain (#8)

knowledge went public on 2026-11-01, so its documentation can now be linked. A draft of this post was written while it was private and kept in an internal repo, because a branch here is already public. The draft is about 2,700 words of Quarto with a bibliography and maps built by an R script: flood factors on the Kootenay flats, chinook on the Bulkley, westslope cutthroat in the Elk Valley upstream of Fernie, each rule shown as existing and tuned.

## Decided at the gate (the agent's calls, approved with the plan by the owner, 2026-11-01)

1. **Branch and PR, not a direct push to `main`.** The issue says push to `main`. The merge is what publishes, and it waits for your word. The last post also went by PR (#5).
2. **Author stays `Al Irvine, R.P.Bio.`** as drafted, because reviewers will link this post. The other posts say `al`.
3. **`embed-resources` is dropped.** The site serves the files, and embedding would add about 8 MB of base64 to one page. `toc: true` from the draft is kept.
4. **Scripts go in only if they run.** The issue's condition is "if it can run from here", so Phase 1 tries it. If it fails, the post ships images only and the report says what the scripts need.
5. **`habitat-rules_bib-write.R` stays out.** The `.bib` is static and the script reads an internal file.

## Phase 1: Bring the post across

- [ ] Run the no-argument `/planning-init` setup, since `planning/` does not exist yet
- [ ] Create `posts/2026-11-01-habitat-rules-tested/` with `index.qmd`, `habitat-rules-tested.bib`, and only the images the post uses: seven maps and figures under `fig/`, nine stickers under `fig/hex/`
- [ ] Front matter: title, subtitle, author, `date: "2026-11-01"`, `categories: [r, fish, floodplain, habitat, stac]`, `image: "fig/habitat-rules_scenarios.jpg"`, `params` (`repo_owner`, `repo_name`, `post_name`), `bibliography`, `toc`
- [ ] Try `habitat-rules_fig-build.R` with its paths re-anchored to the post and `OUT_DIR` in the scratchpad; include it and the Elk script only if they redraw the maps. Committed images stay the draft's

## Phase 2: Public text

- [ ] Read the whole post, the `.bib` and any included script for client or project names, private repos, hosts and local paths
- [ ] Open the two Wiley DOIs in a browser
- [ ] Re-run the URL probe over the post as it now stands, and confirm the links named in the issue are there: knowledge's site and articles, link, fresh, wet, flooded, stac-floodplains-bc

## Phase 3: Render and freeze

- [ ] `quarto render posts/2026-11-01-habitat-rules-tested/index.qmd`; no `citation not found` warnings
- [ ] Commit the post's `_freeze/` output if Quarto writes one, and nothing else under `_freeze/`. If it writes none, remove `engine: knitr`, so nothing asks for R
- [ ] Render a clean clone with R off the `PATH`, as CI has it
- [ ] Look at the rendered page in a browser: mermaid chart, paired maps, sticker table, five-column catalogue row, references

## Phase 4: To the PR

- [ ] `/code-check branch`
- [ ] Re-read origin (`git log HEAD..origin/main`)
- [ ] `/planning-archive`, then `/gh-pr-push` with `Fixes #8`, and a check of every issue number the branch introduces

## Owed at the end (reported, done after merge)

- [ ] On your word, merge; wait on the merge's SHA for the Quarto Publish run and the Pages run
- [ ] Fetch `https://www.newgraphenvironment.com/new_graphiti/posts/2026-11-01-habitat-rules-tested/` and the listing, and compare with the source; the deploy commit is not yet a served page
- [ ] Replace the internal draft with a link to the post plus the short text proposals adapt, and change its "source private" wording to public

## Validation

- [ ] Clean-clone render with no R passes
- [ ] `/code-check` clean over the branch
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive` on completion

Each change is proved by the render with no R (publish works), the URL probe (links resolve), the read-through (public text) and the served-page fetch after merge (it is live).

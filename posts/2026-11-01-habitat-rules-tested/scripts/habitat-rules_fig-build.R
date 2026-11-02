# Draw the maps in this post: one floodplain under three flood factors, and chinook and westslope
# cutthroat rearing joined to it by position.
#
# CAT_DIR holds each group's floodplain from the public stac-floodplains-bc catalogue, the `floodplain`
# asset of item <group>_all_ff04 saved as <group>_floodplain.gpkg, for bulk, morr and kotl. Towns and
# rivers are cached there on the first run, the rivers from a PostgreSQL fwapg (the standard PG*
# variables). KNOWLEDGE_GPKG is data/compare/gpkg in a knowledge checkout, which knowledge builds and
# does not commit. The join is the one knw_floodplain_ha() uses: flooded::fl_valley_join(), each cell
# to the nearest segment among the stream lines that claim it. Run from this post's directory:
#
#   CAT_DIR=<dir> KNOWLEDGE_GPKG=<dir> Rscript scripts/habitat-rules_fig-build.R
#
# The Elk River group needs habitat-rules_elk-floodplain.R run first. The flow map
# (habitat-rules_flow-sources.png) is not drawn here.

suppressPackageStartupMessages({
  library(sf)
  library(terra)
  library(tmap)
})
sf_use_s2(FALSE)

dir_cat <- Sys.getenv("CAT_DIR")
dir_gpkg <- Sys.getenv("KNOWLEDGE_GPKG")
if (!dir.exists(dir_cat) || !dir.exists(dir_gpkg)) stop("set CAT_DIR and KNOWLEDGE_GPKG", call. = FALSE)
dir_out <- Sys.getenv("OUT_DIR", "fig")
# the ground shows through: story classes at 70 %, the floodplain no rule claims at 45 %
see <- function(cols) {
  a <- rep("B3", length(cols))
  a[names(cols) %in% "neither"] <- "73"
  setNames(paste0(cols, a), names(cols))
}
if (!dir.exists(dir_out)) stop("run from the post's directory", call. = FALSE)

# the rule colours are knowledge's comparison palette (R/compare_map.R), so these maps read like its articles; gq has no
# registry entry for rule comparisons, grades or flood factors yet
col_rule <- c(both = "#1b6ca8", current = "#d95f02", tested = "#1b9e77",
              neither = "#7b3f98")   # plum: apart from the blue, orange and the basemap's green
lab_rule <- c(both = "Habitat under both rules", current = "Existing rule only",
              tested = "Tuned rule only", neither = "Floodplain, neither rule")
# the grade ramp starts at pale blue so Low shows on pale ground, which moves it off knowledge's: #c6dbef
# is 0-0.2 here and 0.2-0.4 in its articles, and #9ecae1 is not in its palette
col_grade <- c("#c6dbef", "#9ecae1", "#6baed6", "#2171b5", "#08306b")
lab_grade <- c("Low", "", "", "", "High")

# a square window, in EPSG:3005, around a point (m)
win_of <- function(x, y, half, half_y = half) {
  st_as_sfc(st_bbox(c(xmin = x - half, ymin = y - half_y, xmax = x + half, ymax = y + half_y),
                    crs = 3005))
}

# tiles warped to BC Albers with room to spare, so the frame is the square the data are cut to
basemap_of <- function(w, zoom) {
  bb <- sf::st_bbox(st_transform(st_buffer(w, 5000), 4326))
  topo <- gq::gq_basemap_tiles(bb, provider = "Esri.WorldTopoMap", zoom = zoom, pad = 0, crs = 3005)
  relief <- gq::gq_basemap_tiles(bb, provider = "Esri.WorldShadedRelief", zoom = zoom, pad = 0, crs = 3005)
  if (is.null(topo) || is.null(relief)) stop("basemap tiles did not fetch", call. = FALSE)
  gq::gq_basemap_blend(topo, relief, method = "gamma", gamma = 1)
}

gpkg_of <- function(g) file.path(dir_cat, paste0(g, "_floodplain.gpkg"))

layer_in <- function(f, layer, w) {
  x <- st_read(f, layer, wkt_filter = st_as_text(w), quiet = TRUE)
  st_zm(x, drop = TRUE)
}

segments_of <- function(key, w) {
  x <- layer_in(file.path(dir_gpkg, paste0(key, ".gpkg")), "segments", w)
  for (f in c("accessible", "rearing_default", "rearing_tuned")) x[[f]] <- as.integer(x[[f]]) %in% 1L
  x$blue_line_key <- as.numeric(x$blue_line_key)
  x$class <- ifelse(x$rearing_default & x$rearing_tuned, "both",
                    ifelse(x$rearing_default, "current", ifelse(x$rearing_tuned, "tested", "neither")))
  x
}

# the catalogue's 30 m grid over a window: cell edges at multiples of 30. Clipping a whole group's
# floodplain polygon to a window can drop most of it, so layers are rasterized, never cropped
grid_of <- function(w) {
  bb <- st_bbox(w)
  rast(xmin = floor(bb[["xmin"]] / 30) * 30, xmax = ceiling(bb[["xmax"]] / 30) * 30,
       ymin = floor(bb[["ymin"]] / 30) * 30, ymax = ceiling(bb[["ymax"]] / 30) * 30,
       resolution = 30, crs = "EPSG:3005")
}

# floodplain cells inside the window, each taking its owning segment's value
cells_of <- function(g, sg, w) {
  w_big <- st_buffer(w, 3000)
  fp <- do.call(rbind, lapply(g, function(x) st_read(gpkg_of(x), "all_ff04", quiet = TRUE)["geom"]))
  bl <- do.call(rbind, lapply(g, function(x) {
    layer_in(gpkg_of(x), "all_ff04_by_blue_line_key", w_big)[, "blue_line_key"]
  }))
  bl$blue_line_key <- as.numeric(bl$blue_line_key)
  valleys <- rasterize(vect(fp), grid_of(w_big), field = 1L, background = 0L, touches = FALSE)
  own <- sg[sg$blue_line_key %in% bl$blue_line_key, ]
  # one logical column per class, the form the join carries to each cell
  rule <- match(own$class, names(col_rule))
  grade <- findInterval(own$grade, c(0, 0.2, 0.4, 0.6, 0.8), rightmost.closed = TRUE)
  for (i in seq_along(col_rule)) own[[paste0("r", i)]] <- rule %in% i
  for (i in seq_along(col_grade)) own[[paste0("g", i)]] <- grade %in% i
  cols <- c(paste0("r", seq_along(col_rule)), paste0("g", seq_along(col_grade)))
  j <- flooded::fl_valley_join(valleys, bl, own, group = "blue_line_key", cols = cols)$nearest
  fill <- function(prefix, n) {
    r <- rast(valleys)
    values(r) <- NA_real_
    for (i in seq_len(n)) r[j$cell[j[[paste0(prefix, i)]]]] <- i
    crop(r, vect(w))
  }
  list(class = fill("r", length(col_rule)), grade = fill("g", length(col_grade)))
}

# towns from BC Geographical Names, the source gq's town style names; cached in CAT_DIR. The 1:2M major
# cities layer is too coarse: it puts Elkford 18 km from where it is
f_towns <- file.path(dir_cat, "towns_gns.gpkg")
if (!file.exists(f_towns)) {
  types <- c("City", "Town", "Village (1)", "District Municipality (1)")
  x <- bcdata::bcdc_query_geodata("WHSE_BASEMAPPING.GNS_GEOGRAPHICAL_NAMES_SP")
  x <- bcdata::collect(bcdata::filter(x, FEATURE_TYPE %in% local(types)))
  x <- st_transform(x, 3005)[, "GEOGRAPHICAL_NAME"]
  names(x)[1] <- "NAME"
  st_write(x, f_towns, quiet = TRUE)
}
towns <- st_read(f_towns, quiet = TRUE)
if (!nrow(towns)) stop("no towns", call. = FALSE)
sty_town <- gq::gq_reg_main()$layers$town
sty_stream_label <- gq::gq_reg_main()$layers$stream_labels$label

# the rivers the maps are about, named by the Freshwater Atlas; cached in CAT_DIR
f_rivers <- file.path(dir_cat, "rivers.gpkg")
if (!file.exists(f_rivers)) {
  conn <- DBI::dbConnect(RPostgres::Postgres())
  x <- st_read(conn, quiet = TRUE, query = "
    SELECT gnis_name AS name, geom FROM whse_basemapping.fwa_stream_networks_sp
    WHERE gnis_name IN ('Bulkley River', 'Kootenay River', 'Elk River', 'Fording River') AND edge_type IN (1000, 1050, 1100, 1150, 1200, 1250, 1450)")
  DBI::dbDisconnect(conn)
  st_write(st_zm(x, drop = TRUE), f_rivers, quiet = TRUE)
}
rivers <- st_read(f_rivers, quiet = TRUE)
if (!nrow(rivers)) stop("no rivers", call. = FALSE)

# one label per river, on the straightest part of its longest run, turned to the river's angle and
# set just off the channel so it does not cover it
river_labels <- function(w) {
  x <- suppressWarnings(st_intersection(rivers, st_buffer(w, -2500)))
  if (!nrow(x)) return(NULL)
  do.call(rbind, lapply(unique(x$name), function(n) {
    l <- st_cast(st_line_merge(st_union(x[x$name == n, ])), "LINESTRING")
    l <- l[which.max(st_length(l))]
    at <- seq(0.2, 0.8, by = 0.05)
    len <- as.numeric(st_length(l))
    pt <- function(p) st_coordinates(st_line_sample(l, sample = pmin(pmax(p, 0), 1)))[1:2]
    d <- 2500 / len
    straight <- vapply(at, function(p) {
      a <- pt(p - d); b <- pt(p + d)
      sqrt(sum((b - a)^2)) / (2 * d * len)
    }, 0)
    p <- at[which.max(straight)]
    a <- pt(p - d); b <- pt(p + d); mid <- pt(p)
    ang <- atan2(b[2] - a[2], b[1] - a[1]) * 180 / pi
    if (ang > 90) ang <- ang - 180
    if (ang <= -90) ang <- ang + 180
    # to the upper side of the channel
    off <- 700 * c(-sin(ang * pi / 180), cos(ang * pi / 180))
    st_sf(name = n, ang = ang, geom = st_sfc(st_point(mid + off), crs = 3005))
  }))
}

# text with a thin halo: tmap has none, so white copies sit behind the label
halo_text <- function(m, x, text, col, size, face, halo, angle = NULL, ymod = 0) {
  arg <- list(text = text, size = size, fontface = face)
  if (!is.null(angle)) arg$angle <- angle
  m <- m + tm_shape(x)
  for (o in list(c(1, 0), c(-1, 0), c(0, 1), c(0, -1), c(.7, .7), c(-.7, .7), c(.7, -.7), c(-.7, -.7))) {
    m <- m + do.call(tm_text, c(arg, list(col = "white", xmod = o[1] * halo, ymod = ymod + o[2] * halo)))
  }
  m + do.call(tm_text, c(arg, list(col = col, ymod = ymod)))
}

frame <- function(m, w, leg = c("left", "top")) {
  here <- towns[lengths(st_intersects(towns, w)) > 0, ]
  if (nrow(here)) {
    m <- m + tm_shape(here) +
      tm_dots(fill = sty_town$mark$color, col = sty_town$mark$stroke_color,
              lwd = sty_town$mark$stroke_width, size = 0.7)
    m <- halo_text(m, here, "NAME", sty_town$mark$color, 0.9, "bold", 0.05, ymod = 1)
  }
  lab <- river_labels(w)
  if (!is.null(lab)) m <- halo_text(m, lab, "name", sty_stream_label$color, 0.85, sty_stream_label$style, 0.04, angle = "ang")
  m +
    tm_scalebar(position = if (identical(leg[2], "bottom")) c("right", "top") else c("right", "bottom"), text.size = 0.7, bg.color = "white", bg.alpha = 0.8) +
    tm_layout(frame = TRUE, inner.margins = c(0, 0, 0, 0), outer.margins = rep(0.002, 4),
              legend.position = leg, legend.frame = TRUE,
              legend.bg.color = "white", legend.bg.alpha = 0.9,
              legend.text.size = 0.75, legend.title.size = 0.85)
}

save_map <- function(m, name, w) {
  f <- file.path(dir_out, name)
  bb <- st_bbox(w)
  tmap_save(m, f, width = 7, height = 7 * (bb[["ymax"]] - bb[["ymin"]]) / (bb[["xmax"]] - bb[["xmin"]]), dpi = 300)
  f
}

map_scenarios <- function(g, w, zoom) {
  cols <- c("#f2a93b", "#1aa6a6", "#0b3c6f")
  labs <- c("Valley bottom", "Functional floodplain", "Active channel margin")
  # the widest first, each narrower one over it
  r <- rast(grid_of(w))
  values(r) <- NA_real_
  for (i in 1:3) {
    fp <- st_read(gpkg_of(g), c("all_ff06", "all_ff04", "all_ff02")[i], quiet = TRUE)
    r <- rasterize(vect(fp), r, field = i, update = TRUE, touches = FALSE)
  }
  m <- tm_shape(basemap_of(w, zoom), bbox = st_bbox(w)) + tm_rgb() +
    tm_shape(r) +
    tm_raster(col.scale = tm_scale_categorical(values = setNames(paste0(cols, "B3"), 1:3)),
              col.legend = tm_legend_hide(), col_alpha = 1) +
    tm_add_legend(type = "polygons", labels = labs, fill = see(cols), col = NA, title = "Flood factor scenario")
  save_map(frame(m, w), "habitat-rules_scenarios.jpg", w)
}

map_cells <- function(r, sg, w, zoom, cols, labs, title, name, lines = TRUE, levels_of = seq_along(cols),
                      leg = c("left", "top"), edge = NULL) {
  m <- tm_shape(basemap_of(w, zoom), bbox = st_bbox(w)) + tm_rgb() +
    tm_shape(r) +
    tm_raster(col.scale = tm_scale_categorical(values = setNames(unname(see(cols)), levels_of)),
              col.legend = tm_legend_hide(), col_alpha = 1)
  if (lines) {
    hab <- sg[sg$class != "neither", ]
    hab$lc <- col_rule[hab$class]
    for (k in unique(hab$class)) {
      m <- m + tm_shape(hab[hab$class == k, ]) + tm_lines(col = col_rule[[k]], lwd = 0.9)
    }
  }
  # a thin line round the whole footprint, so the palest class shows on pale ground
  if (!is.null(edge)) {
    m <- m + tm_shape(st_as_sf(as.polygons(ifel(is.na(r), NA, 1L)))) + tm_borders(col = edge, lwd = 0.4)
  }
  # the legend takes the alpha the cells are drawn with
  m <- m + tm_add_legend(type = "polygons", labels = labs, fill = unname(see(cols)), col = NA, title = title)
  save_map(frame(m, w, leg), name, w)
}

# one rule at a time: the habitat both rules share, plus what this rule alone holds
map_rule <- function(r, sg, w, zoom, alone, title, name, leg = c("left", "top")) {
  keep <- c("both", alone, "neither")
  i <- match(keep, names(col_rule))
  other <- setdiff(seq_along(col_rule), i)
  r2 <- classify(r, cbind(other, match("neither", names(col_rule))))
  labs <- lab_rule[i]
  labs[["neither"]] <- "Floodplain, not habitat under this rule"
  map_cells(r2, sg[sg$class %in% c("both", alone), ], w, zoom, col_rule[i], unname(labs), title, name,
            levels_of = i, leg = leg)
}

# chinook, on the Bulkley
w_bulk <- win_of(945000, 1061000, 20000)   # Telkwa to Houston
ch <- segments_of("CH_rear", st_buffer(w_bulk, 3000))
ch_cells <- cells_of(c("bulk", "morr"), ch, w_bulk)
ch_win <- st_crop(ch, st_bbox(w_bulk))
map_rule(ch_cells$class, ch_win, w_bulk, 12, "current", "Chinook rearing, existing rule",
         "habitat-rules_chinook-existing.jpg", leg = c("left", "bottom"))
map_rule(ch_cells$class, ch_win, w_bulk, 12, "tested", "Chinook rearing, tuned rule",
         "habitat-rules_chinook-tuned.jpg", leg = c("left", "bottom"))
map_cells(ch_cells$grade, ch_win, w_bulk, 12, col_grade, lab_grade, "Expected use",
          "habitat-rules_chinook-grade.jpg", lines = FALSE, leg = c("left", "bottom"), edge = "#2171b5")

# the scenarios on the Kootenay flats at Creston, where they separate
map_scenarios("kotl", win_of(1688100, 502000, 14000), zoom = 12)

# westslope cutthroat, the Elk River from Sparwood to Elkford. The catalogue does not yet carry this
# group: habitat-rules_elk-floodplain.R draws it
w_elk <- win_of(1794000, 602700, 15000, 19500)
wct <- segments_of("WCT_rear", st_buffer(w_elk, 3000))
wct <- wct[wct$watershed_group_code == "ELKR", ]   # the group whose floodplain is drawn
wct_cells <- cells_of("elkr", wct, w_elk)
wct_win <- st_crop(wct, st_bbox(w_elk))
map_rule(wct_cells$class, wct_win, w_elk, 12, "current", "Westslope cutthroat, existing rule",
         "habitat-rules_wct-existing.jpg", leg = c("right", "top"))
map_rule(wct_cells$class, wct_win, w_elk, 12, "tested", "Westslope cutthroat, tuned rule",
         "habitat-rules_wct-tuned.jpg", leg = c("right", "top"))

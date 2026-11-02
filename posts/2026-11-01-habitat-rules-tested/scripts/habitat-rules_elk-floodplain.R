# Draw the Elk River group's whole-network floodplain, which the catalogue does not yet carry, the
# way floodplains' step 2 draws a published one: flooded's Valley Confinement Algorithm on MRDEM-30,
# the whole network at order 2 and up, and the catalogue's all_ff scenario parameters.
#
# Needs a PostgreSQL fwapg with the fresh_default schema (the standard PG* variables). Reads the
# database and writes nothing to it (floodplains' step 1 rebuilds a schema, so its query is
# repeated here). Writes <CAT_DIR>/elkr_floodplain.gpkg with the catalogue's layer names, so
# habitat-rules_fig-build.R reads it like any other group:
#
#   CAT_DIR=<dir> Rscript scripts/habitat-rules_elk-floodplain.R

suppressPackageStartupMessages({
  library(sf)
  library(terra)
  library(flooded)
})
sf_use_s2(FALSE)

dir_cat <- Sys.getenv("CAT_DIR")
if (!dir.exists(dir_cat)) stop("set CAT_DIR", call. = FALSE)
out <- file.path(dir_cat, "elkr_floodplain.gpkg")
part <- paste0(out, ".part.gpkg")
unlink(part)

conn <- DBI::dbConnect(RPostgres::Postgres())
streams <- st_read(conn, quiet = TRUE, query = "
  SELECT s.id_segment, s.blue_line_key, s.stream_order, s.waterbody_key,
         ua.upstream_area_ha, p.map_upstream, s.geom
  FROM fresh_default.streams s
  LEFT JOIN (
    SELECT l.linear_feature_id, u.upstream_area_ha
    FROM whse_basemapping.fwa_streams_watersheds_lut l
    JOIN whse_basemapping.fwa_watersheds_upstream_area u
      ON l.watershed_feature_id = u.watershed_feature_id
  ) ua ON ua.linear_feature_id = s.linear_feature_id
  LEFT JOIN whse_basemapping.fwa_stream_networks_mean_annual_precip p
    ON p.wscode_ltree = s.wscode_ltree AND p.localcode_ltree = s.localcode_ltree
  WHERE s.watershed_group_code = 'ELKR' AND s.stream_order >= 2")
streams <- st_zm(streams, drop = TRUE)
for (col in c("upstream_area_ha", "map_upstream", "stream_order")) streams[[col]] <- as.numeric(streams[[col]])
streams$blue_line_key <- as.numeric(streams$blue_line_key)
if (!nrow(streams)) stop("no ELKR streams in fresh_default", call. = FALSE)

keys <- unique(streams$waterbody_key[!is.na(streams$waterbody_key)])
waterbodies <- st_zm(st_read(conn, quiet = TRUE, query = sprintf("
  SELECT waterbody_key, 'lake'::text AS waterbody_type, geom
    FROM whse_basemapping.fwa_lakes_poly WHERE waterbody_key IN (%1$s)
  UNION ALL
  SELECT waterbody_key, 'wetland'::text AS waterbody_type, geom
    FROM whse_basemapping.fwa_wetlands_poly WHERE waterbody_key IN (%1$s)",
  paste(keys, collapse = ","))), drop = TRUE)
DBI::dbDisconnect(conn)
message(nrow(streams), " segments, ", nrow(waterbodies), " waterbodies")

dem <- fl_dem_aoi(streams, buffer = 2000, target_crs = st_crs(streams))
precip <- fl_stream_rasterize(streams, dem, field = "map_upstream")

for (ff in c(2, 4, 6)) {
  id <- paste0("all_ff0", ff)
  valleys <- fl_valley_confine(dem, streams, field = "upstream_area_ha", slope = NULL,
                               slope_threshold = 9, max_width = 2000, cost_threshold = 2500,
                               flood_factor = ff, precip = precip, waterbodies = waterbodies,
                               size_threshold = 5000, hole_threshold = 2500)
  st_write(fl_valley_poly(valleys), part, layer = id, append = file.exists(part), quiet = TRUE)
  message(id, " written")
  if (ff == 4) {
    bl <- fl_valley_attribute(valleys, streams, group = "blue_line_key", dem = dem,
                              max_width = 2000, cost_threshold = 2500)
    st_write(bl, part, layer = "all_ff04_by_blue_line_key", append = TRUE, quiet = TRUE)
    message("attribution written")
  }
}
if (!file.rename(part, out)) stop("could not move ", part, " to ", out, call. = FALSE)
message("DONE ", out)

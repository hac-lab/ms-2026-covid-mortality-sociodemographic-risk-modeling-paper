# df must have columns:
#  - x  : your variable (Moran x-axis)
#  - wx : spatial lag of x (Moran y-axis)
#  - (optional) p : p-value for local Moran's I (e.g., p_ii_sim)

classify_lisa <- function(df, x_col = "x", wx_col = "wx",
                          p_col = NULL, alpha = 0.05,
                          mean_center = TRUE) {
  
  d <- df
  xv <- d[[x_col]]
  wv <- d[[wx_col]]
  
  # Center around the mean (so the quadrant threshold is 0)
  if (mean_center) {
    xv <- xv - mean(xv, na.rm = TRUE)
    wv <- wv - mean(wv, na.rm = TRUE)
  }
  
  quad <- ifelse(xv >= 0 & wv >= 0, "High–High",
                 ifelse(xv <  0 & wv <  0, "Low–Low",
                        ifelse(xv >= 0 & wv <  0, "High–Low", "Low–High")))
  
  # If p-values are supplied, mask non-significant units
  sig <- if (!is.null(p_col) && p_col %in% names(d)) d[[p_col]] < alpha else TRUE
  cluster <- ifelse(sig, quad, "Not significant")
  
  d$quad     <- quad
  d$sig      <- sig
  d$cluster  <- factor(cluster,
                       levels = c("High–High","Low–Low","High–Low","Low–High","Not significant"))
  d
}


# run local Moran
lm <- localmoran(counties_merged2$deaths_adjusted, lw, zero.policy = TRUE)
#lm_socio <- localmoran(counties_merged2$RPL_THEME1, lw, zero.policy = TRUE)

# add p-values to your moran.plot dataframe
deaths_mp$pvalue <- lm[, "Pr(z != E(Ii))"]
#socio_mp$pvalue <- lm[, "Pr(z != E(Ii))"]

# now you can classify into quadrants + mask by significance
lisa_df <- classify_lisa(deaths_mp, x_col = "x", wx_col = "wx", p_col = "pvalue", alpha = 0.05)
#lisa_df_socio <- classify_lisa(socio_mp, x_col = "x", wx_col = "wx", p_col = "pvalue", alpha = 0.05)

counties_merged2_new <- counties_merged2

# lisa_df has your LISA results/classifications
# counties_merged2_new is your SpatialPolygonsDataFrame

# make sure they have the same number of rows
stopifnot(nrow(counties_merged2_new@data) == nrow(lisa_df))

# bind the LISA columns into the SPDF
counties_merged2_new@data <- cbind(
  counties_merged2_new@data,
  lisa_df
)

counties_merged2_new@data <- cbind(counties_merged2_new@data, deaths_mp)
#counties_merged2_socio@data <- cbind(counties_merged2@data, socio_mp)


library(sp)
library(sf)

# 1) Make polygon feature IDs unique (sp uses these internally)
ids <- sapply(slot(counties_merged2_new, "polygons"), slot, "ID")
counties_merged2_new <- sp::spChFIDs(counties_merged2_new, make.unique(ids))

# 2) (Optional) sync data rownames to feature IDs
rownames(counties_merged2_new@data) <- sapply(slot(counties_merged2_new, "polygons"), slot, "ID")

# 3) Convert to sf + validate geometry
counties_sf <- sf::st_as_sf(counties_merged2_new) |> sf::st_make_valid()

# Now you can set:
cls_col <- "cluster"  # or whatever your LISA column is named



# library(dplyr)
# library(sf)
# library(ggplot2)
# 
# cls_col   <- "cluster"   # your LISA column
# state_col <- "State"     # <-- change to your actual state-ID column name
# 
# # Build state boundaries by dissolving counties
# state_sf <- counties_sf %>%
#   sf::st_make_valid() %>%
#   dplyr::group_by(.data[[state_col]]) %>%
#   dplyr::summarise(geometry = sf::st_union(geometry), .groups = "drop") %>%
#   sf::st_as_sf()   # ensure it's sf (in case something masked methods)
# 
# # Sanity check
# stopifnot(inherits(state_sf, "sf"))
# 
# # Plot: fill by LISA, county borders light gray, state borders black
# ggplot() +
#   geom_sf(data = counties_sf, aes(fill = .data[[cls_col]]), color = NA) +
#   geom_sf(data = counties_sf, fill = NA, color = "grey70", linewidth = 0.2) +
#   geom_sf(data = state_sf,    fill = NA, color = "black",  linewidth = 0.6) +
#   scale_fill_manual(
#     values = c(
#       "High–High"="#d73027","Low–Low"="#4575b4",
#       "High–Low"="#fdae61","Low–High"="#74add1",
#       "Not significant"="grey85"
#     ),
#     drop = FALSE, name = "LISA cluster"
#   ) +
#   labs(title = "LISA cluster map") +
#   theme_void()




library(sf)
library(dplyr)
library(ggplot2)
library(tigris)   # clean state polygons (no county holes)
library(ragg)     # robust PNG device (server-friendly)

options(tigris_use_cache = TRUE)

# ---- Inputs ----
cls_col <- "cluster"           # your LISA class column in counties_sf
# counties_sf must already exist: sf of counties with geometry + LISA column

# Geometry sanity
counties_sf <- st_make_valid(counties_sf)

# ---- Get clean state boundaries (no interior county holes) ----
states_sf <- tigris::states(cb = TRUE, year = 2023, class = "sf") |> st_make_valid()
states_sf <- st_transform(states_sf, st_crs(counties_sf))

# Keep only states overlapping your data (optional but faster/neater)
states_sf <- states_sf[st_intersects(states_sf, st_union(st_geometry(counties_sf)), sparse = FALSE), ]

# Use just the exterior borders (lines)
state_lines <- st_boundary(states_sf) |> st_as_sf()

# ---- Split counties for rendering ----
c_with   <- counties_sf |> filter(!is.na(.data[[cls_col]]))
c_nodata <- counties_sf |> filter( is.na(.data[[cls_col]]))

# Lock legend order (optional)
if (nrow(c_with)) {
  c_with[[cls_col]] <- factor(
    c_with[[cls_col]],
    levels = c("High–High","Low–Low","High–Low","Low–High","Not significant")
  )
}

# ---- Build plot ----
p <- ggplot() +
  # LISA-filled counties (no borders)
  geom_sf(data = c_with, aes(fill = .data[[cls_col]]), color = NA) +
  # No-data counties: very light fill, no border
  geom_sf(data = c_nodata, fill = "grey92", color = NA, inherit.aes = FALSE) +
  # County outlines: thin, light gray
  geom_sf(data = counties_sf, fill = NA, color = "grey70", linewidth = 0.2,
          inherit.aes = FALSE) +
  # State outlines: thick, black (draw last so they sit on top)
  geom_sf(data = state_lines, fill = NA, color = "black", linewidth = 0.7,
          lineend = "round", linejoin = "round", inherit.aes = FALSE) +
  scale_fill_manual(
    values = c(
      "High–High"       = "#d73027",
      "Low–Low"         = "#4575b4",
      "High–Low"        = "#fdae61",
      "Low–High"        = "#74add1",
      "Not significant" = "grey85"
    ),
    drop = FALSE, name = "LISA cluster"
  ) +
  labs(title = "LISA cluster map") +
  coord_sf(expand = FALSE) +
  theme_void()

p

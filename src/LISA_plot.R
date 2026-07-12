library(sp)
library(sf)

# 1) Make polygon IDs unique (sp uses these as row names under the hood)
ids  <- sapply(slot(counties_merged2_new, "polygons"), slot, "ID")
idsu <- make.unique(ids)

counties_merged2_new <- sp::spChFIDs(counties_merged2_new, idsu)

# 2) (Optional) align @data row.names to IDs just to be safe
rownames(counties_merged2_new@data) <- idsu

# 3) Convert to sf
counties_sf <- sf::st_as_sf(counties_merged2_new)


cls_col <- "cluster"   # update if needed
counties_sf[[cls_col]] <- factor(
  counties_sf[[cls_col]],
  levels = c("High–High","Low–Low","High–Low","Low–High","Not significant")
)

ggplot(counties_sf) +
  geom_sf(aes(fill = .data[[cls_col]]), color = NA) +
  scale_fill_manual(
    values = c("High–High"="#d73027","Low–Low"="#4575b4",
               "High–Low"="#fdae61","Low–High"="#74add1",
               "Not significant"="grey85"),
    drop = FALSE, name = "LISA cluster"
  ) +
  labs(title = "LISA cluster map") +
  theme_void()

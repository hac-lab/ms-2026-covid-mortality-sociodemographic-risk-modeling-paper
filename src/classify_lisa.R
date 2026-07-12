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

`%||%` <- function(a, b) if (is.null(a)) b else a

# work around until geom_label_repel can handle point dodging
position_year <- function(scenario) {
  n <- n_distinct(scenario)
  counts <- table(scenario)
  flatten_dbl(map2(symmetric_seq(n, 2.3), counts[counts != 0], ~ rep(., .y)))
}

split3 <- function(x, n) {
  by <- table(cut(seq_len(ceiling(length(x) / n) * n), n, labels = FALSE)[1:length(x)])
  unname(
    map2(
      lag(cumsum(by), default = 0),
      cumsum(by),
      ~ (.:.y)[-1]
    )
  )
}

symmetric_seq <- function(length.out, scale = 1) {
  if (length.out %% 2 == 0) {
    m <- length.out / 2
    c(seq(from = -m + 0.5, to = -0.5), seq(from = 0.5, to = m - 0.5)) * scale
  } else {
    m <- floor(length.out / 2)
    seq(from = -m, to = m) * scale
  }
}

icon2unicode <- function(icon) {
  if (is.null(icon)) {
    return(NULL)
  }

  if (!grepl("^fa-", icon)) {
    icon <- paste0("fa-", icon)
  }

  .faIconLookup[.faIconLookup$class == icon, "unicode"]
}

darken <- function(hex, factor = 1.4){
  col <- col2rgb(hex)
  col <- col / factor
  col <- rgb(t(col), maxColorValue = 255)
  names(col) <- names(hex)
  col
}

formatOptNames <- function(opts, prefix) {
  newNames <- paste("data", prefix, names(opts), sep = "-")
  newNames <- gsub("([A-Z])", "-\\L\\1", newNames, perl = TRUE)
  names(opts) <- newNames
  opts
}

formatAriaNames <- function(opts) {
  newNames <- paste("aria", names(opts), sep = "-")
  names(opts) <- newNames
  opts
}

ariaOpts <- function(label = NULL, ...) {
  formatAriaNames(
    c(
      list(...),
      label = label
    )
  )
}


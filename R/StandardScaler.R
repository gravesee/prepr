#'@include Transform.R

##---- Helpers
standard_scale_mean_ <- function(data, with_mean, with_std) UseMethod("standard_scale_mean_")

standard_scale_mean_.numeric <- function(data, with_mean, with_std) {
  var <- var(data)
  list(
    scale_ = if (with_std) sqrt(var) else var,
    mean_ = if (with_mean) mean(data) else 0)
}

standard_scale_mean_.data.frame <- function(data, with_mean, with_std) {
  res <- mapply(standard_scale_mean_, data, with_mean, with_std, SIMPLIFY = FALSE)
  unpack_(res, c("scale_", "mean_"))
}

##---- Transform

standard_transform <- function(data, with_mean, with_std) UseMethod("standard_transform")

#' @export StandardScaler
StandardScaler <-setRefClass(
  "StandardScaler",
  contains = "Transformer",
  fields = c(with_mean="logical", with_std="logical", mean_="numeric", scale_="numeric"),
  methods = list(
    initialize = function(with_mean=TRUE, with_std=TRUE, ...) {
      with_mean <<- with_mean
      with_std <<- with_std
      callSuper(...)
    },

    fit = function(data) {
      isfit <<- TRUE
      env <- list2env(standard_scale_mean_(data, with_mean, with_std), .self@.xData)
    },
    transform = function(data) {
      stopifnot(isfit)
      env <- environment(fun = .self$transform)
      res <- data
      if (with_mean) res <- res - env$mean_
      if (with_std) res <- res / env$scale_
      res
    },
    inverse_transform = function(data) {
      stopifnot(isfit)
      env <- environment(fun = .self$transform)
      res <- data
      if (with_std) res <- res * env$scale_
      if (with_mean) res <- res + env$mean_
      res
    }
  )
)

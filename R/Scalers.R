#' @include Transform.R

#' @export MinMaxScaler
MinMaxScaler <-setRefClass(
  "MinMaxScaler",
  contains = "Transformer",
  fields = c(feature_range = "numeric"),
  methods = list(
    initialize = function(feature_range, ...) {
      feature_range <<- feature_range
      callSuper(...)
    },

    fit = function(data) {
      isfit <<- TRUE
      env <- environment(fun = .self$fit)
      min_max <- range(data, na.rm=TRUE)
      data_range <- diff(min_max)
      env$scale_ <- (feature_range[[2]] - feature_range[[1]]) / data_range
      env$min_ <- feature_range[[1]] - min_max[[1]] * env$scale_
    },
    transform = function(data) {
      stopifnot(isfit)
      env <- environment(fun = .self$transform)
      (data * env$scale_) + env$min_
    },
    inverse_transform = function(data) {
      stopifnot(isfit)
      env <- environment(fun = .self$inverse_transform)
      (data - env$min_) / env$scale_
    }
  )
)

#' @export StandardScaler
StandardScaler <-setRefClass(
  "StandardScaler",
  contains = "Transformer",
  fields = c(with_mean="logical", with_std="logical"),
  methods = list(
    initialize = function(with_mean=TRUE, with_std=TRUE, ...) {
      with_mean <<- with_mean
      with_std <<- with_std
      callSuper(...)
    },

    fit = function(data) {
      isfit <<- TRUE
      env <- environment(fun = .self$fit)
      var <- var(data)
      env$scale_ <- if (with_std) sqrt(var) else var
      env$mean_ <- if (with_mean) mean(data) else 0
      env$var_ <- var
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

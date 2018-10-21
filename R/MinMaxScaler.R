#' @include Transform.R

##----- Calculate scale and min

#' @export
minmax_scale_min_ <- function(data, feature_range) UseMethod("minmax_scale_min_")

#' @export
minmax_scale_min_.numeric <-function(data, feature_range) {
  min_max <- range(data, na.rm=TRUE)
  data_range <- diff(min_max)
  scale <- diff(feature_range) / data_range
  list(scale_ = scale, min_ = feature_range[[1]] - min_max[[1]] * scale)
}

#' @export
minmax_scale_min_.data.frame <-function(data, feature_range) {
  if (is.numeric(feature_range)) feature_range <- rep(list(feature_range), length(data))
  res <- mapply(minmax_scale_min_, data, feature_range, SIMPLIFY = FALSE)
  unpack_(res, c("scale_", "min_"))
}


##----- Transform generics

#' @export
minmax_transform_ <- function(data, scale_, min_) UseMethod("minmax_transform_")

#' @export
minmax_transform_.numeric <- function(data, scale_, min_) (data * scale_) + min_

#' @export
minmax_transform_.data.frame <- function(data, scale_, min_) {
  data[] <- mapply(minmax_transform_, data, as.list(scale_), as.list(min_), SIMPLIFY = FALSE)
  data
}

##----- Inverse transform generics

#' @export
minmax_inverse_transform_ <- function(data, scale_, min_) UseMethod("minmax_inverse_transform_")

#' @export
minmax_inverse_transform_.numeric <- function(data, scale_, min_) (data - min_) / scale_

#' @export
minmax_inverse_transform_.data.frame <- function(data, scale_, min_) {
  data[] <- mapply(minmax_inverse_transform_, data, as.list(scale_), as.list(min_), SIMPLIFY = FALSE)
  data
}

#' @export MinMaxScaler
MinMaxScaler <-setRefClass(
  "MinMaxScaler",
  contains = "Transformer",
  fields = c(feature_range = "numeric", scale_="numeric", min_="numeric"),
  methods = list(
    initialize = function(feature_range, ...) {
      feature_range <<- feature_range
      callSuper(...)
    },

    fit = function(data) {
      callSuper()
      env <- list2env(minmax_scale_min_(data, feature_range), .self@.xData)
    },

    transform = function(data) {
      stopifnot(isfit)
      minmax_transform_(data, scale_, min_)
    },
    inverse_transform = function(data) {
      stopifnot(isfit)
      minmax_inverse_transform_(data, scale_, min_)
    }
  )
)

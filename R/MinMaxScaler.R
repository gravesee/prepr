#' @include Transform.R

#' @exportClass MinMaxScaler
#' @export MinMaxScaler
MinMaxScaler <-setRefClass(
  "MinMaxScaler",
  contains = "Transformer",
  fields = c(feature_range = "numeric", scale_="numeric", min_="numeric"),
  methods = list(
    initialize = function(feature_range, ...) {
      feature_range <<- feature_range
      cols <<- "numeric"
      callSuper(...)
    })
)

check_feature_range_ <- function(feature_range, x) {
  if (is.numeric(feature_range))
    rep(list(feature_range), length(x))
  else
    feature_range
}

##----- Calculate scale and min
MinMaxScaler_fit_ <- function(x, feature_range) {
  min_max <- range(x, na.rm=TRUE)
  data_range <- diff(min_max)
  scale <- diff(feature_range) / data_range

  list(
    scale_ = scale,
    min_ = feature_range[[1]] - min_max[[1]] * scale)
}

#' @export
setMethod("fit_", c("MinMaxScaler", "numeric"), function(.self, x, f, ...) {
  list2env(MinMaxScaler_fit_(x, .self$feature_range), .self@.xData)
})


#' @export
setMethod("fit_", c("MinMaxScaler", "data.frame"), function(.self, x, f, ...) {
  res <- mapply(MinMaxScaler_fit_, x[f],
                check_feature_range_(.self$feature_range, x[f]), SIMPLIFY = F)

  list2env(unpack_(res, c("scale_", "min_")), .self@.xData)
})

MinMaxScaler_transform_ <- function(x, scale_, min_) (x * scale_) + min_

#' @export
setMethod("transform_", c("MinMaxScaler", "numeric"), function(.self, x, f) {
  MinMaxScaler_transform_(x, .self$scale_, .self$min_)
})

#' @export
setMethod("transform_", c("MinMaxScaler", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(MinMaxScaler_transform_, x[f], .self$scale_, .self$min_, SIMPLIFY = F)
  x
})

MinMaxScaler_inverse_transform_ <- function(x, scale_, min_) (x - min_) / scale_

#' @export
setMethod("inverse_transform_", c("MinMaxScaler", "numeric"), function(.self, x, f) {
  MinMaxScaler_inverse_transform_(x, .self$scale_, .self$min_)
})

#' @export
setMethod("inverse_transform_", c("MinMaxScaler", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(MinMaxScaler_inverse_transform_, x[f],
                .self$scale_, .self$min_, SIMPLIFY = FALSE)
  x
})

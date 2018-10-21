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
      callSuper(...)
    },

    fit = function(x) {
      browser()
      UseMethod("fit")
    },

    fit.numeric = function(x) {
      min_max <- range(x, na.rm=TRUE)
      data_range <- diff(min_max)
      scale_ <<- diff(feature_range) / data_range
      min_ <<- feature_range[[1]] - min_max[[1]] * scale_
    })
)



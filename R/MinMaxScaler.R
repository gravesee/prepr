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
      allowed_types_ <<- c("integer", "numeric")
      callSuper(...)
    })
)

minmax_fit_ <- function(x, fr) {
  minmax <- range(x, na.rm=TRUE) ## range of data
  scale <- diff(fr) / diff(minmax)
  c(scale=scale, min=fr[1] - minmax[1] * scale)
}

#' @export
setMethod("fit_", c("MinMaxScaler", "data.frame"), function(.self, x, f, ...) {
  fr <- repvec_(.self$feature_range, length(f))
  res <- mapply(minmax_fit_, x[f], fr, SIMPLIFY = F)
  res <- unpack_(res, "scale", "min")

  .self$scale_ <- res$scale
  .self$min_ <- res$min
})

minmax_tf_ <- function(x, scale_, min_) (x * scale_) + min_

#' @export
setMethod("transform_", c("MinMaxScaler", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(minmax_tf_, x[f], .self$scale_, .self$min_, SIMPLIFY = F)
  x
})

minmax_invtf_ <- function(x, scale_, min_) (x - min_) / scale_

#' @export
setMethod("inverse_transform_", c("MinMaxScaler", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(minmax_invtf_, x[f],
                .self$scale_, .self$min_, SIMPLIFY = FALSE)
  x
})

#'@include Transform.R

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
    })
)

##---- Helpers
StandardScaler_fit_ <- function(x, with_mean, with_std) {
  list(scale_ = if (with_std) sd(x, na.rm=T) else var(x, na.rm=T),
       mean_  = if (with_mean) mean(x, na.rm=T) else 0)
}

setMethod("fit_", c("StandardScaler", "numeric"), function(.self, x, ...) {
  list2env(StandardScaler_fit_(x, .self$with_mean, .self$with_std), .self@.xData)
})

setMethod("fit_", c("StandardScaler", "data.frame"), function(.self, x, ...) {
  res <- mapply(StandardScaler_fit_, x, .self$with_mean, .self$with_std, SIMPLIFY = FALSE)
  list2env(unpack_(res, c("scale_", "mean_")), .self@.xData)
})

StandardScaler_transform_ <- function(x, with_mean, with_std, mean_, scale_) {
  (x - if (with_mean) mean_ else 0) /
    (if (with_std) scale_ else 1)
}

setMethod("transform_", c("StandardScaler", "numeric"), function(.self, x) {
  StandardScaler_transform_(x, .self$with_mean, .self$with_std, .self$mean_, .self$scale_)
})

#' @export
setMethod("transform_", c("StandardScaler", "data.frame"), function(.self, x) {
  x[] <- mapply(StandardScaler_transform_, x,
                .self$with_mean,
                .self$with_std,
                .self$mean_,
                .self$scale_, SIMPLIFY = F)
  x
})

##--- Inverse transform
StandardScaler_inverse_transform_ <- function(x, scale_, mean_, with_mean, with_std) {
  x * (if (with_std) scale_ else 1) + (if (with_mean) mean_ else 0)
}

#' @export
setMethod("inverse_transform_", c("StandardScaler", "numeric"), function(.self, x) {
  StandardScaler_inverse_transform_(x, .self$scale_, .self$mean_,
                                    .self$with_mean, .self$with_std)
})

#' @export
setMethod("inverse_transform_", c("StandardScaler", "data.frame"), function(.self, x) {
  x[] <- mapply(StandardScaler_inverse_transform_, x,
                .self$scale_,
                .self$mean_,
                .self$with_mean,
                .self$with_std, SIMPLIFY = FALSE)
  x
})

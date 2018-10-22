#'@include Transform.R

## TODO: Reafactor this -- drop the with_mean, with_std stuff

#' @export StandardScaler
StandardScaler <-setRefClass(
  "StandardScaler",
  contains = "Transformer",
  fields = c(with_mean="logical", with_std="logical", mean_="numeric", scale_="numeric"),
  methods = list(
    initialize = function(with_mean=TRUE, with_std=TRUE, ...) {
      with_mean <<- with_mean
      with_std <<- with_std
      cols <<- "numeric"
      allowed_types_ <<- c("integer", "numeric")
      callSuper(...)
    },
    show = function(s) {
      callSuper(s)
      if (isfit)
        cat(sprintf("\n%swith_mean: %s, with_std: %s", extend_(s), with_mean, with_std))
      
    })
)

##---- Helpers
scaler_fit_ <- function(x, with_mean, with_std) {
  list(scale = if (with_std) sd(x, na.rm=T) else 1,
       mean = if (with_mean) mean(x, na.rm=T) else 0)
}

setMethod("fit_", c("StandardScaler", "data.frame"), function(.self, x, f, ...) {
  res <- mapply(scaler_fit_, x[f], .self$with_mean, .self$with_std, SIMPLIFY = FALSE)
  res <- unpack_(res, "scale", "mean")
  .self$scale_ <- res$scale
  .self$mean_ <- res$mean
})

scaler_tf_ <- function(x, mean, scale) (x - mean) / scale

#' @export
setMethod("transform_", c("StandardScaler", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(scaler_tf_, x[f], .self$mean_, .self$scale_, SIMPLIFY = F)
  x
})

##--- Inverse transform
scaler_inv_tf_ <- function(x, mean, scale)  x * scale + mean

#' @export
setMethod("inverse_transform_", c("StandardScaler", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(scaler_inv_tf_, x[f], .self$mean_, .self$scale_, SIMPLIFY = FALSE)
  x
})

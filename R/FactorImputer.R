#'@include Transform.R

#' @export FactorImputer
FactorImputer <- setRefClass(
  "ListImputer",
  contains = "Transformer",
  fields = c(values="vector", method="character", y="vector", values_="vector"),
  methods = list(
    initialize = function(values=values, method=method, y=y, ...) {
      if(!missing(method) && missing(y)) stop("If method used, must provide y")
      if(!missing(values)) stopifnot(!is.null(names(values)))
      callSuper(...)
    })
)

##---- Helpers
FactorImputer_fit_ <- function(x, method, value, y) {
  # if (!is.null(value)) value else tapply(y, x, method
}

#' #' @export
#' setMethod("fit_", c("StandardImputer", "factor"), function(.self, x, ...) {
#'   .self$value_ <- StandardImputer_fit_(x, .self$method, .self$value)
#'
#' })
#'
#' #' @export
#' setMethod("fit_", c("StandardImputer", "data.frame"), function(.self, x, ...) {
#'   .self$value_ <- mapply(StandardImputer_fit_, x,
#'                          .self$method, .self$value, SIMPLIFY = TRUE)
#' })
#'
#' StandardImputer_transform_ <- function(x, value_) {
#'   x[is.na(x)] <- value_
#'   x
#' }
#'
#' #' @export
#' setMethod("transform_", c("StandardImputer", "numeric"), function(.self, x) {
#'   StandardImputer_transform_(x, .self$value_)
#' })
#'
#' #' @export
#' setMethod("transform_", c("StandardImputer", "data.frame"), function(.self, x) {
#'   x[] <- mapply(StandardImputer_transform_, x, .self$value_, SIMPLIFY = F)
#'   x
#' })
#'
#' #' @export
#' setMethod("inverse_transform_", c("StandardImputer"), function(.self, x) {
#'   stop("Inverse not valid -- StandardImputer")
#' })

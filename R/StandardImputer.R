#'@include Transform.R

mode <- function(x, na.rm) {
  ux <- na.omit(unique(x))
  ux[which.max(tabulate(match(x, ux)))]
}

#' @name StandardImputer-class
#' @title Impute NA Values
#' @description Replace NA values with calculated values or a constant
#' @param method A function name as a character value
#' @param value A constant numeric value to impute
#' @details If a method is passed, it will be called on each vector with
#' \code{na.rm=TRUE}. The return value will be stored and all NA values will
#' be replaced with this calculated value.
#'
#' If, instead, a value is passed into the constructor it will be replace
#' all NA values.
#'
#' @export StandardImputer
StandardImputer <- setRefClass(
  "StandardImputer",
  contains = "Transformer",
  fields = c(method="character", value="ANY", value_="ANY"),
  methods = list(
    initialize = function(method="mean", value=NULL, cols="numeric", ...) {
      stopifnot(is.function(get(method)))
      method <<- method
      value <<- value
      callSuper(cols=cols)
    })
)

#' @export
setMethod("fit_", c("StandardImputer", "data.frame"), function(.self, x, f, ...) {
  .self$value_ <- if (!is.null(.self$value)) .self$value else lapply(x[f], .self$method, na.rm=TRUE)
})

impute_ <- function(x, v) { x[is.na(x)] <- v; x }

#' @export
setMethod("transform_", c("StandardImputer", "data.frame"), function(.self, x, f, MoreArgs) {
  x[f] <- mapply(impute_, x[f], .self$value_, SIMPLIFY = FALSE)
  x
})

#' @export
prep_impute <- function(method="mean", value=NULL, cols="numeric") {
  StandardImputer(method=method, value=value, cols=cols)
}

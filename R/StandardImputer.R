#'@include Transform.R

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
  fields = c(method="character", value="numeric", value_="numeric"),
  methods = list(
    initialize = function(method="mean", value=NA_real_, cols="numeric", ...) {
      stopifnot(is.function(get(method)))
      method <<- method
      value <<- value
      cols <<- cols
      allowed_types_ <<- c("integer", "numeric")
      callSuper(...)
    })
)

#' @export
setMethod("fit_", c("StandardImputer", "data.frame"), function(.self, x, f, ...) {
  .self$value_ <- mapply(
    function(x, method, value) {
      if (!identical(value, NA_real_))
        value
      else
        do.call(method, list(x, na.rm=TRUE))
  }, x[f], .self$method, .self$value, SIMPLIFY = TRUE)
})


#' @export
setMethod("transform_", c("StandardImputer", "data.frame"), function(.self, x, f) {
  x[f] <- mapply(
    function(x, value) {
      x[is.na(x)] <- value
      x
    }, x[f], .self$value_, SIMPLIFY = FALSE)
  x
})

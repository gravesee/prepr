### Functions to specify data preparation pipelines

##----- scale
#' @export
setGeneric("prep_scale", function(x, ...) standardGeneric("prep_scale"))

#' @export
setMethod("prep_scale", "missing", function(x, ...)
  preparator(fun=partial("prep_scale", ...), call=match.call()))

#' @export
setMethod("prep_scale", "vector", function(x, ..., method) {
  div <- switch(method, sd = sd(x, na.rm=T), range = diff(range(x, na.rm=T)))
  fun <- function(x, ...) x / div
  preparator(fun=fun, data=fun(x), extra=list(divisor=div))
})

##----- center
#' @export
setGeneric("prep_center", function(x, ...) standardGeneric("prep_center"))

#' @export
setMethod("prep_center", "missing", function(x, ...)
  preparator(fun=partial("prep_center", ...), call=match.call()))

#' @export
setMethod("prep_center", "vector", function(x, ..., method) {
  cen <- do.call(method, args=list(x, na.rm=TRUE))
  fun <- function(x, ...) x - cen
  preparator(fun=fun, data=fun(x), extra=list(center=cen))
})

##----- impute
#' @export
setGeneric("prep_impute", function(x, ...) standardGeneric("prep_impute"))

#' @export
setMethod("prep_impute", "missing", function(x, ...)
  preparator(fun=partial("prep_impute", ...), call=match.call()))

#' @export
setMethod("prep_impute", "vector", function(x, ..., method, value=NULL) {
  val <- if (!is.null(value)) value else  do.call(method, list(x, na.rm=TRUE))
  fun <- function(x, ...) {
    x[is.na(x)] <- val
    x
  }
  preparator(fun=fun, data=fun(x), extra=list(value=val), call=match.call())
})


## class for preparation function?


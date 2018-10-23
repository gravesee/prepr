#'@include Transform.R

##' convert factor levels to numbers

woe <- function(x, y, eps = 1e-5) {
  pt <- prop.table(table(x, factor(y, 0:1)) + eps, margin = 2L)
  log(pt[,2] / pt[,1])
}

#' @export FactorImputer
NumFactor <- setRefClass(
  "NumFactor",
  contains = "Transformer",
  fields = c(method="character", values_="vector", values_passed_="logical", y_="ANY"),
  methods = list(
    initialize = function(..., method="mean", cols="factor", y=NULL) {
      values <- list(...)
      y_ <<- y
      method <<- method
      
      cols <<- if (is.null(y) && length(values) == 0L) NULL else cols
      values_passed_ <<- FALSE
      
      if(length(values) > 0L) {
        stopifnot(!is.null(names(values)))
        values_ <<- values
        values_passed_ <<- TRUE
        cols <<- names(values)
      } else {
        
      }
      
      callSuper(cols=cols, allowed_types_="factor")
    })
)

##---- Helpers

FactorImputer_fit_ <- function(x, method, values, y){
  switch(
    method,
    woe = woe(x, y),
    tapply(y, x, method))
}

#' @export
setMethod("fit_", c("NumFactor", "data.frame"), function(.self, x, f, ...) {
  y <- eval(.self$y_, x)
  if (!.self$values_passed_)
    .self$values_ <- lapply(x[,f,drop=F], FactorImputer_fit_, .self$method, .self$values[f], y)
})


#' @export
setMethod("transform_", c("NumFactor", "data.frame"), function(.self, x, f, MoreArgs) {
  x[f] <- mapply(function(z, v) v[as.character(z)], x[f], .self$values_[f], SIMPLIFY=F)
  x
})

#' @export
prep_numfactor <- function(..., method="mean", y=NULL, cols="factor") {
  NumFactor(..., method=method, y=as.list(match.call())$y, cols=cols)
}




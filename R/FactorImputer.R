#'@include Transform.R

woe <- function(x, y, eps = 1e-5) {
  pt <- prop.table(table(x, factor(y, 0:1)) + eps, margin = 2L)
  log(pt[,2] / pt[,1])
}

#' @export FactorImputer
FactorImputer <- setRefClass(
  "FactorImputer",
  contains = "Transformer",
  fields = c(values="vector", method="character", values_="vector"),
  methods = list(
    initialize = function(values=values, method="mean", y=y, cols="factor", ...) {
      if(!missing(values)) stopifnot(!is.null(names(values)))
      method <<- method
      cols <<- cols
      allowed_types_ <<- "factor"
      callSuper(...)
    })
)

##---- Helpers

FactorImputer_fit_ <- function(x, method, values, y){
  if (!is.null(values))
    value
  else
    switch(
      method,
      woe = woe(x, y),
      tapply(y, x, method))
}

#' @export
setMethod("fit_", c("FactorImputer", "data.frame"), function(.self, x, f, ..., y) {
  .self$values_ <- lapply(x[,f,drop=F], FactorImputer_fit_, .self$method, .self$values, y)
})


#' @export
setMethod("transform_", c("FactorImputer", "data.frame"), function(.self, x, f, ..., y) {
  x[f] <- mapply(function(z, v) v[z], x[f], .self$values_, SIMPLIFY=F)
  x
})

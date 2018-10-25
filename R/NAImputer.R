#' @include Transform.R

impute_tf_ <- function(x, v) {
  x[is.na(x)] <- v
  x
}

NAImputer <- setRefClass(
  "NAImputer",
  contains = "Transformer",
  fields = c(method="function", value="ANY", na.rm="logical"),
  methods = list(

    initialize = function(f=~., method=mean, value, na.rm=TRUE, ...) {
      method <<- method
      value <<- value
      na.rm <<- na.rm
      callSuper(f, ...)
    },

    fit = function(x) {
      callSuper(x)

      if (is.null(value)) {
        value <<- sapply(x[vars], method, na.rm=na.rm)
      } else {
        value <<- setNames(rep(value, length(vars)), vars)
      }
    },

    transform = function(x) {
      if (is.null(vars)) return(x)

      for (nm in vars) {
        x[nm] <- impute_tf_(x[nm], value[[nm]])
      }
      x
    })
)

#' @export
prep_impute <- function(f=~sel_numeric(), value=NULL, method=mean, na.rm=TRUE, ...) NAImputer(f=f, value=value, method=method, na.rm=na.rm, ...)



#' @include util.R generics.R

#' @exportClass Transformer
setRefClass(
  "Transformer",
  contains = "VIRTUAL",
  fields = c(isfit="logical", cols="character", allowed_types_="character"),
  methods = list(
    initialize = function(...) {
      isfit <<- FALSE
      callSuper(...)
    },
    filter = function(x) {
      ## set column types on fit
      cols <<- filter_cols_(x, cols)
    },
    fit = function(x, ...) {
      on.exit(isfit <<- TRUE)
      filter(x)
      if (identical(length(cols), 0L)) return()
      checktypes(x, cols, allowed_types_, .self)
      fit_(.self, x, f=cols, ...)
    },
    transform = function(x) {
      stopifnot(isfit)
      checktypes(x, filter(x), allowed_types_, .self)
      transform_(.self, x, f=cols)
    },
    fit_transform = function(x, ...) {
      fit(x, ...)
      transform(x)
    },
    show = function(s="") {
      cat(sprintf("%s%s", s, .self$getRefClass()@className))
      cat(sprintf("\n%scols: %s", extend_(s), trunc_(cols)))
    }
  ))

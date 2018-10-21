#' @include util.R generics.R

setRefClass(
  "Transformer",
  contains = "VIRTUAL",
  fields = c(isfit="logical"),
  methods = list(
    initialize = function(...) {
      isfit <<- FALSE
      callSuper(...)
    },
    fit = function(x) {
      fit_(.self, x)
      isfit <<- TRUE
    },
    transform = function(x) {
      stopifnot(isfit)
      transform_(.self, x)
    },
    fit_transform = function(x) {
      fit(x)
      transform(x)
    },
    inverse_transform = function(x) {
      stopifnot(isfit)
      inverse_transform_(.self, x)
    }
  ))

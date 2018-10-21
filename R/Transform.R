#' @include util.R

setRefClass(
  "Transformer",
  contains = "VIRTUAL",
  fields = c(isfit="logical"),
  methods = list(
    initialize = function(...) {
      isfit <<- FALSE
      callSuper(...)
    },
    fit = function(data) {
      isfit <<- TRUE
    },
    transform = function(data) stopifnot(isfit),
    fit_transform = function(data) {
      fit(data)
      transform(data)
    },
    inverse_transform = function(data) stopifnot(isfit)
  ))

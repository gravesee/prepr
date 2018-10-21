#' @include util.R generics.R

#' @exportClass Transformer
setRefClass(
  "Transformer",
  contains = "VIRTUAL",
  fields = c(isfit="logical", cols="character"),
  methods = list(
    initialize = function(...) {
      isfit <<- FALSE
      callSuper(...)
    },
    filter = function(x) {
      ## return subset of columns based on cols argument
      if (length(cols) > 1) return(names(x) %in% cols)
      switch(cols,
        factor = sapply(x, is.factor),
        numeric = sapply(x, is.numeric),
        TRUE)
    },
    fit = function(x) {
      fit_(.self, x, f=filter(x))
      isfit <<- TRUE
    },
    transform = function(x) {
      stopifnot(isfit)
      transform_(.self, x, f=filter(x))
    },
    fit_transform = function(x) {
      fit(x)
      transform(x)
    },
    inverse_transform = function(x) {
      stopifnot(isfit)
      inverse_transform_(.self, x, f=filter(x))
    }
  ))

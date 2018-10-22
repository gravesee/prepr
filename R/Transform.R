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
      ## return subset of columns based on cols argument
      if (identical(cols, character()))
        TRUE
      else if (length(cols) > 1)
        names(x) %in% cols
      else
        switch(
          cols,
          factor = vapply(x, is.factor, TRUE),
          numeric = vapply(x, is.numeric, TRUE),
          TRUE)
    },
    fit = function(x, ...) {
      f <- filter(x)
      if (!any(f)) return(x)
      checktypes(x, f, allowed_types_, .self)
      fit_(.self, x, f=f, ...)
      isfit <<- TRUE
    },
    transform = function(x) {
      stopifnot(isfit)
      checktypes(x, filter(x), allowed_types_, .self)
      transform_(.self, x, f=filter(x))
    },
    fit_transform = function(x, ...) {
      fit(x, ...)
      transform(x)
    },
    inverse_transform = function(x) {
      stopifnot(isfit)
      checktypes(x, filter(x), allowed_types_, .self)
      inverse_transform_(.self, x, f=filter(x))
    }
  ))

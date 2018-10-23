#' @include util.R generics.R

setClassUnion("NullOrChar", c("character", "NULL"))

#' @exportClass Transformer
setRefClass(
  "Transformer",
  contains = "VIRTUAL",
  fields = c(isfit="logical", cols="NullOrChar", allowed_types_="character"),
  methods = list(
    initialize = function(cols="all", ...) {
      cols <<- cols
      isfit <<- FALSE
      callSuper(cols=cols)
    },
    filter = function(x) {
      cols <<- if (!is.null(cols)) filter_cols_(x, cols) else cols
    },
    fit = function(x, ...) {
      on.exit(isfit <<- TRUE)
      filter(x)
      checktypes(x, cols, allowed_types_, .self)
      invisible(fit_(.self, x, f=cols, ...))
    },
    transform = function(x, MoreArgs=list()) {
      stopifnot(isfit)
      if (!is.null(cols)) {
        checktypes(x, cols, allowed_types_, .self)
        transform_(.self, x, f=cols, MoreArgs)
      } else x
    },
    fit_transform = function(x, ..., MoreArgs=list()) {
      fit(x, ...)
      transform(x, MoreArgs)
    },
    show = function(s="") {
      cat(sprintf("%s%s", s, .self$getRefClass()@className))
      cat(sprintf("\n%scols: %s", extend_(s), trunc_(cols)))
    }
  ))

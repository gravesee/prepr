#' @include Transform.R

Pipeline <- setRefClass(
  "Pipeline",
  contains = "Transformer",
  fields = c(transformers="list"),
  methods = list(
    initialize = function(transformers, ...) {
      callSuper(...)
      transformers <<- transformers

      ## apply column filter to all transformers
      if (!identical(cols, character(0))) {
        transformers <<- lapply(transformers, function(tf) {
          tf$cols <- cols
          tf
        })
      }
    },
    show = function(s) {
      callSuper(s="")
      for (tf in transformers) {
        cat("\n")
        tf$show(s="  ")
      }
    })
  )

#' @export
pipeline <- function(..., cols=character()) {
  tfs <- list(...)
  stopifnot(all(sapply(tfs, is, "Transformer")))
  Pipeline(transformers=tfs, cols=cols)
}

#' @export
setMethod("fit_", c("Pipeline"), function(.self, x, ...) {
  for (i in seq_along(.self$transformers)) {
    x <- .self$transformers[[i]]$fit_transform(x, ...)
  }
})

#' @export
setMethod("transform_", c("Pipeline"), function(.self, x) {
  for (i in seq_along(.self$transformers)) {
    x <- .self$transformers[[i]]$transform(x)
  }
  x
})

#' @export
setMethod("inverse_transform_", c("Pipeline"), function(.self, x) {
  for (i in rev(seq_along(.self$transformers))) {
    x <- .self$transformers[[i]]$inverse_transform(x)
  }
  x
})

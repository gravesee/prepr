#' @include Transform.R

Pipeline <- setRefClass(
  "Pipeline",
  contains = "Transformer",
  fields = c(transformers="list"),
  methods = list(
    initialize = function(transformers, ...) {
      transformers <<- transformers
      callSuper(...)
    })
)

#' @export
pipeline <- function(...) {
  tfs <- list(...)
  stopifnot(all(sapply(tfs, is, "Transformer")))
  Pipeline(transformers=tfs)
}

#' @export
setMethod("fit_", c("Pipeline"), function(.self, x) {
  for (i in seq_along(.self$transformers)) {
    x <- .self$transformers[[i]]$fit_transform(x)
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

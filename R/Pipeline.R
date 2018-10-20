#' @include Transform.R

Pipeline <- setRefClass(
  "Pipeline",
  contains = "Transformer",
  fields = c(transformers="list"),
  methods = list(
    initialize = function(transformers, ...) {
      transformers <<- transformers
      callSuper(...)
    },
    fit = function(data) {
      isfit <<- TRUE
      for (i in seq_along(transformers)) {
        data <- transformers[[i]]$fit_transform(data)
      }
    },
    transform = function(data) {
      stopifnot(isfit)
      for (i in seq_along(transformers)) {
        data <- transformers[[i]]$transform(data)
      }
      data
    },
    inverse_transform = function(data) {
      stopifnot(isfit)
      for (i in rev(seq_along(transformers))) {
        data <- transformers[[i]]$inverse_transform(data)
      }
      data
    }
  )
)

#' @export
pipeline <- function(...) {
  tfs <- list(...)
  stopifnot(all(sapply(tfs, is, "Transformer")))
  Pipeline(transformers=tfs)
}

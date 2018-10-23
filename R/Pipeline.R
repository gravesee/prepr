#' @include Transform.R

Pipeline <- setRefClass(
  "Pipeline",
  contains = "Transformer",
  fields = c(transformers="list", schema_="list", perf_="ANY"),
  methods = list(
    initialize = function(transformers, perf=NULL, ...) {
      perf_ <<- perf
      callSuper(...)
      transformers <<- transformers
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
setMethod("fit_", c("Pipeline"), function(.self, x, ..., overwrite=FALSE) {
  if (.self$isfit && !overwrite) stop("pipeline already fit, use overwrite=TRUE to force")
  
  ## set the schema
  .self$schema_ <- lapply(x, schema_)
  
  for (tf in .self$transformers) {
    if (!is(tf, "Sink")) x <- tf$fit_transform(x, perf=.self$perf_, ...)
  }
})

#' @export
setMethod("transform_", c("Pipeline"), function(.self, x, f, MoreArgs) {
  for (tf in .self$transformers) x <- tf$transform(x, MoreArgs=MoreArgs)
  x
})


#' @export
pipeline <- function(formula, data, ...) {
  f <- strip_formula_(formula, data)
  tfs <- list(...)
  stopifnot(all(sapply(tfs, is, "Transformer")))
  Pipeline(transformers=tfs, cols=f$cols, perf=f$perf)
}

#' @export
setMethod("%|>%", c("Transformer", "Transformer"), function(lhs, rhs) pipeline(lhs, rhs))

#' @export
setMethod("%|>%", c("Pipeline", "Transformer"), function(lhs, rhs) {
  lhs$transformers <- c(lhs$transformers, rhs)
  lhs
})


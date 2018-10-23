#' @include Transform.R

#' @export
Sink <- setRefClass(
  "Sink",
  contains = "Transformer",
  fields = c(FUN="function"),
  methods = list(
    initialize=function(FUN, ...) {
      FUN <<- FUN
      callSuper(...)
    })
  )

#' @export
setMethod("fit_", c("Sink", "data.frame"), function(.self, x, f, ...) .self)


#' @export
setMethod("transform_", c("Sink", "data.frame"), function(.self, x, f, MoreArgs) {
  do.call(.self$FUN, c(list(x), MoreArgs))
})

#' @export
sink_lambda <- function(x) Sink(x)

#' @export
sink_matrix <- function() Sink(as.matrix)

#' @export
sink_sparse <- function() Sink(function(x, formula, ...) Sink(Matrix::sparse.model.matrix(formula, data = x, ...)))

#' @export
sink_tibble <- function() Sink(tibble::as_tibble)

#' @export
sink_DT <- function() Sink(data.table::data.table)

#' @export
sink_xgboost <- function() Sink(function(x, ...) xgboost::xgb.DMatrix(as.matrix(x), ...))
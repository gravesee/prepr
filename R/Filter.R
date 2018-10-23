#' @include Transform.R

drop_unnamed_ <- function(x) x[-which(names(x) == "")]

#' @exportClass Filter
#' @export Filter
Filter <-setRefClass(
  "Filter",
  contains = c("Transformer", "VIRTUAL"),
  fields = c(predicates_="list", drop_cols_="character"),
  methods = list(
    initialize = function(...) {
      # cols <<- cols
      callSuper(...)
    },
    show = function(s="") {
      callSuper(s=s)
      cat(sprintf("\n%sdrop: %s", extend_(s), trunc_(drop_cols_)))
    })
)

#' @exportClass StandardFilter
#' @export StandardFilter
StandardFilter <-setRefClass(
  "StandardFilter",
  contains = "Filter",
  methods = list(
    initialize = function(cols="numeric", ...) {
      callSuper(cols=cols, allowed_types_=c("integer", "numeric"))
      predicates_ <<- strip_preds(list(...))
    })
)

#' @exportClass FactorFilter
#' @export FactorFilter
FactorFilter <-setRefClass(
  "FactorFilter",
  contains = "Filter",
  methods = list(
    initialize = function(cols="factor", ...) {
      callSuper(cols=cols, allowed_types_="factor")
      predicates_ <<- strip_preds(list(...))
    })
)

#' @param p predicate, function that returns TRUE, FALSE for each column of a data.frame
#' @param df data.frame to apply the predicate to, one column at a time
check_predicates_ <- function(p, df) vapply(df, p, TRUE)

#' @export
setMethod("fit_", c("Filter", "data.frame"), function(.self, x, f, ...) {
  res <- lapply(.self$predicates_, check_predicates_, x[f])
  .self$drop_cols_ <- names(which(Reduce(`|`, res))) ## drop columns that pass any predicate
})

#' @export
setMethod("transform_", c("Filter", "data.frame"), function(.self, x, f) {
  k <- match(.self$drop_cols_, names(x), nomatch = 0)
  if (all(k == 0)) x else x[,-k,drop=F]
})

#' @include Transform.R

drop_unnamed_ <- function(x) x[-which(names(x) == "")]

#' @exportClass Filter
#' @export Filter
Filter <-setRefClass(
  "Filter",
  contains = c("Transformer"),
  fields = c(axis="integer", predicates_="list", drop_cols_="character"),
  methods = list(
    initialize = function(..., cols="all", axis=2L) {
      axis <<- axis
      predicates_ <<- strip_preds(list(...), axis)
      callSuper(cols=cols)
    },
    show = function(s="") {
      callSuper(s=s)
      cat(sprintf("\n%sdrop: %s", extend_(s), trunc_(drop_cols_)))
    })
)


#' @param p predicate, function that returns TRUE, FALSE for each column of a data.frame
#' @param df data.frame to apply the predicate to, one column at a time
check_predicates_ <- function(p, df, axis) {
  res <- switch(axis, p(df), vapply(df, p, TRUE))
  
  ## Error checking for axis == 1L, vapply will catch errors for axis = 2L
  if (!identical(length(res), NROW(df)) && identical(axis, 1L))
    stop("predicate must return nrow(x) elements when axis=1")
  
  res
  
}

#' @export
setMethod("fit_", c("Filter", "data.frame"), function(.self, x, f, ...) {
  res <- lapply(.self$predicates_, check_predicates_, x[f], .self$axis)
  ## drop columns that pass any predicate when axis = 2L
  if (identical(.self$axis, 2L)) .self$drop_cols_ <- names(which(Reduce(`|`, res)))
})

#' @export
setMethod("transform_", c("Filter", "data.frame"), function(.self, x, f) {
  
  switch(
    .self$axis,
     { ## Filter rows axis = 1 
       res <- lapply(.self$predicates_, check_predicates_, x[f], .self$axis)
       k <- Reduce(`|`, res)
       x[!k,,drop=F]
     },
     { ## Filter columns axis = 2
       k <- match(.self$drop_cols_, names(x), nomatch = 0)
       if (all(k == 0)) x else x[,-k,drop=F]
     })
})


#' @export
prep_filter <- function(..., axis=2L, cols="all") Filter(..., axis=axis, cols=cols)

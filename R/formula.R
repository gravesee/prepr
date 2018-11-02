##---- Functions for manipulating formulae


safe_index <- function(l, i) if (length(i) > 0) l[i] else NULL

## get the formula parts that represent column selector functions
#' @title Strip Function calls from Formula
#' @details As part of a formula, the user may include calls that select groups
#' of variables. This collection of function is detailed in \link{column-selectors}.
#' @param tm The terms structure returned after applying \code{term} to a formula
#' @param i The index of the response attribute
#' @return A list of calls that either add or subtract variables to the transform
form_calls <- function(tm, i) {
  #  browser()
  exprs <- as.list(attr(tm, "variables"))[-1]
  calls <- which(vapply(exprs, is, TRUE, "call"))
  calls <- setdiff(calls, i)

  #res <- list(add=NULL, sub=NULL)
  if (any(calls)) {
    ## determine which direction
    dirs <- rowSums(attr(tm, "factors"))
    res$add <- safe_index(exprs, intersect(which(dirs == 1), calls))
    res$sub <- safe_index(exprs, intersect(which(dirs == 0), calls))
  }
  res
}

##---- Helper Funcs
sub_terms <- function(d, i) setdiff(which(d == 0), i)
add_terms <- function(d, i) setdiff(which(d > 0), i)
filter_call <- function(exprs, i) unlist(Filter(is.call, exprs[i]))
filter_vars <- function(exprs, i) unlist(sapply(Filter(is.name, exprs[i]), deparse))

#' @title Parse Formula for Variable Specification
#' @param f A formula specifying how variables should be treated.
#' @param data A dataset containing variables referenced by the formula.
#' @return A nested list containing information \link{\code{Transformer}} objects
#' need for processing fit & transform methods.
form_parts <- function(f, data) {

  tm <- terms(f, data=data)

  factors <- attr(tm, "factors")
  if (identical(factors, integer(0))) {
    stop("Formula must have predictors.")
  }

  exprs <- as.list(attr(tm, "variables"))[-1]
  calls <- which(vapply(exprs, is, TRUE, "call"))
  dirs <- rowSums(factors)

  i <- attr(tm, "response")
  v <- sapply(exprs, deparse)

  ## store all of the indices in own vars
  list(
    resp = v[i],
    vars = list(
      add = filter_vars(exprs, add_terms(dirs, i)),
      sub = filter_vars(exprs, sub_terms(dirs, i))),
    funs = list(
      add = filter_call(exprs, add_terms(dirs, i)),
      sub = filter_call(exprs, sub_terms(dirs, i)))
  )
}

##---- Variable Selectors

cols_filter <- function(what, env) {
  x <- sapply(env, class)
  unlist(names(Filter(function(x) x %in% what, x)))
}


#' @name sel_factor
#' @title Select Factor Columns
#' @rdname column-selectors
#' @export
sel_factor <- function()  cols_filter("factor", parent.frame())

#' @name sel_numeric
#' @title Select Numeric Columns
#' @rdname column-selectors
#' @export
sel_numeric <- function() cols_filter(c("numeric", "integer"), parent.frame())

#' @name sel_regex
#' @title Select Columns by Regex
#' @rdname  column-selectors
#' @export
sel_regex <- function(regex) {
  x <- names(parent.frame())
  grep(pattern = regex, x, value = TRUE)
}

## TODO: add method to pass any lambda test for which columns are selected
sel_lambda <- function(pred) {
  x <- parent.frame()
  names(x)[vapply(x, pred, FUN.VALUE = TRUE)]
}

eval_funs <- function(funs, data) {
  res <- lapply(funs, eval, envir=data)
  do.call(c, res)
}

reify <- function(x, data, what) UseMethod("reify")

reify.formula <- function(x, data, what=c("vars", "resp")) {
  fp <- form_parts(x, data)
  reify(fp, data, what)
}

### use formula_parts and data.frame to extract information
reify.list <- function(x, data, what=c("vars", "resp")) {
  # check here for vars that aren't in ?
  # nms <- names(data)
  switch(
    match.arg(what),
    resp = x$resp,
    vars = {
      adds <- c(x$vars$add, eval_funs(x$funs$add, data))
      subs <- c(x$vars$sub, eval_funs(x$funs$sub, data))

      res <- unlist(unique(setdiff(adds, subs)))
      #intersect(res, data)
      res
    }
  )
}


##---- Helpers
unpack_ <- function(l, ...) {
  names <- unlist(list(...))
  lapply(setNames(names, names), function(el) sapply(l, "[[", el))
}

repvec_ <- function(vec, length=1L) {
  if (is.numeric(vec)) rep(list(vec), length) else vec
}

comma <- function(x) paste0(x, collapse=", ")

trunc_ <- function(x, max=5) {
  toprint <- head(x, max)
  rest <- length(tail(x, -5))
  paste0(comma(toprint), sprintf(", ... (%d more)", if (rest > 0) rest else NULL))
}


## get names of vars that aren't of class type
checktypes <- function(x, f, type, .self) {
  if (identical(length(type), 0L)) return()

  res <- base::Filter(Negate(function(el) el %in% type), sapply(x, class)[f])
  fail <- names(res)

  if (length(fail) > 0L) {
    rc <- .self$getRefClass()
    stop("Invalid column classes for ", rc@className, ": ", comma(fail))
  }
}

extend_ <- function(s, n=2) paste0(s, rep(" ", n), collapse= "")

all_found_ <- function(cols, nms) {
  fail <- cols[!cols %in% nms]

  if (length(fail) > 0)
    stop("Requested column(s) not found in x: ", comma(fail))
  else
    cols
}

filter_cols_ <- function(x, cols) {
  nms <- names(x)

  cols <-
    if (identical(cols, character()))
      nms
    else if (length(cols) > 1)
      all_found_(cols, nms)
    else switch(
      cols,
      factor = nms[vapply(x, is.factor, TRUE)],
      numeric = nms[vapply(x, is.numeric, TRUE)],
      all_found_(cols, nms))
}

##---- Filter helper functions

is.formula <- function(x) is(x, "formula")

forms <- function(x) base::Filter(is.formula, x)

make_func <- function(text, env=parent.frame()) {
  eval(
    call("function",
         as.pairlist(list(x=quote(expr =))),
         parse(text=text)[[1]]),
    env=env)
}

form_to_func <- function(x, env) make_func(as.character(tail(x, 1)), env)

strip_preds <- function(x, env=parent.frame()) lapply(forms(x), form_to_func, env)



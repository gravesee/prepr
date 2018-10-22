##---- Helpers
unpack_ <- function(l, ...) {
  names <- unlist(list(...))
  lapply(setNames(names, names), function(el) sapply(l, "[[", el))
}

repvec_ <- function(vec, length=1L) {
  if (is.numeric(vec)) rep(list(vec), length) else vec
}

comma <- function(x) paste0(x, collapse=", ")

## get names of vars that aren't of class type
checktypes <- function(x, f, type, .self) {
  if (identical(length(type), 0L)) return()

  res <- Filter(Negate(function(el) el %in% type), sapply(x, class)[f])
  fail <- names(res)

  if (length(fail) > 0L) {
    rc <- .self$getRefClass()
    stop("Invalid column classes for ", rc@className, ": ", comma(fail))
  }
}

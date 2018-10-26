#' @include Transform.R

sub_fit_ <- function(x, y, method, na.rm) {
  tapply(y, x, method, na.rm=na.rm)
}

Substituter <- setRefClass(
  "Substituter",
  contains = "Transformer",
  fields = c(method="function", na.rm="logical", values="list"),
  methods = list(

    initialize = function(f=~., method=mean, na.rm=TRUE, ...) {
      method <<- method
      na.rm <<- na.rm
      callSuper(f, ...)
    },

    fit = function(x) {
      callSuper(x)
      ## check for perf here?
      if(!length(resp) > 0) stop("prep_substitute requires a response variable.", call. = FALSE)

      values <<- lapply(x[vars], sub_fit_, method=method, y=x[[resp]], na.rm=na.rm)
    },

    transform = function(x) {
      if (is.null(vars)) return(x)

      ## substitute values of y in each var
      x[vars] <- mapply(function(x, v) v[as.character(x)],
                        x[vars], values, SIMPLIFY = FALSE)
      x

    })
)

#' @export
prep_substitute <- function(f=~sel_factor(), method=mean, na.rm=TRUE, ...) Substituter(f=f, method=method, na.rm=na.rm, ...)



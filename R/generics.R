

#' @export
setGeneric("fit_", function(.self, x, f, ...) standardGeneric("fit_"))

#' @export
setGeneric("transform_", function(.self, x, f, MoreArgs) standardGeneric("transform_"))

#' @export
setGeneric("%|>%", function(lhs, rhs) standardGeneric("%|>%"))

#' @export
schema_ <- function(x) UseMethod("schema_")

#' @export
schema_.default <- function(x) list(class=class(x), summary=summary(x))

#' @export
schema_.factor <- function(x) list(class=class(x), levels=levels(x))


#'@include Transform.R

#' @export OnehotEncoder
OnehotEncoder <- setRefClass(
  "OnehotEncoder",
  contains = "Transformer",
  fields = c(levels="list", keep="logical", levels_="list"),
  methods = list(
    initialize = function(levels=list(), keep=FALSE, cols="factor", ...) {
      ## check levels
      levels <<- levels
      keep <<- keep
      allowed_types_ <<- "factor"

      if (!identical(levels, list())) {
        errs <- list()
        if (is.null(names(levels)))
          append(errs, "  levels argument must be a named list")

        if(!all(sapply(levels, is.character)))
          append(errs, "  levels argument elements must all be character")

        if (!identical(errs, list())) {
          errs <- c("levels have following errors:", errs)
          stop(paste0(errs, collapse="\n"))
        }

        levels_ <<- levels
        cols <<- names(levels)
      } else {
        cols <<- cols
      }

      callSuper(...)
    })
)

##---- Helpers

#' @export
setMethod("fit_", c("OnehotEncoder", "data.frame"), function(.self, x, f, ...) {
  if (!identical(.self$levels, list())) return()
  .self$levels_ <- lapply(x[,f,drop=F], levels)
})

#' @param x factor
#' @param l levels
#' @return data.frame of column indicators
onehot_tf_ <- function(x, l) {
  m <- matrix(0, NROW(x), length(l))
  m[cbind(seq_along(x), match(x, l, nomatch = 0))] <- 1
  colnames(m) <- paste0("=", l)
  data.frame(m, check.names = FALSE)
}

#' @export
setMethod("transform_", c("OnehotEncoder", "data.frame"), function(.self, x, f, ..., y) {
  inds <- mapply(onehot_tf_, x[f], .self$levels_[f], SIMPLIFY=F)

  for (nm in f) {
    names(inds[[nm]]) <- paste0(nm, colnames(inds[[nm]]))
  }

  inds <- do.call(cbind, unname(inds))

  if (.self$keep)
    cbind(x, inds)
  else {
    i <- match(f, names(x))
    cbind(x[-i], inds)
  }
})

#' @include Transform.R

onehot_tf_ <- function(x, l) {
  k <- match(x, l, 0)
  m <- matrix(0, NROW(x), length(l))
  m[cbind(seq_along(x), k)] <- 1
  colnames(m) <- paste0("=", as.character(l))
  data.frame(m, check.names = FALSE)
}

#' @export
onehot_fit_ <- function(x) UseMethod("onehot_fit_")

#' @export
onehot_fit_.default <- function(x) {
  warning("creating onehot encoding for non-factor", call. = F)
  unique(x)
}

#' @export
onehot_fit_.factor <- function(x) levels(x)



OnehotEncoder <- setRefClass(
  "OnehotEncoder",
  contains = "Transformer",
  fields= c(keep="logical", levels="ANY"),
  methods = list(

    initialize = function(f=~cols_factor(), keep=FALSE, ...) {
      keep <<- keep
      callSuper(f, ...)
    },

    fit = function(x, ...) {
      callSuper(x)
      levels <<- lapply(x[vars], onehot_fit_)
    },

    transform = function(x) {
      callSuper(X)
      if (is.null(vars)) return(x)

      res <- mapply(onehot_tf_, x[vars], levels, SIMPLIFY = FALSE)

      ## add var names
      for (nm in names(res)) {
        names(res[[nm]]) <- paste0(nm, names(res[[nm]]))
      }

      out <- do.call(cbind, unname(res))

      if (keep) {
        cbind(x, out)
      } else {
        k <- match(vars, names(x), 0)
        cbind(x[-k], out)
      }
    })
)

#' @export
prep_onehot <- function(f=~sel_factor(), keep=FALSE, ...) OnehotEncoder(f=f, keep=keep, ...)



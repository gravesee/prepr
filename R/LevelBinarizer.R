#' @include Transform.R OnehotEncoder.R

LevelBinarizer <- setRefClass(
  "LevelBinarizer",
  contains = "Transformer",
  fields = c(levels="ANY", replace="ANY"),
  methods = list(

    initialize = function(f=~., levels, replace, ...) {
      levels <<- levels
      replace <<- replace
      callSuper(f, ...)
    },

    fit = function(x) {
      callSuper(x)
    },

    transform = function(x) {
      if (is.null(vars)) return(x)

      res <- lapply(x[vars], onehot_tf_, levels)

      ## replace `levels` with `replace` for each var
      for (nm in names(res)) {
        names(res[[nm]]) <- paste0(nm, names(res[[nm]]))
      }

      x[vars] <- lapply(x[vars], function(x) {
        x[x %in% levels] <- replace
        x
      })

      cbind(x, do.call(cbind, unname(res)))

    })
)

#' @export
prep_binarize <- function(f=~., levels=NA, replace=0, ...) LevelBinarizer(f=f, levels=levels, replace=replace, ...)



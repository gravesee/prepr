 #' @include Transform.R

Pipeline <- setRefClass(
  "Pipeline",
  contains = "Transformer",
  fields = c(tfs="list"),
  methods = list(
    initialize = function(f=~., ...) {
      callSuper(f=f)
      tfs <<- list(...)
    },

    fit = function(x, ...) {
      callSuper(x)
      for (tf in tfs) {
        x <- tf$fit_transform(x, ...)
      }
    },

    transform = function(x) {
      for (tf in tfs) {
        x <- tf$transform(x)
      }
      x
    },

    fit_transform = function(x, ...) {
      for (tf in tfs) {
        x <- tf$fit_transform(x, ...)
      }
      x
    }
  )
)

#' @export
pipeline <- function(..., f=~.) Pipeline(..., f=f)

#' @export
setGeneric("%|>%", function(lhs, rhs) standardGeneric("%|>%"))

#' @export
setMethod("%|>%", c("Transformer", "Transformer"), function(lhs, rhs) pipeline(lhs, rhs))

#' @export
setMethod("%|>%", c("Pipeline", "Transformer"), function(lhs, rhs) {
  lhs$tfs <- append(lhs$tfs, rhs)
  lhs
})

#' @export
setMethod("%|>%", c("Pipeline", "Pipeline"), function(lhs, rhs) {
  lhs$tfs <- append(lhs$tfs, rhs$tfs)
  lhs
})

#' @export
setMethod("show", "Pipeline", function(object) {
  cat("[", object$getClass()@className, "] [isfit: ", if (object$isfit) "yes" else "no", "]")
  for (tf in object$tfs) {
    cat("\n|--")
    show(tf)
  }
})


#'@include Transform.R

#' @export StandardImputer
StandardImputer <-setRefClass(
  "StandardImputer",
  contains = "Transformer",
  fields = c(method="character", value="numeric", value_="numeric"),
  methods = list(
    initialize = function(method="mean", value=NA_real_, ...) {
      method <<- method
      value <<- value
      callSuper(...)
    })
)

##---- Helpers
StandardImputer_fit_ <- function(x, method, value) {
  if (!identical(value, NA_real_)) value else do.call(method, list(x, na.rm=TRUE))
}

#' @export
setMethod("fit_", c("StandardImputer", "numeric"), function(.self, x, ...) {
  .self$value_ <- StandardImputer_fit_(x, .self$method, .self$value)

})

#' @export
setMethod("fit_", c("StandardImputer", "data.frame"), function(.self, x, ...) {
  .self$value_ <- mapply(StandardImputer_fit_, x,
                         .self$method, .self$value, SIMPLIFY = TRUE)
})

StandardImputer_transform_ <- function(x, value_) {
  x[is.na(x)] <- value_
  x
}

#' @export
setMethod("transform_", c("StandardImputer", "numeric"), function(.self, x) {
  StandardImputer_transform_(x, .self$value_)
})

#' @export
setMethod("transform_", c("StandardImputer", "data.frame"), function(.self, x) {
  x[] <- mapply(StandardImputer_transform_, x, .self$value_, SIMPLIFY = F)
  x
})

#' @export
setMethod("inverse_transform_", c("StandardImputer"), function(.self, x) {
  stop("Inverse not valid -- StandardImputer")
})

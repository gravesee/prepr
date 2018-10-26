#' @include Transform.R

scale_fit_ <- function(x, min, max, na.rm) {
  r <- range(x, na.rm=na.rm)
  diff(c(min, max)) / diff(r)
}

scale_base_ <- function(x, min, na.rm=T) {
  min(x, na.rm=T)
}

scale_tf_ <- function(x, scale, base, min) {
  scale * (x - base) + min
}

MinMaxScaler <- setRefClass(
  "MinMaxScaler",
  contains = "Transformer",
  fields = c(min="numeric", max="numeric", scale="list", base="list", na.rm="logical"),
  methods = list(

    initialize = function(f=~., min=-1, max=1, na.rm=TRUE, ...) {
      min <<- min
      max <<- max
      na.rm <<- na.rm
      callSuper(f, ...)
    },

    fit = function(x) {
      callSuper(x)

      scale <<- lapply(x[vars], scale_fit_, min, max, na.rm)
      base <<- lapply(x[vars], scale_base_, min, na.rm)

    },

    transform = function(x) {
      if (is.null(vars)) return(x)

      x[vars] <- mapply(scale_tf_,
                        x[vars], scale[vars], base[vars], min)
      x
    })
)

#' @export
prep_minmax <- function(f=~sel_numeric(), min=-1, max=1, na.rm=TRUE, ...)
  MinMaxScaler(f=f, min=min, max=max, na.rm=na.rm, ...)

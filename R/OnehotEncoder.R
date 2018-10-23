#'@include Transform.R

check_levels_ <- function(l) {
  if (is.null(names(l)) || !all(sapply(l, is.character)))
    stop("Each level must be passed as a named argument with character elements")
}


#' @export OnehotEncoder
OnehotEncoder <- setRefClass(
  "OnehotEncoder",
  contains = "Transformer",
  fields = c(levels="list", keep="logical", levels_="list", levels_passed_="logical"),
  methods = list(
    initialize = function(..., keep=FALSE, cols="factor") {
      ## check levels
      levels <<- list(...)
      levels_passed_ <<- FALSE
      keep <<- keep
      
      if (!identical(levels, list())) {
        check_levels_(levels)
        levels_passed_ <<- TRUE
        levels_ <<- levels
        cols <- names(levels)
      }
      
      callSuper(allowed_types_="factor", cols=cols)
    })
)

##---- Helpers

#' @export
setMethod("fit_", c("OnehotEncoder", "data.frame"), function(.self, x, f, ...) {
  if (.self$levels_passed_) return() else .self$levels_ <- lapply(x[,f,drop=F], levels)
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
setMethod("transform_", c("OnehotEncoder", "data.frame"), function(.self, x, f, MoreArgs) {
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

#' Onehot Encoder
#' 
#' Encode factor variables to indicator columns
#' 
#' @param ... Named arguments where the name maps to variables in the dataset and the argument is
#' a character vector of levels to create indicator columns
#' @param keep keep original factors levels after onehot encoding
#' @param cols character vector of column names to onehot encode. Defaults to all factor columns.
#' @examples
#' data(mtcars)
#' mtcars$cyl <- factor(mtcars$cyl)
#' prep <- prep_onehot()
#' prep$fit_transfrom(mtcars)
#' @export
prep_onehot <- function(..., keep=FALSE, cols="factor") OnehotEncoder(..., keep=keep, cols=cols)

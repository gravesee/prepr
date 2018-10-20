
#' @include preparator.R

#' @export
setGeneric("compose", function(f, g) standardGeneric("compose"))

#' @export
setMethod("compose", c("vector", "preparator"), function(f, g) {
  res <- g@fun(f)
  res@call <- g@call
  res
})

#' @export
setMethod("compose", c("vector", "preplist"), function(f, g) {
  x <- f ## pass the vector through and return the preplist
  for (i in seq_along(g@preparators)) {
    p <- g@preparators[[i]]
    g@preparators[[i]] <- x %|>% p
    x <- g@preparators[[i]]@data
  }
  g
})

#' @export
setMethod("compose", c("preparator", "preparator"), function(f, g) {
  if (!is.null(f@data))
    preplist(preparators=list(f, g@fun(f@data)))
  else
    preplist(preparators=list(f, g))
})

#' @export
setMethod("compose", c("preplist", "preparator"), function(f, g) {
  ## check last element of preplist
  last <- tail(f@preparators, 1L)[[1L]]
  to_append <- if (!is.null(last@data)) g@fun(last@data) else g
  f@preparators <- append(f@preparators, to_append)
  f
})

#' @export
setMethod("compose", c("preplist", "preplist"), function(f, g) {
  ## check last element of preplist
  last <- tail(f@preparators, 1L)[[1L]]
  to_append <- if (!is.null(last@data)) last@data %|>% g else g
  f@preparators <- append(f@preparators, to_append)
  f
})

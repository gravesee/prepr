##----- Preparator class
#' @export
preparator <- setClass("preparator", list(fun="function", data="ANY", extra="list", call="call"))

#' @export
setMethod("predict", "preparator", function(object, newdata, ...) {
  object@fun(newdata)@data
})

#' @export
setMethod("show", "preparator", function(object) cat(deparse(object@call), sep = "\n"))


##----- Preplist class
#' @export
preplist <- setClass("preplist", list(preparators="list"))

#' @export
setMethod("show", "preplist", function(object) invisible(lapply(object@preparators, show)))

#' @export
setMethod("predict", "preplist", function(object, newdata, ...) {
  for (p in object@preparators) newdata <- predict(p, newdata)
  newdata
})

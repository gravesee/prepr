setRefClass(
  "Transformer",
  contains = "VIRTUAL",
  fields = c(isfit="logical"),
  methods = list(
    initialize = function(...) {
      isfit <<- FALSE
      callSuper(...)
    },
    fit = function(data) stop("Must implement"),
    transform = function(data) stop("Must implement"),
    fit_transform = function(data) {
      fit(data)
      transform(data)
    }
  ))

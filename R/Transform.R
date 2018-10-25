
Transformer <- setRefClass(
  "Transformer",
  contains="VIRTUAL",
  fields=c(f="formula", info="list", vars="character", resp="character", isfit="logical"),

  methods = list(
    initialize = function(f=~., keep=FALSE, ...) {
      isfit <<- FALSE
      f <<- f
    },

    fit = function(x, ...) {
      ## get the data needed to fit
      info <<- form_parts(f, x)
      vars <<- reify(info, x, "vars")
      resp <<- reify(info, x, "resp")
      isfit <<- TRUE
    },

    transform = function(x) if (length(vars) == 0L) return(NULL),

    fit_transform = function(x, ...) {
      fit(x, ...)
      transform(x)
    }
  )
)


setMethod("show", "Transformer", function(object) {
  cat("[", object$getClass()@className, "] [isfit: ", if (object$isfit) "yes" else "no", "]")
})


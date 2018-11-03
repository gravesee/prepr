
Sink <- setRefClass(
  "Sink",
  contains="Transformer",
  fields=c(f="formula", info="list", vars="character", resp="character", sink="function"),
  methods = list(
    initialize = function(f=~., sink=sink, ...) {
      isfit <<- FALSE
      f <<- f
      sink <<- sink
    },

    fit = function(x, ...) {
      ## get the data needed to fit
      #browser()
      #debugonce(form_parts)
      info <<- form_parts(f, x)
      vars <<- reify(info, x, "vars")
      resp <<- reify(info, x, "resp")
      isfit <<- TRUE
    },

    transform = function(x) {
      if (length(vars) == 0) return(NULL)
      sink(x[vars], x[resp])
    },

    fit_transform = function(x, ...) {
      fit(x, ...)
      transform(x)
    }
  )
)

#' @export
sink_matrix <- function(f=~.) Sink$new(f=~., sink=function(x, ...) as.matrix(x))

#' @export
sink_sparse <- function(f=~.) {
  Sink$new(f=f, sink = function(x, ...) {
    dn <- list(row.names(x), colnames(x))
    Matrix::Matrix(as.matrix(x), sparse = TRUE, dimnames = dn)
  })
}

#' @importFrom  xgb.DMatrix xgboost

#' @export
sink_xgboost <- function(f=~.) {
  Sink$new(f=f, sink=function(x, resp, ...) {
    if (identical(NCOL(resp), 0L))
      stop("xgboost sink must have response var")
    xgboost::xgb.DMatrix(as.matrix(x), info = list(label=resp[[1]]))
  })
}

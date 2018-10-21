#'@include Transform.R

##---- Helpers

#' @export
standard_scale_mean_ <- function(data, with_mean, with_std) {
  UseMethod("standard_scale_mean_")
}

#' @export
standard_scale_mean_.numeric <- function(data, with_mean, with_std) {
  list(
    scale_ = if (with_std) sd(data) else var(data),
    mean_  = if (with_mean) mean(data) else 0)
}

#' @export
standard_scale_mean_.data.frame <- function(data, with_mean, with_std) {
  res <- mapply(standard_scale_mean_, data, with_mean, with_std, SIMPLIFY = FALSE)
  unpack_(res, c("scale_", "mean_"))
}

##---- Transform

#' @export
standard_transform_ <- function(data, scale_, mean_, with_mean, with_std) {
  UseMethod("standard_transform_")
}

#' @export
standard_transform_.numeric <- function(data, scale_, mean_, with_mean, with_std) {
  if (with_mean) data <- data - mean_
  if (with_std) data <- data / scale_
  data
}

#' @export
standard_transform_.data.frame <- function(data, scale_, mean_, with_mean, with_std) {
  data[] <- mapply(
    standard_transform_,
    data,
    as.list(scale_),
    as.list(mean_),
    MoreArgs = list(with_mean=with_mean, with_std=with_std),
    SIMPLIFY = FALSE)

  data
}

##--- Inverse transform

#' @export
standard_inverse_transform_ <- function(data, scale_, mean_, with_mean, with_std) {
  UseMethod("standard_inverse_transform_")
}

#' @export
standard_inverse_transform_.numeric <- function(data, scale_, mean_, with_mean, with_std) {
  if (with_std) data <- data * scale_
  if (with_mean) data <- data + mean_
  data
}

#' @export
standard_inverse_transform_.data.frame <- function(data, scale_, mean_, with_mean, with_std) {
  data[] <- mapply(
    standard_inverse_transform_,
    data,
    as.list(scale_),
    as.list(mean_),
    MoreArgs = list(with_mean=with_mean, with_std=with_std),
    SIMPLIFY = FALSE)

  data
}


#' @export StandardScaler
StandardScaler <-setRefClass(
  "StandardScaler",
  contains = "Transformer",
  fields = c(with_mean="logical", with_std="logical", mean_="numeric", scale_="numeric"),
  methods = list(
    initialize = function(with_mean=TRUE, with_std=TRUE, ...) {
      with_mean <<- with_mean
      with_std <<- with_std
      callSuper(...)
    },

    fit = function(data) {
      callSuper()
      env <- list2env(standard_scale_mean_(data, with_mean, with_std), .self@.xData)
    },
    transform = function(data) {
      callSuper()
      standard_transform_(data, scale_, mean_, with_mean, with_std)
    },
    inverse_transform = function(data) {
      callSuper()
      standard_inverse_transform_(data, scale_, mean_, with_mean, with_std)
    }
  )
)

#' @export
`%|>%` <- function(f, g) compose(f, g)

partial <- function(...f, ..., env=parent.frame()) {
  fcall <- as.call(c(as.name(...f), list(...)))
  fcall[[length(fcall) + 1]] <- quote(...)
  args <- list(... = quote(expr = ))
  eval(call("function", as.pairlist(args), fcall), env)
}


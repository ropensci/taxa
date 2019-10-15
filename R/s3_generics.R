#' @export
`%in%` <- function(x, table) {
  UseMethod('%in%')
}


#' @export
`%in%.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @export
`%in%.character` <- function(x, table) {
  UseMethod("%in%.character", table)
}


#' @export
`%in%.character.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @export
`%in%.factor` <- function(x, table) {
  UseMethod("%in%.factor", table)
}


#' @export
`%in%.factor.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @export
`%in%.numeric` <- function(x, table) {
  UseMethod("%in%.numeric", table)
}


#' @export
`%in%.numeric.default` <- function(x, table) {
  base::`%in%`(x, table)
}

#' @export
`%in%` <- function(x, table) {
  UseMethod('%in%')
}


#' @export
`%in%.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @method %in% character
#' @export
`%in%.character` <- function(x, table) {
  UseMethod("%in%.character", table)
}


#' @export
`%in%.character.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @method %in% factor
#' @export
`%in%.factor` <- function(x, table) {
  UseMethod("%in%.factor", table)
}


#' @export
`%in%.factor.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @method %in% numeric
#' @export
`%in%.numeric` <- function(x, table) {
  UseMethod("%in%.numeric", table)
}


#' @export
`%in%.numeric.default` <- function(x, table) {
  base::`%in%`(x, table)
}


#' @export
as_data_frame <- function(x, row.names = NULL, optional = FALSE, ...,
                          stringsAsFactors = default.stringsAsFactors()) {
  UseMethod('as_data_frame')
}

#' @export
as_data_frame.default <- function(x, row.names = NULL, optional = FALSE, ...,
                                  stringsAsFactors = default.stringsAsFactors()) {
  as.data.frame(x, row.names = row.names, optional = optional, stringsAsFactors = stringsAsFactors, ...)
}

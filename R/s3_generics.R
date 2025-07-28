#' Value matching for taxa package
#'
#' A wrapper for the base value matching %in% that is used to take into consideration features of the taxa package.
#'
#' @inheritParams base::match
#'
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


#' Convert a taxa object to a `data.frame`
#'
#' Convert the information in a taxa object to a `data.frame` using base R
#' vectors as columns. Use [tibble::as_tibble()] to convert to tibbles.
#'
#' @inheritParams base::as.data.frame
#' @param x An object defined by taxa, such as [taxon] or [taxon_id]
#'
#' @examples
#' x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
#'            rank = c('species', 'genus', 'phylum', 'family'),
#'            id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
#'            auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
#' as_data_frame(x)
#'
#' @export
as_data_frame <- function(x, row.names = NULL, optional = FALSE, ...,
                          stringsAsFactors = FALSE) {
  UseMethod('as_data_frame')
}

#' @export
as_data_frame.default <- function(x, row.names = NULL, optional = FALSE, ...,
                                  stringsAsFactors = FALSE) {
  as.data.frame(x, row.names = row.names, optional = optional, stringsAsFactors = stringsAsFactors, ...)
}


#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal taxon constructor
#'
#' Minimal taxon constructor for internal use. Only use when the input is known to be valid since
#' few validity checks are done.
#'
#' @param .names The names of the vector.
#' @param name The names of taxa as a [character] vector.
#' @param rank The ranks of taxa as a [taxon_rank] vector.
#' @param id The ids of taxa as a [taxon_id] vector.
#' @param auth The authority of the taxon as a [taxon_authority] vector.
#'
#' @return An `S3` object of class `taxa_taxon`
#'
#' @keywords internal
new_taxon <- function(.names = NULL, name = character(), rank = taxon_rank(), id = taxon_id(), auth = taxon_authority(), ...) {

  # Set names to NA if not set
  if (is.null(names) || all(is.na(.names))) {
    .names_set <- FALSE
    .names <- vctrs::vec_recycle(NA_character_, length(name))
  } else {
    .names_set <- TRUE
    vctrs::vec_assert(.names, ptype = character())
  }

  # Check that values are the correct type
  vctrs::vec_assert(name, ptype = character())
  # vctrs::vec_assert(rank, ptype = taxon_rank())
  vctrs::vec_assert(id, ptype = taxon_id())
  vctrs::vec_assert(auth, ptype = taxon_authority())

  # Create new object
  vctrs::new_rcrd(list(.names = .names, name = name, rank = rank, id = id, auth = auth),
                  .names_set = .names_set,
                  ...,
                  class = "taxa_taxon")
}


#' Taxon class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("maturing")}
#' Used to store information about taxa, such as names, ranks, and IDs.
#'
#' @param name The names of taxa. Inputs with be coerced into a [character] vector if anything else
#'   is given.
#' @param rank The ranks of taxa. Inputs with be coerced into a [taxon_rank] vector if anything else
#'   is given.
#' @param id The ids of taxa. These should be unique identifier and are usually associated with a
#'   database. Inputs with be coerced into a [taxon_id] vector if anything else is given.
#' @param auth The authority of the taxon. Inputs with be coerced into a [taxon_authority] vector if
#'   anything else is given.
#' @param .names The names of the vector.
#' @param ... Additional arguments.
#'
#' @return An `S3` object of class `taxa_taxon`
#' @family classes
#'
#' @examples
#'
#' # Create taxon name vector
#' x <- taxon(c('A', 'B', 'C'))
#' x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
#'            rank = c('species', 'genus', 'phylum', 'family'),
#'            id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
#'            auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
#' names(x) <- c('a', 'b', 'c', 'd')
#'
#' # Get parts of the taxon name vector
#' tax_name(x)
#' tax_rank(x)
#' tax_id(x)
#' tax_db(x)
#' tax_auth(x)
#' tax_author(x)
#' tax_date(x)
#' tax_cite(x)
#'
#' # Set parts of the taxon name vector
#' tax_name(x) <- tolower(tax_name(x))
#' tax_rank(x)[1] <- NA
#' tax_name(x)['b'] <- 'Billy'
#' tax_id(x) <- '9999'
#' tax_db(x) <- 'itis'
#' tax_auth(x) <- NA
#' tax_author(x)[2:3] <- c('Joe', 'Billy')
#' tax_date(x) <- c('1999', '2013', '1796', '1899')
#' tax_cite(x)[1] <- 'Linnaeus, C. (1771). Mantissa plantarum altera generum.'
#'
#' # Manipulate taxon name vectors
#' x[1:3]
#' x[tax_rank(x) > 'family']
#' x['b'] <- NA
#' x[c('c', 'd')] <- 'unknown'
#' is.na(x)
#'
#' # Use as columns in tables
#' tibble::tibble(x = x, y = 1:4)
#' data.frame(x = x, y = 1:4)
#'
#' # Converting to tables
#' tibble::as_tibble(x)
#' as_data_frame(x)
#'
#' @export
taxon <- function(name = character(0), rank = NA, id = NA, auth = NA, .names = NA, ...) {
  # Cast inputs to correct values
  name <- vctrs::vec_cast(name, character())
  rank <- vctrs::vec_cast(rank, taxon_rank())
  id <- vctrs::vec_cast(id, taxon_id())
  auth <- vctrs::vec_cast(auth, taxon_authority())
  .names <- vctrs::vec_cast(.names, character())

  # Recycle ranks and databases to common length
  recycled <- vctrs::vec_recycle_common(name, rank, id, auth, .names)
  name <- recycled[[1]]
  rank <- recycled[[2]]
  id <- recycled[[3]]
  auth <- recycled[[4]]
  .names <- recycled[[5]]

  # Create taxon object
  new_taxon(.names = .names, name = name, rank = rank, id = id, auth = auth, ...)
}


#' Taxon class
#'
#' Taxon class. See [taxon] for more information
#'
#' @name taxa_taxon-class
#' @aliases taxa_taxon
#' @rdname taxa_taxon
#' @importFrom methods setOldClass
#' @exportClass taxa_taxon
setOldClass(c("taxa_taxon", "vctrs_vctr"))



#--------------------------------------------------------------------------------
# S3 getters/setters
#--------------------------------------------------------------------------------

#' @rdname tax_id
#' @export
tax_id.taxa_taxon <- function(x) {
  named_field(x, "id")
}

#' @rdname tax_id
#' @export
`tax_id<-.taxa_taxon` <- function(x, value) {
  value <- vctrs::vec_cast(value, taxon_id())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "id") <- unname(value)
  return(x)
}



#' @rdname tax_db
#' @export
tax_db.taxa_taxon <- function(x) {
  tax_db(tax_id(x))
}

#' @rdname tax_db
#' @export
`tax_db<-.taxa_taxon` <- function(x, value) {
  tax_db(tax_id(x)) <- value
  return(x)
}



#' @rdname tax_author
#' @export
tax_author.taxa_taxon <- function(x) {
  tax_author(tax_auth(x))
}

#' @rdname tax_author
#' @export
`tax_author<-.taxa_taxon` <- function(x, value) {
  tax_author(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_date
#' @export
tax_date.taxa_taxon <- function(x) {
  tax_date(tax_auth(x))
}

#' @rdname tax_date
#' @export
`tax_date<-.taxa_taxon` <- function(x, value) {
  tax_date(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_cite
#' @export
tax_cite.taxa_taxon <- function(x) {
  tax_cite(tax_auth(x))
}

#' @rdname tax_cite
#' @export
`tax_cite<-.taxa_taxon` <- function(x, value) {
  tax_cite(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_name
#' @export
tax_name.taxa_taxon <- function(x) {
  named_field(x, "name")
}

#' @rdname tax_name
#' @export
`tax_name<-.taxa_taxon` <- function(x, value) {
  value <- vctrs::vec_cast(value, character())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "name") <- unname(value)
  return(x)
}



#' @rdname tax_auth
#' @export
tax_auth.taxa_taxon <- function(x) {
  named_field(x, "auth")
}

#' @rdname tax_auth
#' @export
`tax_auth<-.taxa_taxon` <- function(x, value) {
  value <- vctrs::vec_cast(value, taxon_authority())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "auth") <- unname(value)
  return(x)
}



#' @rdname tax_rank
#' @export
tax_rank.taxa_taxon <- function(x) {
  named_field(x, "rank")
}

#' @rdname tax_rank
#' @export
`tax_rank<-.taxa_taxon` <- function(x, value) {
  value <- vctrs::vec_cast(value, taxon_rank())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "rank") <- unname(value)
  return(x)
}


#' @export
names.taxa_taxon <- function(x) {
  if (attributes(x)[['.names_set']]) {
    return(vctrs::field(x, ".names"))
  } else {
    return(NULL)
  }
}

#' @export
`names<-.taxa_taxon` <- function(x, value) {
  if (is.null(value)) {
    value = NA_character_
    attr(x, '.names_set') <- FALSE
  } else {
    attr(x, '.names_set') <- TRUE
  }
  value <- vctrs::vec_cast(value, character())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, ".names") <- unname(value)
  return(x)
}


#' @export
`[<-.taxa_taxon` <- function(x, i, j, value) {
  # If value can be cast to taxon with rank info, then update ranks
  if (is_taxon(value)) {
    tax_rank(x)[i] <- tax_rank(value)
  }

  # NOTE: This is a hack to make a vctrs rcrd class work with names.
  #   At the time of writing, names are not supported.
  #   It should be unnecessary eventually
  i_original <- i
  names_original <- names(x)
  if (is.character(i)) {
    i_temp <- rep(0, length(i))
    i_temp[i %in% names(x)] <- match(i[i %in% names(x)], names(x))
    i_temp[! i %in% names(x)] <- length(x) + seq_len(sum(! i %in% names(x)))
    i <- i_temp
  }
  x <- NextMethod()
  if (is.character(i_original)) {
    names(x)[i] <- i_original
  } else {
    names(x)[i] <- names_original[i]
  }
  return(x)
}


#' @export
`[[.taxa_taxon` <- function(x, i, j) {
  # NOTE: This is a hack to make a vctrs rcrd class work with names.
  #   At the time of writing, names are not supported.
  #   It should be unnecessary eventually
  if (length(i) > 1) {
    stop('attempt to select more than one element')
  }
  return(unname(unname_fields(x[i])))
}


#' @export
`[[<-.taxa_taxon` <- function(x, i, j, value) {
  # NOTE: This is a hack to make a vctrs rcrd class work with names.
  #   At the time of writing, names are not supported.
  #   It should be unnecessary eventually
  if (length(i) > 1) {
    stop('attempt to select more than one element')
  }
  x[i] <- value
  return(x)
}

#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------

#' Prepare taxon for printing
#'
#' Prepare taxon for printing. Makes color optional.
#'
#' @param color Use color?
#'
#' @return character
#'
#' @keywords internal
printed_taxon <- function(x, color = FALSE) {
  id <- vctrs::field(x, 'id')
  rank <- vctrs::field(x, 'rank')
  auth <- vctrs::field(x, 'auth')
  out <- font_tax_name(x)
  out <- paste0(out, ifelse(is.na(auth), '', paste0(' ', font_secondary(auth))))
  out <- paste0(ifelse(is.na(id), '', paste0(font_secondary(id), font_punct('|'))),
                out)
  out <- paste0(out, ifelse(is.na(rank), '',
                            paste0(font_punct('|'),
                                   printed_taxon_rank(rank, color = TRUE))))
  if (! color) {
    out <- crayon::strip_style(out)
  }
  if (! is.null(names(x))) {
    names(out) <- names(x)
  }
  return(out)
}


#' @rdname taxa_printing_funcs
#' @export
#' @keywords internal
format.taxa_taxon <- function(x, ...) {
  printed_taxon(x, color = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_data
#' @export
#' @keywords internal
obj_print_data.taxa_taxon <- function(x, ...) {
  # Dont print anything if nothing to print
  if (length(x) == 0) {
    return()
  }

  # Only print other info for the taxa printed for speed
  original_length <- length(x)
  truncated <- original_length > options()$max.print
  if (truncated) {
    x <- utils::head(x, options()$max.print)
  }

  # Print
  out <- printed_taxon(x, color = TRUE)
  print_with_color(out, original_length = original_length, quote = FALSE)
  invisible(x)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_footer
#' @export
#' @keywords internal
obj_print_footer.taxa_taxon <- function(x, ...) {
  # print taxon rank levels
  vctrs::obj_print_footer(vctrs::field(x, 'rank'))

  # Only print other info for the taxa printed for speed
  original_length <- length(x)
  truncated <- original_length > options()$max.print
  if (truncated) {
    x <- utils::head(x, options()$max.print)
  }

  # print databases used in ids


}

#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_taxon <- function(x, ...) {
  "taxon"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_taxon <- function(x, ...) {
  "taxon"
}


#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_taxon <- function(x, ...) {
  out <- printed_taxon(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}



#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------

#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_taxon
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_taxon <- function(x, y, ...) UseMethod("vec_ptype2.taxa_taxon", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon default
#' @export
vec_ptype2.taxa_taxon.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon vctrs_unspecified
#' @export
vec_ptype2.taxa_taxon.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon taxa_taxon
#' @export
vec_ptype2.taxa_taxon.taxa_taxon <- function(x, y, ...) new_taxon()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon character
#' @export
vec_ptype2.taxa_taxon.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_taxon
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_taxon <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon factor
#' @export
vec_ptype2.taxa_taxon.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_taxon
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_taxon <- function(x, y, ...) factor()



#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_taxon
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_taxon <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_taxon")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon default
#' @export
vec_cast.taxa_taxon.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon taxa_taxon
#' @export
vec_cast.taxa_taxon.taxa_taxon <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon character
#' @export
vec_cast.taxa_taxon.character <- function(x, to, ..., x_arg, to_arg) taxon(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_taxon
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_taxon <- function(x, to, ..., x_arg, to_arg) named_field(x, "name")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon factor
#' @export
vec_cast.taxa_taxon.factor <- function(x, to, ..., x_arg, to_arg) taxon(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_taxon
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_taxon <- function(x, to, ..., x_arg, to_arg) as.factor(named_field(x, "name"))



#--------------------------------------------------------------------------------
# S3 equality and comparison functions
#--------------------------------------------------------------------------------

#' @rdname taxa_comparison_funcs
#' @method vec_proxy_equal taxa_taxon
#' @importFrom vctrs vec_proxy_equal
#' @export
vec_proxy_equal.taxa_taxon <- function(x, ...) {
  # out <- as_data_frame(x)
  # out[] <- lapply(out, function(a_col) {
  #   a_col[is.na(a_col)] <- "*.___NA___.*" # Bit of a hack, could cause a bug if a user has the same string in their data
  #   a_col
  # })
  out <- taxon_comp_hash(x)
  return(out)
}


#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------

#' @export
c.taxa_taxon <- function(...) {
  out <- vctrs::vec_c(...)
  if (is_taxon(out)) {
    vctrs::field(out, 'rank') <- do.call(c, lapply(list(...), function(x) vctrs::field(x, 'rank')))
  }
  return(out)
}


#' Check if something is a [taxon] object
#'
#' Check if an object is of the [taxon] class
#'
#' @param x An object to test
#'
#' @examples
#' x <- taxon(c('A', 'B', 'C'))
#' is_taxon(x)
#' is_taxon(1:2)
#'
#' @export
is_taxon <- function(x) {
  inherits(x, "taxa_taxon")
}


#' @export
is.na.taxa_taxon <- function(x) {
  is.na(vctrs::field(x, 'name'))
}


#' @method %in% taxa_taxon
#' @export
`%in%.taxa_taxon` <- function(x, table) {
  UseMethod("%in%.taxa_taxon", table)
}


#' @export
`%in%.taxa_taxon.default` <- function(x, table) {
  as.character(x) %in% table
}


#' @export
`%in%.character.taxa_taxon` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
`%in%.factor.taxa_taxon` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
as_data_frame.taxa_taxon <- function(x, row.names = NULL, optional = FALSE, ...,
                                          stringsAsFactors = FALSE) {
  cbind(
    data.frame(tax_name = as.character(x), row.names = row.names, stringsAsFactors = stringsAsFactors, ...),
    as_data_frame(tax_rank(x), row.names = row.names, stringsAsFactors = stringsAsFactors, ...),
    as_data_frame(tax_id(x), row.names = row.names, stringsAsFactors = stringsAsFactors, ...),
    as_data_frame(tax_auth(x), row.names = row.names, stringsAsFactors = stringsAsFactors, ...)
  )
}


#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_taxon <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}


#' Convert to a [taxon] vector
#'
#' Convert other objects to [taxon] vectors. Compatible base R vectors can also
#' be converted using the [taxon constructor][taxon].
#'
#' @param x An object to be converted to a taxon vector
#' @param ... Additional parameters.
#'
#' @examples
#'
#' # Convert a taxonomy object to a taxon vector
#' x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'                     rank = c('order', 'family', 'genus', 'species',
#'                              'species', 'family', 'genus', 'species'),
#'                     id = taxon_id(c('33554', '9681', '9688', '9689',
#'                                     '9694', '9632', '9639', '9644'),
#'                                   db = 'ncbi'),
#'                     auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
#'                              'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' names(x) <- letters[1:8]
#' as_taxon(x)
#'
#' # Convert base R vectors
#' as_taxon(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo'))
#' as_taxon(factor(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo')))
#'
#' @export
as_taxon <- function(x, ...) {
  UseMethod('as_taxon')
}

#' @export
as_taxon.default <-  function(x, ...) {
  taxon(x)
}

#' @export
as_taxon.taxa_taxon <- function(x, ...) {
  x
}

#' @export
as_taxon.taxa_taxonomy <- function(x, ...) {
  vctrs::field(x, 'taxa')
}


#' @export
c.taxa_taxon <- function(...) {
  out <- vctrs::vec_c(...)
  if (is_taxon(out)) {
    attr(tax_rank(out), 'levels') <- do.call(c, lapply(list(...), function(x) attr(tax_rank(x), 'levels')))
  }
  return(out)
}

#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------


#' @keywords internal
taxon_comp_hash <- function(x) {
  paste0('N: ', tax_name(x), '; ',
         'I: ', tax_id(x), '; ',
         'D: ', tax_db(x), '; ',
         'R: ', tax_rank(x), '; ',
         'A: ', tax_auth(x), '; ',
         'C: ', tax_cite(x), ';')
}

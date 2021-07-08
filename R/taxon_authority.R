#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal taxon_authority constructor
#'
#' Minimal taxon_authority constructor for internal use. Only use when the input is known to be valid since
#' few validity checks are done.
#'
#' @param .names The names of the vector.
#' @param author Zero or more author names.
#' @param date Zero or more dates.
#' @param citation Zero or more literature citations.
#'
#' @return An `S3` object of class `taxa_taxon_authority`
#'
#' @keywords internal
new_taxon_authority <- function(.names = NULL, author = character(), date = character(), citation = character()) {
  # Set names to NA if not set
  if (is.null(names) || all(is.na(.names))) {
    .names_set <- FALSE
    .names <- vctrs::vec_recycle(NA_character_, length(author))
  } else {
    .names_set <- TRUE
    vctrs::vec_assert(.names, ptype = character())
  }
  vctrs::vec_assert(author, ptype = character())
  vctrs::vec_assert(date, ptype = character())
  vctrs::vec_assert(citation, ptype = character())

  vctrs::new_rcrd(list(.names = .names, author = author, date = date, citation = citation),
                  .names_set = .names_set,
                  class = "taxa_taxon_authority")
}


#' Taxon authority class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("maturing")} Used to store information on taxon authorities, such as author names, date, and citation.
#'
#' @param author Zero or more author names.
#' @param date Zero or more dates.
#' @param citation Zero or more literature citations.
#' @param extract_date If `TRUE` (the default), then if a date is detected in the `author` input and
#'   no `date` input is given, then the date is separated from the author input.
#' @param .names The names of the vector.
#'
#' @return An `S3` object of class `taxa_taxon_authority`
#' @family classes
#'
#' @examples
#'
#' # Making new objects
#' x <- taxon_authority(c('A', 'B', 'C'))
#' x <- taxon_authority(c('Cham. & Schldl.', 'L.'),
#'                      date = c('1827', '1753'))
#'
#' # Manipulating objects
#' as.character(x)
#' x[2]
#' x[2] <- 'ABC'
#' names(x) <- c('a', 'b')
#' x['b'] <- 'David Bowie'
#' tax_author(x)[1] <- tolower(tax_author(x)[1])
#' tax_author(x)
#' tax_date(x) <- c('2000', '1234')
#' tax_date(x)
#' tax_cite(x)[2] <- c('Linnaeus, C. (1771). Mantissa plantarum altera generum.')
#' tax_cite(x)
#'
#' # Using as columns in tables
#' tibble::tibble(x = x, y = 1:2)
#' data.frame(x = x, y = 1:2)
#'
#' # Converting to tables
#' tibble::as_tibble(x)
#' as_data_frame(x)
#'
#' @export
taxon_authority <- function(author = character(), date = NA, citation = NA, .names = NA, extract_date = TRUE) {
  .names <- vctrs::vec_cast(.names, character())
  author <- vctrs::vec_cast(author, character())
  date <- vctrs::vec_cast(date, character())
  citation <- vctrs::vec_cast(citation, character())
  recycled <- vctrs::vec_recycle_common(author, date, citation, .names)
  author <- recycled[[1]]
  date <- recycled[[2]]
  citation <- recycled[[3]]
  names <- recycled[[4]]
  out <- new_taxon_authority(.names = .names, author = author, date = date, citation = citation)
  if (extract_date) {
    out <- parse_date_from_author(out)
  }
  return(out)
}

#' Taxon authority class
#'
#' Taxon authority class. See [taxon_authority] for more information
#'
#' @name taxa_taxon_authority-class
#' @aliases taxa_taxon_authority
#' @rdname taxa_taxon_authority
#' @importFrom methods setOldClass
#' @exportClass taxa_taxon_authority
setOldClass(c("taxa_taxon_authority", "vctrs_vctr"))



#--------------------------------------------------------------------------------
# S3 getters/setters
#--------------------------------------------------------------------------------


#' @rdname tax_author
#' @export
`tax_author<-.taxa_taxon_authority` <- function(x, value) {
  value <- vctrs::vec_cast(value, character())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "author") <- value
  return(x)
}

#' @rdname tax_author
#' @export
tax_author.taxa_taxon_authority <- function(x) {
  named_field(x, "author")
}



#' @rdname tax_date
#' @export
`tax_date<-.taxa_taxon_authority` <- function(x, value) {
  value <- vctrs::vec_cast(value, character())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "date") <- value
  return(x)
}

#' @rdname tax_date
#' @export
tax_date.taxa_taxon_authority <- function(x) {
  named_field(x, "date")
}



#' @rdname tax_cite
#' @export
`tax_cite<-.taxa_taxon_authority` <- function(x, value) {
  value <- vctrs::vec_cast(value, character())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, "citation") <- value
  return(x)
}

#' @rdname tax_cite
#' @export
tax_cite.taxa_taxon_authority <- function(x) {
  named_field(x, "citation")
}



#' @export
names.taxa_taxon_authority <- function(x) {
  if (attributes(x)[['.names_set']]) {
    return(vctrs::field(x, ".names"))
  } else {
    return(NULL)
  }
}

#' @export
`names<-.taxa_taxon_authority` <- function(x, value) {
  if (is.null(value)) {
    value = NA_character_
    attr(x, '.names_set') <- FALSE
  } else {
    attr(x, '.names_set') <- TRUE
  }
  value <- vctrs::vec_cast(value, character())
  value <- vctrs::vec_recycle(value, length(x))
  vctrs::field(x, ".names") <- value
  return(x)
}

#' @export
`[<-.taxa_taxon_authority` <- function(x, i, j, value) {
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
`[[<-.taxa_taxon_authority` <- function(x, i, j, value) {
  # NOTE: This is a hack to make a vctrs rcrd class work with names.
  #   At the time of writing, names are not supported.
  #   It should be unnecessary eventually
  if (length(i) > 1) {
    stop('attempt to select more than one element')
  }
  x[i] <- value
  return(x)
}


#' @export
`[[.taxa_taxon_authority` <- function(x, i, j) {
  # NOTE: This is a hack to make a vctrs rcrd class work with names.
  #   At the time of writing, names are not supported.
  #   It should be unnecessary eventually
  if (length(i) > 1) {
    stop('attempt to select more than one element')
  }
  return(unname(unname_fields(x[i])))
}


#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------

#' Prepare taxon_authority for printing
#'
#' Prepare taxon_authority for printing. Makes color optional.
#'
#' @param color Use color?
#'
#' @return character
#'
#' @keywords internal
printed_taxon_authority <- function(x, color = FALSE) {
  author <- vctrs::field(x, 'author')
  date <- vctrs::field(x, 'date')
  out <- font_na(author)
  out <- paste0(out, ifelse(is.na(date), '', paste0(' ', font_secondary(date))))
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
format.taxa_taxon_authority <- function(x, ...) {
  printed_taxon_authority(x, color = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_data
#' @export
#' @keywords internal
obj_print_data.taxa_taxon_authority <- function(x, ...) {
  if (length(x) == 0) {
    return()
  }
  out <- printed_taxon_authority(x, color = TRUE)
  print_with_color(out, quote = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_taxon_authority <- function(x, ...) {
  "tax_auth"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_taxon_authority <- function(x, ...) {
  paste0("taxon_authority")
}


#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_taxon_authority <- function(x, ...) {
  out <- printed_taxon_authority(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}



#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------

#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_taxon_authority
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_taxon_authority <- function(x, y, ...) UseMethod("vec_ptype2.taxa_taxon_authority", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_authority default
#' @export
vec_ptype2.taxa_taxon_authority.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_authority vctrs_unspecified
#' @export
vec_ptype2.taxa_taxon_authority.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_authority taxa_taxon_authority
#' @export
vec_ptype2.taxa_taxon_authority.taxa_taxon_authority <- function(x, y, ...) taxon_authority()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_authority character
#' @export
vec_ptype2.taxa_taxon_authority.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_taxon_authority
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_taxon_authority <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_authority factor
#' @export
vec_ptype2.taxa_taxon_authority.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_taxon_authority
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_taxon_authority <- function(x, y, ...) factor()



#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_taxon_authority
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_taxon_authority <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_taxon_authority")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_authority default
#' @export
vec_cast.taxa_taxon_authority.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_authority taxa_taxon_authority
#' @export
vec_cast.taxa_taxon_authority.taxa_taxon_authority <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_authority character
#' @export
vec_cast.taxa_taxon_authority.character <- function(x, to, ..., x_arg, to_arg) {
  taxon_authority(x)
}


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_taxon_authority
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_taxon_authority <- function(x, to, ..., x_arg, to_arg) {
  ifelse(is.na(x), NA_character_, printed_taxon_authority(x, color = FALSE))
}


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_authority factor
#' @export
vec_cast.taxa_taxon_authority.factor <- function(x, to, ..., x_arg, to_arg) taxon_authority(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_taxon_authority
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_taxon_authority <- function(x, to, ..., x_arg, to_arg) factor(as.character(x))


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_authority integer
#' @export
vec_cast.taxa_taxon_authority.integer <- function(x, to, ..., x_arg, to_arg) taxon_authority(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.data.frame taxa_taxon_authority
#' @importFrom vctrs vec_cast.data.frame
#' @export
vec_cast.data.frame.taxa_taxon_authority <- function(x, to, ..., x_arg, to_arg) data.frame(stringsAsFactors = FALSE,
                                                                                      author = vctrs::field(x, "author"),
                                                                                      date = vctrs::field(x, "date"))



#--------------------------------------------------------------------------------
# S3 equality and comparison functions
#--------------------------------------------------------------------------------



#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------

#' Check if is a [taxon_authority]
#'
#' Check if an object is of the [taxon_authority] class
#'
#' @param x An object to test
#'
#' @examples
#' x <- taxon_authority(c('Cham. & Schldl.', 'L.'),
#'                      date = c('1827', '1753'))
#' is_taxon_authority(x)
#' is_taxon_authority(1:3)
#'
#' @export
is_taxon_authority <- function(x) {
  inherits(x, "taxa_taxon_authority")
}


#' @export
is.na.taxa_taxon_authority <- function(x) {
  is.na(vctrs::field(x, "author")) & is.na(vctrs::field(x, "date"))
}


#' @method %in% taxa_taxon_authority
#' @export
`%in%.taxa_taxon_authority` <- function(x, table) {
  UseMethod("%in%.taxa_taxon_authority", table)
}


#' @export
`%in%.taxa_taxon_authority.default` <- function(x, table) {
  as.character(x) %in% table
}


#' @export
`%in%.character.taxa_taxon_authority` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
`%in%.factor.taxa_taxon_authority` <- function(x, table) {
  x %in% as.character(table)
}

#' @export
as_data_frame.taxa_taxon_authority <- function(x, row.names = NULL, optional = FALSE, ...,
                                               stringsAsFactors = default.stringsAsFactors()) {
  data.frame(tax_author = tax_author(x),
             tax_date = tax_date(x),
             tax_cite = tax_cite(x),
             row.names = row.names, stringsAsFactors = stringsAsFactors, ...)

}

#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_taxon_authority <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}


#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------

#' @keywords internal
parse_date_from_author <- function(x) {
  parts <- stringr::str_match(tax_author(x), '^(.+?),? *([0-9]{4}) *$')
  to_replace <- unname(stats::complete.cases(parts) & is.na(tax_date(x)))
  tax_author(x)[to_replace] <- parts[to_replace, 2]
  tax_date(x)[to_replace] <- parts[to_replace, 3]
  return(x)
}

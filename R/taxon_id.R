#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal taxon_id constructor
#'
#' Minimal taxon_id constructor for internal use. Only use when the input is known to be valid since
#' few validity checks are done.
#'
#' @param id Zero or more taxonomic ids. Inputs will be transformed to a `character` vector.
#' @param db The name(s) of the database(s) associated with the IDs. If not `NA` (the
#'   default), the input must consist of names of databases in [database_ref]. The length must be
#'   0, 1, or equal to the number of IDs.
#' @param .names The names to apply to the vector
#'
#' @return An `S3` object of class `taxa_taxon_id`
#'
#' @keywords internal
new_taxon_id <- function(.names = NULL, id = character(), db = taxon_db()) {
  if (is.null(names) || all(is.na(.names))) {
    .names_set <- FALSE
    .names <- vctrs::vec_recycle(NA_character_, length(id))
  } else {
    .names_set <- TRUE
    vctrs::vec_assert(.names, ptype = character())
  }
  vctrs::vec_assert(id, ptype = character())
  vctrs::vec_assert(db, ptype = taxon_db())

  vctrs::new_rcrd(list(.names = .names, id = id, db = db), .names_set = .names_set,
                  class = "taxa_taxon_id")
}


#' Taxon ID class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("maturing")}
#' Used to store the ID corresponding to taxa, either arbitrary or from a
#' particular taxonomy database. This is typically used to store taxon IDs in
#' [taxon] objects.
#'
#' @param id Zero or more taxonomic ids. Inputs will be transformed to a [character] vector if
#'   possible.
#' @param db The name(s) of the database(s) associated with the IDs. If not `NA` (the default), the
#'   input must consist of names of databases in [db_ref$get()][db_ref].
#' @param .names The names that will be applied to the vector.
#'
#' @return An `S3` object of class `taxa_taxon_id`
#' @family classes
#'
#' @examples
#'
#' # Making new objects
#' x <- taxon_id(c('A', 'B', 'C'))
#' x <- taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi')
#' x <- taxon_id(c('9606', '1386', '4890', '4345'),
#'               db = c('ncbi', 'ncbi', 'itis', 'itis'))
#' names(x) <- c('a', 'b', 'c', 'd')
#'
#' # Manipulating objects
#' as.character(x)
#' x[2:3]
#' x[2:3] <- 'ABC'
#' x[c('a', 'c')] <- '123'
#' x[['b']] <- taxon_id('123423', db = 'ncbi')
#' tax_db(x)
#' tax_db(x) <- 'nbn'
#' c(x, x)
#'
#' # Using as columns in tables
#' tibble::tibble(x = x, y = 1:4)
#' data.frame(x = x, y = 1:4)
#'
#' # Convert to tables
#' tibble::as_tibble(x)
#' as_data_frame(x)
#'
#' # Trying to use an invalid ID with a specified database causes an error
#' #taxon_id('NOLETTERS', db = 'ncbi')
#'
#' @export
taxon_id <- function(id = character(), db = NA, .names = NULL) {
  if (is.null(.names)) {
    .names <- NA_character_
  }
  .names <- vctrs::vec_cast(.names, character())
  id <- vctrs::vec_cast(id, character())
  db <- vctrs::vec_cast(db, taxon_db())
  recycled <- vctrs::vec_recycle_common(id, db, .names)
  id <- recycled[[1]]
  db <- recycled[[2]]
  .names <- recycled[[3]]
  validate_id_for_database(id, db)
  new_taxon_id(.names = .names, id = id, db = db)
}


#' Taxon ID class
#'
#' Taxon ID class. See [taxon_id] for more information
#'
#' @name taxa_taxon_id-class
#' @aliases taxa_taxon_id
#' @rdname taxa_taxon_id
#' @importFrom methods setOldClass
#' @exportClass taxa_taxon_id
setOldClass(c("taxa_taxon_id", "vctrs_vctr"))



#--------------------------------------------------------------------------------
# S3 getters/setters
#--------------------------------------------------------------------------------

#' @rdname tax_db
#' @export
tax_db.taxa_taxon_id <- function(x) {
  named_field(x, "db")
}

#' @rdname tax_db
#' @export
`tax_db<-.taxa_taxon_id` <- function(x, value) {
  value <- vctrs::vec_cast(value, taxon_db())
  value <- vctrs::vec_recycle(value, length(x))

  vctrs::field(x, "db") <- value

  return(x)
}



#' @export
names.taxa_taxon_id <- function(x) {
  if (attributes(x)[['.names_set']]) {
    return(vctrs::field(x, ".names"))
  } else {
    return(NULL)
  }
}

#' @export
`names<-.taxa_taxon_id` <- function(x, value) {
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
`[<-.taxa_taxon_id` <- function(x, i, j, value) {
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
`[[<-.taxa_taxon_id` <- function(x, i, j, value) {
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
`[[.taxa_taxon_id` <- function(x, i, j) {
  # NOTE: This is a hack to make a vctrs rcrd class work with names.
  #   At the time of writing, names are not supported.
  #   It should be unnecessary eventually
  if (length(i) > 1) {
    stop('attempt to select more than one element')
  }
  return(unname(x[i]))
}


#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------

#' Prepare taxon_id for printing
#'
#' Prepare taxon_id for printing. Makes color optional.
#'
#' @param color Use color?
#'
#' @return character
#'
#' @keywords internal
printed_taxon_id <- function(x, color = FALSE) {
  out <- vctrs::field(x, 'id')
  db <- vctrs::field(x, 'db')
  out <- font_na(out)
  out <- paste0(out, ifelse(is.na(db), '', font_secondary(paste0(' (', db, ')'))))
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
format.taxa_taxon_id <- function(x, ...) {
  printed_taxon_id(x, color = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_data
#' @export
#' @keywords internal
obj_print_data.taxa_taxon_id <- function(x, ...) {
  if (length(x) == 0) {
    return()
  }
  out <- printed_taxon_id(x, color = TRUE)
  print_with_color(out, quote = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_taxon_id <- function(x, ...) {
  "tax_id"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_taxon_id <- function(x, ...) {
  paste0("taxon_id")
}


#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_taxon_id <- function(x, ...) {
  out <- printed_taxon_id(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}



#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------

#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_taxon_id
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_taxon_id <- function(x, y, ...) UseMethod("vec_ptype2.taxa_taxon_id", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_id default
#' @export
vec_ptype2.taxa_taxon_id.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_id vctrs_unspecified
#' @export
vec_ptype2.taxa_taxon_id.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_id taxa_taxon_id
#' @export
vec_ptype2.taxa_taxon_id.taxa_taxon_id <- function(x, y, ...) new_taxon_id()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_id character
#' @export
vec_ptype2.taxa_taxon_id.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_taxon_id
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_taxon_id <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_id factor
#' @export
vec_ptype2.taxa_taxon_id.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_taxon_id
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_taxon_id <- function(x, y, ...) factor()



#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_taxon_id
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_taxon_id")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_id default
#' @export
vec_cast.taxa_taxon_id.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_id taxa_taxon_id
#' @export
vec_cast.taxa_taxon_id.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_id character
#' @export
vec_cast.taxa_taxon_id.character <- function(x, to, ..., x_arg, to_arg) taxon_id(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_taxon_id
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) vctrs::field(x, "id")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_id factor
#' @export
vec_cast.taxa_taxon_id.factor <- function(x, to, ..., x_arg, to_arg) taxon_id(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_taxon_id
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) factor(vctrs::field(x, "id"))


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_id integer
#' @export
vec_cast.taxa_taxon_id.integer <- function(x, to, ..., x_arg, to_arg) taxon_id(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.integer taxa_taxon_id
#' @importFrom vctrs vec_cast.integer
#' @export
vec_cast.integer.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) integer(vctrs::field(x, "id"))


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_id double
#' @export
vec_cast.taxa_taxon_id.double <- function(x, to, ..., x_arg, to_arg) taxon_id(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.double taxa_taxon_id
#' @importFrom vctrs vec_cast.double
#' @export
vec_cast.double.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) double(vctrs::field(x, "id"))


#' @rdname taxa_casting_funcs
#' @method vec_cast.data.frame taxa_taxon_id
#' @importFrom vctrs vec_cast.data.frame
#' @export
vec_cast.data.frame.taxa_taxon_id <- function(x, to, ..., x_arg, to_arg) data.frame(stringsAsFactors = FALSE,
                                                                                    id = vctrs::field(x, "id"),
                                                                                    db = vctrs::field(x, "db"))



#--------------------------------------------------------------------------------
# S3 equality and comparison functions
#--------------------------------------------------------------------------------


#' @rdname taxa_comparison_funcs
#' @importFrom vctrs vec_proxy_equal
#' @export
#' @keywords internal
vec_proxy_equal.taxa_taxon_id <- function(x, ...) {
  db <- as.character(tax_db(x))
  db[is.na(db)] <- "NA" # avoids NA comparisons always being NA
  data.frame(id = as.character(x),
             db = db,
             stringsAsFactors = FALSE)
}



#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------

#' Check if something is a [taxon_id] object
#'
#' Check if an object is of the [taxon_id] class
#'
#' @param x An object to test
#'
#' @examples
#' x <- taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi')
#' is_taxon_id(x)
#' is_taxon_id(1:3)
#'
#' @export
is_taxon_id <- function(x) {
  inherits(x, "taxa_taxon_id")
}


#' @export
is.na.taxa_taxon_id <- function(x) {
  is.na(vctrs::vec_cast(x, character()))
}


#' @method %in% taxa_taxon_id
#' @export
`%in%.taxa_taxon_id` <- function(x, table) {
  UseMethod("%in%.taxa_taxon_id", table)
}


#' @export
`%in%.taxa_taxon_id.default` <- function(x, table) {
  as.character(x) %in% table
}


#' @export
`%in%.character.taxa_taxon_id` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
`%in%.factor.taxa_taxon_id` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
as_data_frame.taxa_taxon_id <- function(x, row.names = NULL, optional = FALSE, ...,
                                        stringsAsFactors = FALSE) {
  cbind(
    data.frame(tax_id = as.character(x), row.names = row.names, stringsAsFactors = stringsAsFactors, ...),
    as_data_frame(tax_db(x), row.names = row.names, stringsAsFactors = stringsAsFactors, ...)
  )
}


#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_taxon_id <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}


#' @export
as.character.taxa_taxon_id <- function(x, ...) {
  out <- NextMethod()
  names(out) <- names(x)
  return(out)
}



#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------

#' @keywords internal
validate_id_for_database <- function(id, db) {
  is_invalid <- ! is_valid_database_id(id, db)
  if (sum(is_invalid, na.rm = TRUE) > 0) {
    stop(call. = FALSE, 'Taxon IDs must follow the database ID conventions if a database with a defined ID regex is specified. ',
         'The following IDs do not match the pattern for their database:\n',
         limited_print(paste0(id[is_invalid], ' (', db[is_invalid], ')'), type = 'silent', prefix = '  '))
  }
}


#' @keywords internal
is_valid_database_id <- function(id, db) {
  mapply(function(i, r) {
    grepl(i, pattern = r) | is.na(i)
  }, i = id, r = db_ref$get(value = 'id_regex')[db])
}
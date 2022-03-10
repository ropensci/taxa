#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal taxon_db constructor
#'
#' Minimal taxon_db constructor for internal use. Only use when the input is known to be valid since
#' few validity checks are done.
#'
#' @param db Zero or more taxonomic database names. Should be a name contained in
#'   `names(db_ref)`. Inputs will be transformed to a `character` vector.
#' @param ... Additional arguments.
#'
#' @return An `S3` object of class `taxa_taxon_db`
#'
#' @keywords internal
new_taxon_db <- function(db = character(), ...) {
  vctrs::vec_assert(db, character())
  vctrs::new_vctr(db, ..., class = "taxa_taxon_db")
}


#' Taxon database class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("maturing")}
#' Used to store the names of taxon databases defined in [db_ref]. Primarily
#' used in other classes like [taxon_id] to define databases for each item.
#'
#' @param db Zero or more taxonomic database names. Should be a name contained in
#'   [db_ref]. Inputs will be transformed to a [character] vector if possible.
#' @param .names The names of the vector.
#' @param ... Additional arguments.
#'
#' @return An `S3` object of class `taxa_taxon_db`
#'
#' @family classes
#'
#' @examples
#'
#' # Making new objects
#' x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
#' x
#'
#' # Manipulating objects
#' as.character(x)
#' x[2:3]
#' x[2:3] <- 'nbn'
#' names(x) <- c('a', 'b', 'c')
#' x['b']
#' x['b'] <- 'nbn'
#' x[x == 'itis'] <- 'gbif'
#'
#' # Using as columns in tables
#' tibble::tibble(x = x, y = 1:3)
#' data.frame(x = x, y = 1:3)
#'
#' # Converting to tables
#' tibble::as_tibble(x)
#' as_data_frame(x)
#'
#' # Trying to use an invalid database generates an error
#' # x <- taxon_db(c('ncbi', 'ncbi', 'my_custom_db'))
#' # x[x == 'itis'] <- 'my_custom_db'
#'
#' # Listing known databases and their properties
#' db_ref$get()
#'
#' # Adding and using a new database
#' db_ref$set(name = 'my_custom_db', desc = 'I just made this up')
#' db_ref$get()
#' x <- taxon_db(c('ncbi', 'ncbi', 'my_custom_db'))
#'
#' @export
taxon_db <- function(db = character(), .names = NULL, ...) {
  # Make input lower case character
  db <- vctrs::vec_cast(db, character())
  db <- tolower(db)

  # Recycle input and names to common length
  recycled <- vctrs::vec_recycle_common(db, .names)
  db <- recycled[[1]]
  .names <- recycled[[2]]

  # Create taxon_db object
  validate_db_names(db)
  out <- new_taxon_db(db, ...)

  # Add names if needed
  if (! is.null(.names)) {
    names(out) <- .names
  }

  return(out)
}


#' Taxon database class
#'
#' Taxon database class. See [taxon_db] for more information
#'
#' @name taxa_taxon_db-class
#' @aliases taxa_taxon_db
#' @rdname taxa_taxon_db
#' @importFrom methods setOldClass
#' @exportClass taxa_taxon_db
setOldClass(c("taxa_taxon_db", "vctrs_vctr"))


#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------

#' @rdname taxa_printing_funcs
#' @keywords internal
#' @export
format.taxa_taxon_db <- function(x, ...) {
  out <- formatC(vctrs::vec_data(x))
  out
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @keywords internal
#' @export
vec_ptype_abbr.taxa_taxon_db <- function(x, ...) {
  "tax_db"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @keywords internal
#' @export
vec_ptype_full.taxa_taxon_db <- function(x, ...) {
  paste0("taxon_db")
}



#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------

#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_taxon_db
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_taxon_db <- function(x, y, ...) UseMethod("vec_ptype2.taxa_taxon_db", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_db default
#' @keywords internal
#' @export
vec_ptype2.taxa_taxon_db.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_db vctrs_unspecified
#' @keywords internal
#' @export
vec_ptype2.taxa_taxon_db.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_db taxa_taxon_db
#' @keywords internal
#' @export
vec_ptype2.taxa_taxon_db.taxa_taxon_db <- function(x, y, ...) new_taxon_db()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_db character
#' @keywords internal
#' @export
vec_ptype2.taxa_taxon_db.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_taxon_db
#' @importFrom vctrs vec_ptype2.character
#' @keywords internal
#' @export
vec_ptype2.character.taxa_taxon_db <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_db factor
#' @keywords internal
#' @export
vec_ptype2.taxa_taxon_db.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_taxon_db
#' @importFrom vctrs vec_ptype2.factor
#' @keywords internal
#' @export
vec_ptype2.factor.taxa_taxon_db <- function(x, y, ...) factor()


#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_taxon_db
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_taxon_db <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_taxon_db")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_db default
#' @export
vec_cast.taxa_taxon_db.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_db taxa_taxon_db
#' @export
vec_cast.taxa_taxon_db.taxa_taxon_db <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_db character
#' @export
vec_cast.taxa_taxon_db.character <- function(x, to, ..., x_arg, to_arg) taxon_db(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_taxon_db
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_taxon_db <- function(x, to, ..., x_arg, to_arg) vctrs::vec_data(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_db factor
#' @export
vec_cast.taxa_taxon_db.factor <- function(x, to, ..., x_arg, to_arg) taxon_db(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_taxon_db
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_taxon_db <- function(x, to, ..., x_arg, to_arg) factor(vctrs::vec_data(x))



#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------


#' Check if something is a [taxon_db]
#'
#' Check if an object is of the [taxon_db] class
#'
#' @param x An object to test
#'
#' @examples
#' x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
#' is_taxon_db(x)
#' is_taxon_db(1:3)
#'
#' @export
is_taxon_db <- function(x) {
  inherits(x, "taxa_taxon_db")
}


#' @export
is.na.taxa_taxon_db <- function(x) {
  is.na(vctrs::vec_cast(x, character()))
}


#' @method %in% taxa_taxon_db
#' @export
`%in%.taxa_taxon_db` <- function(x, table) {
  UseMethod("%in%.taxa_taxon_db", table)
}


#' @export
`%in%.taxa_taxon_db.default` <- function(x, table) {
  as.character(x) %in% table
}


#' @export
`%in%.character.taxa_taxon_db` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
`%in%.factor.taxa_taxon_db` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
as_data_frame.taxa_taxon_db <- function(x, row.names = NULL, optional = FALSE, ...,
                                        stringsAsFactors = FALSE) {
  data.frame(tax_db = as.character(x), row.names = row.names,
             stringsAsFactors = stringsAsFactors, ...)
}


#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_taxon_db <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}


#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------

#' @keywords internal
is_valid_db_name <- function(db_names) {
  db_names %in% c(db_ref$get(value = 'name'), NA)
}


#' @keywords internal
validate_db_names <- function(db_names) {
  invalid_names <- db_names[! is_valid_db_name(db_names)]
  if (length(invalid_names) > 0) {
    stop(call. = FALSE, 'Taxon database names must be defined in `db_ref`.',
         ' See `?db_ref` for help on adding new database definitions if needed.',
         ' The following names are not known databases:\n',
         limited_print(unique(invalid_names), type = "silent", prefix = "  "),
         'The following databases are defined:\n',
         limited_print(db_ref$get(value = 'name'), type = "silent", prefix = "  "))
  }
}

new_test_class <- function( x = list(), .names = NULL) {
  vctrs::new_list_of(x, character(), class = "taxa_test_class")
}


test_class <- function(x = character(0), .names = NA) {

  # Convert vector inputs to lists
  x <- as.list(x)

  # Cast inputs to correct values
  .names <- vctrs::vec_cast(.names, character())

  # Recycle to common length
  recycled <- vctrs::vec_recycle_common(x, .names)
  x <- recycled[[1]]
  .names <- recycled[[2]]

  # Create test_class object
  out <- new_test_class(x = x)
  if (!is.null(.names) && ! all(is.na(.names))) {
    names(out) <- .names
  }

  return(out)
}

setOldClass(c("taxa_test_class", "vctrs_vctr"))



#' @rdname taxa_printing_funcs
#' @export
#' @keywords internal
format.taxa_test_class <- function(x, ...) {
  print(x)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_test_class <- function(x) {
  "test_class"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_test_class <- function(x) {
  "test_class"
}


#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_test_class <- function(x, ...) {
  out <- printed_test_class(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}



#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------

#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_test_class
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_test_class <- function(x, y, ...) UseMethod("vec_ptype2.taxa_test_class", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class default
#' @export
vec_ptype2.taxa_test_class.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class vctrs_unspecified
#' @export
vec_ptype2.taxa_test_class.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class taxa_test_class
#' @export
vec_ptype2.taxa_test_class.taxa_test_class <- function(x, y, ...) test_class()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class character
#' @export
vec_ptype2.taxa_test_class.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_test_class
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_test_class <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class taxa_test_class_name
#' @export
vec_ptype2.taxa_test_class.taxa_test_class_name <- function(x, y, ...) test_class()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class_name taxa_test_class
#' @export
vec_ptype2.taxa_test_class_name.taxa_test_class <- function(x, y, ...) test_class()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_test_class factor
#' @export
vec_ptype2.taxa_test_class.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_test_class
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_test_class <- function(x, y, ...) factor()




#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------


#' Check if is a test_class
#'
#' Check if an object is the test_class class
#'
#' @param x An object to test
#'
#' @export
is_test_class <- function(x) {
  inherits(x, "taxa_test_class")
}


#' @export
is.na.taxa_test_class <- function(x) {
  is.na(tax_name(x))
}


#' @method %in% taxa_test_class
#' @export
`%in%.taxa_test_class` <- function(x, table) {
  UseMethod("%in%.taxa_test_class", table)
}


#' @export
`%in%.taxa_test_class.default` <- function(x, table) {
  vapply(x, FUN.VALUE = logical(1), function(y) {
    any(as.character(y) %in% table)
  })
}


#' @export
`%in%.character.taxa_test_class` <- function(x, table) {
  x %in% as.character(as_test_class_name(table))
}


#' @export
`%in%.factor.taxa_test_class` <- function(x, table) {
  x %in% as.character(as_test_class_name(table))
}


#' @export
as.data.frame.taxa_test_class <- function(x, row.names = NULL, optional = FALSE, ...,
                                     stringsAsFactors = default.stringsAsFactors()) {
  tax_name_df <- lapply(x, as.data.frame, row.names = row.names, optional = optional,
                        stringsAsFactors = stringsAsFactors, ...)
  tax_name_i <- rep(seq_len(length(tax_name_df)), vapply(tax_name_df, nrow, numeric(1)))
  tax_name_df <- do.call(rbind, tax_name_df)
  cbind(test_class = tax_name_i, tax_name_df)
}


#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_test_class <- function(x, ...) {
  tibble::as_tibble(as.data.frame(x, stringsAsFactors = FALSE), ...)
}

#' @export
as.character.taxa_test_class <- function(x, ...) {
  tax_name(x)
}

#' @export
as_test_class <- function(x, ...) {
  UseMethod('as_test_class')
}

#' @export
as_test_class.taxa_test_class <- function(x, ...) {
  x
}

#' @export
as_test_class.taxa_test_classomy <- function(x, ...) {
  vctrs::field(x, 'taxa')
}

#' @export
as_test_class.taxa_classification <- function(x, ...) {
  as_test_class(attr(x, 'test_classomy'))[x]
}

#' @export
c.taxa_test_class <- function(...) {
  out <- vctrs::vec_c(...)
  if (is_test_class(out)) {
    attr(tax_rank(out), 'levels') <- do.call(c, lapply(list(...), function(x) attr(tax_rank(x), 'levels')))
  }
  return(out)
}


#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------

#' Get a value from test_class_name in test_class
#'
#' Get a value from test_class_name in test_class
#'
#' @param simplify If TRUE, the return a vector composed of the first item in each test_class. Otherwise,
#'   a list will all data is returned.
#'
#' @keywords internal
get_test_class_field <- function(x, i, simplify = TRUE) {
  out <- get_field_in_list(x, i)
  if (simplify) {
    out <- get_first_of_each(out)
  }
  return(out)
}

#' @keywords internal
get_first_of_each <- function(a_list) {
  do.call(c, lapply(a_list, function(x) {
    x[1]
  }))
}

#' @keywords internal
get_field_in_list <- function(list_vctr, id) {
  lapply(list_vctr, vctrs::field, i = id)
}


#' @keywords internal
set_first_of_each <- function(a_list, setter, value) {
  new_test_class(taxa = lapply(seq_len(length(a_list)), function(i) {
    a_list[[i]][1] <- setter(a_list[[i]][1], value[[i]])
    a_list[[i]]
  }))
}

library(vctrs)
x <- test_class(letters[1:3])
names(x) <- LETTERS[1:3]
x
x["A"]
x["A"] <- new_test_class(list("a"))


library(stringr)
new_example <- function(x = list()) {
  if (vec_is(x, character())) {
    x <- str_split(x, " ")
  }
  new_list_of(x,
              ptype = character(),
              class = "example")
}

b <- new_example(c("a b", "c e"))
class(b)
#> [1] "example"       "vctrs_list_of" "vctrs_vctr"
b[[2]] <- new_example("c d")

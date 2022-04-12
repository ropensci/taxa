#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal taxon_rank constructor
#'
#' Minimal taxon_rank constructor for internal use. Only use when the input is
#' known to be valid since few validity checks are done.
#'
#' @param rank Zero or more taxonomic rank names. Inputs will be transformed to
#'   a `character` vector.
#' @param levels A named numeric vector indicating the names and orders of
#'   possible taxonomic ranks. Higher numbers indicate for fine-scale groupings.
#'   Ranks of unknown order can be indicated with `NA` instead of a number.
#'
#' @return An `S3` object of class `taxa_taxon_rank`
#'
#' @keywords internal
new_taxon_rank <- function(rank = character(), levels = taxon_rank_level()) {
  # Check that values are the correct type
  vctrs::vec_assert(rank, ptype = character())
  vctrs::vec_assert(levels, ptype = taxon_rank_level())

  # Create new object
  vctrs::new_vctr(rank, levels = levels, class = "taxa_taxon_rank")
}


#' Taxon rank class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("maturing")}
#' Used to store taxon ranks, possibly associated with a taxonomy database. This is typically used to
#' store taxon ranks in [taxon] objects.
#'
#' @param rank Zero or more taxonomic rank names. Inputs will be transformed to a [character]
#'   vector.
#' @param .names The names of the vector
#' @param levels A named numeric vector indicating the names and orders of possible taxonomic ranks.
#'   Higher numbers indicate for fine-scale groupings. Ranks of unknown order can be indicated with
#'   `NA` instead of a number.
#' @param guess_order If `TRUE` and no rank order is given using numbers, try to guess order based
#'   on rank names.
#'
#' @return An `S3` object of class `taxa_taxon_rank`
#' @family classes
#'
#' @examples
#'
#' # Making new objects
#' x <- taxon_rank(c('species', 'species', 'phylum', 'family'))
#'
#' # Specifiying level order
#' taxon_rank(c('A', 'B', 'C', 'D', 'A', 'D', 'D'),
#'            levels = c('D', 'C', 'B', 'A'))
#' taxon_rank(c('A', 'B', 'C', 'D', 'A', 'D', 'D'),
#'            levels = c(D = NA, A = 10, B = 20, C = 30))
#' names(x) <- c('a', 'b', 'c', 'd')
#'
#' # Manipulating objects
#' as.character(x)
#' as.factor(x)
#' as.ordered(x)
#' x[2:3]
#' x[x > 'family'] <- taxon_rank('unknown')
#' x[1] <- taxon_rank('order')
#' x['b']
#' x['b'] <- 'order'
#'
#' # Using as columns in tables
#' tibble::tibble(x = x, y = 1:4)
#' data.frame(x = x, y = 1:4)
#'
#' # Converting to tables
#' tibble::as_tibble(x)
#' as_data_frame(x)

#'
#' # Trying to add an unknown level as a character causes an error
#' #x[2] <- 'superkingdom'
#'
#' # But you can add a new level using taxon_rank objects
#' x[2] <- taxon_rank('superkingdom')
#'
#' @export
taxon_rank <- function(rank = character(), .names = NULL, levels = NULL, guess_order = TRUE) {
  # Cast inputs to correct values
  rank <- vctrs::vec_cast(rank, character())

  # Create taxon levels object
  if (is.null(levels)) {
    levels <- unique(rank)
    levels <- levels[! is.na(levels)]
    levels <- taxon_rank_level(levels, guess_order = TRUE, impute_na = FALSE)
  } else {
    levels <- taxon_rank_level(levels, guess_order = guess_order, impute_na = TRUE)
  }

  # Check that all ranks are defined in levels
  validate_rank_levels(rank, levels)

  # Create taxon_rank object
  out <- new_taxon_rank(rank = rank, levels = levels)

  # Add names if needed
  if (! is.null(.names)) {
    names(out) <- .names
  }

  return(out)

}


#' Taxon rank class
#'
#' Taxon rank class. See [taxon_rank] for more information
#'
#' @name taxa_taxon_rank-class
#' @aliases taxa_taxon_rank
#' @rdname taxa_taxon_rank
#' @importFrom methods setOldClass
#' @exportClass taxa_taxon_rank
setOldClass(c("taxa_taxon_rank", "vctrs_vctr"))



#--------------------------------------------------------------------------------
# S3 getters/setters
#--------------------------------------------------------------------------------


#' @export
`levels<-.taxa_taxon_rank` <- function(x, value) {
  levels <- vctrs::vec_cast(value, taxon_rank_level())
  validate_rank_levels(rank = vctrs::field(x, 'rank'),
                       levels = levels)
  attr(x, "levels") <- levels
  return(x)
}


#' @export
levels.taxa_taxon_rank <- function(x) {
  stats::setNames(vctrs::field(attr(x, 'levels'), 'order'),
                  vctrs::field(attr(x, 'levels'), 'level'))
}


#' @export
`[<-.taxa_taxon_rank` <- function(x, i, j, value) {
  if (is_taxon_rank(value)) {
    attr(x, 'levels') <- c(attr(x, 'levels'), attr(value, 'levels'))
  } else {
    value <- vctrs::vec_cast(value, taxon_rank())
    validate_rank_levels(as.character(value), attr(x, 'levels'))
  }
  NextMethod()
}


#' @export
`[[<-.taxa_taxon_rank` <- function(x, i, j, value) {
  if (is_taxon_rank(value)) {
    attr(x, 'levels') <- c(attr(x, 'levels'), attr(value, 'levels'))
  } else {
    value <- vctrs::vec_cast(value, taxon_rank())
    validate_rank_levels(as.character(value), attr(x, 'levels'))
  }
  NextMethod()
}



#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------

#' Prepare taxon_rank for printing
#'
#' Prepare taxon_rank for printing. Makes color optional.
#'
#' @param color Use color?
#'
#' @return character
#'
#' @keywords internal
printed_taxon_rank <- function(x, color = FALSE) {
  out <- vctrs::vec_data(x)
  styles <- rank_level_color_funcs(levels(x))
  is_a_value <- ! is.na(out) & out != ""
  out[is_a_value] <- vapply(out[is_a_value], FUN.VALUE = character(1), function(r) {
    if (r %in% names(styles)) {
      styles[[r]](r)
    } else {
      crayon::red(r)
    }
  })
  out <- font_na(out)
  if (! color) {
    out <- crayon::strip_style(out)
  }
  return(out)
}


#' @rdname taxa_printing_funcs
#' @export
#' @keywords internal
format.taxa_taxon_rank <- function(x, ...) {
  printed_taxon_rank(x, color = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_data
#' @export
#' @keywords internal
obj_print_data.taxa_taxon_rank <- function(x, ...) {
  if (length(x) == 0) {
    return()
  }
  out <- printed_taxon_rank(x, color = TRUE)
  print_with_color(out, quote = FALSE)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_footer
#' @export
#' @keywords internal
obj_print_footer.taxa_taxon_rank <- function(x, ...) {
  levels <- attr(x, 'levels')
  if (length(levels) == 0) {
    return()
  }
  out <- printed_taxon_rank_level(attr(x, 'levels'), color = TRUE)
  cat(paste0('Rank levels: ', out, '\n'))
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_taxon_rank <- function(x, ...) {
  "tax_rank"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_taxon_rank <- function(x, ...) {
  paste0("taxon_rank")
}


#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_taxon_rank <- function(x, ...) {
  out <- printed_taxon_rank(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}



#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------

#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_taxon_rank
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_taxon_rank <- function(x, y, ...) UseMethod("vec_ptype2.taxa_taxon_rank", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_rank default
#' @export
vec_ptype2.taxa_taxon_rank.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_rank vctrs_unspecified
#' @export
vec_ptype2.taxa_taxon_rank.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_rank taxa_taxon_rank
#' @export
vec_ptype2.taxa_taxon_rank.taxa_taxon_rank <- function(x, y, ...) new_taxon_rank()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_rank character
#' @export
vec_ptype2.taxa_taxon_rank.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_taxon_rank
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_taxon_rank <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxon_rank factor
#' @export
vec_ptype2.taxa_taxon_rank.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_taxon_rank
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_taxon_rank <- function(x, y, ...) factor()



#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_taxon_rank
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_taxon_rank <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_taxon_rank")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_rank default
#' @export
vec_cast.taxa_taxon_rank.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_rank taxa_taxon_rank
#' @export
vec_cast.taxa_taxon_rank.taxa_taxon_rank <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_rank character
#' @export
vec_cast.taxa_taxon_rank.character <- function(x, to, ..., x_arg, to_arg) taxon_rank(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_taxon_rank
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_taxon_rank <- function(x, to, ..., x_arg, to_arg) vctrs::vec_data(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_rank factor
#' @export
vec_cast.taxa_taxon_rank.factor <- function(x, to, ..., x_arg, to_arg) taxon_rank(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_taxon_rank
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_taxon_rank <- function(x, to, ..., x_arg, to_arg) factor(vctrs::vec_data(x))


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon_rank double
#' @export
vec_cast.taxa_taxon_rank.double <- function(x, to, ..., x_arg, to_arg) taxon_rank(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.double taxa_taxon_rank
#' @importFrom vctrs vec_cast.double
#' @export
vec_cast.double.taxa_taxon_rank <- function(x, to, ..., x_arg, to_arg) as.numeric(vctrs::vec_data(x))


#' @rdname taxa_casting_funcs
#' @method vec_cast.data.frame taxa_taxon_rank
#' @importFrom vctrs vec_cast.data.frame
#' @export
vec_cast.data.frame.taxa_taxon_rank <- function(x, to, ..., x_arg, to_arg) data.frame(stringsAsFactors = FALSE,
                                                                                      rank = vctrs::vec_data(x))



#--------------------------------------------------------------------------------
# S3 equality and comparison functions
#--------------------------------------------------------------------------------

#' @rdname taxa_comparison_funcs
#' @importFrom vctrs vec_proxy_compare
#' @export
#' @keywords internal
vec_proxy_compare.taxa_taxon_rank <- function(x, ...) {
  levels(x)[as.character(x)]
}


#' @rdname taxa_comparison_funcs
#' @importFrom vctrs vec_proxy_equal
#' @export
#' @keywords internal
vec_proxy_equal.taxa_taxon_rank <- function(x, ...) {
  data.frame(rank = as.character(x),
             stringsAsFactors = FALSE)
}


#' @rdname taxa_comparison_funcs
#' @export
#' @keywords internal
Ops.taxa_taxon_rank <- function(e1, e2) {

  # Make comparisons with character vectors use the levels of the taxon_rank
  if (.Generic %in% c('>', '>=', '<', '<=')) {
    if (is.character(e1) && is_taxon_rank(e2)) {
      validate_rank_levels(e1, attr(e2, 'levels'))
      e1 <- taxon_rank(e1, levels = attr(e2, 'levels'))
    }
    if (is.character(e2) && is_taxon_rank(e1)) {
      validate_rank_levels(e2, attr(e1, 'levels'))
      e2 <- taxon_rank(e2, levels = attr(e1, 'levels'))
    }
  }

  NextMethod()
}



#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------

#' Check if something is a [taxon_rank]
#'
#' Check if an object is of the [taxon_rank] class
#'
#' @param x An object to test
#'
#' @examples
#' x <- taxon_rank(c('species', 'species', 'phylum', 'family'))
#' is_taxon_rank(x)
#' is_taxon_rank(1:3)
#'
#' @export
is_taxon_rank <- function(x) {
  inherits(x, "taxa_taxon_rank")
}


#' @export
is.na.taxa_taxon_rank <- function(x) {
  is.na(vctrs::vec_cast(x, character()))
}


#' @method %in% taxa_taxon_rank
#' @export
`%in%.taxa_taxon_rank` <- function(x, table) {
  UseMethod("%in%.taxa_taxon_rank", table)
}


#' @export
`%in%.taxa_taxon_rank.default` <- function(x, table) {
  as.character(x) %in% table
}


#' @export
`%in%.character.taxa_taxon_rank` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
`%in%.factor.taxa_taxon_rank` <- function(x, table) {
  x %in% as.character(table)
}


#' @export
as_data_frame.taxa_taxon_rank <- function(x, row.names = NULL, optional = FALSE, ...,
                                          stringsAsFactors = FALSE) {
  data.frame(tax_rank = as.character(x), row.names = row.names,
             stringsAsFactors = stringsAsFactors, ...)
}


#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_taxon_rank <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}

#' @export
c.taxa_taxon_rank <- function(...) {
  out <- NextMethod()
  if (is_taxon_rank(out)) {
    attr(out, 'levels') <- do.call(c, lapply(list(...), function(x) attr(x, 'levels')))
  }
  return(out)
}


#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------


#' @keywords internal
validate_rank_levels <- function(rank, levels) {
  not_defined <- ! is.na(rank) & rank != "" & ! rank %in% as.character(levels)
  if (sum(not_defined) > 0) {
    stop(call. = FALSE,
         'The following rank names are not in `levels`:\n',
         limited_print(type = 'silent', prefix = '  ', unique(rank[not_defined])))
  }
}


# validate_rank_dbs <- function(rank, db) {
#   db_levels <- db_ref$get(value = "rank_levels")
#   is_invalid <- vapply(seq_len(length(rank)), FUN.VALUE = logical(1), function(i) {
#     ! is.null(db[[i]]) &&
#       ! is.na(rank[i]) &&
#       ! is.null(db_levels[[db[i]]]) &&
#       ! tolower(rank[i]) %in% as.character(db_levels[[db[i]]])
#   })
#   if (sum(is_invalid) > 0) {
#     stop(call. = FALSE,
#          'Taxonomic levels must match those used by the database when both levels and database are defined. ',
#          'The following levels are not used by their assocaited database:\n',
#          limited_print(type = 'silent', prefix = '  ', unique(paste0(rank[is_invalid], ' (', db, ')'))),
#          'Type `db_ref$get(value = "rank_levels")` to see valid levels for each database.')
#   }
#
# }
#

#' Get font color for levels
#'
#' Make list of crayon style functions to print taxon rank levels in color.
#'
#' @keywords internal
rank_level_color_funcs <- function(levels) {
  lev <- sort(levels, na.last = TRUE)
  colored_lev <- unique(lev[! is.na(lev)])
  if (length(colored_lev) > 0) {
    colors <- viridisLite::viridis(length(colored_lev), begin = 0.8, end = 0.2)
  } else {
    colors <- character(0)
  }
  out <- lapply(lev, function(l) {
    if (is.na(l)) {
      return(crayon::make_style(grDevices::rgb(.5, .5, .5)))
    } else {
      crayon::make_style(colors[colored_lev == l])
    }
  })
  names(out) <- names(lev)
  return(out)
}

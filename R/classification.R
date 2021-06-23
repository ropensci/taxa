#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal classfication constructor
#'
#' Minimal classfication constructor for internal use. Only use when the input is known to be valid
#' since few validity checks are done.
#'
#' @param taxonomy A [taxonomy()] object.
#' @param instances The indexes of each instance of a taxon in the taxonomy. Can be any length.
#'
#' @return An `S3` object of class `taxa_classification`
#'
#' @keywords internal
new_classification <- function(taxonomy = taxonomy(), instances = integer()) {
  # Check that values are the correct type
  vctrs::vec_assert(instances, ptype = integer())

  # Create new object
  vctrs::new_vctr(instances, taxonomy = taxonomy,
                  class = "taxa_classification",
                  sep = '|')
}


#' Taxon class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("experimental")} Used to
#' store classifications in reference to a taxonomic tree.
#'
#' @param x One of:
#' * A list where each item represents a series of nested taxa. The contents of
#' the list can be in any form that can be converted to a [taxon] vector.
#' * The indexes/names of each instance of a taxon in a [taxonomy] object specified by the `taxonomy` option. Can
#'   be any length, but must consist of valid indexes for taxa in the `taxonomy`
#'   object.
#' @param taxonomy A [taxonomy] object. Only needed if taxon indexes are supplied as the first argument.
#' @param .names The names of the vector.
#'
#' @return An `S3` object of class `taxa_classification`
#' @family classes
#'
#' @examples
#'
#' # Create classification vector with a list
#' x <- classification(list(
#'   c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo'),
#'   c('Carnivora', 'Felidae', 'Panthera', 'Panthera tigris'),
#'   c('Carnivora', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'   c('Carnivora', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'   c('Carnivora', 'Felidae', 'Panthera', 'Panthera tigris')
#' ))
#'
#'
#' # Create classification vector with indexes and a taxonomy
#' x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
#'                     taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                                'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'                              supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)))
#'
#' x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
#'                     taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                                             'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'                                    rank = c('order', 'family', 'genus', 'species',
#'                                             'species', 'family', 'genus', 'species'),
#'                                    id = taxon_id(c('33554', '9681', '9688', '9689',
#'                                                    '9694', '9632', '9639', '9644'),
#'                                                  db = 'ncbi'),
#'                                    auth = c('Bowdich, 1821', 'Fischer, 1817',
#'                                             'Oken, 1816', 'L., 1758',
#'                                             'L., 1758', 'Fischer, 1817',
#'                                             'L., 1758', 'L., 1758')),
#'                              supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)))
#' names(x) <- letters[1:12]
#'
#'
#' # Get parts of the classification vector
#' tax_name(x)
#' tax_rank(x)
#' tax_id(x)
#' tax_db(x)
#' tax_auth(x)
#' tax_author(x)
#' tax_date(x)
#' tax_cite(x)
#'
#' # Manipulate classification vectors
#' x[1:3]
#' x[tax_rank(x) > 'family']
#' # c(x, x)
#' # x['b'] <- NA
#' is.na(x)
#' # as.data.frame(x)
#' # tibble::as_tibble(x)
#'
#' # Use as columns in tables
#' tibble::tibble(x = x, y = 1:12)
#' data.frame(x = x, y = 1:12)
#'
#' @export
classification <- function(x = NULL, taxonomy = NULL, .names = NULL) {
  # If no input, return an empty object
  if (is.null(x)) {
    return(new_classification(taxonomy(), integer(0)))
  }

  # Check user input
  if (is.numeric(x) || is.character(x)) {
    if (! is_taxonomy(taxonomy)) {
      stop(call. = FALSE, 'If `x` is a vector of indexes or names, then a taxonomy object must be supplied with the `taxonomy` option.')
    } else {
      x <- to_index(taxonomy, x)
    }
  }
  if (is.list(x) && (! is.null(taxonomy))) {
    stop(call. = FALSE, 'If `x` is a list, then the `taxonomy` option cannot be used')
  }

  # Cast inputs to correct values
  .names <- vctrs::vec_cast(.names, character())

  # Create classification object
  if (is.list(x)) {
    out <- list_to_classification(x)
  } else {
    out <- new_classification(taxonomy = taxonomy, instances = as.integer(x))
  }
  names(out) <- .names

  return(out)
}


#' @importFrom methods setOldClass
#' @exportClass taxa_taxon
setOldClass(c("taxa_classification", "vctrs_vctr"))


#--------------------------------------------------------------------------------
# S3 getters/setters
#--------------------------------------------------------------------------------

#' @rdname tax_id
#' @export
tax_id.taxa_classification <- function(x) {
  get_taxonomy_named_field(x, tax_id)
}

#' @rdname tax_id
#' @export
`tax_id<-.taxa_classification` <- function(x, value) {
  tax_id(attr(x, 'taxonomy')) <- value
  return(x)
}



#' @rdname tax_db
#' @export
tax_db.taxa_classification <- function(x) {
  tax_db(tax_id(x))
}

#' @rdname tax_db
#' @export
`tax_db<-.taxa_classification` <- function(x, value) {
  tax_db(tax_id(x)) <- value
  return(x)
}



#' @rdname tax_author
#' @export
tax_author.taxa_classification <- function(x) {
  tax_author(tax_auth(x))
}

#' @rdname tax_author
#' @export
`tax_author<-.taxa_classification` <- function(x, value) {
  tax_author(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_date
#' @export
tax_date.taxa_classification <- function(x) {
  tax_date(tax_auth(x))
}

#' @rdname tax_date
#' @export
`tax_date<-.taxa_classification` <- function(x, value) {
  tax_date(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_cite
#' @export
tax_cite.taxa_classification <- function(x) {
  tax_cite(tax_auth(x))
}

#' @rdname tax_cite
#' @export
`tax_cite<-.taxa_classification` <- function(x, value) {
  tax_cite(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_name
#' @export
tax_name.taxa_classification <- function(x) {
  get_taxonomy_named_field(x, tax_name)
}

#' @rdname tax_name
#' @export
`tax_name<-.taxa_classification` <- function(x, value) {
  tax_name(attr(x, 'taxonomy')) <- value
  return(x)
}



#' @rdname tax_auth
#' @export
tax_auth.taxa_classification <- function(x) {
  get_taxonomy_named_field(x, tax_auth)
}

#' @rdname tax_auth
#' @export
`tax_auth<-.taxa_classification` <- function(x, value) {
  tax_auth(attr(x, 'taxonomy')) <- value
  return(x)
}



#' @rdname tax_rank
#' @export
tax_rank.taxa_classification <- function(x) {
  get_taxonomy_named_field(x, tax_rank)
}

#' @rdname tax_rank
#' @export
`tax_rank<-.taxa_classification` <- function(x, value) {
  tax_rank(attr(x, 'taxonomy')) <- value
  return(x)
}


#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------


#' Prepare classification for printing
#'
#' Prepare classification for printing. Makes color optional.
#'
#' @param color Use color?
#'
#' @return character
#'
#' @keywords internal
printed_classification <- function(x, color = FALSE) {
  # Dont print anything if nothing to print
  if (length(x) == 0) {
    return(character(0))
  }

  # Make print out
  out <- vapply(supertaxa(attr(x, 'taxonomy'), include = TRUE)[x], FUN.VALUE = character(1), function(i) {
    taxa <- as.character(attr(x, 'taxonomy'))[rev(i)]
    paste(taxa, collapse = font_punct(attr(x, 'sep')))
  })

  # Disable color if needed
  if (! color) {
    out <- crayon::strip_style(out)
  }

  # Add names
  if (! is.null(names(x))) {
    names(out) <- names(x)
  }

  # Return tree
  return(out)
}

#' @rdname taxa_printing_funcs
#' @export
#' @keywords internal
format.taxa_classification <- function(x, ...) {
  out <- printed_classification(x, color = FALSE)
}

#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_data
#' @export
#' @keywords internal
obj_print_data.taxa_classification <- function(x, ...) {
  # Dont print anything if nothing to print
  if (length(x) == 0) {
    return()
  }
  out <- printed_classification(x, color = TRUE)
  print_with_color(out, quote = FALSE)
  invisible(x)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_footer
#' @export
#' @keywords internal
obj_print_footer.taxa_classification <- function(x, ...) {
  vctrs::obj_print_footer(attr(x, 'taxonomy'))
}



#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_classification <- function(x, ...) {
  "classif"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_classification <- function(x, ...) {
  "classification"
}

#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_classification <- function(x, ...) {
  out <- printed_classification(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}


#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_classification
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_classification <- function(x, y, ...) UseMethod("vec_ptype2.taxa_classification", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_classification default
#' @export
vec_ptype2.taxa_classification.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_classification vctrs_unspecified
#' @export
vec_ptype2.taxa_classification.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_classification taxa_classification
#' @export
vec_ptype2.taxa_classification.taxa_classification <- function(x, y, ...) new_classification()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_classification character
#' @export
vec_ptype2.taxa_classification.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_classification
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_classification <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_classification factor
#' @export
vec_ptype2.taxa_classification.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_classification
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_classification <- function(x, y, ...) factor()



#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_classification
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_classification <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_classification")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_classification default
#' @export
vec_cast.taxa_classification.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_classification taxa_classification
#' @export
vec_cast.taxa_classification.taxa_classification <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_classification
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_classification <- function(x, to, ..., x_arg, to_arg) as.character(format(x))


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_classification
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_classification <- function(x, to, ..., x_arg, to_arg) as.factor(format(x))

#' @rdname taxa_casting_funcs
#' @method vec_cast.integer taxa_classification
#' @importFrom vctrs vec_cast.integer
#' @export
vec_cast.integer.taxa_classification <- function(x, to, ..., x_arg, to_arg) {
  out <- unclass(x)
  attr(out, "taxonomy") <- NULL
  return(out)
}


#' @rdname taxonomy
#' @export
#' @keywords internal
`[.taxa_classification` <- function(x, ...) {

  index <- seq_len(length(x))
  names(index) <- names(x)
  subset <- index[...]

  # Subset instances
  out <- NextMethod()

  # Remove any unused taxa from the taxonomy
  attr(out, 'taxonomy') <- attr(x, 'taxonomy')[as.integer(x)[subset], supertaxa = TRUE]

  return(out)
}

#' @rdname taxonomy
#' @export
#' @keywords internal
`[[.taxa_classification` <- function(x, i) {
  must_be_length_1(i)
  unname(x[i])
}


# NOTES:
#  * everything downstream of a new taxon must be duplicated and the leaf becomes the instance index
#  * taxa are only the same if they have to same supertaxon and value
#  * could add all new parts of taxonomy, change instance indexes, and prune unsed parts of tree
#  * input values that would caused the same change should be deteceted so the same change does not happen mutliple times
#' @export
`[<-.taxa_classification` <- function(x, i = NULL, j = NULL, value) {
  # If numeric input, set instances rather than adding/replacing taxa
  if (is.numeric(value)) {
    if (! is.null(j)) {
      stop(call. = FALSE, '`j` cannot be used if the input value is a taxon index (numeric)')
    }
    return(NextMethod())
  }

  # Standardize inputs
  if (is.null(i)) {
    i <- seq_along(x)
  } else {
    i <- to_index(x, i)
  }
  if (! is.null(j) && ! is.numeric(j)) {
    stop(call. = FALSE, '`j` must be an index')
  }
  if (is.null(j)) {
    if (is.factor(value)) {
      value <- as.character(value)
    }
    if (is.character(value)) {
      value <- strsplit(value, split = attr(x, 'sep'), fixed = TRUE)
    } else {
      value <- as.list(value)
    }
  } else {
    if (is.character(value) || is.factor(value) || is_taxon(value)) {
      value <- list(value)
    }
  }

  # Recycle inputs to same length
  rec <- vctrs::vec_recycle_common(i, list(j), value)
  i = rec[[1]]
  j = rec[[2]]
  value = rec[[3]]

  # Make new taxa for each change
  new_branches <- lapply(seq_along(i), function(index) {
    if (is.null(j[[index]])) {
      return(taxon(value[[index]]))
    } else {
      class_indexes <- rev(supertaxa(attr(x, 'taxonomy'), subset = as.integer(x)[i[[index]]], include = TRUE)[[1]])
      # modified_indexes <- seq(min(j[[index]]), max(class_indexes))
      out <- vctrs::field(attr(x, 'taxonomy'), 'taxa')[class_indexes]
      out[j[[index]]] <- value[[index]]
      # return(out[modified_indexes])
      return(out)
    }
  })
  # new_branch_parents <- vapply(seq_along(i), FUN.VALUE = numeric(1),
  #                              function(index) {
  #                                class_indexes <- rev(supertaxa(attr(x, 'taxonomy'), subset = as.integer(x)[i[[index]]], include = TRUE)[[1]])
  #                                parent_index <- min(j[[index]]) - 1
  #                                if (parent_index <= 0) {
  #                                  return(NA)
  #                                } else {
  #                                  return(class_indexes[min(j[[index]]) - 1])
  #                                }
  #                              })

  # Convert replaced taxa to new classification
  new_class <- classification(new_branches)
  new_taxonomy <- c(attr(x, 'taxonomy'), attr(new_class, 'taxonomy'))

  # Adjust instance indexes
  tax_reassignment_key <- duplicated_index_taxonomy(new_taxonomy)
  tax_reassignment_key[! duplicated(tax_reassignment_key)] <- seq_len(sum(! duplicated(tax_reassignment_key)))
  new_instance_index <- tax_reassignment_key[as.integer(new_class) + length(attr(x, 'taxonomy'))]

  # Apply changes to indexes and taxonomy
  x[] <- tax_reassignment_key[as.integer(x)]
  x[i] <- new_instance_index
  attr(x, 'taxonomy') <- unique(new_taxonomy)

  # Delete any unused taxa after changes
  x <- delete_unused_class_taxa(x)

  return(x)
}


#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------

#' Check if is a classification
#'
#' Check if an object is the classification class
#'
#' @param x An object to test
#'
#' @export
is_classification <- function(x) {
  inherits(x, "taxa_classification")
}


#' @export
is_root.taxa_classification <- function(x, subset = NULL) {
  is_root(attr(x, 'taxonomy'), subset = subset)
}

#' @export
roots.taxa_classification <- function(x, subset = NULL) {
  roots(attr(x, 'taxonomy'), subset = subset)
}

#' @export
subtaxa.taxa_classification <- function(x, subset = NULL, max_depth = NULL, include = FALSE, value = NULL, ...) {
  subtaxa(attr(x, 'taxonomy'), subset = subset, max_depth = max_depth, include = include, value = value, ...)
}

#' @export
n_subtaxa.taxa_classification <- function(x, subset = NULL, max_depth = NULL, include = FALSE) {
  subtaxa(attr(x, 'taxonomy'), subset = subset, max_depth = max_depth, include = include)
}

#' @export
supertaxa.taxa_classification <- function(x, subset = NULL, max_depth = NULL, include = FALSE, value = NULL, ...) {
  supertaxa(attr(x, 'taxonomy'), subset = subset, max_depth = max_depth, include = include, value = value, ...)
}

#' @export
n_supertaxa.taxa_classification <- function(x, subset = NULL, max_depth = NULL, include = FALSE) {
  n_supertaxa(attr(x, 'taxonomy'), subset = subset, max_depth = max_depth, include = include)
}

#' @method %in% taxa_classification
#' @export
`%in%.taxa_classification` <- function(x, table) {
  UseMethod("%in%.taxa_classification", table)
}

#' @export
`%in%.taxa_classification.default` <- function(x, table) {
  as_taxon(x) %in% table
}

#' @export
`%in%.character.taxa_classification` <- function(x, table) {
  x %in% as.character(as_taxon(table))
}

#' @export
`%in%.factor.taxa_classification` <- function(x, table) {
  x %in% as.character(as_taxon(table))
}

#' @export
as_data_frame.taxa_classification <- function(x, row.names = NULL, optional = FALSE, ...,
                                              stringsAsFactors = default.stringsAsFactors()) {
  out <- as_data_frame(as_taxon(x))
  cbind(supertaxon = vctrs::field(x, 'supertaxa')[out$taxon], out)
}

#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_classification <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}

#' @export
stems.taxa_classification <- function(x, value = NULL, ...) {
  stems(attr(x, 'taxonomy'), value = value, ...)
}

#' @export
is_stem.taxa_classification <- function(x) {
  is_stem(attr(x, 'taxonomy'))
}

#' @export
leaves.taxa_classification <- function(x, value = NULL, ...) {
  leaves(attr(x, 'taxonomy'), value = value, ...)
}

#' @export
is_leaf.taxa_classification <- function(x) {
  is_leaf(attr(x, 'taxonomy'))
}

#' @export
n_leaves.taxa_classification <- function(x) {
  n_leaves(attr(x, 'taxonomy'))
}

#' @export
internodes.taxa_classification <- function(x) {
  internodes(attr(x, 'taxonomy'))
}

#' @export
is_internode.taxa_classification <- function(x) {
  is_internode(attr(x, 'taxonomy'))
}

#' @export
c.taxa_classification <- function(...) {
  input <- list(...)

  # Combine taxonomy
  tax_list <- lapply(input, function(x) attr(x, 'taxonomy'))
  combined_taxonomy <- do.call(c, tax_list)

  # Add offsets to instance indexes and combine
  tax_lengths <- vapply(tax_list, length, numeric(1))
  instance_lengths <- vapply(input, length, numeric(1))
  index_offsets <- rep(c(0, cumsum(tax_lengths)[-length(tax_lengths)]), instance_lengths)
  combined_instances <- unlist(lapply(input, as.integer)) + index_offsets

  # Remove redundant taxonomic information
  unique_indexes <- duplicated_index_taxonomy(combined_taxonomy)
  vctrs::field(combined_taxonomy, 'supertaxa') <- unique_indexes[vctrs::field(combined_taxonomy, 'supertaxa')]
  combined_taxonomy <- combined_taxonomy[unique(unique_indexes), subtaxa = FALSE]

  # Fix instance indexes after taxonomy subset
  combined_instances <- match(unique_indexes[combined_instances], unique(unique_indexes))

  # Make new classification object
  out <- classification(combined_instances,
                        taxonomy = taxonomy(vctrs::field(combined_taxonomy, 'taxa'),
                                            supertaxa = vctrs::field(combined_taxonomy, 'supertaxa')))

  return(out)
}


#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------

#' @keywords internal
attr_as_classification <- function(x, value) {
  out <- lapply(supertaxa(attr(x, 'taxonomy'))[x], function(i) {
    value[i]
  })
  names(out) <- names(x)
  return(out)
}

#' @keywords internal
get_taxonomy_named_field <- function(x, func) {
  out <- func(attr(x, 'taxonomy'))[unname(as.integer(x))]
  if (! is.null(names(x))) {
    names(out) <- names(x)
  }
  return(out)
}


#' @keywords internal
list_to_classification <- function(x) {
  # class_length <- vapply(x, length, numeric(1))
  # classification(cumsum(class_length), taxonomy = list_to_taxonomy(x))
  classes <- lapply(x, function(y) classification(length(y), taxonomy = taxonomy(y, supertaxa = c(NA, 1:(length(y) - 1)))))
  do.call(c, classes)
}

#' Removes taxa from the taxonomy of a classification that are not used by any of the instances
#'
#' @keywords internal
delete_unused_class_taxa <- function(x) {
  # Find which taxa will be preserved
  preserved <- sort(unique(unlist(supertaxa(attr(x, 'taxonomy'), subset = unique(as.integer(x)), include = TRUE))))

  # Delete any unused taxa
  attr(x, 'taxonomy') <- attr(x, 'taxonomy')[unique(as.integer(x)), supertaxa = TRUE, subtaxa = FALSE]

  # Adjust the instance indexes
  x[seq_along(x)] <- match(as.integer(x), preserved)

  return(x)
}
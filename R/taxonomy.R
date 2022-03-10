#--------------------------------------------------------------------------------
# S3 constructors
#--------------------------------------------------------------------------------

#' Minimal taxonomy constructor
#'
#' Minimal taxonomy constructor for internal use. Only use when the input is known to be valid since
#' few validity checks are done.
#'
#' @param taxa A [taxon] vector.
#' @param supertaxa The indexes of `taxa` for each taxon's supertaxon.
#'
#' @return An `S3` object of class `taxa_taxon`
#'
#' @keywords internal
new_taxonomy <- function(taxa = taxon(), supertaxa = integer()) {
  # Check that values are the correct type
  # vctrs::vec_assert(taxa, ptype = taxon())
  vctrs::vec_assert(supertaxa, ptype = integer())

  # Create new object
  vctrs::new_rcrd(list(taxa = taxa, supertaxa = supertaxa),
                  class = 'taxa_taxonomy')
}


#' Taxonomy class
#'
#' \Sexpr[results=rd, stage=render]{taxa:::lifecycle("experimental")}
#' Used to store information about a set of taxa forming a taxonomic tree.
#'
#' @param taxa A [taxon] vector or something that can be converted to a [taxon] vector.
#' @param supertaxa The indexes of `taxa` for each taxon's supertaxon.
#' @param .names The names of the vector (not the names of taxa).
#'
#' @return An `S3` object of class `taxa_taxon`
#' @family classes
#'
#' @examples
#'
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#'
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
#'
#' # Subset taxonomy vector
#' x[2] # By default, all subtaxa are included
#' x['b'] # Names can also be used
#' x[2:3, subtaxa = FALSE] # Disable subtaxa
#' x[3, supertaxa = TRUE] # include supertaxa
#' x[is_leaf(x)] # Subset by logical vector
#'
#' # Get parts of the taxonomy vector
#' tax_name(x)
#' tax_rank(x)
#' tax_id(x)
#' tax_db(x)
#' tax_auth(x)
#' tax_author(x)
#' tax_date(x)
#' tax_cite(x)
#'
#' # Set parts of the taxonomy vector
#' tax_name(x) <- tolower(tax_name(x))
#' tax_rank(x)[1] <- NA
#' tax_id(x) <- '9999'
#' tax_db(x) <- 'itis'
#' tax_auth(x) <- NA
#' tax_author(x)[2:3] <- c('Joe', 'Billy')
#' tax_date(x) <- c('1999', '2013', '1796', '1899',
#'                  '1997', '2003', '1996', '1859')
#' tax_cite(x)['c'] <- 'Linnaeus, C. (1771). Mantissa plantarum altera generum.'
#'
#' # Convert to table
#' tibble::as_tibble(x)
#' as_data_frame(x)
#'
#' # Get taxonomy attributes
#' subtaxa(x)
#' subtaxa(x, value = tax_name(x))
#' subtaxa(x, value = as_taxon(x))
#' n_subtaxa(x)
#' supertaxa(x)
#' n_supertaxa(x)
#' leaves(x)
#' n_leaves(x)
#' is_leaf(x)
#' stems(x)
#' is_stem(x)
#' roots(x)
#' is_root(x)
#' internodes(x)
#' is_internode(x)
#'
#' @export
taxonomy <- function(taxa = taxon(), supertaxa = NA, .names = NULL) {
  # Cast inputs to correct values
  if (!is_taxon(taxa)) {
    taxa <- taxon(taxa)
  }
  supertaxa <- vctrs::vec_cast(supertaxa, integer())

  # Recycle ranks and databases to common length
  recycled <- vctrs::vec_recycle_common(taxa, supertaxa)
  taxa <- recycled[[1]]
  supertaxa <- recycled[[2]]

  # Create taxon object
  out <- new_taxonomy(taxa = taxa, supertaxa = supertaxa)
  names(out) <- .names

  return(out)
}


#' Taxonomy class
#'
#' Taxonomy class. See [taxonomy] for more information
#'
#' @name taxa_taxonomy-class
#' @aliases taxa_taxonomy
#' @rdname taxa_taxonomy
#' @importFrom methods setOldClass
#' @exportClass taxa_taxonomy
setOldClass(c("taxa_taxonomy", "vctrs_vctr"))



#--------------------------------------------------------------------------------
# S3 getters/setters
#--------------------------------------------------------------------------------

#' @rdname tax_id
#' @export
tax_id.taxa_taxonomy <- function(x) {
  tax_id(vctrs::field(x, "taxa"))
}

#' @rdname tax_id
#' @export
`tax_id<-.taxa_taxonomy` <- function(x, value) {
  tax_id(vctrs::field(x, "taxa")) <- value
  return(x)
}



#' @rdname tax_db
#' @export
tax_db.taxa_taxonomy <- function(x) {
  tax_db(tax_id(x))
}

#' @rdname tax_db
#' @export
`tax_db<-.taxa_taxonomy` <- function(x, value) {
  tax_db(tax_id(x)) <- value
  return(x)
}



#' @rdname tax_author
#' @export
tax_author.taxa_taxonomy <- function(x) {
  tax_author(tax_auth(x))
}

#' @rdname tax_author
#' @export
`tax_author<-.taxa_taxonomy` <- function(x, value) {
  tax_author(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_date
#' @export
tax_date.taxa_taxonomy <- function(x) {
  tax_date(tax_auth(x))
}

#' @rdname tax_date
#' @export
`tax_date<-.taxa_taxonomy` <- function(x, value) {
  tax_date(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_cite
#' @export
tax_cite.taxa_taxonomy <- function(x) {
  tax_cite(tax_auth(x))
}

#' @rdname tax_cite
#' @export
`tax_cite<-.taxa_taxonomy` <- function(x, value) {
  tax_cite(tax_auth(x)) <- value
  return(x)
}



#' @rdname tax_name
#' @export
tax_name.taxa_taxonomy <- function(x) {
  tax_name(vctrs::field(x, "taxa"))
}

#' @rdname tax_name
#' @export
`tax_name<-.taxa_taxonomy` <- function(x, value) {
  tax_name(vctrs::field(x, "taxa")) <- value
  return(x)
}



#' @rdname tax_auth
#' @export
tax_auth.taxa_taxonomy <- function(x) {
  tax_auth(vctrs::field(x, "taxa"))
}

#' @rdname tax_auth
#' @export
`tax_auth<-.taxa_taxonomy` <- function(x, value) {
  tax_auth(vctrs::field(x, "taxa")) <- value
  return(x)
}



#' @rdname tax_rank
#' @export
tax_rank.taxa_taxonomy <- function(x) {
  tax_rank(vctrs::field(x, "taxa"))
}

#' @rdname tax_rank
#' @export
`tax_rank<-.taxa_taxonomy` <- function(x, value) {
  tax_rank(vctrs::field(x, "taxa")) <- value
  return(x)
}



#' @rdname taxonomy
#' @export
names.taxa_taxonomy <- function(x) {
  names(vctrs::field(x, "taxa"))
}

#' @rdname taxonomy
#' @export
`names<-.taxa_taxonomy` <- function(x, value) {
  names(vctrs::field(x, "taxa")) <- value
  return(x)
}


#--------------------------------------------------------------------------------
# S3 printing functions
#--------------------------------------------------------------------------------


#' Prepare taxonomy for printing
#'
#' Prepare taxonomy for printing. Makes color optional.
#'
#' @param color Use color?
#'
#' @return character
#'
#' @keywords internal
printed_taxonomy <- function(x, color = FALSE) {
  # Dont print anything if nothing to print
  if (length(x) == 0) {
    return(character(0))
  }

  # Make tree print out
  if (! is.null(names(x)) && ! all(is.na(names(x)))) {
    name_printed <- paste0(font_punct('['), names(x), font_punct(']'))
  } else {
    name_printed <- ''
  }
  tax_char <- paste0(seq_len(length(x)),
                     name_printed,
                     font_punct(': '),
                     printed_taxon(vctrs::field(x, 'taxa'), color = TRUE))
  sub_char <- unname(lapply(subtaxa(x, max_depth = 1), function(i) tax_char[i]))
  tree_data <- data.frame(stringsAsFactors = FALSE,
                          taxa = tax_char,
                          subtaxa = I(sub_char))
  out <- lapply(roots(x), function(i) cli::tree(tree_data, root = tax_char[i]))
  out <- unlist(out)

  # Disable color if needed
  if (! color) {
    out <- crayon::strip_style(out)
  }

  # Return tree
  return(out)
}

#' @rdname taxa_printing_funcs
#' @export
#' @keywords internal
format.taxa_taxonomy <- function(x, ...) {
  out <- printed_taxonomy(x, color = FALSE)
  stringr::str_pad(out, width = max(nchar(out)), side = 'right')
}

#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_data
#' @export
#' @keywords internal
obj_print_data.taxa_taxonomy <- function(x, ...) {
  # Dont print anything if nothing to print
  if (length(x) == 0) {
    return(invisible(x))
  }
  tree <- printed_taxonomy(x, color = TRUE)
  cat(tree, sep = '\n')
  invisible(x)
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs obj_print_footer
#' @export
#' @keywords internal
obj_print_footer.taxa_taxonomy <- function(x, ...) {
  vctrs::obj_print_footer(vctrs::field(x, 'taxa'))
}



#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_abbr
#' @export
#' @keywords internal
vec_ptype_abbr.taxa_taxonomy <- function(x, ...) {
  "taxonomy"
}


#' @rdname taxa_printing_funcs
#' @importFrom vctrs vec_ptype_full
#' @export
#' @keywords internal
vec_ptype_full.taxa_taxonomy <- function(x, ...) {
  "taxonomy"
}

#' @rdname taxa_printing_funcs
#' @importFrom pillar pillar_shaft
#' @export
#' @keywords internal
pillar_shaft.taxa_taxonomy <- function(x, ...) {
  out <- printed_taxonomy(x, color = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "left")
}

#--------------------------------------------------------------------------------
# S3 coercion functions
#--------------------------------------------------------------------------------


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2 taxa_taxonomy
#' @importFrom vctrs vec_ptype2
#' @export
#' @keywords internal
vec_ptype2.taxa_taxonomy <- function(x, y, ...) UseMethod("vec_ptype2.taxa_taxonomy", y)


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxonomy default
#' @export
vec_ptype2.taxa_taxonomy.default <- function(x, y, ..., x_arg = "", y_arg = "") {
  vctrs::stop_incompatible_type(x, y, x_arg = x_arg, y_arg = y_arg)
}


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxonomy vctrs_unspecified
#' @export
vec_ptype2.taxa_taxonomy.vctrs_unspecified <- function(x, y, ...) x


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxonomy taxa_taxonomy
#' @export
vec_ptype2.taxa_taxonomy.taxa_taxonomy <- function(x, y, ...) new_taxonomy()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxonomy character
#' @export
vec_ptype2.taxa_taxonomy.character <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.character taxa_taxonomy
#' @importFrom vctrs vec_ptype2.character
#' @export
vec_ptype2.character.taxa_taxonomy <- function(x, y, ...) character()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.taxa_taxonomy factor
#' @export
vec_ptype2.taxa_taxonomy.factor <- function(x, y, ...) factor()


#' @rdname taxa_coercion_funcs
#' @method vec_ptype2.factor taxa_taxonomy
#' @importFrom vctrs vec_ptype2.factor
#' @export
vec_ptype2.factor.taxa_taxonomy <- function(x, y, ...) factor()



#--------------------------------------------------------------------------------
# S3 casting functions
#--------------------------------------------------------------------------------

#' @rdname taxa_casting_funcs
#' @method vec_cast taxa_taxonomy
#' @importFrom vctrs vec_cast
#' @export
#' @keywords internal
vec_cast.taxa_taxonomy <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.taxa_taxonomy")


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxonomy default
#' @export
vec_cast.taxa_taxonomy.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxonomy taxa_taxonomy
#' @export
vec_cast.taxa_taxonomy.taxa_taxonomy <- function(x, to, ..., x_arg, to_arg) x


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxonomy character
#' @export
vec_cast.taxa_taxonomy.character <- function(x, to, ..., x_arg, to_arg) taxonomy(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.character taxa_taxonomy
#' @importFrom vctrs vec_cast.character
#' @export
vec_cast.character.taxa_taxonomy <- function(x, to, ..., x_arg, to_arg) as.character(vctrs::field(x, "taxa"))


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxonomy factor
#' @export
vec_cast.taxa_taxonomy.factor <- function(x, to, ..., x_arg, to_arg) taxonomy(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.factor taxa_taxonomy
#' @importFrom vctrs vec_cast.factor
#' @export
vec_cast.factor.taxa_taxonomy <- function(x, to, ..., x_arg, to_arg) as.factor(vctrs::field(x, "taxa"))


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxonomy taxa_taxon
#' @export
vec_cast.taxa_taxonomy.taxa_taxon <- function(x, to, ..., x_arg, to_arg) taxonomy(x)


#' @rdname taxa_casting_funcs
#' @method vec_cast.taxa_taxon taxa_taxonomy
#' @export
vec_cast.taxa_taxon.taxa_taxonomy <- function(x, to, ..., x_arg, to_arg) vctrs::field(x, "taxa")


#--------------------------------------------------------------------------------
# S3 equality and comparison functions
#--------------------------------------------------------------------------------

#' @rdname taxa_comparison_funcs
#' @method vec_proxy_equal taxa_taxonomy
#' @importFrom vctrs vec_proxy_equal
#' @export
vec_proxy_equal.taxa_taxonomy <- function(x, ...) {
  vec_proxy_equal(as_taxon(x))
}



#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------

#' Check if something is a [taxonomy]
#'
#' Check if an object is of the [taxonomy] class
#'
#' @param x An object to test
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' is_taxonomy(x)
#' is_taxonomy(1:2)
#'
#' @export
is_taxonomy <- function(x) {
  inherits(x, "taxa_taxonomy")
}


#' Test if taxa are roots
#'
#' Check if each taxon is a root. A root is a taxon with no supertaxon.
#'
#' @param x An object containing taxonomic relationships, such as [taxonomy] objects.
#' @param subset The subset of the tree to search for roots to that subset. Can be indexes or names.
#'
#' @family root functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' is_root(x)
#' is_root(x, subset = 2:8)
#'
#' @export
is_root <- function(x, subset = NULL) {
  UseMethod('is_root')
}

#' @export
is_root.taxa_taxonomy <- function(x, subset = NULL) {
  if (is.null(subset)) {
    out <- is.na(vctrs::field(x, 'supertaxa'))
  } else {
    subset <- parse_subset_argument(x, subset)
    # subset <- unname(unlist(subtaxa(x, include = TRUE)[subset])) # NOTE: replace with 'subset' version of subtaxa
    supertaxa <- vctrs::field(x, 'supertaxa')
    out <-  seq_len(length(x)) %in% subset & ((! supertaxa %in% subset) | is.na(supertaxa))
  }
  names(out) <- names(x)
  return(out)
}


#' Get root taxa
#'
#' Get the indexes of root taxa in a taxonomy.
#'
#' @inheritParams is_root
#'
#' @family taxonomy functions
#' @family root functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' roots(x)
#' roots(x, subset = 2:8)
#'
#' @export
roots <- function(x, subset = NULL) {
  UseMethod('roots')
}

#' @export
roots.taxa_taxonomy <- function(x, subset = NULL) {
  out <- which(is_root(x, subset = subset))
  names(out) <- names(x)[out]
  return(out)
}


#' Get subtaxa
#'
#' Get subtaxa indexes for each taxon or another per-taxon value. Subtaxa are
#' taxa contained within a taxon.
#'
#' @param x The object to get subtaxa for, such as a [taxonomy] object.
#' @param subset The subset of the tree to search. Can be indexes or names.
#' @param max_depth The number of ranks to traverse. For example, `max_depth =
#'   1` returns only immediate subtaxa. By default (NULL) information for all
#'   subtaxa is returned (i.e. subtaxa of subtaxa, etc).
#' @param include If `TRUE`, include information for each taxon in the output.
#' @param value Something to return instead of indexes. Must be the same length
#'   as the number of taxa.
#' @param ... Additional arguments.
#'
#' @family taxonomy functions
#' @family subtaxa functions
#'
#' @examples
#' # Generate example data
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#'
#' # The indexes of all subtaxa (with subtaxa of subtaxa, etc) for each taxon
#' subtaxa(x)
#'
#' # The indexes of immediate subtaxa (without subtaxa of subtaxa, etc) for each taxon
#' subtaxa(x, max_depth = 1)
#'
#' # Return something other than index
#' subtaxa(x, value = tax_name(x))
#'
#' # Include each taxon with its subtaxa
#' subtaxa(x, value = tax_name(x), include = TRUE)
#'
#' # Only return data for some taxa (faster than subsetting the whole result)
#' subtaxa(x, subset = 3)
#'
#' @export
subtaxa <- function(x, subset = NULL, max_depth = NULL, include = FALSE, value = NULL, ...) {
  UseMethod('subtaxa')
}

#' @export
subtaxa.taxa_taxonomy <- function(x, subset = NULL, max_depth = NULL, include = FALSE, value = NULL, ...) {
  # Parse arguments
  subset <- parse_subset_argument(x, subset)
  original_names <- names(x)
  names(x) <- as.character(seq_len(length(x)))

  # Get subtaxa
  get_children <- function(taxon) {
    which(vctrs::field(x, 'supertaxa') == taxon)
  }
  recursive_part <- function(taxon) {
    # Get immediate children of current taxon
    children <- get_children(taxon)
    # Run this function on them to get their output
    child_output <- lapply(children, recursive_part) # stops if no children
    child_output <- stats::setNames(unlist(child_output, recursive = FALSE),
                                    unlist(lapply(child_output, names)))
    # Get all subtaxa from the names of the child output
    child_taxa <- c(taxon, as.numeric(names(child_output)))
    # Combine the child output with the subtaxa for the current taxon
    output <- stats::setNames(c(list(child_taxa), child_output),
                              c(taxon, names(child_output)))
    return(output)
  }
  if (is.null(max_depth) || max_depth > 1) {
    output <- unlist(unname(lapply(roots(x, subset = subset), recursive_part)), recursive = FALSE)
  } else if (max_depth == 0) {
    output <- rep(list(integer(0)), length(x))
  } else {
    output <- stats::setNames(
      lapply(seq_len(length(x)), function(i) c(i, get_children(i))),
      names(x)
    )
  }

  # Remove query taxa from output
  if (! include) {
    output <- lapply(output, `[`, -1)
  }

  # Simulate limited recursion
  #
  # To increase speed, the recursive algorithm only searches starting at
  # root taxa, but this makes it hard to limit the number of rankes returned
  # below each taxon during recursion. Instead, a finite number of
  # recursions are simulated by filtering the results of traversing the
  # entire tree and comparing rank depth between each taxon and its subtaxa.
  if (! is.null(max_depth) && max_depth > 0) {
    rank_depth <- vapply(supertaxa(x, subset = as.numeric(names(output))), length, numeric(1))
    output[] <- lapply(seq_len(length(output)), function(i) {
      subtaxa_depth <- rank_depth[output[[i]]]
      current_depth <- rank_depth[i]
      passing_taxa <- subtaxa_depth - current_depth <= max_depth
      return(output[[i]][passing_taxa])
    })
  }

  # Only return information for the subset
  output <- output[as.character(subset)]

  # Set names and values
  names(x) <- original_names
  output <- apply_names_and_values(x, index_list = output, value = value)
  names(output) <- original_names[subset]

  return(output)
}

#' Number of subtaxa per taxon
#'
#' Get the number of subtaxa per taxon.
#'
#' @inheritParams subtaxa
#'
#' @family subtaxa functions
#'
#' @examples
#' # Generate example data
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#'
#' # Find number of subtaxa (including subtaxa of subtaxa, etc)
#' n_subtaxa(x)
#'
#' # Find the number of subtaxa one rank below each taxon
#' n_subtaxa(x, max_depth = 1)
#'
#' # Only return data for some taxa (faster than subsetting the whole result)
#' n_subtaxa(x, subset = 1:3)
#'
#' @export
n_subtaxa <- function(x, subset = NULL, max_depth = NULL, include = FALSE) {
  UseMethod('n_subtaxa')
}

#' @export
n_subtaxa.taxa_taxonomy <- function(x, subset = NULL, max_depth = NULL, include = FALSE) {
  output <- vapply(subtaxa(x, subset = subset, max_depth = max_depth, include = include), length, numeric(1))
  names(output) <- names(x)
  return(output)
}


#' Get supertaxa
#'
#' Get supertaxa indexes for each taxon or another per-taxon value. Supertaxa
#' are taxa a taxon is contained in.
#'
#' @param x The object to get supertaxa for, such as a [taxonomy] object.
#' @param subset The subset of the tree to search for roots to that subset. Can
#'   be indexes or names.
#' @param max_depth The number of levels to traverse. For example, `max_depth =
#'   1` returns only immediate supertaxa. By default (NULL) information for all
#'   supertaxa is returned.
#' @param include If `TRUE`, include information for each taxon in the output.
#' @param value Something to return instead of indexes. Must be the same length
#'   as the number of taxa.
#' @param use_na Add a NA to represent the root of the taxonomy (i.e. no
#'   supertaxon)
#' @param ... Additional arguments.
#'
#' @family taxonomy functions
#' @family supertaxa functions
#'
#' @examples
#' # Generate example data
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#'
#' # The indexes of all supertaxa (with supertaxa of supertaxa, etc) for each taxon
#' supertaxa(x)
#'
#' # Return something other than index
#' supertaxa(x, value = tax_name(x))
#'
#' # Include each taxon with its supertaxa
#' supertaxa(x, value = tax_name(x), include = TRUE)
#'
#' # Only return data for some taxa (faster than subsetting the whole result)
#' supertaxa(x, subset = 3)
#'
#' @export
supertaxa <- function(x, subset = NULL, max_depth = NULL, include = FALSE, value = NULL, use_na = FALSE, ...) {
  UseMethod('supertaxa')
}

#' @export
supertaxa.taxa_taxonomy <- function(x, subset = NULL, max_depth = NULL, include = FALSE, value = NULL, use_na = FALSE, ...) {
  # Parse arguments
  subset <- parse_subset_argument(x, subset)

  # Get supertaxa
  parent_index <- vctrs::field(x, 'supertaxa')
  recursive_part <- function(taxon, depth = 1) {
    supertaxon <- parent_index[taxon]
    if (is.na(supertaxon) || (! is.null(max_depth) && depth >= max_depth)) {
      output <- c(taxon, supertaxon)
    } else {
      output <- c(taxon, recursive_part(supertaxon, depth = depth + 1))
    }
    return(unname(output))
  }
  if (! is.null(max_depth) && max_depth == 0) {
    output <- lapply(subset, function(i) numeric(0))
  } else {
    output <- lapply(subset, recursive_part)
  }

  # Remove query taxa from output
  if (! include) {
    output <- lapply(output, `[`, -1)
  }

  # Remove NAs from output
  if (! use_na) {
    output <- lapply(output, function(x) x[!is.na(x)])
  }

  # Set names and values
  output <- apply_names_and_values(x, index_list = output, value = value)
  names(output) <- names(x)[subset]

  return(output)
}

#' Number of supertaxa per taxon
#'
#' Get the number of supertaxa each taxon is contained in.
#'
#' @inheritParams supertaxa
#'
#' @family supertaxa functions
#'
#' @examples
#' # Generate example data
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#'
#' # Find number of supertaxa each taxon is contained in
#' n_supertaxa(x)
#'
#' # Only return data for some taxa (faster than subsetting the whole result)
#' n_supertaxa(x, subset = 1:3)
#'
#' @export
n_supertaxa <- function(x, subset = NULL, max_depth = NULL, include = FALSE) {
  UseMethod('n_supertaxa')
}

#' @export
n_supertaxa.taxa_taxonomy <- function(x, subset = NULL, max_depth = NULL, include = FALSE) {
  output <- vapply(supertaxa(x, subset = subset, max_depth = max_depth, include = include), length, numeric(1))
  names(output) <- names(x)
  return(output)
}


#' @rdname taxonomy
#' @export
#' @keywords internal
`[.taxa_taxonomy` <- function(x, ..., subtaxa = TRUE, supertaxa = FALSE, invert = FALSE) {

  index <- seq_len(length(x))
  names(index) <- names(x)
  subset <- index[...]

  # Get taxa of subset
  taxa_subset <- subset
  if (is.null(subtaxa) || (is.logical(subtaxa) && subtaxa) || (is.numeric(subtaxa) && subtaxa > 0)) {
    if (is.logical(subtaxa) && subtaxa) {
      subtaxa = NULL
    }
    taxa_subset <- c(taxa_subset, unlist(subtaxa(x, max_depth = subtaxa, include_input = FALSE)[subset]))
  }
  if (is.null(supertaxa) || (is.logical(supertaxa) && supertaxa) || (is.numeric(supertaxa) && supertaxa > 0)) {
    if (is.logical(supertaxa) && supertaxa) {
      supertaxa = NULL
    }
    taxa_subset <- c(taxa_subset, unlist(supertaxa(x, max_depth = supertaxa, include_input = FALSE)[subset]))
  }
  taxa_subset <- sort(unique(taxa_subset))

  # Invert selection
  if (invert) {
    taxa_subset <- index[-taxa_subset]
  }

  # Apply supset
  taxonomy(taxa = vctrs::field(x, 'taxa')[taxa_subset],
           supertaxa = match(nearest_supertaxa(x, taxa_subset), taxa_subset),
           .names = names(x)[taxa_subset])
}

#' @rdname taxonomy
#' @export
#' @keywords internal
`[[.taxa_taxonomy` <- function(x, i, ..., subtaxa = TRUE, supertaxa = FALSE, invert = FALSE) {
  must_be_length_1(i)
  x[i, ..., subtaxa = subtaxa, supertaxa = supertaxa, invert = invert]
}



#' @export
`[<-.taxa_taxonomy` <- function(x, i, supertaxa = NULL, subtaxa = NULL, value) {
  # Standardize index input
  i <- to_index(x, i)

  # If supertaxa are undefined, use current supertaxa for replaced values and NA for new values
  if (is.null(supertaxa)) {
    parents <- rep(NA, length(i))
    is_replacing <- i %in% seq_len(length(x))
    parents[is_replacing] <- unname(unlist(supertaxa(x, subset = i[is_replacing], max_depth = 1, use_na = TRUE)))
  } else {
    parents <- supertaxa
  }

  # Simplify subtaxa and infer supertaxa if not specified
  if (is.null(subtaxa)) {
    children <- subtaxa(x, subset = i, max_depth = 1)
  } else {
    if (! is.list(subtaxa)) {
      subtaxa <- list(subtaxa)
    }
    children <- lapply(subtaxa, function(s) roots(x, subset = s))
    if (is.null(supertaxa)) {
      parents <- vapply(subtaxa, function(s) enclosing_taxon(x, subset = s), numeric(1))
    }
  }

  # Recycle inputs to same length
  rec <- vctrs::vec_recycle_common(i, parents, children, value)
  i = rec[[1]]
  parents = rec[[2]]
  children = rec[[3]]
  value = rec[[4]]

  # Check that taxa are not made supertaxa of themselves
  if (any(! is.na(parents) & i == parents)) {
    stop(call. = FALSE, 'Cannot set a taxon to be a supertaxon of itself')
  }

  # Check that taxa are not made subtaxa of themselves
  cyclical_subtaxa <- any(vapply(seq_len(length(i)),
                                 function(index) i[[index]] %in% children[[index]],
                                 logical(1)))
  if (cyclical_subtaxa) {
    stop(call. = FALSE, 'Cannot set a taxon to be a subtaxon of itself')
  }

  if (is.null(supertaxa) && is.null(subtaxa)) {
    x <- NextMethod()
  } else {
    # Calls this function to make new rows
    x[i] <- value
  }

  # Remove any cycles in the taxonomy
  # parents_to_reset <- parents[mapply(function(p, c) p %in% unlist(subtaxa(x, subset = c, include = TRUE)), parents, children)]
  children <- lapply(seq_len(length(children)), function(i) {
    children[[i]][children[[i]] != parents[i]]
  })

  # Reset overwritten supertaxa
  nearest_supertaxa <- unname(unlist(lapply(supertaxa(x), function(s) {
    s[! s %in% i][1]
  })))
  vctrs::field(x, 'supertaxa') <- nearest_supertaxa

  # Set supertaxa
  vctrs::field(x, 'supertaxa')[i] <- parents

  # Set subtaxa
  to_set <- unlist(children)
  vctrs::field(x, 'supertaxa')[to_set] <- rep(i, vapply(children, length, numeric(1)))

  return(x)
}


#' @method %in% taxa_taxonomy
#' @export
`%in%.taxa_taxonomy` <- function(x, table) {
  UseMethod("%in%.taxa_taxonomy", table)
}

#' @export
`%in%.taxa_taxonomy.default` <- function(x, table) {
  as_taxon(x) %in% table
}

#' @export
`%in%.character.taxa_taxonomy` <- function(x, table) {
  x %in% as.character(as_taxon(table))
}

#' @export
`%in%.factor.taxa_taxonomy` <- function(x, table) {
  x %in% as.character(as_taxon(table))
}

#--------------------------------------------------------------------------------
# Exported utility functions
#--------------------------------------------------------------------------------


#' @export
as_data_frame.taxa_taxonomy <- function(x, row.names = NULL, optional = FALSE, ...,
                                        stringsAsFactors = default.stringsAsFactors()) {
  out <- as_data_frame(as_taxon(x))
  cbind(supertaxon = vctrs::field(x, 'supertaxa'), out)
}

#' @importFrom tibble as_tibble
#' @export
as_tibble.taxa_taxonomy <- function(x, ...) {
  tibble::as_tibble(as_data_frame(x, stringsAsFactors = FALSE), ...)
}

#' Get stems
#'
#' Get stem indexes for each taxon or another per-taxon value.
#'
#' @param x An object with taxonomic relationships, like [taxonomy] objects.
#' @param value Something to return instead of indexes. Must be the same length as the number of taxa.
#' @param ... Additional arguments.
#'
#' @family taxonomy functions
#' @family stem functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris'),
#'               supertaxa = c(NA, 1, 2, 3, 3))
#' x <- c(x, x)
#' stems(x)
#' stems(x, value = tax_name(x))
#'
#' @export
stems <- function(x, value = NULL, ...) {
  UseMethod('stems')
}

#' @export
stems.taxa_taxonomy <- function(x, value = NULL, ...) {
  # Search until taxa with multiple subtaxa are found
  recursive_part <- function(index) {
    children <- which(vctrs::field(x, 'supertaxa') == index)
    if (length(children) == 0) {
      output <- index
    } else if (length(children) == 1) {
      output <- c(index, recursive_part(children))
    } else {
      output <- numeric(0)
    }
    return(unname(output))
  }
  output <- lapply(roots(x), recursive_part)

  # Set names and values
  output <- apply_names_and_values(x, index_list = output, value = value)

  return(output)
}

#' Check if taxa are stems
#'
#' Check if each taxon is a stem. A stem is any taxa from a root to the first taxon with multiple subtaxa.
#'
#' @inheritParams stems
#' @family stem functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris'),
#'               supertaxa = c(NA, 1, 2, 3, 3))
#' is_stem(x)
#'
#' @export
is_stem <- function(x) {
  UseMethod('is_stem')
}

#' @export
is_stem.taxa_taxonomy <- function(x) {
  output <- seq_len(length(x)) %in% unlist(stems(x))
  names(output) <- names(x)
  return(output)
}


#' Get leaves
#'
#' Get leaves indexes for each taxon or another per-taxon value. Leaves are taxa with no subtaxa.
#'
#' @param x The object to get leaves for, such as a [taxonomy] object
#' @param value Something to return instead of indexes. Must be the same length as the number of taxa.
#' @param ... Additional arguments.
#'
#' @family taxonomy functions
#' @family leaf functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' leaves(x)
#' leaves(x, value = tax_name(x))
#'
#' @export
leaves <- function(x, value = NULL, ...) {
  UseMethod('leaves')
}

#' @export
leaves.taxa_taxonomy <- function(x, value = NULL, ...) {
  # Find taxa without subtaxa (leaves)
  subtax <- subtaxa(x)
  no_subtaxa <- which(vapply(subtax, length, numeric(1)) == 0)

  # Subset subtaxa results to just leaves
  output <- lapply(subtax, function(i) i[i %in% no_subtaxa])

  # Set names and values
  output <- apply_names_and_values(x, index_list = output, value = value)
  names(output) <- names(x)

  return(output)
}

#' Check if taxa are leaves
#'
#' Check if each taxon is a leaf. A leaf is a taxon with no subtaxa.
#' subtaxa.
#'
#' @inheritParams leaves
#'
#' @family leaf functions
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' is_leaf(x)
#'
#' @export
is_leaf <- function(x) {
  UseMethod('is_leaf')
}

#' @export
is_leaf.taxa_taxonomy <- function(x) {
  output <- ! seq_len(length(x)) %in% vctrs::field(x, 'supertaxa')
  names(output) <- names(x)
  return(output)
}

#' Number of leaves per taxon
#'
#' Get the number of leaves per taxon. A leaf is a taxon with no subtaxa.
#'
#' @inheritParams leaves
#' @family leaf functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' n_leaves(x)
#'
#' @export
n_leaves <- function(x) {
  UseMethod('n_leaves')
}

#' @export
n_leaves.taxa_taxonomy <- function(x) {
  output <- vapply(leaves(x), length, numeric(1))
  names(output) <- names(x)
  return(output)
}


#' Get internodes
#'
#' Get internodes indexes for each taxon or another per-taxon value. An
#' internode is a taxon with exactly one supertaxon and one subtaxon. These taxa
#' can be removed without losing information on the relationships of the
#' remaining taxa.
#'
#' @param x The object to get internodes for, such as a [taxonomy] object.
#'
#' @family taxonomy functions
#' @family internode functions
#'
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' internodes(x)
#'
#' @export
internodes <- function(x) {
  UseMethod('internodes')
}

#' @export
internodes.taxa_taxonomy <- function(x) {
  output <- which(is_internode(x))
  names(output) <- names(x)[output]
  return(output)
}

#' Check if taxa are internodes
#'
#' Check if each taxon is an internode. An internode is a taxon with exactly one
#' supertaxon and one subtaxon. These taxa can be removed without losing
#' information on the relationships of the remaining taxa.
#'
#' @inheritParams internodes
#'
#' @family internode functions
#' @examples
#' x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#'                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#'               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
#' is_internode(x)
#'
#' @export
is_internode <- function(x) {
  UseMethod('is_internode')
}

#' @export
is_internode.taxa_taxonomy <- function(x) {
  output <- n_subtaxa(x, max_depth = 1) == 1 & n_supertaxa(x, max_depth = 1) == 1
  names(output) <- names(x)
  return(output)
}


#' @export
c.taxa_taxonomy <- function(...) {
  out <- NextMethod()
  if (is_taxonomy(out) && length(list(...)) > 1) {
    in_lengths <- vapply(list(...), length, numeric(1))
    supertaxon_index_offsets <- rep(c(0, cumsum(in_lengths)[-length(in_lengths)]), in_lengths)
    vctrs::field(out, 'supertaxa') <- as.integer(vctrs::field(out, 'supertaxa') + supertaxon_index_offsets)
    attr(tax_rank(out), 'levels') <- do.call(c, lapply(list(...), function(x) attr(tax_rank(x), 'levels')))
  }
  return(out)
}

#' @export
unique.taxa_taxonomy <- function(x, incomparables = FALSE, fromLast = FALSE,
                                 nmax = NA, ..., proxy_func = NULL) {
  # Find duplicated taxa
  unique_indexes <- duplicated_index_taxonomy(x, proxy_func = proxy_func)

  # Set supertaxa for subtaxa of combined taxa
  vctrs::field(x, 'supertaxa') <- unique_indexes[vctrs::field(x, 'supertaxa')]

  # Remove duplicate taxa
  x[unique(unique_indexes), subtaxa = FALSE]
}


#--------------------------------------------------------------------------------
# Internal utility functions
#--------------------------------------------------------------------------------


#' @keywords internal
apply_names_and_values <- function(x, index_list, value) {
  if (is.null(value)) {
    value <- seq_len(length(x))
  }
  lapply(index_list, function(i) {
    stats::setNames(value[i], names(x)[i])
  })
}


#' @keywords internal
enclosing_taxon <- function(x, subset) {
  super <- table(unname(unlist((supertaxa(x)[subset])))) # NOTE use subset version of supertaxa
  possible <- as.numeric(names(super[super == length(subset)]))
  if (length(possible) == 0) {
    possible <- NA
  } else if (length(possible) > 1) {
    possible <- possible[which.max(n_supertaxa(x)[possible])] # NOTE use subset version of n_supertaxa
  }
  return(possible)
}


#' @keywords internal
parse_subset_argument <- function(x, subset) {
  if (is.null(subset)) {
    subset <- seq_len(length(x))
  } else {
    if (is.character(subset)) {
      subset <- match(subset, names(x))
    } else if (! is.numeric(subset)) {
      stop(call. = FALSE, "Invalid value for 'subset' argument of class '", class(x)[1], "'.")
    }
  }
  return(subset)
}


# Returns the nearest supertaxa in the subset for each item in the subset
#' @keywords internal
nearest_supertaxa <- function(x, taxa_subset) {
  unname(unlist(lapply(supertaxa(x)[taxa_subset], function(s) {
    s[s %in% taxa_subset][1]
  })))

}


# Convert a logical or name vector to index
#' @keywords internal
to_index <- function(x, i) {
  if (is.numeric(i)) {
    return(i)
  }
  if (is.character(i)) {
    return(match(i, names(x)))
  }
  if (is.logical(i) && length(i) == length(x)) {
    return(which(i))
  }
  stop('Cannot convery input into an index')
}


#' Returns the index of the first occurrence of each unique element
#'
#' @keywords internal
duplicated_index <- function(x, proxy_func = NULL) {
  if (is.null(proxy_func)) {
    proxy <- x
  } else {
    proxy <- proxy_func(x)
  }
  vapply(seq_len(length(x)), function(i) which(proxy == proxy[[i]])[1], numeric(1))
}

#' Returns the index of the first occurrence of each unique taxon in a taxonomy
#'
#' @keywords internal
duplicated_index_taxonomy <- function(x, proxy_func = NULL) {
  if (is.null(proxy_func)) {
    proxy_func <- taxon_comp_hash
  }

  # Precalculate subtaxa and comparison proxy object for speed
  cached_supertaxa <- vctrs::field(x, 'supertaxa')
  cached_subtaxa <- lapply(seq_len(length(x)), function(i) which(cached_supertaxa == i))
  proxy <- proxy_func(x)

  # Find which taxa are the same and should be combined
  find_changes <- function(i) {
    t_sub <- cached_subtaxa[i]
    unique_i <- i[duplicated_index(proxy[i])]
    is_duplicated <- i != unique_i
    out <- data.frame(from = i[is_duplicated], to = unique_i[is_duplicated])
    combined_subtaxa <- lapply(unique(unique_i), function(identical_i) unlist(t_sub[unique_i == identical_i]))
    c(list(out), unlist(lapply(combined_subtaxa, find_changes), recursive = FALSE)) # NOTE: This is recursive
  }
  changes <- dplyr::bind_rows(find_changes(roots(x)))
  out <- seq_len(length(x))
  out[changes$from] <- changes$to
  return(out)
}

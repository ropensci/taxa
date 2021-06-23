#' Default font
#'
#' A wrapper to make changing the formatting of text printed easier.
#'
#' @param text What to print.
#'
#' @family printer fonts
#'
#' @keywords internal
font_default <- function(text) {
  text
}



#' Font for secondary data
#'
#' A wrapper to make changing the formatting of text printed easier.
#' This is used for print data associated with other data.
#'
#' @param text What to print.
#'
#' @family printer fonts
#'
#' @keywords internal
font_secondary <- function(text) {
  style <- crayon::make_style(grDevices::rgb(.7, .7, .7))
  style(text)
}


#' Punctuation formatting in print methods
#'
#' A simple wrapper to make changing the formatting of text printed easier.
#' This is used for non-data, formatting characters
#'
#' @param text What to print
#'
#' @family printer fonts
#'
#' @keywords internal
font_punct <- function(text) {
  crayon::silver(text)
}


#' Taxon name formatting in print methods
#'
#' A simple wrapper to make changing the formatting of text printed easier.
#' This is used for taxon names.
#'
#' @param text What to print
#'
#' @family printer fonts
#'
#' @keywords internal
font_tax_name <- function(text) {
  if (is_taxon(text)) {
    ranks_below_genus <- names(rank_ref[rank_ref >= rank_ref['genus']])
    ranks_below_genus <- ranks_below_genus[! is.na(ranks_below_genus)]
    out <- ifelse(! is.na(text) & tolower(vctrs::field(text, 'rank')) %in% ranks_below_genus,
                  crayon::italic(vctrs::field(text, 'name')), vctrs::field(text, 'name'))
    out <- font_na(out)
  } else {
    out <- text
  }
  return(out)
}


#' Font for NAs in print methods
#'
#' A simple wrapper to make changing the formatting of text printed easier.
#' This is used for `NA`s
#'
#' @param text What to print
#'
#' @family printer fonts
#'
#' @keywords internal
font_na <- function(text) {
  text[is.na(text)] <- crayon::red(text[is.na(text)])
  return(text)
}


#' Print that works with color
#'
#' The same as the `print` function, but can print colored text. Its a bit of a hack, but the only
#' way I found to replicate the behavior of `print` without rewriting the entire `print` function.
#'
#' @param x What to print, typically a character vector
#' @param original_length The length of the full vector if only part was given.
#' @param ... Passed to `print`
#'
#' @keywords internal
print_with_color <- function(x, original_length = length(x), ...) {
  # Apply maximum printing limits
  if (original_length > options()$max.print) {
    x <- x[seq_len(options()$max.print)]
  }

  # Print fake data with same length as uncolored text
  dummy <- vapply(nchar(crayon::strip_style(x)), FUN.VALUE = character(1),
                  function(n) paste0(rep("@", n), collapse = ""))
  dummy <- utils::capture.output(print(dummy, ...))
  dummy <- paste0(dummy, collapse = "\n")

  # Replace fake data with colored data
  split_dummy <- strsplit(dummy, "@+")[[1]]
  output <- paste0(interleave(c(split_dummy, ""), c(x, "")), collapse = "")

  # Replicate maximum print truncation message
  if (original_length > length(x)) {
    output <- paste0(output, '\n',
                     '[ reached getOption("max.print") -- omitted ',
                     original_length - length(x), ' entries ]')
  }

  # Print output and return input
  output <- paste0(output, '\n')
  cat(output)
  invisible(x)
}

#' Interleaves two vectors
#'
#' Taken from "http://r.789695.n4.nabble.com/Interleaving-elements-of-two-vectors-td795123.html"
#'
#' @keywords internal
interleave <- function(v1, v2)
{
  ord1 <- 2*(1:length(v1))-1
  ord2 <- 2*(1:length(v2))
  c(v1,v2)[order(c(ord1,ord2))]
}
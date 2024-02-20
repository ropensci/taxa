#' Print a subset of a character vector
#'
#' Prints the start and end values for a character vector. The number of values
#' printed depend on the width of the screen by default.
#'
#' @param chars (`character`) What to print.
#' @param prefix (`character` of length 1) What to print before
#'   `chars`, on the same line.
#' @param sep What to put between consecutive values
#' @param mid What is used to indicate omitted values
#' @param trunc_char What is appended onto truncated values
#' @param max_chars (`numeric` of length 1) The maximum number of
#'   characters to print.
#' @param type (`"error"`, `"warning"`, `"message"`, `"cat"`, `"print"`, `"silent"`, `"plain"`)
#'
#' @return `NULL`
#'
#' @examples
#' taxa:::limited_print(1:100)
#' taxa:::limited_print(1:10000)
#' taxa:::limited_print(1:10000, prefix = "stuff:")
#'
#' @keywords internal
limited_print <- function(chars, prefix = "", sep = ", ", mid = " ... ",
                          trunc_char = "[truncated]",
                          max_chars = getOption("width") - nchar(prefix) - 5,
                          type = "message") {

  # https://stat.ethz.ch/pipermail/r-help/2006-March/101023.html
  interleave <- function(v1,v2) {
    ord1 <- 2*(1:length(v1))-1
    ord2 <- 2*(1:length(v2))
    c(v1,v2)[order(c(ord1,ord2))]
  }

  truncate <- function(x, max_chars = 30) {
    if (nchar(x) > max_chars) {
      x <- paste0(substr(x, 0, max_chars - nchar(crayon::strip_style(trunc_char))), trunc_char)
    }
    return(x)
  }

  # Remove colsole fonts
  raw_chars <- chars
  chars <- crayon::strip_style(chars)

  # Convert NA to "NA"
  chars[is.na(chars)] <- "NA"

  #
  if (length(chars) == 0) {
    output <- prefix
    return(invisible(NULL))
  }

  #
  q = "'"
  interleaved <- interleave(chars[1:(length(chars) / 2)],
                            rev(chars[(length(chars) / 2 + 1):length(chars)]))
  is_greater_than_max <- cumsum(nchar(interleaved) + nchar(crayon::strip_style(sep))) + 10 > max_chars
  if (all(! is_greater_than_max)) {
    max_printed <- length(chars)
  } else {
    max_printed <- which.max(is_greater_than_max) - 1
  }
  if (max_printed < length(chars)) {
    if (max_printed < 2) {
      first_part <- truncate(chars[1])
      second_part <- truncate(chars[length(chars)])
    } else {
      first_part <-  raw_chars[1:ceiling(max_printed / 2)]
      second_part <- raw_chars[(length(chars) - floor(max_printed / 2) + 1):length(chars)]
    }
    if (length(chars) > 1) {
      output <- paste0(paste0(collapse = sep, first_part),
                       mid,
                       paste0(collapse = sep, second_part),
                       "\n")
    } else {
      output <- paste0(paste0(collapse = sep, first_part),
                       "\n")

    }
  } else {
    output <- paste0(paste0(collapse = sep, raw_chars), "\n")
  }
  output <- paste(prefix, output, collapse = "")

  if (type == "error") {
    stop(output)
  } else if (type == "warning") {
    warning(output)
  } else if (type == "message") {
    message(output)
  } else if (type == "cat") {
    cat(output)
  } else if (type == "print") {
    print(output)
  } else if (type == "plain") {
    output <- crayon::strip_style(output)
  } else if (type != "silent") {
    stop("invalid type option")
  }
  return(invisible(output))
}


#' @keywords internal
named_field <- function(x, i) {
  out <- vctrs::field(x, i)
  if (! is.null(names(x))) {
    names(out) <- names(x)
  }
  return(out)
}


#' Remove names from fields in a vctrs rcrd
#'
#' Remove names from fields in a vctrs rcrd
#'
#' @param x a vctrs rcrd
#'
#' @keywords internal
unname_fields <- function(x) {
  for (f in vctrs::fields(x)) {
    vctrs::field(x, f) <- unname(vctrs::field(x, f))
  }
  return(x)
}


#' @keywords internal
must_be_length_1 <- function(x) {
  if (is.logical(x)) {
    x <- which(x)
  }
  if (length(x) < 1) {
    stop(call. = FALSE, 'attempt to select less than one element')
  } else if (length(x) > 1) {
    stop(call. = FALSE, 'attempt to select more than one element')
  }
}
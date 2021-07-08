library(vctrs)

new_test_class <- function(.names = NULL, x = character(), ...) {
  if (is.null(names) || all(is.na(.names))) {
    .names_set <- FALSE
    .names <- vctrs::vec_recycle(NA_character_, length(x))
  } else {
    .names_set <- TRUE
    vctrs::vec_assert(.names, ptype = character())
  }
  vctrs::vec_assert(x, ptype = character())
  vctrs::new_rcrd(list(.names = .names, x = x),
                  .names_set = .names_set,
                  ...,
                  class = "test_class")
}

test_class <- function(x = character(0), .names = NA, ...) {
  # Cast inputs to correct values
  x <- vctrs::vec_cast(x, character())
  .names <- vctrs::vec_cast(.names, character())
  # Recycle ranks and databases to common length
  recycled <- vctrs::vec_recycle_common(x, .names)
  x <- recycled[[1]]
  .names <- recycled[[2]]
  # Create object
  new_test_class(.names = .names, x = x, ...)
}

format.test_class <- function(x, ...) {
  vctrs::field(x, 'x')
}


vec_cast.test_class <- function(x, to, ..., x_arg, to_arg) UseMethod("vec_cast.test_class")

vec_cast.test_class.default <- function(x, to, ..., x_arg, to_arg) vctrs::vec_default_cast(x, to, x_arg, to_arg)

vec_cast.test_class.test_class <- function(x, to, ..., x_arg, to_arg) x

vec_cast.test_class.character <- function(x, to, ..., x_arg, to_arg) test_class(x)

vec_cast.character.test_class <- function(x, to, ..., x_arg, to_arg) as.character(vctrs::field(x, "name"))


names.test_class <- function(x) {
  if (attributes(x)[['.names_set']]) {
    return(vctrs::field(x, ".names"))
  } else {
    return(NULL)
  }
}

`names<-.test_class` <- function(x, value) {
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


x <- test_class(c('a', 'b', 'c'))
names(x) <- c('A', 'B', 'C')
x['D'] <- 'X'
vctrs::field(x, ".names")
vctrs::field(x, "x")

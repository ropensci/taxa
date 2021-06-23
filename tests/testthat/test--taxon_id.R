context("taxon_id")
library(taxa)


# Creating taxon_id objects

test_that("taxon_id objects can be created from character input", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_id')
  expect_true(is_taxon_id(x))
  expect_equal(as.character(x[3]), '3')
})

test_that("taxon_id objects can be created from factor input", {
  x <- taxon_id(as.factor(c('1', '2', '3')))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_id')
  expect_equal(as.character(x[3]), '3')
})

test_that("taxon_id objects can be created with names", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_id')
  expect_equal(as.character(x[3]), c(c = '3'))
  expect_equal(names(x), letters[1:3])
})

test_that("taxon_id values must match the regex of the database", {
  expect_error(taxon_id('NOLETTERS', db = 'ncbi'), 'Taxon IDs must follow the database ID conventions ')
})


# Printing taxon_id objects

test_that("taxon_id objects can be printed", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  names(x) <- c('a', 'b', 'c')
  verify_output(path = test_path('print_outputs', 'taxon_id.txt'),
                code = {print(x)},
                crayon = TRUE)
})

test_that("taxon_id objects can be printed in tables", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  verify_output(path = test_path('print_outputs', 'taxon_id_tibble.txt'),
                code = {print(tibble::tibble(x))},
                crayon = TRUE)
  verify_output(path = test_path('print_outputs', 'taxon_id_data_frame.txt'),
                code = {print(data.frame(x))},
                crayon = TRUE)
})

# Subsetting taxon_id objects with `[`

test_that("taxon_id objects can be `[` subset by index", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  expect_equal(length(x[1:2]), 2)
  expect_equal(x[2:3], taxon_id(c('2', '3'), db = c('ncbi', 'itis')))
})

test_that("taxon_id objects can be `[` subset by logical vector", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  expect_equal(length(x[c(FALSE, TRUE, FALSE)]), 1)
  expect_equal(x[c(FALSE, TRUE, TRUE)], taxon_id(c('2', '3'), db = c('ncbi', 'itis')))
})

test_that("taxon_id objects can be `[` subset by name", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(length(x[c('a', 'b')]), 2)
  expect_equal(x[c('b', 'c')], taxon_id(c('2', '3'), db = c('ncbi', 'itis'), .names = letters[2:3]))
})


# Subsetting taxon_id objects with `[[`

test_that("taxon_id objects can be `[[` subset by index", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(length(x[[1]]), 1)
  expect_equal(x[[3]], taxon_id('3'))
})

test_that("taxon_id objects can be `[[` subset by name", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(length(x[['c']]), 1)
  expect_equal(x[['c']], taxon_id('3',db = 'itis')) # names are dropped for [[
})


# Setting names of taxon_id objects

test_that("taxon_id objects can be named", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  names(x) <- letters[1:3]
  expect_equal(x, taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3]))
  expect_equal(names(x),  letters[1:3])
  names(x)[2] <- 'd'
  expect_equal(names(x), c('a', 'd', 'c'))
})


# Assigning values to taxon_id objects

test_that("taxon_id objects can have values assigned to them", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  x[2] <- '4'
  expect_equal(x[2], taxon_id('4', .names = letters[2]))
  x[[2]] <- '5'
  expect_equal(x[2], taxon_id('5', .names = letters[2]))
  x['b'] <- '4'
  expect_equal(x[2], taxon_id('4', .names = letters[2]))
  x[c(FALSE, TRUE, FALSE)] <- '4'
  expect_equal(x[2], taxon_id('4', .names = letters[2]))
})

test_that("taxon_id assignment is recycled correctly", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  x[1:3] <- '4'
  expect_equal(x,  taxon_id(c('4', '4', '4'), .names = letters[1:3]))
})

test_that("(taxon_id) multiple items can not be used with [[", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_error(x[[1:3]] <- '4', 'attempt to select more than one element')
  expect_error(x[[1:3]], 'attempt to select more than one element')
})


# Invalid values cannot be assigned

test_that("taxon_id objects cannot be created with invalid databases", {
  expect_error(taxon_id('1', db = 'not_valid'), "Taxon database names must be defined in `db_ref`")
})

test_that("taxon_id objects cannot be assigned invalid values woth `[`", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_error(tax_db(x)[2] <- 'not_valid', "Taxon database names must be defined in `db_ref`")
})

test_that("taxon_id objects cannot be assigned invalid values woth `[[`", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_error(tax_db(x)[[2]] <- 'not_valid', "Taxon database names must be defined in `db_ref`")
})

# Assign values to components

test_that("components of taxon objects can be assigned", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  tax_db(x) <- 'nbn'
  expect_true(all(tax_db(x) == 'nbn'))
})

# Assign taxon db

test_that("taxon_authority objects can be combined", {
  x <- taxon_id(c('1', '2', '3'))
  tax_db(x) <- 'nbn'
  expect_equal(tax_db(x), taxon_db(rep('nbn', 3)))
})


# Can be concatenated

test_that("taxon_id objects can be combined", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(c(x, x), taxon_id(rep(c('1', '2', '3'), 2)))
  expect_equal(c(x, x, x), taxon_id(rep(c('1', '2', '3'), 3)))
})

test_that("named taxon_id objects can be combined", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(c(x, x), taxon_id(rep(c('1', '2', '3'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(c(x, x, x), taxon_id(rep(c('1', '2', '3'), 3), .names = rep(letters[1:3], 3)))
})


# Works with `rep`

test_that("taxon_id objects work with `rep`", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(rep(x, 2), taxon_id(rep(c('1', '2', '3'), 2)))
  expect_equal(rep(x, 3), taxon_id(rep(c('1', '2', '3'), 3)))
})

test_that("named taxon_id objects work with `rep`", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(rep(x, 2), taxon_id(rep(c('1', '2', '3'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(rep(x, 3), taxon_id(rep(c('1', '2', '3'), 3), .names = rep(letters[1:3], 3)))
})

# Works with `seq_along`

test_that("taxon_id objects work with `seq_along`", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(seq_along(x), 1:3)
})

test_that("named taxon_id objects work with `seq_along`", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(seq_along(x), 1:3)
})


# Can be converted to character

test_that("taxon_id objects can be converted to characters", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(as.character(x), c('1', '2', '3'))
})

test_that("named taxon_id objects can be converted to characters", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(as.character(x), c(a = '1', b = '2', c = '3'))
})


# Can be converted to factor

test_that("taxon_id objects can be converted to factor", {
  x <- taxon_id(c('1', '2', '3'))
  expect_equal(as.factor(x), as.factor(c('1', '2', '3')))
})

test_that("named taxon_id objects can be converted to factor", {
  x <- taxon_id(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(as.factor(x), as.factor(c(a = '1', b = '2', c= '3')))
})


# Can be converted to a data.frame

test_that("taxon_id objects can be converted to a data.frame", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  expect_equal(
    as_data_frame(x),
    data.frame(tax_id = c('1', '2', '3'), tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})

test_that("named taxon_id objects can be converted to data.frame", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(
    as_data_frame(x),
    data.frame(tax_id = c('1', '2', '3'), tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})


# Can be converted to a tibble

test_that("taxon_id objects can be converted to a tibble", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'))
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_id = c('1', '2', '3'), tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})

test_that("named taxon_id objects can be converted to a tibble", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_id = c('1', '2', '3'), tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})

# works with is.na

test_that("taxon_id objects work with is.na", {
  x <- taxon_id(c('1', NA, '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(is.na(x), is.na(c('1', NA, '3')))
})


# works with %in%

test_that("taxon_id objects work with %in%", {
  x <- taxon_id(c('1', '2', '3'), db = c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_true('1' %in% x)
  expect_true(factor('1') %in% x)
  expect_equal(x %in% c('1', '2'), c('1', '2', '3') %in% c('1', '2'))
  expect_equal(x %in% factor(c('1', '2')), c('1', '2', '3') %in% c('1', '2'))
  expect_true(x[1] %in% x)
  expect_equal(x %in% x[1:2], c('1', '2', '3') %in% c('1', '2'))
})
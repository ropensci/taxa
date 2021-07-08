context("taxon_db")
library(taxa)


# Creating taxon_db objects

test_that("taxon_db objects can be created from character input", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_db')
  expect_true(is_taxon_db(x))
  expect_equal(as.character(x[3]), 'itis')
})

test_that("taxon_db objects can be created from factor input", {
  x <- taxon_db(as.factor(c('ncbi', 'ncbi', 'itis')))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_db')
  expect_equal(as.character(x[3]), 'itis')
})

test_that("taxon_db objects can be created with names", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_db')
  expect_equal(as.character(x[3]), c(c = 'itis'))
  expect_equal(names(x), letters[1:3])
})

# Printing taxon_db objects

test_that("taxon_db objects can be printed", {
  x <- taxon_db(as.factor(c('ncbi', 'ncbi', 'itis')))
  verify_output(path = test_path('print_outputs', 'taxon_db.txt'),
                code = {print(x)},
                crayon = TRUE)
})

test_that("taxon_db objects can be printed in tables", {
  x <- taxon_db(as.factor(c('ncbi', 'ncbi', 'itis')))
  verify_output(path = test_path('print_outputs', 'taxon_db_tibble.txt'),
                code = {print(tibble::tibble(x))},
                crayon = TRUE)
  verify_output(path = test_path('print_outputs', 'taxon_db_data_frame.txt'),
                code = {print(data.frame(x))},
                crayon = TRUE)
})


# Subsetting taxon_db objects

test_that("taxon_db objects can be `[` subset by index", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(length(x[1:2]), 2)
  expect_equal(x[2:3], taxon_db(c('ncbi', 'itis')))
})

test_that("taxon_db objects can be `[` subset by logical vector", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(length(x[c(FALSE, TRUE, FALSE)]), 1)
  expect_equal(x[c(FALSE, TRUE, TRUE)], taxon_db(c('ncbi', 'itis')))
})

test_that("taxon_db objects can be `[` subset by name", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(length(x[c('a', 'b')]), 2)
  expect_equal(x[c('b', 'c')], taxon_db(c('ncbi', 'itis'), .names = letters[2:3]))
})


# Subsetting taxon_db objects

test_that("taxon_db objects can be `[[` subset by index", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(length(x[[1]]), 1)
  expect_equal(x[[3]], taxon_db('itis'))
})

test_that("taxon_db objects can be `[[` subset by name", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(length(x[['c']]), 1)
  expect_equal(x[['c']], taxon_db('itis')) # names are dropped for [[
})


# Setting names of taxon_db objects

test_that("taxon_db objects can be named", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  names(x) <- letters[1:3]
  expect_equal(x, taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3]))
  expect_equal(names(x),  letters[1:3])
  names(x)[2] <- 'd'
  expect_equal(names(x), c('a', 'd', 'c'))
})


# Assigning values to taxon_db objects

test_that("taxon_db objects can have values assigned to them", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  x[2] <- 'gbif'
  expect_equal(x[2], taxon_db('gbif', .names = letters[2]))
  x['b'] <- 'gbif'
  expect_equal(x[2], taxon_db('gbif', .names = letters[2]))
  x[c(FALSE, TRUE, FALSE)] <- 'gbif'
  expect_equal(x[2], taxon_db('gbif', .names = letters[2]))
})

test_that("taxon_db assignment is recycled correctly", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  x[1:3] <- 'gbif'
  expect_equal(x,  taxon_db(c('gbif', 'gbif', 'gbif'), .names = letters[1:3]))
})


# Invalid values cannot be assigned

test_that("taxon_db objects cannot be created with invalid values", {
  expect_error(taxon_db('not_valid'), "Taxon database names must be defined in `db_ref`")
  expect_error(taxon_db(c('gbif', 'not_valid')), "Taxon database names must be defined in `db_ref`")

})

test_that("taxon_db objects cannot be assigned invalid values woth `[`", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_error(x[2] <- 'not_valid', "Taxon database names must be defined in `db_ref`")
})

test_that("taxon_db objects cannot be assigned invalid values woth `[[`", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_error(x[[2]] <- 'not_valid', "Taxon database names must be defined in `db_ref`")
})


# Can be concatenated

test_that("taxon_db objects can be combined", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(c(x, x), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 2)))
  expect_equal(c(x, x, x), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 3)))
})

test_that("named taxon_db objects can be combined", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(c(x, x), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(c(x, x, x), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 3), .names = rep(letters[1:3], 3)))
})


# Works with `rep`

test_that("taxon_db objects work with `rep`", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(rep(x, 2), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 2)))
  expect_equal(rep(x, 3), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 3)))
})

test_that("named taxon_db objects work with `rep`", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(rep(x, 2), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(rep(x, 3), taxon_db(rep(c('ncbi', 'ncbi', 'itis'), 3), .names = rep(letters[1:3], 3)))
})

# Works with `seq_along`

test_that("taxon_db objects work with `seq_along`", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(seq_along(x), 1:3)
})

test_that("named taxon_db objects work with `seq_along`", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(seq_along(x), 1:3)
})


# Can be converted to character

test_that("taxon_db objects can be converted to characters", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(as.character(x), c('ncbi', 'ncbi', 'itis'))
})

test_that("named taxon_db objects can be converted to characters", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(as.character(x), c(a = 'ncbi', b = 'ncbi', c = 'itis'))
})


# Can be converted to factor

test_that("taxon_db objects can be converted to factor", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(as.factor(x), as.factor(c('ncbi', 'ncbi', 'itis')))
})

test_that("named taxon_db objects can be converted to factor", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(as.factor(x), as.factor(c(a = 'ncbi', b = 'ncbi', c= 'itis')))
})


# Can be converted to a data.frame

test_that("taxon_db objects can be converted to a data.frame", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(
    as_data_frame(x),
    data.frame(tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})

test_that("named taxon_db objects can be converted to data.frame", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(
    as_data_frame(x),
    data.frame(tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})


# Can be converted to a tibble

test_that("taxon_db objects can be converted to a tibble", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'))
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})

test_that("named taxon_db objects can be converted to a tibble", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_db = c('ncbi', 'ncbi', 'itis'))
  )
})


# works with %in%

test_that("taxon_db objects work with %in%", {
  x <- taxon_db(c('ncbi', 'ncbi', 'itis'), .names = letters[1:3])
  expect_true('ncbi' %in% x)
  expect_true(factor('ncbi') %in% x)
  expect_equal(x %in% 'itis', c(FALSE, FALSE, TRUE))
  expect_equal(x %in% 'itis', x %in% factor('itis'))
  expect_true(x[1] %in% x)
  expect_equal(x %in% x[2],  c(TRUE, TRUE, FALSE))
})

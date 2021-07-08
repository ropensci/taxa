context("taxon_authority")
library(taxa)


# Creating taxon_authority objects

test_that("taxon_authority objects can be created from character input", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_authority')
  expect_true(is_taxon_authority(x))
  expect_equal(as.character(x[2]), 'L. 1753')
})

test_that("taxon_authority objects can be created from factor input", {
  x <- taxon_authority(as.factor(c('Cham. & Schldl.', 'L.', 'Billy')), date = as.factor(c('1827', '1753', '2000')))
  expect_equal(x, taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000')))
})

test_that("taxon_authority objects can be created with names", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon_authority')
  expect_equal(as.character(x[2]), c(b = 'L. 1753'))
  expect_equal(names(x), letters[1:3])
})

# Printing taxon_authority objects

test_that("taxon_authority objects can be printed", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  verify_output(path = test_path('print_outputs', 'taxon_authority.txt'),
                code = {print(x)},
                crayon = TRUE)
})

test_that("taxon_authority objects can be printed in tables", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  verify_output(path = test_path('print_outputs', 'taxon_authority_tibble.txt'),
                code = {print(tibble::tibble(x))},
                crayon = TRUE)
  verify_output(path = test_path('print_outputs', 'taxon_authority_data_frame.txt'),
                code = {print(data.frame(x))},
                crayon = TRUE)
})

# Subsetting taxon_authority objects with `[`

test_that("taxon_authority objects can be `[` subset by index", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  expect_equal(length(x[1:2]), 2)
  expect_equal(x[2:3], taxon_authority(c('L.', 'Billy'), date = c('1753', '2000')))
})

test_that("taxon_authority objects can be `[` subset by logical vector", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  expect_equal(length(x[c(FALSE, TRUE, FALSE)]), 1)
  expect_equal(x[c(FALSE, TRUE, TRUE)], taxon_authority(c('L.', 'Billy'), date = c('1753', '2000')))
})

test_that("taxon_authority objects can be `[` subset by name", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  expect_equal(length(x[c('a', 'b')]), 2)
  expect_equal(x[c('b', 'c')], taxon_authority(c('L.', 'Billy'), date = c('1753', '2000'), .names = letters[2:3]))
})


# Subsetting taxon_authority objects with `[[`

test_that("taxon_authority objects can be `[[` subset by index", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  expect_equal(length(x[[1]]), 1)
  expect_equal(x[[3]], taxon_authority(author = 'Billy', date = '2000'))
})

test_that("taxon_authority objects can be `[[` subset by name", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  expect_equal(length(x[['c']]), 1)
  expect_equal(x[['c']], taxon_authority(author = 'Billy', date = '2000')) # names are dropped for [[
})


# Setting names of taxon_authority objects

test_that("taxon_authority objects can be named", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  names(x) <- letters[1:3]
  expect_equal(names(x),  letters[1:3])
  names(x)[2] <- 'd'
  expect_equal(names(x), c('a', 'd', 'c'))
})


# Assigning values to taxon_authority objects

test_that("taxon_authority objects can have values assigned to them", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  x[2] <- '4'
  expect_equal(x[2], taxon_authority('4', .names = letters[2]))
  x[[2]] <- '5'
  expect_equal(x[2], taxon_authority('5', .names = letters[2]))
  x['b'] <- '4'
  expect_equal(x[2], taxon_authority('4', .names = letters[2]))
  x[c(FALSE, TRUE, FALSE)] <- '4'
  expect_equal(x[2], taxon_authority('4', .names = letters[2]))
})

test_that("taxon_authority assignment is recycled correctly", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  x[1:3] <- '4'
  expect_equal(x,  taxon_authority(c('4', '4', '4'), .names = letters[1:3]))
})

test_that("(taxon_authority) multiple items can not be used with [[", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  expect_error(x[[1:3]] <- '4', 'attempt to select more than one element')
  expect_error(x[[1:3]], 'attempt to select more than one element')
})


# Assign info for components

test_that("taxon_authority objects can be combined", {
  x <- taxon_authority(c('1', '2', '3'))
  tax_cite(x) <- c('a', 'b', 'c')
  expect_equal(tax_cite(x), c('a', 'b', 'c'))
  tax_date(x) <- c('1', '2', '3')
  expect_equal(tax_date(x), c('1', '2', '3'))
  tax_author(x) <- c('x', 'y', 'x')
  expect_equal(tax_author(x), c('x', 'y', 'x'))
})


# Can be concatenated

test_that("taxon_authority objects can be combined", {
  x <- taxon_authority(c('1', '2', '3'))
  expect_equal(c(x, x), taxon_authority(rep(c('1', '2', '3'), 2)))
  expect_equal(c(x, x, x), taxon_authority(rep(c('1', '2', '3'), 3)))
})

test_that("named taxon_authority objects can be combined", {
  x <- taxon_authority(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(c(x, x), taxon_authority(rep(c('1', '2', '3'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(c(x, x, x), taxon_authority(rep(c('1', '2', '3'), 3), .names = rep(letters[1:3], 3)))
})


# Works with `rep`

test_that("taxon_authority objects work with `rep`", {
  x <- taxon_authority(c('1', '2', '3'))
  expect_equal(rep(x, 2), taxon_authority(rep(c('1', '2', '3'), 2)))
  expect_equal(rep(x, 3), taxon_authority(rep(c('1', '2', '3'), 3)))
})

test_that("named taxon_authority objects work with `rep`", {
  x <- taxon_authority(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(rep(x, 2), taxon_authority(rep(c('1', '2', '3'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(rep(x, 3), taxon_authority(rep(c('1', '2', '3'), 3), .names = rep(letters[1:3], 3)))
})

# Works with `seq_along`

test_that("taxon_authority objects work with `seq_along`", {
  x <- taxon_authority(c('1', '2', '3'))
  expect_equal(seq_along(x), 1:3)
})

test_that("named taxon_authority objects work with `seq_along`", {
  x <- taxon_authority(c('1', '2', '3'), .names = letters[1:3])
  expect_equal(seq_along(x), 1:3)
})


# Can be converted to character

test_that("taxon_authority objects can be converted to characters", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  expect_equal(as.character(x), paste(c('Cham. & Schldl.', 'L.', 'Billy'), c('1827', '1753', '2000')))
})

test_that("named taxon_authority objects can be converted to characters", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  expect_equal(as.character(x), stats::setNames(paste(c('Cham. & Schldl.', 'L.', 'Billy'), c('1827', '1753', '2000')), letters[1:3]))
})


# Can be converted to factor

test_that("taxon_authority objects can be converted to factor", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'))
  expect_equal(as.factor(x), as.factor(paste(c('Cham. & Schldl.', 'L.', 'Billy'), c('1827', '1753', '2000'))))
})

test_that("named taxon_authority objects can be converted to factor", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), .names = letters[1:3])
  expect_equivalent(as.factor(x), as.factor(stats::setNames(paste(c('Cham. & Schldl.', 'L.', 'Billy'), c('1827', '1753', '2000')), letters[1:3])))
})


# Can be converted to a data.frame

test_that("taxon_authority objects can be converted to a data.frame", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), citation = c(NA, NA, 'cite'))
  expect_equal(
    as_data_frame(x),
    data.frame(tax_author = c('Cham. & Schldl.', 'L.', 'Billy'), tax_date = c('1827', '1753', '2000'), tax_cite = c(NA, NA, 'cite'))
  )
})

test_that("named taxon_authority objects can be converted to data.frame", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), citation = c(NA, NA, 'cite'), .names = letters[1:3])
  expect_equal(
    as_data_frame(x),
    data.frame(tax_author = c('Cham. & Schldl.', 'L.', 'Billy'), tax_date = c('1827', '1753', '2000'), tax_cite = c(NA, NA, 'cite'))
  )
})


# Can be converted to a tibble

test_that("taxon_authority objects can be converted to a tibble", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'), date = c('1827', '1753', '2000'), citation = c(NA, NA, 'cite'))
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_author = c('Cham. & Schldl.', 'L.', 'Billy'), tax_date = c('1827', '1753', '2000'), tax_cite = c(NA, NA, 'cite'))
  )
})

test_that("named taxon_authority objects can be converted to a tibble", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'),
                       date = c('1827', '1753', '2000'),
                       citation = c(NA, NA, 'cite'),
                       .names = letters[1:3])
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_author = c('Cham. & Schldl.', 'L.', 'Billy'), tax_date = c('1827', '1753', '2000'), tax_cite = c(NA, NA, 'cite'))
  )
})

# works with %in%

test_that("taxon objects work with %in%", {
  x <- taxon_authority(c('Cham. & Schldl.', 'L.', 'Billy'),
                       date = c('1827', '1753', '2000'),
                       citation = c(NA, NA, 'cite'),
                       .names = letters[1:3])
  expect_true('L. 1753' %in% x)
  expect_equal(x %in% 'L. 1753', c(FALSE, TRUE, FALSE))
  expect_true(x[1] %in% x)
  expect_equal(x %in% x[2],  c(FALSE, TRUE, FALSE))
})


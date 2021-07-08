context("taxon_rank")
library(taxa)


# Creating taxon_rank objects

test_that("taxon_rank objects can be created from character input", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(length(x), 6)
  expect_equal(length(levels(x)), 5)
  expect_equal(class(x)[1], 'taxa_taxon_rank')
  expect_equal(as.character(x[3]), 'phylum')
})

test_that("taxon_rank objects can be created from factor input", {
  x <- taxon_rank(as.factor(c('species', 'species', 'phylum', 'family', 'customA', 'customB')))
  expect_equal(x, taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB')))
})

test_that("taxon_rank objects can be created with names", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(length(x), 6)
  expect_equal(names(x), letters[1:6])
  expect_equal(length(levels(x)), 5)
  expect_equal(class(x)[1], 'taxa_taxon_rank')
  expect_equal(as.character(x[3]), c(c = 'phylum'))
})

# Printing taxon objects

test_that("taxon_id objects can be printed", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  verify_output(path = test_path('print_outputs', 'taxon_rank.txt'),
                code = {print(x)},
                crayon = TRUE)
})

# Subsetting taxon_rank objects with `[`

test_that("taxon_rank objects can be `[` subset by index", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(length(x[1:2]), 2)
  expect_equal(x[2:3], taxon_rank(c('species', 'phylum'), levels = levels(x)))
})

test_that("taxon_rank objects can be `[` subset by logical vector", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(length(x[c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE)]), 1)
  expect_equal(x[c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE)],
               taxon_rank(c('species', 'phylum'), levels = levels(x)))
})

test_that("taxon_rank objects can be `[` subset by name", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(length(x[c('a', 'b')]), 2)
  expect_equal(x[c('b', 'c')], taxon_rank(c('species', 'phylum'), .names = letters[2:3], levels = levels(x)))
})


# Subsetting taxon_rank objects with `[[`

test_that("taxon_rank objects can be `[[` subset by index", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(length(x[[1]]), 1)
  expect_equal(x[[3]], taxon_rank('phylum', levels = levels(x)))
})

test_that("taxon_rank objects can be `[[` subset by name", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(length(x[['c']]), 1)
  expect_equal(x[['c']], taxon_rank('phylum', levels = levels(x)))
})


# Setting names of taxon_rank objects

test_that("taxon_rank objects can be named", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  names(x) <- letters[1:6]
  expect_equal(names(x),  letters[1:6])
  names(x)[2] <- 'x'
  expect_equal(names(x)[2], 'x')
})


# Assigning values to taxon_rank objects

test_that("taxon_rank objects can have values assigned to them", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  x[2] <- 'family'
  expect_equal(x[2], taxon_rank('family', levels = levels(x), .names = 'b'))
  x[[2]] <- 'species'
  expect_equal(x[2], taxon_rank('species', levels = levels(x), .names = 'b'))
  x['c'] <- 'family'
  expect_equal(x[3], taxon_rank('family', levels = levels(x), .names ='c'))
  x[c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)] <- 'family'
  expect_equal(x[4], taxon_rank('family', levels = levels(x), .names = 'd'))
})

test_that("taxon_rank assignment is recycled correctly", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  x[1:3] <- 'family'
  expect_equal(x[1:3],  taxon_rank(rep('family', 3), levels = levels(x), .names = letters[1:3]))
})


# Can be concatenated

test_that("taxon_rank objects can be combined", {
  x <- taxon_rank(c('species', 'species', 'phylum'))
  expect_equal(c(x, x), taxon_rank(rep(c('species', 'species', 'phylum'), 2)))
  expect_equal(c(x, x, x), taxon_rank(rep(c('species', 'species', 'phylum'), 3)))
})

test_that("taxon_rank objects with different levels can be combined", {
  expect_equal(
    c(taxon_rank(c('species', 'species', 'phylum')), taxon_rank(c('family', 'customA', 'customB'))),
    taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  )
  expect_equal(
    c(taxon_rank(c('species', 'species')), taxon_rank(c('phylum', 'family')), taxon_rank(c('customA', 'customB'))),
    taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  )
})

test_that("named taxon_rank objects can be combined", {
  x <- taxon_rank(c('species', 'species', 'phylum'), .names = letters[1:3])
  expect_equal(c(x, x), taxon_rank(rep(c('species', 'species', 'phylum'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(c(x, x, x), taxon_rank(rep(c('species', 'species', 'phylum'), 3), .names = rep(letters[1:3], 3)))
})

test_that("named taxon_rank objects with different levels can be combined", {
  expect_equal(
    c(taxon_rank(c('species', 'species', 'phylum'), .names = letters[1:3]),
      taxon_rank(c('family', 'customA', 'customB'), .names = letters[4:6])),
    taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  )
  expect_equal(
    c(taxon_rank(c('species', 'species'), .names = letters[1:2]),
      taxon_rank(c('phylum', 'family'), .names = letters[3:4]),
      taxon_rank(c('customA', 'customB'), .names = letters[5:6])),
    taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  )
})


# Works with `rep`

test_that("taxon_rank objects work with `rep`", {
  x <- taxon_rank(c('species', 'species', 'phylum'))
  expect_equal(rep(x, 2), taxon_rank(rep(c('species', 'species', 'phylum'), 2)))
  expect_equal(rep(x, 3), taxon_rank(rep(c('species', 'species', 'phylum'), 3)))
})

test_that("named taxon_rank objects work with `rep`", {
  x <- taxon_rank(c('species', 'species', 'phylum'), .names = letters[1:3])
  expect_equal(rep(x, 2), taxon_rank(rep(c('species', 'species', 'phylum'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(rep(x, 3), taxon_rank(rep(c('species', 'species', 'phylum'), 3), .names = rep(letters[1:3], 3)))
})

# Works with `seq_along`

test_that("taxon_rank objects work with `seq_along`", {
  x <- taxon_rank(c('species', 'species', 'phylum'))
  expect_equal(seq_along(x), 1:3)
})

test_that("named taxon_rank objects work with `seq_along`", {
  x <- taxon_rank(c('species', 'species', 'phylum'), .names = letters[1:3])
  expect_equal(seq_along(x), 1:3)
})


# Can be converted to character

test_that("taxon_rank objects can be converted to characters", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(as.character(x), c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
})

test_that("named taxon_rank objects can be converted to characters", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(as.character(x), stats::setNames(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), letters[1:6]))
})


# Can be converted to factor

test_that("taxon_rank objects can be converted to factor", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(
    as.factor(x),
    factor(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), levels = names(levels(x)))
  )
})

test_that("named taxon_rank objects can be converted to factor", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(
    as.factor(x),
    stats::setNames(factor(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), levels = names(levels(x))), letters[1:6])
  )
})


# Can be converted to a data.frame

test_that("taxon_rank objects can be converted to a data.frame", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(
    as_data_frame(x),
    data.frame(tax_rank = as.character(x))
  )
})

test_that("named taxon_rank objects can be converted to data.frame", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(
    as_data_frame(x),
    data.frame(tax_rank = unname(as.character(x)))
  )
})


# Can be converted to a tibble

test_that("taxon_rank objects can be converted to a tibble", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'))
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_rank = as.character(x))
  )
})

test_that("named taxon_rank objects can be converted to a tibble", {
  x <- taxon_rank(c('species', 'species', 'phylum', 'family', 'customA', 'customB'), .names = letters[1:6])
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_rank = unname(as.character(x)))
  )
})

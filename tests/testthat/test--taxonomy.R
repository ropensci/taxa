context("taxonomy")
library(taxa)


# Creating taxonomy objects

test_that("taxonomy objects can be created from character input", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  expect_equal(length(x), 8)
  expect_equal(class(x)[1], 'taxa_taxonomy')
})

test_that("taxonomy objects can be created from factor input", {
  x <- taxonomy(as.factor(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                            'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  expect_equal(length(x), 8)
  expect_equal(class(x)[1], 'taxa_taxonomy')
})

test_that("taxonomy objects can be created with names", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_equal(length(x), 8)
  expect_equal(class(x)[1], 'taxa_taxonomy')
  expect_equal(names(x), letters[1:8])
})


# Printing

test_that("taxonomy objects can be printed", {
  x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                               'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                      rank = c('order', 'family', 'genus', 'species',
                               'species', 'family', 'genus', 'species'),
                      id = taxon_id(c('33554', '9681', '9688', '9689',
                                      '9694', '9632', '9639', '9644'),
                                    db = 'ncbi'),
                      auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
                               'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  names(x) <- letters[1:8]
  verify_output(path = test_path('print_outputs', 'taxonomy.txt'),
                code = {print(x)},
                crayon = TRUE)
})


# Subsetting taxonomy objects with `[`

test_that("taxonomy objects can be `[` subset by index", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])

  # By default, all subtaxa are included
  expect_equal(names(x[1]), letters[1:8])
  expect_equal(names(x['c']), c('c', 'd', 'e'))
  expect_equal(names(x[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE)]), 'e')

  ## Can turn off inclusion of subtaxa
  expect_equal(names(x[1, subtaxa = FALSE]), 'a')
  expect_equal(names(x['c', subtaxa = FALSE]), 'c')
  expect_equal(names(x[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE), subtaxa = FALSE]), 'e')

  ## Can include supertaxa
  expect_equal(names(x[1, supertaxa = TRUE]), letters[1:8])
  expect_equal(names(x['c', supertaxa = TRUE]), c("a", "b", "c", "d", "e"))
  expect_equal(names(x[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE), supertaxa = TRUE]), c("a", "b", "c", "e"))

  ## Can include only supertaxa
  expect_equal(names(x[1, subtaxa = FALSE, supertaxa = TRUE]), 'a')
  expect_equal(names(x['c', subtaxa = FALSE, supertaxa = TRUE]), c("a", "b", "c"))
  expect_equal(names(x[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE), subtaxa = FALSE, supertaxa = TRUE]), c("a", "b", "c", "e"))

  ## Can invert the selection
  expect_equal(length(x[1, invert = TRUE]), 0)
  expect_equal(names(x['c', invert = TRUE]), c("a", "b", "f", "g", "h"))
  expect_equal(names(x['c', supertaxa = TRUE, invert = TRUE]), c("f", "g", "h"))
  expect_equal(names(x['c', subtaxa = FALSE, invert = TRUE]), c("a", "b", "d", "e", "f", "g", "h"))
  expect_equal(names(x['c', subtaxa = FALSE, supertaxa = TRUE, invert = TRUE]), c("d", "e", "f", "g", "h"))
})


# Subsetting taxonomy objects with `[[`

test_that("taxonomy objects can be subset with `[[`", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_equal(x[3], x[[3]])
  expect_equal(x['c'], x[['c']])
  expect_equal(x[5], x[[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE)]])
})

test_that("subsetting taxonomy objects with `[[` only allows for a single selection", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_error(x[[1:2]], "attempt to select more than one element")
  expect_error(x[[c('e', 'f')]], "attempt to select more than one element")
  expect_error(x[[c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE)]], "attempt to select more than one element")
  expect_error(x[[numeric(0)]], "attempt to select less than one element")
  expect_error(x[[character(0)]], "attempt to select less than one element")
  expect_error(x[[c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)]], "attempt to select less than one element")
})



# Setting names of taxonomy objects

test_that("taxonomy objects can be named", {
  x <- taxonomy(as.factor(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                            'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  names(x) <- letters[1:8]
  expect_equal(x, taxonomy(as.factor(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                       'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos')),
                           supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                           .names = letters[1:8]))
  expect_equal(names(x),  letters[1:8])
  names(x)[2] <- 'x'
  expect_equal(names(x), c("a", "x", "c", "d", "e", "f", "g", "h"))
  names(x)[2:3] <- 'x'
  expect_equal(names(x), c("a", "x", "x", "d", "e", "f", "g", "h"))
})


# Assigning values to taxonomy objects

test_that("Replacing a value with no taxonomic context does not change its place in the tree", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])

  x[3] <- 'XXX'
  expect_equal(length(x), 8)
  expect_equal(supertaxa(x, subset = 3, max_depth = 1)[[1]], c(b = 2))
  expect_equal(vctrs::field(x, 'supertaxa')[4:5], c(3, 3))
})

# Assign values to components

test_that("components of taxonomy objects can be assigned", {
  x <- taxonomy(c('A', 'B', 'C'))
  tax_auth(x) <- c('a', 'b', 'c')
  expect_equal(tax_auth(x), taxon_authority(c('a', 'b', 'c')))
  tax_name(x) <- c('d', 'e', 'f')
  expect_equal(tax_name(x), c('d', 'e', 'f'))
  tax_rank(x) <- c('a', 'b', 'c')
  expect_equal(tax_rank(x), taxon_rank(c('a', 'b', 'c')))
  tax_id(x) <- c('1', '2', '3')
  expect_equal(tax_id(x), taxon_id(c('1', '2', '3')))
  tax_db(x) <- c('ncbi', 'ncbi', 'ncbi')
  expect_equal(tax_db(x), taxon_db(c('ncbi', 'ncbi', 'ncbi')))
  tax_author(x) <- c('g', 'h', 'i')
  expect_equal(tax_author(x), c('g', 'h', 'i'))
  tax_date(x) <- c('4', '5', '6')
  expect_equal(tax_date(x), c('4', '5', '6'))
  tax_cite(x) <- c('x', 'y', 'z')
  expect_equal(tax_cite(x), c('x', 'y', 'z'))
})

# NOTE: It seems vctrs does not allow defining new values by index. Not sure if we will try to make this work anyway
#
# test_that("New values with no taxonomic context are added at the root of the tree", {
#   x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#                 supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
#                 .names = letters[1:8])
#
#   x[9] <- 'XXX'
#   expect_equal(length(x), 9)
#   expect_true(is_root(x)[9])
#
#   x[11] <- 'YYY'
#   expect_equal(length(x), 11)
#   expect_true(all(is_root(x)[9:11]))
# })

test_that("Replacing a value with specified supertaxon preserves its subtaxa", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  x[3, supertaxa = 6] <- 'XXX'
  expect_equal(length(x), 8)
  expect_equal(vctrs::field(x, 'supertaxa')[3], 6)
  expect_equal(vctrs::field(x, 'supertaxa')[4:5], c(3, 3))
})

test_that("Replacing a value with specified supertaxon cant make cyclical trees", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  x[3, supertaxa = 4] <- 'XXX'
  expect_equal(length(x), 8)
  expect_equal(vctrs::field(x, 'supertaxa')[3], 4)
  expect_equal(vctrs::field(x, 'supertaxa')[5], 3)
})

# NOTE: It seems vctrs does not allow defining new values by index. Not sure if we will try to make this work anyway
#
# test_that("Adding a value with specified supertaxon", {
#   x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#                 supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
#                 .names = letters[1:8])
#   x[9, supertaxa = 6] <- 'XXX'
#   expect_equal(length(x), 9)
#   expect_equal(vctrs::field(x, 'supertaxa')[9], 6)
# })

test_that("Replacing a value with specified subtaxa sets its supertaxon to the common grouping of the subtaxa", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  x[2, subtaxa = 7:8] <- 'XXX'
  expect_equal(length(x), 8)
  expect_equal(vctrs::field(x, 'supertaxa')[2], 6)
  expect_equal(vctrs::field(x, 'supertaxa')[7], 2)
})

# NOTE: It seems vctrs does not allow defining new values by index. Not sure if we will try to make this work anyway
#
# test_that("Adding a value with specified subtaxa sets its supertaxon to the common grouping of the subtaxa", {
#   x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
#                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
#                 supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
#                 .names = letters[1:8])
#   x[9, subtaxa = 7:8] <- 'XXX'
#   expect_equal(length(x), 9)
#   expect_equal(vctrs::field(x, 'supertaxa')[9], 6)
#   expect_equal(vctrs::field(x, 'supertaxa')[7], 9)
# })

test_that("Replacing a value with specified subtaxa cant make cyclical trees", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  x[3, subtaxa = 2] <- 'XXX'
  expect_equal(length(x), 8)
  expect_equal(vctrs::field(x, 'supertaxa')[3], 1)
  expect_equal(vctrs::field(x, 'supertaxa')[2], 3)
})

test_that("Cannot make values supertaxa/subtaxa of themselves", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_error(x[2, supertaxa = 2] <- 'XXX', 'Cannot set a taxon to be a supertaxon of itself')
  expect_error(x[1:2, supertaxa = 2] <- 'XXX', 'Cannot set a taxon to be a supertaxon of itself')
  expect_error(x[2, subtaxa = 2] <- 'XXX', 'Cannot set a taxon to be a subtaxon of itself')
  expect_error(x[2, subtaxa = 2:3] <- 'XXX', 'Cannot set a taxon to be a subtaxon of itself')
})






# Can be concatenated

test_that("taxonomy objects can be combined", {
  x <- taxonomy(taxon(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                        'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                      rank = c('order', 'family', 'genus', 'species',
                               'species', 'family', 'genus', 'species')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  y <- taxonomy(taxon(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo'),
                      rank = c('order', 'family', 'genus', 'species')),
                supertaxa = c(NA, 1, 2, 3),
                .names = letters[1:4])
  z <- taxonomy(taxon(c('Carnivora', 'Felidae'), rank = c('order', 'family')),
                supertaxa = c(NA, 1),
                .names = letters[1:2])
  expect_equal(
    c(x, y),
    taxonomy(taxon(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                     'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos',
                     'Carnivora', 'Felidae', 'Panthera', 'Panthera leo'),
                   rank = c('order', 'family', 'genus', 'species',
                            'species', 'family', 'genus', 'species',
                            'order', 'family', 'genus', 'species')),
             supertaxa = c(c(NA, 1, 2, 3, 3, 1, 6, 7),  c(NA, 1, 2, 3) + 8),
             .names = c(letters[1:8], letters[1:4]))
  )
  expect_equal(
    c(x, y, z),
    taxonomy(taxon(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                     'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos',
                     'Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                     'Carnivora', 'Felidae'),
                   rank = c('order', 'family', 'genus', 'species',
                            'species', 'family', 'genus', 'species',
                            'order', 'family', 'genus', 'species',
                            'order', 'family')),
             supertaxa = c(c(NA, 1, 2, 3, 3, 1, 6, 7),  c(NA, 1, 2, 3) + 8, c(NA, 1) + 12),
             .names = c(letters[1:8], letters[1:4], letters[1:2]))
  )
  expect_equal(c(x, y, x, y), c(c(x, y), c(x, y)))
  expect_equal(c(x), x)
})




# Works with `seq_along`

test_that("taxonomy objects work with `seq_along`", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_equal(seq_along(x), 1:8)
})


# Can be converted to character

test_that("taxonomy objects can be converted to characters", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  expect_equal(as.character(x),
               c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'))
})

test_that("named taxonomy objects can be converted to characters", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_equal(as.character(x),
               stats::setNames(
                 c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                 letters[1:8]
               ))
})


# Can be converted to factor

test_that("taxonomy objects can be converted to factor", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  expect_equivalent(as.factor(x), as.factor(as.character(x)))
})

test_that("named taxonomy objects can be converted to factor", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7),
                .names = letters[1:8])
  expect_equivalent(as.factor(x), as.factor(as.character(x)))
})


# Can be converted to a data.frame

test_that("taxonomy objects can be converted to a data.frame", {
  x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                               'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                      rank = c('order', 'family', 'genus', 'species',
                               'species', 'family', 'genus', 'species'),
                      id = taxon_id(c('33554', '9681', '9688', '9689',
                                      '9694', '9632', '9639', '9644'),
                                    db = 'ncbi'),
                      auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
                               'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))

  expect_equal(
    as_data_frame(x),
    data.frame(
      supertaxon = c(NA, 1, 2, 3, 3, 1, 6, 7),
      tax_name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
      tax_rank = c('order', 'family', 'genus', 'species',
                   'species', 'family', 'genus', 'species'),
      tax_id = c('33554', '9681', '9688', '9689',
                 '9694', '9632', '9639', '9644'),
      tax_db = 'ncbi',
      tax_author = c('Bowdich', 'Fischer de Waldheim', 'Oken', 'L.',
                     'L.', 'Fischer de Waldheim', 'L.', 'L.'),
      tax_date = c('1821', '1817', '1816', '1758',
                   '1758', '1817', '1758', '1758'),
      tax_cite = ''
      )
  )
})

test_that("named taxonomy objects can be converted to data.frame", {
  x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                               'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                      rank = c('order', 'family', 'genus', 'species',
                               'species', 'family', 'genus', 'species'),
                      id = taxon_id(c('33554', '9681', '9688', '9689',
                                      '9694', '9632', '9639', '9644'),
                                    db = 'ncbi'),
                      auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
                               'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  names(x) <- letters[1:8]

  expect_equal(
    as_data_frame(x),
    data.frame(
      supertaxon = c(NA, 1, 2, 3, 3, 1, 6, 7),
      tax_name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
      tax_rank = c('order', 'family', 'genus', 'species',
                   'species', 'family', 'genus', 'species'),
      tax_id = c('33554', '9681', '9688', '9689',
                 '9694', '9632', '9639', '9644'),
      tax_db = 'ncbi',
      tax_author = c('Bowdich', 'Fischer de Waldheim', 'Oken', 'L.',
                     'L.', 'Fischer de Waldheim', 'L.', 'L.'),
      tax_date = c('1821', '1817', '1816', '1758',
                   '1758', '1817', '1758', '1758'),
      tax_cite = ''
    )
  )
})


# Can be converted to a tibble

test_that("taxonomy objects can be converted to a tibble", {
  x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                               'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                      rank = c('order', 'family', 'genus', 'species',
                               'species', 'family', 'genus', 'species'),
                      id = taxon_id(c('33554', '9681', '9688', '9689',
                                      '9694', '9632', '9639', '9644'),
                                    db = 'ncbi'),
                      auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
                               'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))

  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(
      supertaxon = c(NA, 1, 2, 3, 3, 1, 6, 7),
      tax_name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
      tax_rank = c('order', 'family', 'genus', 'species',
                   'species', 'family', 'genus', 'species'),
      tax_id = c('33554', '9681', '9688', '9689',
                 '9694', '9632', '9639', '9644'),
      tax_db = 'ncbi',
      tax_author = c('Bowdich', 'Fischer de Waldheim', 'Oken', 'L.',
                     'L.', 'Fischer de Waldheim', 'L.', 'L.'),
      tax_date = c('1821', '1817', '1816', '1758',
                   '1758', '1817', '1758', '1758'),
      tax_cite = ''
    )
  )
})

test_that("named taxonomy objects can be converted to a tibble", {
  x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                               'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                      rank = c('order', 'family', 'genus', 'species',
                               'species', 'family', 'genus', 'species'),
                      id = taxon_id(c('33554', '9681', '9688', '9689',
                                      '9694', '9632', '9639', '9644'),
                                    db = 'ncbi'),
                      auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
                               'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  names(x) <- letters[1:8]

  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(
      supertaxon = c(NA, 1, 2, 3, 3, 1, 6, 7),
      tax_name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                   'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
      tax_rank = c('order', 'family', 'genus', 'species',
                   'species', 'family', 'genus', 'species'),
      tax_id = c('33554', '9681', '9688', '9689',
                 '9694', '9632', '9639', '9644'),
      tax_db = 'ncbi',
      tax_author = c('Bowdich', 'Fischer de Waldheim', 'Oken', 'L.',
                     'L.', 'Fischer de Waldheim', 'L.', 'L.'),
      tax_date = c('1821', '1817', '1816', '1758',
                   '1758', '1817', '1758', '1758'),
      tax_cite = ''
    )
  )
})


# Can be made unique

test_that("taxa in taxonomy objects can be made unique", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  y <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Kitty'),
                supertaxa = c(NA, 1, 2, 3, 3, 3))
  x <- c(x, y)

  expect_equal(
    unique(x),
    taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
               'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos', 'Kitty'),
             supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7, 3))
  )
})


# works with %in%

test_that("taxonomy objects work with %in%", {
  x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                  'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
  expect_true('Carnivora' %in% x)
  expect_equal(x %in% 'Carnivora', tax_name(x) %in% 'Carnivora')
  expect_true(x[1, subtaxa = FALSE] %in% x)
  expect_equal(x %in% x[1, subtaxa = FALSE], tax_name(x) %in% 'Carnivora')
  expect_false('sapiens' %in% x)
  expect_true(factor('Carnivora') %in% x)
  expect_equal(which(x %in% factor('Carnivora')), 1)
})

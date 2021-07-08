context("classification")
library(taxa)


# Creating classification objects

test_that("classification objects can be created from character input", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)))
  expect_equal(length(x), 12)
  expect_equal(class(x)[1], 'taxa_classification')
})

test_that("classification objects can be created from factor input", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(as.factor(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                           'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos')),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)))
  expect_equal(length(x), 12)
  expect_equal(class(x)[1], 'taxa_classification')
})

test_that("classification objects can be created with names", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)),
                      .names = letters[1:12])
  expect_equal(length(x), 12)
  expect_equal(class(x)[1], 'taxa_classification')
  expect_equal(names(x), letters[1:12])
})

test_that("classification objects can be created with a list of taxon info", {
  x <- classification(list(
    c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo'),
    c('Carnivora', 'Felidae', 'Panthera', 'Panthera tigris'),
    c('Carnivora', 'Ursidae', 'Ursus', 'Ursus arctos'),
    c('Carnivora', 'Ursidae', 'Ursus', 'Ursus arctos'),
    c('Carnivora', 'Felidae', 'Panthera', 'Panthera tigris')
  ))
  expect_equal(
    x,
    classification(c(4, 5, 8, 8, 5),
                   taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                            supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)))
  )

})


# Subsetting taxonomy objects with `[`

test_that("classification objects can be subset with `[`", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)),
                      .names = letters[1:12])

  expect_equal(length(x[2:5]), 4)
  expect_equal(x[letters[2:5]], x[2:5])
  expect_equal(x[1:12 %in% 2:5], x[2:5])
  expect_equal(class(x[2:5])[1], 'taxa_classification')
  expect_equal(names(x[2:5]), letters[2:5])

  # taxonomy is subset too
  expect_equal(attr(x[2:5], 'taxonomy'),
               taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo','Panthera tigris'),
                        supertaxa = c(NA, 1, 2, 3, 3)))

})

# Subsetting taxonomy objects with `[[`

test_that("classification objects can be subset with `[[`", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)),
                      .names = letters[1:12])

  expect_equal(length(x[[2]]), 1)
  expect_equal(class(x[[2]])[1], 'taxa_classification')
  expect_equal(x[[2]], unname(x[2])) # names are dropped for [[
  expect_equal(x[['b']], x[[2]])
  expect_equal(x[[1:12 == 2]], x[[2]])
})

test_that("classification objects can only select one item with `[[`", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)),
                      .names = letters[1:12])

  expect_error(x[[2:4]], 'attempt to select more than one element')
  expect_error(x[[c('b', 'c')]], 'attempt to select more than one element')
  expect_error(x[[1:12 %in% 2:3]], 'attempt to select more than one element')
})


# Assigning values to classification objects with `[`

test_that("Assigning values to classification objects with `[`", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)),
                      .names = letters[1:12])

  # If a interior taxon is changed, subtaxa are duplicated
  y <- x
  y[2, 3] <- 'Ursus'
  expect_equal(
    y,
    classification(c(3, 10, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                   taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos',
                              'Ursus', 'Panthera leo'),
                            supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7, 2, 9)),
                   .names = letters[1:12])
  )

  # New taxa are added if the taxon does not exist, but replaced taxa are preserved if used by other elements
  y <- x
  y[2, 4] <- 'Kitty'
  expect_equal(
    y,
    classification(c(3, 9, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                   taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos',
                              'Kitty'),
                            supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7, 3)),
                   .names = letters[1:12])
  )

  # Taxa that are no longer needed are removed
  y <- x
  y[2:5, 4] <- 'Kitty'
  expect_equal(
    y,
    classification(c(3, 8, 8, 8, 8, 5, 7, 7, 2, 4, 5, 2),
                   taxonomy(c('Carnivora', 'Felidae', 'Panthera',
                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos',
                              'Kitty'),
                            supertaxa = c(NA, 1, 2, 3, 1, 5, 6, 3)),
                   .names = letters[1:12])
  )

  # Multiple ranks can be modified at once
  y <- x
  y[2:3, 3:4] <- list(c('Cats', 'fluffly'), c('Cats', 'fuzzy'))
  expect_equal(
    y,
    classification(c(3, 9, 10, 4, 4, 5, 7, 7, 2, 4, 5, 2),
                   taxonomy(c('Carnivora', 'Felidae', 'Panthera',
                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos',
                              'Cats', 'fluffly', 'fuzzy'),
                            supertaxa = c(NA, 1, 2, 3, 1, 5, 6, 2, 8, 8)),
                   .names = letters[1:12])
  )

  # All taxa can be modified at once
  y <- x
  y[ , 2] <- 'Beasts'
  expect_equal(
    y,
    classification(c(3, 4, 4, 5, 5, 2, 7, 7, 2, 5, 2, 2),
                   taxonomy(c('Carnivora', 'Beasts', 'Panthera', 'Panthera leo',
                              'Panthera tigris', 'Ursus', 'Ursus arctos'),
                            supertaxa = c(NA, 1, 2, 3, 3, 2, 6)),
                   .names = letters[1:12])
  )


  # Whole classifications can be replaced
  y <- x
  y[2:3] <- list(c('Beasts', 'Cats', 'fluffly'), c('Beasts', 'Cats', 'fuzzy'))
  expect_equal(
    y,
    classification(c(3, 10, 11, 4, 4, 5, 7, 7, 2, 4, 5, 2),
                   taxonomy(c("Carnivora", "Felidae", "Panthera", "Panthera tigris", "Ursidae",
                              "Ursus", "Ursus arctos", "Beasts", "Cats", "fluffly", "fuzzy"),
                            supertaxa = c(NA, 1, 2, 3, 1, 5, 6, NA, 8, 9, 9)),
                   .names = letters[1:12])
  )


  # Whole classifications can be replaced by name
  z <- x
  z[c('b', 'c')] <- list(c('Beasts', 'Cats', 'fluffly'), c('Beasts', 'Cats', 'fuzzy'))
  expect_equal(z, y)

  # Whole classifications can be replaced with character vector
  z <- x
  z[2:3] <- c("Beasts|Cats|fluffly", "Beasts|Cats|fuzzy")
  expect_equal(z, y)
})


# classification objects can be combined with `c`

test_that("classification objects can be combined with `c`", {
  x <- classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2),
                      taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                                 'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                               supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7)))
  y = classification(3:4,
                     taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Kitty'),
                              supertaxa = c(NA, 1, 2, 3)))

  expect_equal(
    c(x, y),
    classification(c(3, 4, 4, 5, 5, 6, 8, 8, 2, 5, 6, 2, 3, 9),
                   taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                              'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos', 'Kitty'),
                            supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7, 3)))
  )
})



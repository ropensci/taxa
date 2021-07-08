library(taxa)
library(testthat)

context("taxa")

t1 <- taxon("Poa annua", "species", 93036)
t2 <- taxon("Homo sapiens", "species", 93036)

test_that("taxa - constructor", {
  # Empty
  expect_true("Taxa" %in% class(taxa()))
  expect_equal(length(taxa()), 0)

  # Taxon Objects
  x <- taxa(t1, t2)
  expect_true("Taxa" %in% class(x))
  expect_equal(length(x), 2)

  # Vectors
  expect_equal(taxa(taxon("a"), taxon("b")), taxa("a", "b"))
  expect_equal(taxa(taxon("1"), taxon("2")), taxa(1, 2))
  expect_equal(taxa(taxon("a"), taxon("b")), taxa(as.factor("a"), as.factor("b")))

  # TaxonName objects
  expect_equal(taxa(taxon("a"), taxon("b")), taxa(taxon_name("a"), taxon_name("b")))

  # Mixed
  expect_equal(taxa(taxon("a"), taxon("b"), taxon("c")), taxa("a", taxon_name("b"), taxon("c")))

  # List
  expect_equal(taxa("a", "b"), taxa(.list = list("a", "b")))

  # Bad inputs
  expect_error(taxa(mtcars))
  expect_error(taxa(c))
  expect_error(taxa(taxon("a"), .list = list(taxon("a"))),
               'Both `...` and `.list` were supplied')

  # r6 constructor passes by reference
  ta <- taxon("a", "species", 93036)
  tb <- taxon("b", "species", 93036)
  x <- Taxa$new(ta, tb)
  expect_identical(x$taxa[[1]], ta)

  # s3 constructor passes by value
  ta <- taxon("a", "species", 93036)
  tb <- taxon("b", "species", 93036)
  x <- taxa(ta, tb)
  expect_equal(x$taxa[[1]], ta)
  expect_false(identical(x$taxa[[1]], ta))
})

test_that("taxa - print method", {
  expect_output(print(taxa()), "<taxa>")
  expect_output(print(taxa()), "no\\. taxa:  0")
  expect_output(print(taxa(t1)), "no\\. taxa:  1")
  expect_output(print(taxa(t1)), "Poa annua / species / 93036")
})

test_that("taxa - subsetting", {
  x <- taxa(t1, t2)

  # [ indexing
  expect_true("Taxa" %in% class(x[1]))
  expect_equal(x[1], taxa(t1))
  expect_equal(x[], taxa())
  expect_equal(x[0], taxa())
  expect_error(x[3], "Index out of bounds")
  expect_error(x[-3], "Index out of bounds")

  # [[ indexing
  expect_true("Taxon" %in% class(x[[1]]))
  expect_equal(x[[1]], t1)
  expect_error(x[[]])
  expect_error(x[[0]])
  expect_error(x[[3]], "Index out of bounds")
  expect_error(x[[-3]], "Index out of bounds")
})

test_that("taxa - replacing by index", {
  # [ indexing
  x <- taxa(t1, t2)
  x[1] <- "new"
  expect_equal(x, taxa("new", t2))

  x <- taxa(t1, t2)
  x[2] <- "new"
  expect_equal(x, taxa(t1, "new"))

  x <- taxa(t1, t2)
  x[-2] <- "new"
  expect_equal(x, taxa("new", t2))

  x <- taxa(t1, t2)
  x[c(2, 1)] <- c("a", "b")
  expect_equal(x, taxa("b", "a"))

  x <- taxa(t1, t2)
  x[c(2, 1)] <- taxa("a", "b")
  expect_equal(x, taxa("b", "a"))

  x <- taxa(t1, t2)
  x[] <- "new"
  expect_equal(x, taxa("new", "new"))

  x <- taxa(t1, t2)
  expect_error(x[3] <- "a", "Index out of bounds")
  expect_error(x[-3] <- "a", "Index out of bounds")

  # [[ indexing
  x <- taxa(t1, t2)
  x[[1]] <- "new"
  expect_equal(x, taxa("new", t2))

  x <- taxa(t1, t2)
  x[[2]] <- "new"
  expect_equal(x, taxa(t1, "new"))

  x <- taxa(t1, t2)
  x[[-2]] <- "new"
  expect_equal(x, taxa("new", t2))

  x <- taxa(t1, t2)
  expect_error(x[[3]] <- "a", "Index out of bounds")
  expect_error(x[[-3]] <- "a", "Index out of bounds")
  expect_error(x[[1:2]] <- c("a", "b"), "with more than one value")
  expect_error(x[[]] <- "a", "No index supplied")
})

test_that("taxa: taxon_name getters and setters", {

  # Can set the taxon names with a list of taxon_name objects
  ta <- taxon("a", "species", 93036)
  tb <- taxon("b", "species", 93036)
  x <- taxa(t1, t2)
  x$names <- list(ta$name, tb$name)
  expect_equal(x$names, list(taxon_name("a"), taxon_name("b")))
  expect_identical(x$names[[1]], ta$name) # R6 setters pass by reference
  ta$name$name <- "new"
  expect_equal(x$names[[1]], taxon_name("new")) # R6 setters pass by reference

  # Can set the taxon names with a character
  x <- taxa(t1, t2)
  x$names <- c("a", "b")
  expect_equal(x$names, list(taxon_name("a"), taxon_name("b")))

  # Can set the taxon names with a factor
  x <- taxa(t1, t2)
  x$names <- as.factor(c("a", "b"))
  expect_equal(x$names, list(taxon_name("a"), taxon_name("b")))

  # Can get the character version of taxon names from S3 method
  x <- taxa(t1, t2)
  expect_equal(taxon_names(x), c("Poa annua", "Homo sapiens"))

  # Can set the taxon names using a character with the S3 method
  x <- taxa(t1, t2)
  taxon_names(x) <- c("1", "2")
  expect_equal(taxon_names(x), c("1", "2"))

  # Can set the taxon names using a list of TaxonName objects with the S3 method
  ta <- taxon("a", "species", 93036)
  tb <- taxon("b", "species", 93036)
  x <- taxa(t1, t2)
  taxon_names(x) <- list(ta$name, tb$name)
  expect_equal(x$names, list(taxon_name("a"), taxon_name("b")))
  expect_false(identical(x$names[[1]], ta$name)) # s3 setters pass by value
  ta$name$name <- "new"
  expect_equal(x$names[[1]], taxon_name("a")) # s3 setters pass by value

  # Can set the taxon names using a list of Taxon objects with the S3 method
  x <- taxa(t1, t2)
  taxon_names(x) <- list(taxon("1"), taxon("2"))
  expect_equal(taxon_names(x), c("1", "2"))

  # Can get id when no ids are set
  x <- taxa("a", NULL)
  expect_equal(taxon_names(x), c("a", NA))

})


test_that("taxa: taxon_id getters and setters", {

  # Can set the taxon ids with a list of taxon_id objects
  ta <- taxon("a", "species", "a")
  tb <- taxon("b", "species", "b")
  x <- taxa(t1, t2)
  x$ids <- list(ta$id, tb$id)
  expect_equal(x$ids, list(taxon_id("a"), taxon_id("b")))
  expect_identical(x$ids[[1]], ta$id) # R6 setters pass by reference
  ta$id$id <- "new"
  expect_equal(x$ids[[1]], taxon_id("new")) # R6 setters pass by reference

  # Can set the taxon ids with a character
  x <- taxa(t1, t2)
  x$ids <- c("a", "b")
  expect_equal(x$ids, list(taxon_id("a"), taxon_id("b")))

  # Can set the taxon ids with a factor
  x <- taxa(t1, t2)
  x$ids <- as.factor(c("a", "b"))
  expect_equal(x$ids, list(taxon_id("a"), taxon_id("b")))

  # Can set the taxon ids with a number
  x <- taxa(t1, t2)
  x$ids <- 1:2
  expect_equal(x$ids, list(taxon_id("1"), taxon_id("2")))

  # Can get the character version of taxon ids from S3 method
  x <- taxa(t1, t2)
  expect_equal(taxon_ids(x), c("93036", "93036"))

  # Can set the taxon ids using a character with the S3 method
  x <- taxa(t1, t2)
  taxon_ids(x) <- c("1", "2")
  expect_equal(taxon_ids(x), c("1", "2"))

  # Can set the taxon ids using a list of TaxonId objects with the S3 method
  ta <- taxon("a", "species", "a")
  tb <- taxon("b", "species", "b")
  x <- taxa(t1, t2)
  taxon_ids(x) <- list(ta$id, tb$id)
  expect_equal(x$ids, list(taxon_id("a"), taxon_id("b")))
  expect_false(identical(x$ids[[1]], ta$id)) # s3 setters pass by value
  ta$id$id <- "new"
  expect_equal(x$ids[[1]], taxon_id("a")) # s3 setters pass by value

  # Can get id when no ids are set
  x <- taxa(taxon("a", "species", "123"), "b")
  expect_equal(taxon_ids(x), c("123", NA))

})


test_that("taxa: taxon_rank getters and setters", {

  # Can set the taxon ranks with a list of taxon_rank objects
  ta <- taxon("a", "genus", "a")
  tb <- taxon("b", "family", "b")
  x <- taxa(t1, t2)
  x$ranks <- list(ta$rank, tb$rank)
  expect_equal(x$ranks, list(taxon_rank("genus"), taxon_rank("family")))
  expect_identical(x$ranks[[1]], ta$rank) # R6 setters pass by reference
  ta$rank$name <- "new"
  expect_equal(x$ranks[[1]], taxon_rank("new")) # R6 setters pass by reference

  # Can set the taxon ranks with a character
  x <- taxa(t1, t2)
  x$ranks <- c("a", "b")
  expect_equal(x$ranks, list(taxon_rank("a"), taxon_rank("b")))

  # Can set the taxon ranks with a factor
  x <- taxa(t1, t2)
  x$ranks <- as.factor(c("a", "b"))
  expect_equal(x$ranks, list(taxon_rank("a"), taxon_rank("b")))

  # Can set the taxon ranks with a number
  x <- taxa(t1, t2)
  x$ranks <- 1:2
  expect_equal(x$ranks, list(taxon_rank("1"), taxon_rank("2")))

  # Can get the character version of taxon ranks from S3 method
  x <- taxa(t1, t2)
  expect_equal(taxon_ranks(x), c("species", "species"))

  # Can set the taxon ranks using a character with the S3 method
  x <- taxa(t1, t2)
  taxon_ranks(x) <- c("1", "2")
  expect_equal(taxon_ranks(x), c("1", "2"))

  # Can set the taxon ranks using a list of TaxonId objects with the S3 method
  ta <- taxon("a", "genus", "a")
  tb <- taxon("b", "family", "b")
  x <- taxa(t1, t2)
  taxon_ranks(x) <- list(ta$rank, tb$rank)
  expect_equal(x$ranks, list(taxon_rank("genus"), taxon_rank("family")))
  expect_false(identical(x$ranks[[1]], ta$rank)) # s3 setters pass by value
  ta$rank$name <- "new"
  expect_equal(x$ranks[[1]], taxon_rank("genus")) # s3 setters pass by value

  # Can get rank when no ranks are set
  x <- taxa(taxon("a", "species", "123"), "b")
  expect_equal(taxon_ranks(x), c("species", NA))

})


test_that("taxa: authority getters and setters", {

  # Can set the authorities with a character
  x <- taxa(t1, t2)
  x$authorities <- c("a", "b")
  expect_equal(x$authorities,  c("a", "b"))

  # Can get the authorities from the S3 method
  expect_equal(taxon_auths(x),  c("a", "b"))

  # Can set the authorities using a character with the S3 method
  x <- taxa(t1, t2)
  taxon_auths(x) <- c("a", "b")
  expect_equal(taxon_auths(x),  c("a", "b"))

  # Can get authorities when no authority is set
  x <- taxa(taxon("a", "species", "123", "auth1"), "b")
  expect_equal(taxon_auths(x), c("auth1", NA))

})


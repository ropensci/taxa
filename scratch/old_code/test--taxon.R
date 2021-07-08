library(taxa)
library(testthat)

context("taxon")

name <- taxon_name("Poa annua")
rank <- taxon_rank("species")
id <- taxon_id(93036)

test_that("taxa works", {
  aa <- taxon(name, rank, id)

  expect_is(aa, "Taxon")
  expect_null(aa$authority)
  expect_is(aa$id, "TaxonId")
  expect_is(aa$name, "TaxonName")
  expect_is(aa$rank, "TaxonRank")
  expect_output(aa$print())

  # Can coerce the taxon_name object returned into a character
  x <- taxon(name, rank, id)
  expect_equal(as.character(x), "Poa annua")

  # Can make a taxon with as_Taxon
  expect_identical(as.Taxon(x), x)
  expect_equal(as_Taxon("new taxon"), taxon("new taxon"))

  # S3 constructor passes by value
  n <- taxon_name("1")
  x <- taxon(n, rank, id)
  n$name <- "2"
  expect_equal(x$name$name, "1")
  x$name$name <- "3"
  expect_equal(n$name, "2")

  # R6 constructor passes by reference
  n <- taxon_name("1")
  x <- Taxon$new(n, rank, id)
  n$name <- "2"
  expect_equal(x$name$name, "2")
  expect_identical(x$name, n)
  x$name$name <- "3"
  expect_equal(n$name, "3")

})

test_that("taxa fails well", {
  expect_error(taxon(rank = "adfd"),
               "argument \"name\" is missing")
  expect_error(taxon(mtcars),
               "must be a class that is or inherits one of the following classes")
  expect_error(taxon("adf", mtcars),
               "must be a class that is or inherits one of the following classes")
  expect_error(taxon("adfadsf", authority = mtcars),
               "must be a class that is or inherits one of the following classes")
})

test_that("taxon can do null data", {
  x <- taxon(NULL)
  expect_is(x, "Taxon")
  expect_null(x$name)
  expect_null(x$rank)
  expect_null(x$authority)
  expect_null(x$id)
})




test_that("taxon: taxon_name getters and setters", {

  # Can set the taxon name with a taxon_name object
  x <- taxon(name, rank, id)
  new_name <- taxon_name("new name")
  x$name <- new_name
  expect_identical(x$name, new_name) # "expect_identical" since R6 setters pass by reference

  # Can set the taxon name with a character
  x <- taxon(name, rank, id)
  x$name <- "new name"
  expect_equal(x$name, taxon_name("new name"))

  # Can set the taxon name with a factor
  x <- taxon(name, rank, id)
  x$name <- as.factor("new name")
  expect_equal(x$name, taxon_name("new name"))

  # Can get the taxon_name object
  expect_equal(x$name, taxon_name("new name"))

  # Can coerce the taxon_name object returned into a character
  expect_equal(as.character(x$name), "new name")

  # Can get the character version of taxon_name from S3 method
  expect_equal(taxon_names(x), "new name")

  # Can set the taxon_name using a character with the S3 method
  x <- taxon(name, rank, id)
  taxon_names(x) <- "new name"
  expect_equal(taxon_names(x), "new name")

  # Can set the taxon_name using an object with the S3 method
  x <- taxon(name, rank, id)
  new_name <- taxon_name("new name")
  taxon_names(x) <- new_name
  expect_equal(x$name, new_name)
  expect_false(identical(x$name, new_name)) # S3 setters should pass by value

})


test_that("taxon: taxon_id getters and setters", {

  # Can set the taxon id with a taxon_id object
  x <- taxon(name, rank, id)
  new_id <- taxon_id("new id")
  x$id <- new_id
  expect_identical(x$id, new_id) # "expect_identical" since R6 setters pass by reference

  # Can set the taxon id with a character/factor/nunmber
  x <- taxon(name, rank, id)
  x$id <- "new id"
  expect_equal(x$id, taxon_id("new id"))
  x$id <- as.factor("new id")
  expect_equal(x$id, taxon_id("new id"))
  x$id <- 1
  expect_equal(x$id, taxon_id("1"))

  # Can coerce the taxon_id object returned into a character
  x <- taxon(name, rank, id)
  expect_equal(as.character(x$id), "93036")

  # Can get the character version of taxon_id from S3 method
  x <- taxon(name, rank, id)
  expect_equal(taxon_ids(x), "93036")

  # Can set the taxon_id using a character with the S3 method
  x <- taxon(name, rank, id)
  taxon_ids(x) <- "new id"
  expect_equal(taxon_ids(x), "new id")

  # Can set the taxon_id using an object with the S3 method
  x <- taxon(name, rank, id)
  new_id <- taxon_id("new id")
  taxon_ids(x) <- new_id
  expect_equal(x$id, new_id)
  expect_false(identical(x$id, new_id)) # S3 setters should pass by value

})


test_that("taxon: taxon_rank getters and setters", {

  # Can set the taxon rank with a taxon_rank object
  x <- taxon(name, rank, id)
  new_rank <- taxon_rank("new rank")
  x$rank <- new_rank
  expect_identical(x$rank, new_rank) # "expect_identical" since R6 setters pass by reference

  # Can set the taxon rank with a character/factor/nunmber
  x <- taxon(name, rank, id)
  x$rank <- "new rank"
  expect_equal(x$rank, taxon_rank("new rank"))
  x$rank <- as.factor("new rank")
  expect_equal(x$rank, taxon_rank("new rank"))
  x$rank <- 1
  expect_equal(x$rank, taxon_rank("1"))

  # Can coerce the taxon_rank object returned into a character
  x <- taxon(name, rank, id)
  expect_equal(as.character(x$rank), "species")

  # Can get the character version of taxon_rank from S3 method
  x <- taxon(name, rank, id)
  expect_equal(taxon_ranks(x), "species")

  # Can set the taxon_rank using a character with the S3 method
  x <- taxon(name, rank, id)
  taxon_ranks(x) <- "new rank"
  expect_equal(taxon_ranks(x), "new rank")

  # Can set the taxon_rank using an object with the S3 method
  x <- taxon(name, rank, id)
  new_rank <- taxon_rank("new rank")
  taxon_ranks(x) <- new_rank
  expect_equal(x$rank, new_rank)
  expect_false(identical(x$rank, new_rank)) # S3 setters should pass by value

  # Only valid ranks are accepted by setters if valid ranks are defined [TO DO]

})


test_that("taxon: authority getters and setters", {

  # Can set the authority with a character/factor/nunmber
  x <- taxon(name, rank, id)
  x$authority <- "new authority"
  expect_equal(x$authority, "new authority")

  # Can get the authority from the S3 method
  expect_equal(taxon_auths(x), "new authority")

  # Can set the authority using a character with the S3 method
  taxon_auths(x) <- "newer authority"
  expect_equal(x$authority, "newer authority")

})

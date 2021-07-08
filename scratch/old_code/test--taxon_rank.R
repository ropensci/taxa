library(taxa)
library(testthat)

context("taxon_rank")

test_that("taxa_rank - just rank", {
  aa <- taxon_rank("species")

  expect_is(aa, "TaxonRank")
  expect_null(aa$database)
  expect_type(aa$name, "character")
  expect_output(print(aa$print()), "<TaxonRank>")
})

test_that("taxa_rank - name and database (TaxonRank)", {
  aa <- taxon_rank("species", database_list$ncbi)

  expect_is(aa, "TaxonRank")
  expect_is(aa$database, "TaxonDatabase")
  expect_equal(aa$database$name, "ncbi")
  expect_equal(aa$database$url, "http://www.ncbi.nlm.nih.gov/taxonomy")
  expect_type(aa$name, "character")
})

test_that("taxa_rank - name and database (character)", {
  aa <- taxon_rank("genus", "ncbi")

  expect_is(aa, "TaxonRank")
  expect_is(aa$database, "TaxonDatabase")
  expect_equal(aa$database$name, "ncbi")
  expect_null(aa$database$url)
  expect_type(aa$name, "character")

  # S3 constructor passes by value
  db <- taxon_database("1")
  x <- taxon_rank("species", db)
  db$name <- "2"
  expect_equal(x$database$name, "1")
  x$database$name <- "3"
  expect_equal(db$name, "2")

  # R6 constructor passes by reference
  db <- taxon_database("1")
  x <- TaxonRank$new("species", db)
  db$name <- "2"
  expect_equal(x$database$name, "2")
  expect_identical(x$database, db)
  x$database$name <- "3"
  expect_equal(db$name, "3")
})

test_that("taxon_rank fails well", {
  expect_error(taxon_rank(),
               "argument \"name\" is missing")
  expect_error(taxon_rank(mtcars),
               "must be a class that is or inherits one of the following classes")
  expect_error(taxon_rank("adf", 5),
               "must be a class that is or inherits one of the following classes")
})

test_that("taxon_rank can do null data", {
  # empty taxon_rank() tested in above block
  x <- taxon_rank(NULL)
  expect_is(x, "TaxonRank")
  expect_null(x$name)
  expect_null(x$database)
})

test_that("taxon_rank: name getters and setters", {
  # Can set the name with a character
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  x$name <- "genus"
  expect_equal(x$name, "genus")

  # Can set the name with a factor
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  x$name <- as.factor("genus")
  expect_equal(x$name, "genus")

  # Can coerce to character
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  expect_equal(as.character(x), "species")

  # Error when given odd input
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  expect_error(x$name <- TRUE,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$name <- mtcars,
               "must be a class that is or inherits one of the following classes")
})

test_that("taxon_rank: database getters and setters", {
  # Can set the database with a character
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  x$database <- "new database"
  expect_equal(x$database, taxon_database("new database"))

  # Can set the database with a database object
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  database_obj <- taxon_database("new database")
  x$database <- database_obj
  expect_identical(x$database, database_obj) # "expect_identical" since R6 setters pass by reference

  # Error when given odd input
  x <- taxon_rank(name = "species", database = database_list$ncbi)
  expect_error(x$database <- 1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$database <- mtcars,
               "must be a class that is or inherits one of the following classes")
})

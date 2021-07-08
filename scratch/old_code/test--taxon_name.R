library(taxa)
library(testthat)

context("taxon_nane")

test_that("taxa_name - just", {
  aa <- taxon_name("Poa")

  expect_is(aa, "TaxonName")
  expect_null(aa$database)
  expect_type(aa$name, "character")
  expect_output(aa$print())
})

test_that("taxa_name - name and database (TaxonDatabase)", {
  aa <- taxon_name("Poa", database_list$ncbi)

  expect_is(aa, "TaxonName")
  expect_is(aa$database, "TaxonDatabase")
  expect_equal(aa$database$name, "ncbi")
  expect_equal(aa$database$url, "http://www.ncbi.nlm.nih.gov/taxonomy")
  expect_type(aa$name, "character")
  expect_output(aa$print())
})

test_that("taxa_name - ID and database (character)", {
  aa <- taxon_name("Poa", "ncbi")

  expect_is(aa, "TaxonName")
  expect_is(aa$database, "TaxonDatabase")
  expect_equal(aa$database$name, "ncbi")
  expect_null(aa$database$url)
  expect_type(aa$name, "character")
  expect_output(aa$print())

  # S3 constructor passes by value
  db <- taxon_database("1")
  x <- taxon_name("poa", db)
  db$name <- "2"
  expect_equal(x$database$name, "1")
  x$database$name <- "3"
  expect_equal(db$name, "2")

  # R6 constructor passes by reference
  db <- taxon_database("1")
  x <- TaxonName$new("poa", db)
  db$name <- "2"
  expect_equal(x$database$name, "2")
  expect_identical(x$database, db)
  x$database$name <- "3"
  expect_equal(db$name, "3")
})

test_that("taxon_name fails well", {
  expect_error(taxon_name(),
               "argument \"name\" is missing")
  expect_error(taxon_name(mtcars),
               "must be a class that is or inherits one of the following classes")
  expect_error(taxon_name("adf", 5),
               "must be a class that is or inherits one of the following classes")
})

test_that("taxon_name can do null data", {
  # empty taxon_name() tested in above block
  x <- taxon_name(NULL)
  expect_is(x, "TaxonName")
  expect_null(x$name)
  expect_null(x$database)
})

test_that("taxon_name: name getters and setters", {
  # Can set the name with a character
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  x$name <- "new name"
  expect_equal(x$name, "new name")

  # Can set the name with a factor
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  x$name <- as.factor("new name")
  expect_equal(x$name, "new name")

  # Can coerce to character
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  expect_equal(as.character(x), "poa")

  # Error when given odd input
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  expect_error(x$name <- TRUE,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$name <- mtcars,
               "must be a class that is or inherits one of the following classes")
})

test_that("taxon_name: database getters and setters", {
  # Can set the database with a character
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  x$database <- "new database"
  expect_equal(x$database, taxon_database("new database"))

  # Can set the database with a database object
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  database_obj <- taxon_database("new database")
  x$database <- database_obj
  expect_identical(x$database, database_obj) # "expect_identical" since R6 setters pass by reference

  # Error when given odd input
  x <- taxon_name(name = "poa", database = database_list$ncbi)
  expect_error(x$database <- 1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$database <- mtcars,
               "must be a class that is or inherits one of the following classes")
})

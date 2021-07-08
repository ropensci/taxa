library(taxa)
library(testthat)

context("taxon_id")

test_that("taxa_id - just ID", {
  aa <- taxon_id(93036)

  expect_is(aa, "TaxonId")
  expect_null(aa$database)
  expect_type(aa$id, "character")
  expect_output(aa$print())
})

test_that("taxa_id - ID and database (TaxonDatabase)", {
  aa <- taxon_id(93036, database_list$ncbi)

  expect_is(aa, "TaxonId")
  expect_is(aa$database, "TaxonDatabase")
  expect_equal(aa$database$name, "ncbi")
  expect_equal(aa$database$url, "http://www.ncbi.nlm.nih.gov/taxonomy")
  expect_type(aa$id, "character")
  expect_output(aa$print())
})

test_that("taxa_id - ID and database (character)", {
  aa <- taxon_id(93036, "ncbi")

  expect_is(aa, "TaxonId")
  expect_is(aa$database, "TaxonDatabase")
  expect_equal(aa$database$name, "ncbi")
  expect_null(aa$database$url)
  expect_type(aa$id, "character")
  expect_output(aa$print())

  # S3 constructor passes by value
  db = taxon_database("1")
  x = taxon_id(93036, db)
  db$name = "2"
  expect_equal(x$database$name, "1")

  # R6 constructor passes by reference
  db = taxon_database("1")
  x = TaxonId$new(93036, db)
  db$name = "2"
  expect_equal(x$database$name, "2")
  expect_identical(x$database, db)

  # R6 constructor passes by value any non-R6 objects, since they have to
  id = "1"
  x = TaxonId$new(id, "db")
  id = "2"
  expect_equal(x$id, "1")
  x$id = "3"
  expect_equal(id, "2")

})

test_that("taxon_id fails well", {
  expect_error(taxon_id(),
               "argument \"id\" is missing")
  expect_error(taxon_id(mtcars),
               "must be a class that is or inherits one of the following classes")
  expect_error(taxon_id("adf", 5),
               "must be a class that is or inherits one of the following classes")
})

test_that("taxon_id can do null data", {
  # empty taxon_id() tested in above block
  x <- taxon_id(NULL)
  expect_is(x, "TaxonId")
  expect_null(x$name)
  expect_null(x$database)
})


test_that("taxon_id: id getters and setters", {
  # Can set the id with a character
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  x$id <- "new id"
  expect_equal(x$id, "new id")

  # Can set the id with a factor
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  x$id <- as.factor("new id")
  expect_equal(x$id, "new id")

  # Can coerce to character
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  expect_equal(as.character(x), "12345")

  # Error when given odd input
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  expect_error(x$id <- TRUE,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$id <- mtcars,
               "must be a class that is or inherits one of the following classes")

  # Error when ID does not match database id regex
  db1 <- taxon_database(name = "id_regex", id_regex = "^[0-9]+$")
  db2 <- taxon_database(name = "no id_regex")
  expect_error(taxon_id(id = "aaa", database = db1),
               "Taxon IDs must follow the database ID conventions")
  expect_silent(taxon_id(id = "aaa", database = db2))
  expect_silent(taxon_id(id = "aaa"))
})

test_that("taxon_id: database getters and setters", {
  # Can set the database with a character
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  x$database <- "new database"
  expect_equal(x$database, taxon_database("new database"))

  # Can set the database with a database object
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  database_obj <- taxon_database("new database")
  x$database <- database_obj
  expect_identical(x$database, database_obj) # "expect_identical" since R6 setters pass by reference

  # Error when given odd input
  x <- taxon_id(id = "12345", database = database_list$ncbi)
  expect_error(x$database <- 1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$database <- mtcars,
               "must be a class that is or inherits one of the following classes")
})

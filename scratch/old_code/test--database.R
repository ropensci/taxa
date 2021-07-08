library(taxa)
library(testthat)

context("taxon_database")

test_that("TaxonDatabase can be initialized", {

  # Using characters
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_equal(x$name, "ncbi")
  expect_equal(x$url, "https://www.ncbi.nlm.nih.gov/")
  expect_equal(x$description, "NCBI description")
  expect_equal(x$id_regex, ".*")

  # Using factors
  y <- taxon_database(name = as.factor("ncbi"),
                      url = as.factor("https://www.ncbi.nlm.nih.gov/"),
                      description = as.factor("NCBI description"),
                      id_regex = as.factor(".*"))
  expect_equal(x, y)

})


test_that("taxon_database: name getters and setters", {

  # Can set the database name with a taxon_database object
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  new_database <- taxon_database("new name")
  x$name <- new_database
  expect_equal(x$name, "new name")

  # Can set the database name with a character
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$name <- "new name"
  expect_equal(x$name, "new name")

  # Can set the database name with a factor
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$name <- as.factor("new name")
  expect_equal(x$name, "new name")

  # Error when given odd input
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_error(x$name <- 1.1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$name <- mtcars,
               "must be a class that is or inherits one of the following classes")

  # Can coerce the taxon_database object into a character
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_equal(as.character(x),  "ncbi")

})


test_that("taxon_database: url getters and setters", {

  # Can set the database url with a character
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$url <- "new url"
  expect_equal(x$url, "new url")

  # Can set the database url with a factor
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$url <- as.factor("new url")
  expect_equal(x$url, "new url")

  # Error when given odd input
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_error(x$url <- 1.1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$url <- mtcars,
               "must be a class that is or inherits one of the following classes")

})


test_that("taxon_database: description getters and setters", {

  # Can set the database description with a character
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$description <- "new description"
  expect_equal(x$description, "new description")

  # Can set the database description with a factor
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$description <- as.factor("new description")
  expect_equal(x$description, "new description")

  # Error when given odd input
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_error(x$description <- 1.1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$description <- mtcars,
               "must be a class that is or inherits one of the following classes")

})

test_that("taxon_database: id_regex getters and setters", {

  # Can set the database id_regex with a character
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$id_regex <- "new id_regex"
  expect_equal(x$id_regex, "new id_regex")

  # Can set the database id_regex with a factor
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  x$id_regex <- as.factor("new id_regex")
  expect_equal(x$id_regex, "new id_regex")

  # Errors on invalid regular expression
  expect_error(taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = "["),
               "must be a valid regular expression")
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_error(x$id_regex <- "[",
               "must be a valid regular expression")

  # Error when given odd input
  x <- taxon_database(name = "ncbi",
                      url = "https://www.ncbi.nlm.nih.gov/",
                      description = "NCBI description",
                      id_regex = ".*")
  expect_error(x$id_regex <- 1.1,
               "must be a class that is or inherits one of the following classes")
  expect_error(x$id_regex <- mtcars,
               "must be a class that is or inherits one of the following classes")

})


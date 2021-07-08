context("taxon_db_def")
library(taxa)

# Printing taxon objects

test_that("database def printing", {
  verify_output(path = test_path('print_outputs', 'taxon_db_def.txt'),
                code = {print(db_ref$get())},
                crayon = TRUE)
})


# `db_ref$get()` returns the correct default

test_that("`db_ref$get()` returns the correct default", {
  expect_equal(db_ref$get(), taxa:::database_ref)
})


# `db_ref$set()` works to add datbases

test_that("`db_ref$set()` can add new values", {
  db_ref$set(name = 'my_custom_db', desc = 'I just made this up')
  expect_equal(length(db_ref$get()), length(taxa:::database_ref) + 1)
  expect_equal(db_ref$get()[length(db_ref$get())], taxa:::taxon_db_def(name = 'my_custom_db', desc = 'I just made this up'))
})


# `db_ref$set()` works to replace datbases

test_that("`db_ref$set()` can replace values", {
  db_ref$set(name = 'gbif', desc = 'New gbif')
  expect_equal(length(db_ref$get()), length(taxa:::database_ref) + 1)
  expect_equal(db_ref$get('gbif'), taxa:::taxon_db_def(name = 'gbif', desc = 'New gbif'))
})


# `db_ref$reset()` resets to the defualt databases

test_that("`db_ref$set()` can replace values", {
  db_ref$set(name = 'gbif', desc = 'New gbif')
  db_ref$reset()
  expect_equal(db_ref$get(), taxa:::database_ref)
})


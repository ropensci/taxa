library(taxa)
library(testthat)

context("hierarchies")

## Creating test data
x <- taxon(
  name = taxon_name("Poaceae"),
  rank = taxon_rank("family"),
  id = taxon_id(4479)
)
y <- taxon(
  name = taxon_name("Poa"),
  rank = taxon_rank("genus"),
  id = taxon_id(4544)
)
z <- taxon(
  name = taxon_name("Poa annua"),
  rank = taxon_rank("species"),
  id = taxon_id(93036)
)
hier1 <- hierarchy(z, y, x)

a <- taxon(
  name = taxon_name("Felidae"),
  rank = taxon_rank("family"),
  id = taxon_id(9681)
)
b <- taxon(
  name = taxon_name("Puma"),
  rank = taxon_rank("genus"),
  id = taxon_id(146712)
)
c <- taxon(
  name = taxon_name("Puma concolor"),
  rank = taxon_rank("species"),
  id = taxon_id(9696)
)
hier2 <- hierarchy(c, b, a)


test_that("hierarchies works", {
  aa <- hierarchies(hier1, hier2)

  expect_is(aa, "hierarchies")
  expect_is(unclass(aa), "list")
  expect_is(aa[[1]], "Hierarchy")
  expect_is(aa[[2]], "Hierarchy")

  expect_equal(length(aa), 2)
})


test_that("hierarchies - empty", {
  aa <- hierarchies(hierarchy(), hierarchy())

  expect_is(aa, "hierarchies")
  expect_is(unclass(aa), "list")
  expect_is(aa[[1]], "Hierarchy")
  expect_is(aa[[2]], "Hierarchy")
  expect_equal(length(aa[[1]]$taxa), 0)
  expect_equal(length(aa[[2]]$taxa), 0)

  # prints 'Empty hierarchy'
  expect_output(
    print(hierarchies()),
    "no. hierarchies:  0"
  )
  expect_output(
    print(hierarchies(hierarchy(), hierarchy())),
    "Empty hierarchy"
  )

  aa <- hierarchies()

  expect_match(paste0(capture.output(hierarchies()), collapse = ""),
               "<Hierarchies>")
  expect_is(aa, "hierarchies")
  expect_is(unclass(aa), "list")
  expect_equal(length(aa), 0)
})


test_that("hierarchies - print when not empty", {
  expect_output(
    print(hierarchies(hier1)),
    "Poaceae / Poa / Poa annua"
  )

  expect_output(
    print(hierarchies(hier1, hier2)),
    "Poaceae / Poa / Poa annua \n  Felidae / Puma / Puma concolor"
  )
})


test_that("hierarchies fails well", {
  expect_error(hierarchies(4),
               "all inputs to 'hierarchies' must be of class 'Hierarchy'")
  expect_error(hierarchies("a", "b", "c"),
               "all inputs to 'hierarchies' must be of class 'Hierarchy'")
  expect_error(hierarchies(hier1, "c"),
               "all inputs to 'hierarchies' must be of class 'Hierarchy'")
})


test_that("dots and .list return the same output", {
  expect_equal(hierarchies(hier1, hier2),
               hierarchies(.list = list(hier1, hier2)))
})



test_that("hierarchies: taxon_name getters and setters", {

  # Can set the taxon names with a list of lists of taxon_name objects

  # Can set the taxon names with a list of character/factor (data frame)

  # Can set the taxon names with a NA padded matrix of character/factor

  # Can set the taxon names with a list of lists of anything else that can be coerced into a character/object with a warning

  # Can get a list of list of taxon_names objects

  # Can get a list of  character of taxon names from S3 method

  # Can set the taxon names using a list of character with the S3 method

  # Can set the taxon names using a list of list of objects with the S3 method

})


test_that("hierarchies: taxon_id getters and setters", {

  # Can set the taxon ids with a list of list of taxon_id objects

  # Can set the taxon ids with a list of character/factor/nunmber (data.frame)

  # Can set the taxon ids with a matrix padded by NA

  # Can set the taxon ids with a list of anything else that can be coerced into a character/object with a warning

  # Can get a list of lists of taxon_id objects

  # Can get the list of character of taxon ids from S3 method

  # Can set the taxon ids using a list of character with the S3 method

  # Can set the taxon ids using a list of list of objects with the S3 method

})


test_that("hierarchies: taxon_rank getters and setters", {

  # Can set the taxon ranks with a list of lists of taxon_rank objects

  # Can set the taxon ranks with a list of character/factor/nunmber (dataframe)

  # Can set the taxon ranks with a matrix padded by NA

  # Can set the taxon ranks with a list of anything else that can be coerced into a character/object with a warning

  # Can get the list of list of  taxon_rank objects

  # Can get the list of characters of taxon ranks from S3 method

  # Can set the taxon ranks using a list of character with the S3 method

  # Can set the taxon ranks using a list of lists of objects with the S3 method

  # Only valid ranks are accepted by setters if valid ranks are defined

})


test_that("hierarchies: authority getters and setters", {

  # Can set the authorities with a list of character/factor/nunmber

  # Can set the authorities with a list of anything else that can be coerced into a character with a warning

  # Can get the authorities from the S3 method

  # Can set the authorities using a list of character/factor with the S3 method

})

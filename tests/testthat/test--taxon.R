context("taxon")
library(taxa)


# Creating taxon objects

test_that("taxon objects can be created from character input", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon')
  expect_equal(as.character(x[3]), 'C')
})

test_that("taxon objects can be created from factor input", {
  x <- taxon(as.factor(c('A', 'B', 'C')))
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon')
  expect_equal(as.character(x[3]), 'C')
})

test_that("taxon objects can be created with names", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(length(x), 3)
  expect_equal(class(x)[1], 'taxa_taxon')
  expect_equal(as.character(x[3]), c(c = 'C'))
  expect_equal(names(x), letters[1:3])
})

test_that("taxon objects can be created with as_taxon", {
  expect_equal(as_taxon(c('A', 'B', 'C')), taxon(c('A', 'B', 'C')))
  expect_equal(as_taxon(taxon(c('A', 'B', 'C'))), taxon(c('A', 'B', 'C')))
})

# Printing taxon objects

test_that("taxon objects can be printed", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
  names(x) <- c('a', 'b', 'c', 'd')
  verify_output(path = test_path('print_outputs', 'taxon.txt'),
                code = {print(x)},
                crayon = TRUE)
  options(max.print = 1000)
  expect_output(print(rep(x, 1000)), regexp = 'reached getOption("max.print")', fixed = TRUE)
  expect_output(print(taxon()), "<taxon[0]>", fixed = TRUE)
})

test_that("taxon objects can be printed in tables", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
  names(x) <- c('a', 'b', 'c', 'd')
  verify_output(path = test_path('print_outputs', 'taxon_tibble.txt'),
                code = {print(tibble::tibble(x))},
                crayon = TRUE)
  verify_output(path = test_path('print_outputs', 'taxon_data_frame.txt'),
                code = {print(data.frame(x))},
                crayon = TRUE)
})

# Subsetting taxon objects with `[`

test_that("taxon objects can be `[` subset by index", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(length(x[1:2]), 2)
  expect_equal(x[2:3], taxon(c('B', 'C')))
})

test_that("taxon objects can be `[` subset by logical vector", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(length(x[c(FALSE, TRUE, FALSE)]), 1)
  expect_equal(x[c(FALSE, TRUE, TRUE)], taxon(c('B', 'C')))
})

test_that("taxon objects can be `[` subset by name", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(length(x[c('a', 'b')]), 2)
  expect_equal(x[c('b', 'c')], taxon(c('B', 'C'), .names = letters[2:3]))
})


# Subsetting taxon objects with `[[`

test_that("taxon objects can be `[[` subset by index", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(length(x[[1]]), 1)
  expect_equal(x[[3]], taxon('C'))
})

test_that("taxon objects can be `[[` subset by name", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(length(x[['c']]), 1)
  expect_equal(x[['c']], taxon('C')) # names are dropped for [[
})

test_that("(taxon) selecting multiple with `[[` errors", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_error(x[[1:3]], 'attempt to select more than one element')
})

# Setting names of taxon objects

test_that("taxon objects can be named", {
  x <- taxon(c('A', 'B', 'C'))
  names(x) <- letters[1:3]
  expect_equal(x, taxon(c('A', 'B', 'C'), .names = letters[1:3]))
  expect_equal(names(x),  letters[1:3])
  names(x)[2] <- 'd'
  expect_equal(names(x), c('a', 'd', 'c'))
})


# Assigning values to taxon objects

test_that("taxon objects can have values assigned to them", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  x[2] <- '4'
  expect_equal(x[2], taxon('4', .names = letters[2]))
  x[[2]] <- '5'
  expect_equal(x[[2]], taxon('5'))
  x['b'] <- '4'
  expect_equal(x[2], taxon('4', .names = letters[2]))
  x[c(FALSE, TRUE, FALSE)] <- '4'
  expect_equal(x[2], taxon('4', .names = letters[2]))
})

test_that("taxon assignment is recycled correctly", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  x[1:3] <- '4'
  expect_equal(x,  taxon(c('4', '4', '4'), .names = letters[1:3]))
})

test_that("(taxon) multiple items can not be assigned with [[", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_error(x[[1:3]] <- '4', 'attempt to select more than one element')
})


# Assign values to components

test_that("components of taxon objects can be assigned", {
  x <- taxon(c('A', 'B', 'C'))
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

# Can be concatenated

test_that("taxon objects can be combined", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(c(x, x), taxon(rep(c('A', 'B', 'C'), 2)))
  expect_equal(c(x, x, x), taxon(rep(c('A', 'B', 'C'), 3)))
})

test_that("named taxon objects can be combined", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(c(x, x), taxon(rep(c('A', 'B', 'C'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(c(x, x, x), taxon(rep(c('A', 'B', 'C'), 3), .names = rep(letters[1:3], 3)))
})


# Taxon can be compared with eachother

test_that("taxon objects can be compared with eachother", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(x == x[1], c(TRUE, FALSE, FALSE))
})


# Works with `rep`

test_that("taxon objects work with `rep`", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(rep(x, 2), taxon(rep(c('A', 'B', 'C'), 2)))
  expect_equal(rep(x, 3), taxon(rep(c('A', 'B', 'C'), 3)))
})

test_that("named taxon objects work with `rep`", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(rep(x, 2), taxon(rep(c('A', 'B', 'C'), 2), .names = rep(letters[1:3], 2)))
  expect_equal(rep(x, 3), taxon(rep(c('A', 'B', 'C'), 3), .names = rep(letters[1:3], 3)))
})

# Works with `seq_along`

test_that("taxon objects work with `seq_along`", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(seq_along(x), 1:3)
})

test_that("named taxon objects work with `seq_along`", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(seq_along(x), 1:3)
})


# Can be converted to character

test_that("taxon objects can be converted to characters", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(as.character(x), c('A', 'B', 'C'))
})

test_that("named taxon objects can be converted to characters", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(as.character(x), c(a = 'A', b = 'B', c = 'C'))
})


# Can be converted to factor

test_that("taxon objects can be converted to factor", {
  x <- taxon(c('A', 'B', 'C'))
  expect_equal(as.factor(x), as.factor(c('A', 'B', 'C')))
})

test_that("named taxon objects can be converted to factor", {
  x <- taxon(c('A', 'B', 'C'), .names = letters[1:3])
  expect_equal(as.factor(x), as.factor(c(a = 'A', b = 'B', c= 'C')))
})


# Can be converted to a data.frame

test_that("taxon objects can be converted to a data.frame", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
  expect_equal(
    as_data_frame(x),
    data.frame(tax_name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
               tax_rank = c('species', 'genus', 'phylum', 'family'),
               tax_id = c('9606', '1386', '4890', '4345'),
               tax_db = 'ncbi',
               tax_author = c('Linnaeus', 'Cohn', NA, 'Juss.'),
               tax_date = c('1758', '1872', NA, '1789'),
               tax_cite = NA_character_)
  )
})

test_that("named taxon objects can be converted to data.frame", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'),
             .names = letters[1:4])
  expect_equal(
    as_data_frame(x),
    data.frame(tax_name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
               tax_rank = c('species', 'genus', 'phylum', 'family'),
               tax_id = c('9606', '1386', '4890', '4345'),
               tax_db = 'ncbi',
               tax_author = c('Linnaeus', 'Cohn', NA, 'Juss.'),
               tax_date = c('1758', '1872', NA, '1789'),
               tax_cite = NA_character_)
  )
})


# Can be converted to a tibble

test_that("taxon objects can be converted to a tibble", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
                   tax_rank = c('species', 'genus', 'phylum', 'family'),
                   tax_id = c('9606', '1386', '4890', '4345'),
                   tax_db = 'ncbi',
                   tax_author = c('Linnaeus', 'Cohn', NA, 'Juss.'),
                   tax_date = c('1758', '1872', NA, '1789'),
                   tax_cite = NA_character_)
  )
})

test_that("named taxon objects can be converted to a tibble", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'),
             .names = letters[1:4])
  expect_equal(
    tibble::as_tibble(x),
    tibble::tibble(tax_name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
                   tax_rank = c('species', 'genus', 'phylum', 'family'),
                   tax_id = c('9606', '1386', '4890', '4345'),
                   tax_db = 'ncbi',
                   tax_author = c('Linnaeus', 'Cohn', NA, 'Juss.'),
                   tax_date = c('1758', '1872', NA, '1789'),
                   tax_cite = NA_character_)
  )
})

# works with is.na

test_that("taxon objects work with is.na", {
  x <- taxon(c('a', NA, 'c'))
  expect_equal(is.na(x), is.na(c('a', NA, 'c')))
})


# works with %in%

test_that("taxon objects work with %in%", {
  x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
             rank = c('species', 'genus', 'phylum', 'family'),
             id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
             auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
  expect_true('Homo sapiens' %in% x)
  expect_equal(x %in% c('Homo sapiens', 'Bacillus'), tax_name(x) %in% c('Homo sapiens', 'Bacillus'))
  expect_true(x[1] %in% x)
  expect_equal(x %in% x[1:2], tax_name(x) %in% c('Homo sapiens', 'Bacillus'))
  expect_false('sapiens' %in% x)
  expect_true(factor('Homo sapiens') %in% x)
  expect_equal(which(x %in% factor('Homo sapiens')), 1)
})



#' Set and get taxon authors
#'
#' Set and get taxon authors in objects that have them, such as [taxon_authority] objects.
#'
#' @param x An object with taxon authors.
#'
#' @examples
#' x <- taxon_authority(c('Cham. & Schldl.', 'L.'),
#'                      date = c('1827', '1753'))
#' tax_author(x)
#' tax_author(x)[1] <- "Billy"
#' tax_author(x) <- tolower(tax_author(x))
#'
#' @export
tax_author <- function(x) {
  UseMethod('tax_author')
}

#' @rdname tax_author
#'
#' @param value The taxon authors to set. Inputs will be coerced into a [character] vector.
#'
#' @export
`tax_author<-` <- function(x, value) {
  UseMethod('tax_author<-')
}



#' Set and get taxon authority dates
#'
#' Set and get the taxon authority dates in objects that have them, such as [taxon_authority] objects.
#'
#' @param x An object with taxon authority dates.
#'
#' @examples
#' x <- taxon_authority(c('Cham. & Schldl.', 'L.'),
#'                      date = c('1827', '1753'))
#' tax_date(x)
#' tax_date(x)[1] <- "1984"
#' tax_date(x) <- c(NA, '1800')
#'
#' @export
tax_date <- function(x) {
  UseMethod('tax_date')
}

#' @rdname tax_date
#'
#' @param value The taxon authority dates to set. Inputs will be coerced into a [character] vector.
#'
#' @export
`tax_date<-` <- function(x, value) {
  UseMethod('tax_date<-')
}



#' Set and get taxon authority citations
#'
#' Set and get the taxon authority citations in objects that have them, such as [taxon_authority] objects.
#'
#' @param x An object with taxon authority dates.
#'
#' @examples
#' x <- taxon_authority(c('Cham. & Schldl.', 'L.'),
#'                      date = c('1827', '1753'),
#'                      citation = c(NA, 'Species Plantarum'))
#' tax_cite(x)
#' tax_cite(x)[1] <- "Cham. et al 1984"
#'
#' @export
tax_cite <- function(x) {
  UseMethod('tax_cite')
}

#' @rdname tax_cite
#'
#' @param value The taxon citations to set. Inputs will be coerced into a [taxon_authority] vector.
#'
#' @export
`tax_cite<-` <- function(x, value) {
  UseMethod('tax_cite<-')
}



#' Set and get taxon ID databases
#'
#' Set and get the taxon ID databases in objects that have them, such as [taxon_id] objects.
#'
#' @param x An object with taxon authority dates.
#'
#' @examples
#' x <- taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi')
#' tax_db(x)
#' tax_db(x) <- 'nbn'
#' tax_db(x)[2] <- 'itis'
#'
#' @export
tax_db <- function(x) {
  UseMethod('tax_db')
}

#' @rdname tax_db
#'
#' @param value The taxon citations to set. Inputs will be coerced into a [taxon_db] vector.
#'
#' @export
`tax_db<-` <- function(x, value) {
  UseMethod('tax_db<-')
}



#' Set and get taxon names
#'
#' Set and get the taxon names in objects that have them, such as [taxon] objects.
#' Note that this is not the same as adding vector names with [names].
#'
#' @param x An object with taxon names.
#'
#' @examples
#' x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
#'            rank = c('species', 'genus', 'phylum', 'family'),
#'            id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
#'            auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
#'
#' tax_name(x)
#' tax_name(x) <- tolower(tax_name(x))
#' tax_name(x)[1] <- 'Billy'
#'
#' @export
tax_name <- function(x) {
  UseMethod('tax_name')
}

#' @rdname tax_name
#'
#' @param value The taxon names to set. Inputs will be coerced into a [character] vector.
#'
#' @export
`tax_name<-` <- function(x, value) {
  UseMethod('tax_name<-')
}



#' Set and get taxon IDs
#'
#' Set and get the taxon IDs in objects that have them, such as [taxon] objects.
#'
#' @param x An object with taxon IDs.
#'
#' @examples
#' x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
#'            rank = c('species', 'genus', 'phylum', 'family'),
#'            id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
#'            auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
#'
#' tax_id(x)
#' tax_id(x) <- paste0('00', tax_id(x))
#' tax_id(x)[1] <- '00000'
#'
#' @export
tax_id <- function(x) {
  UseMethod('tax_id')
}

#' @rdname tax_id
#'
#' @param value The taxon IDs to set. Inputs will be coerced into a [taxon_id] vector.
#'
#' @export
`tax_id<-` <- function(x, value) {
  UseMethod('tax_id<-')
}



#' Set and get taxon authorities
#'
#' Set and get the taxon authorities in objects that have them, such as [taxon] objects.
#' Note that this sets all the authority information, such as author name, date, and citations.
#' To set or get just one of part of the authorities, use [tax_author], [tax_date], or [tax_cite] instead.
#'
#' @param x An object with taxon authorities.
#'
#' @examples
#' x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
#'            rank = c('species', 'genus', 'phylum', 'family'),
#'            id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
#'            auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
#'
#' tax_auth(x)
#' tax_auth(x) <- tolower(tax_auth(x))
#' tax_auth(x)[1] <- 'Billy'
#'
#' @export
tax_auth <- function(x) {
  UseMethod('tax_auth')
}

#' @rdname tax_auth
#'
#' @param value The taxon IDs to set. Inputs will be coerced into a [taxon_id] vector.
#'
#' @export
`tax_auth<-` <- function(x, value) {
  UseMethod('tax_auth<-')
}



#' Set and get taxon ranks
#'
#' Set and get the taxon ranks in objects that have them, such as [taxon] objects.
#'
#' @param x An object with taxon ranks.
#'
#' @examples
#' x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
#'            rank = c('species', 'genus', 'phylum', 'family'),
#'            id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
#'            auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
#'
#' tax_rank(x)
#' tax_rank(x) <- 'species'
#' tax_rank(x)[1] <- taxon_rank('family')
#'
#' @export
tax_rank <- function(x) {
  UseMethod('tax_rank')
}

#' @rdname tax_rank
#'
#' @param value The taxon ranks to set. Inputs will be coerced into a [taxon_rank] vector.
#'
#' @export
`tax_rank<-` <- function(x, value) {
  UseMethod('tax_rank<-')
}

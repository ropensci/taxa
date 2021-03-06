% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxon.R
\name{taxon}
\alias{taxon}
\title{Taxon class}
\usage{
taxon(name = character(0), rank = NA, id = NA, auth = NA, .names = NA, ...)
}
\arguments{
\item{name}{The names of taxa. Inputs with be coerced into a \link{character} vector if anything else
is given.}

\item{rank}{The ranks of taxa. Inputs with be coerced into a \link{taxon_rank} vector if anything else
is given.}

\item{id}{The ids of taxa. These should be unique identifier and are usually associated with a
database. Inputs with be coerced into a \link{taxon_id} vector if anything else is given.}

\item{auth}{The authority of the taxon. Inputs with be coerced into a \link{taxon_authority} vector if
anything else is given.}

\item{.names}{The names of the vector.}

\item{...}{Additional arguments.}
}
\value{
An \code{S3} object of class \code{taxa_taxon}
}
\description{
\Sexpr[results=rd, stage=render]{taxa:::lifecycle("maturing")}
Used to store information about taxa, such as names, ranks, and IDs.
}
\examples{

# Create taxon name vector
x <- taxon(c('A', 'B', 'C'))
x <- taxon(name = c('Homo sapiens', 'Bacillus', 'Ascomycota', 'Ericaceae'),
           rank = c('species', 'genus', 'phylum', 'family'),
           id = taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi'),
           auth = c('Linnaeus, 1758', 'Cohn 1872', NA, 'Juss., 1789'))
names(x) <- c('a', 'b', 'c', 'd')

# Get parts of the taxon name vector
tax_name(x)
tax_rank(x)
tax_id(x)
tax_db(x)
tax_auth(x)
tax_author(x)
tax_date(x)
tax_cite(x)

# Set parts of the taxon name vector
tax_name(x) <- tolower(tax_name(x))
tax_rank(x)[1] <- NA
tax_name(x)['b'] <- 'Billy'
tax_id(x) <- '9999'
tax_db(x) <- 'itis'
tax_auth(x) <- NA
tax_author(x)[2:3] <- c('Joe', 'Billy')
tax_date(x) <- c('1999', '2013', '1796', '1899')
tax_cite(x)[1] <- 'Linnaeus, C. (1771). Mantissa plantarum altera generum.'

# Manipulate taxon name vectors
x[1:3]
x[tax_rank(x) > 'family']
x['b'] <- NA
x[c('c', 'd')] <- 'unknown'
is.na(x)

# Use as columns in tables
tibble::tibble(x = x, y = 1:4)
data.frame(x = x, y = 1:4)

# Converting to tables
tibble::as_tibble(x)
as_data_frame(x)

}
\seealso{
Other classes: 
\code{\link{[.taxa_classification}()},
\code{\link{classification}()},
\code{\link{taxon_authority}()},
\code{\link{taxon_db}()},
\code{\link{taxon_id}()},
\code{\link{taxon_rank}()}
}
\concept{classes}

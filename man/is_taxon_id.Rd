% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxon_id.R
\name{is_taxon_id}
\alias{is_taxon_id}
\title{Check if something is a \link{taxon_id} object}
\usage{
is_taxon_id(x)
}
\arguments{
\item{x}{An object to test}
}
\description{
Check if an object is of the \link{taxon_id} class
}
\examples{
x <- taxon_id(c('9606', '1386', '4890', '4345'), db = 'ncbi')
is_taxon_id(x)
is_taxon_id(1:3)

}

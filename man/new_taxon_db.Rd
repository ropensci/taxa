% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxon_db.R
\name{new_taxon_db}
\alias{new_taxon_db}
\title{Minimal taxon_db constructor}
\usage{
new_taxon_db(db = character(), ...)
}
\arguments{
\item{db}{Zero or more taxonomic database names. Should be a name contained in
\code{names(db_ref)}. Inputs will be transformed to a \code{character} vector.}

\item{...}{Additional arguments.}
}
\value{
An \code{S3} object of class \code{taxa_taxon_db}
}
\description{
Minimal taxon_db constructor for internal use. Only use when the input is known to be valid since
few validity checks are done.
}
\keyword{internal}

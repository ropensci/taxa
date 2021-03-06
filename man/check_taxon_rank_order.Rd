% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxon_rank_level.R
\name{check_taxon_rank_order}
\alias{check_taxon_rank_order}
\title{Check that order is ascending}
\usage{
check_taxon_rank_order(level, order, warn = FALSE)
}
\arguments{
\item{level}{Zero or more taxonomic rank names.}

\item{order}{Integers that determine the relative order of taxonomic levels.}

\item{warn}{If \code{TRUE}, issue a warning when not in ascending order.}
}
\description{
Check that order is ascending and reorder the orders and their levels if needed.
}
\keyword{internal}

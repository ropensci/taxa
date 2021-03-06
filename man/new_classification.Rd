% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classification.R
\name{new_classification}
\alias{new_classification}
\title{Minimal classfication constructor}
\usage{
new_classification(taxonomy = taxonomy(), instances = integer())
}
\arguments{
\item{taxonomy}{A \code{\link[=taxonomy]{taxonomy()}} object.}

\item{instances}{The indexes of each instance of a taxon in the taxonomy. Can be any length.}
}
\value{
An \code{S3} object of class \code{taxa_classification}
}
\description{
Minimal classfication constructor for internal use. Only use when the input is known to be valid
since few validity checks are done.
}
\keyword{internal}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classification.R,
%   R/getter_setter_s3_generics.R, R/taxon.R, R/taxon_authority.R, R/taxonomy.R
\name{tax_cite.taxa_classification}
\alias{tax_cite.taxa_classification}
\alias{tax_cite<-.taxa_classification}
\alias{tax_cite}
\alias{tax_cite<-}
\alias{tax_cite.taxa_taxon}
\alias{tax_cite<-.taxa_taxon}
\alias{tax_cite<-.taxa_taxon_authority}
\alias{tax_cite.taxa_taxon_authority}
\alias{tax_cite.taxa_taxonomy}
\alias{tax_cite<-.taxa_taxonomy}
\title{Set and get taxon authority citations}
\usage{
\method{tax_cite}{taxa_classification}(x)

\method{tax_cite}{taxa_classification}(x) <- value

tax_cite(x)

tax_cite(x) <- value

\method{tax_cite}{taxa_taxon}(x)

\method{tax_cite}{taxa_taxon}(x) <- value

\method{tax_cite}{taxa_taxon_authority}(x) <- value

\method{tax_cite}{taxa_taxon_authority}(x)

\method{tax_cite}{taxa_taxonomy}(x)

\method{tax_cite}{taxa_taxonomy}(x) <- value
}
\arguments{
\item{x}{An object with taxon authority dates.}

\item{value}{The taxon citations to set. Inputs will be coerced into a \link{taxon_authority} vector.}
}
\description{
Set and get the taxon authority citations in objects that have them, such as \link{taxon_authority} objects.
}
\examples{
x <- taxon_authority(c('Cham. & Schldl.', 'L.'),
                     date = c('1827', '1753'),
                     citation = c(NA, 'Species Plantarum'))
tax_cite(x)
tax_cite(x)[1] <- "Cham. et al 1984"

}

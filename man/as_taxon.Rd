% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxon.R
\name{as_taxon}
\alias{as_taxon}
\title{Convert to a \link{taxon} vector}
\usage{
as_taxon(x, ...)
}
\arguments{
\item{x}{An object to be converted to a taxon vector}

\item{...}{Additional parameters.}
}
\description{
Convert other objects to \link{taxon} vectors. Compatible base R vectors can also
be converted using the \link[=taxon]{taxon constructor}.
}
\examples{

# Convert a taxonomy object to a taxon vector
x <- taxonomy(taxon(name = c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                             'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
                    rank = c('order', 'family', 'genus', 'species',
                             'species', 'family', 'genus', 'species'),
                    id = taxon_id(c('33554', '9681', '9688', '9689',
                                    '9694', '9632', '9639', '9644'),
                                  db = 'ncbi'),
                    auth = c('Bowdich, 1821', 'Fischer de Waldheim, 1817', 'Oken, 1816', 'L., 1758',
                             'L., 1758', 'Fischer de Waldheim, 1817', 'L., 1758', 'L., 1758')),
              supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
names(x) <- letters[1:8]
as_taxon(x)

# Convert base R vectors
as_taxon(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo'))
as_taxon(factor(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo')))

}

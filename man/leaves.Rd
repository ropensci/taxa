% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxonomy.R
\name{leaves}
\alias{leaves}
\title{Get leaves}
\usage{
leaves(x, value = NULL, ...)
}
\arguments{
\item{x}{The object to get leaves for, such as a \link{taxonomy} object}

\item{value}{Something to return instead of indexes. Must be the same length as the number of taxa.}

\item{...}{Additional arguments.}
}
\description{
Get leaves indexes for each taxon or another per-taxon value. Leaves are taxa with no subtaxa.
}
\examples{
x <- taxonomy(c('Carnivora', 'Felidae', 'Panthera', 'Panthera leo',
                'Panthera tigris', 'Ursidae', 'Ursus', 'Ursus arctos'),
              supertaxa = c(NA, 1, 2, 3, 3, 1, 6, 7))
leaves(x)
leaves(x, value = tax_name(x))

}
\seealso{
Other taxonomy functions: 
\code{\link{internodes}()},
\code{\link{roots}()},
\code{\link{stems}()},
\code{\link{subtaxa}()},
\code{\link{supertaxa}()}

Other leaf functions: 
\code{\link{is_leaf}()},
\code{\link{n_leaves}()}
}
\concept{leaf functions}
\concept{taxonomy functions}

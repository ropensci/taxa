taxa
====

[![Build
Status](https://travis-ci.org/ropensci/taxa.svg?branch=master)](https://travis-ci.org/ropensci/taxa)
[![cran
checks](https://cranchecks.info/badges/worst/taxa)](https://cranchecks.info/pkgs/taxa)
[![codecov](https://codecov.io/gh/ropensci/taxa/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/taxa)
[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![rstudio mirror
downloads](http://cranlogs.r-pkg.org/badges/taxa)](https://github.com/metacran/cranlogs.app)
[![cran
version](http://www.r-pkg.org/badges/version/taxa)](https://cran.r-project.org/package=taxa)

`taxa` defines taxonomic classes and functions to manipulate them. The
goal is to use these classes as low level fundamental taxonomic classes
that other R packages can build on and supply robust manipulation
functions (e.g. subsetting) that are broadly useful.

There are two distinct types of classes in `taxa`:

-   Classes that are concerned only with taxonomic information: `taxon`,
    `taxonomy`, `hierarchy`, etc.
-   A class called `taxmap` that is concerned with combining taxonomic
    data with user-defined data of any type (e.g. molecular sequences,
    abundance counts etc.)

Diagram of class concepts for `taxa` classes:

Relationship between classes implemented in the taxa package.
Diamond-tipped arrows indicate that objects of one class are used in
another class. For example, a database object can stored in the
taxon\_rank, taxon\_name, or taxon\_id objects. A standard arrow
indicates inheritance. For example, the taxmap class inherits the
taxonomy class. `*` means that the object (e.g. a database object) can
be replaced by a simple character vector. `?` means that the data is
optional (Note: being able to replace objects with characters might be
going away soon).

Install
-------

For the latest “stable” release, use the CRAN version:

    install.packages("taxa")

For all the latest improvements, bug fixes, and bugs, you can download
the development version:

    devtools::install_github("ropensci/taxa")

    library("taxa")

The classes
-----------

### Minor component classes

There are a few optional classes used to store information in other
classes. These will probably mostly be of interest to developers rather
than users.

#### database

Taxonomic data usually comes from a database. A common example is the
[NCBI Taxonomy Database](https://www.ncbi.nlm.nih.gov/taxonomy) used to
provide taxonomic classifications to sequences deposited in [other NCBI
databases](https://www.ncbi.nlm.nih.gov/guide/all/). The `database`
class stores the name of the database and associated information:

    (ncbi <- taxon_database(
      name = "ncbi",
      url = "http://www.ncbi.nlm.nih.gov/taxonomy",
      description = "NCBI Taxonomy Database",
      id_regex = "*"
    ))
    ncbi$name
    ncbi$url

To save on memory, a selection of common databases is provided with the
package (`database_list`) and any in this list can be used by name
instead of making a new database object (e.g. `"ncbi"` instead of the
`ncbi` above).

    database_list

#### rank

Taxa might have defined ranks (e.g. species, family, etc.), ambiguous
ranks (e.g. “unranked”, “unknown”), or no rank information at all. The
particular selection and format of valid ranks varies with database, so
the database can be optionally defined. If no database is defined, any
ranks in any order are allowed.

    taxon_rank(name = "species", database = "ncbi")

#### `taxon_name`

The taxon name can be defined in the same way as rank.

    taxon_name("Poa", database = "ncbi")

#### taxon\_id

Each database has its set of unique taxon IDs. These IDs are better than
using the taxon name directly because they are guaranteed to be unique,
whereas there are often duplicates of taxon names (e.g. *Orestias
elegans* is the name of both an orchid and a fish).

    taxon_id(12345, database = "ncbi")

### The “taxon” class

The `taxon` class combines the classes containing the name, rank, and ID
for the taxon. There is also a place to define an authority of the
taxon.

    (x <- taxon(
      name = taxon_name("Poa annua"),
      rank = taxon_rank("species"),
      id = taxon_id(93036),
      authority = "Linnaeus"
    ))

Instead of the name, rank, and ID classes, simple character vectors can
be supplied. These will be converted to objects automatically.

    (x <- taxon(
      name = "Poa annua",
      rank = "species",
      id = 93036,
      authority = "Linnaeus"
    ))

The `taxa` class is just a list of `taxon` classes. It is meant to store
an arbitrary list of `taxon` objects.

    grass <- taxon(
      name = taxon_name("Poa annua"),
      rank = taxon_rank("species"),
      id = taxon_id(93036)
    )
    mammalia <- taxon(
      name = taxon_name("Mammalia"),
      rank = taxon_rank("class"),
      id = taxon_id(9681)
    )
    plantae <- taxon(
      name = taxon_name("Plantae"),
      rank = taxon_rank("kingdom"),
      id = taxon_id(33090)
    )

    taxa(grass, mammalia, plantae)

### The “hierarchy” class

[Taxonomic
classifications](https://en.wikipedia.org/wiki/Taxonomy_(biology)#Classifying_organisms)
are an ordered set of taxa, each at a different rank. The `hierarchy`
class stores a list of `taxon` classes like `taxa`, but `hierarchy` is
meant to store all of the taxa in a classification in the correct order.

    x <- taxon(
      name = taxon_name("Poaceae"),
      rank = taxon_rank("family"),
      id = taxon_id(4479)
    )

    y <- taxon(
      name = taxon_name("Poa"),
      rank = taxon_rank("genus"),
      id = taxon_id(4544)
    )

    z <- taxon(
      name = taxon_name("Poa annua"),
      rank = taxon_rank("species"),
      id = taxon_id(93036)
    )

    (hier1 <- hierarchy(z, y, x))

Multiple `hierarchy` classes are stored in the `hierarchies` class,
similar to how multiple `taxon` are stored in `taxa`.

    a <- taxon(
      name = taxon_name("Felidae"),
      rank = taxon_rank("family"),
      id = taxon_id(9681)
    )
    b <- taxon(
      name = taxon_name("Puma"),
      rank = taxon_rank("genus"),
      id = taxon_id(146712)
    )
    c <- taxon(
      name = taxon_name("Puma concolor"),
      rank = taxon_rank("species"),
      id = taxon_id(9696)
    )
    (hier2 <- hierarchy(c, b, a))

    hierarchies(hier1, hier2)

### The “taxonomy” class

The `taxonomy` class stores unique `taxon` objects in a tree structure.
Usually this kind of complex information would be the output of a file
parsing function, but the code below shows how to construct a `taxonomy`
object from scratch (you would not normally do this).

    # define taxa
    notoryctidae <- taxon(name = "Notoryctidae", rank = "family", id = 4479)
    notoryctes <- taxon(name = "Notoryctes", rank = "genus", id = 4544)
    typhlops <- taxon(name = "typhlops", rank = "species", id = 93036)
    mammalia <- taxon(name = "Mammalia", rank = "class", id = 9681)
    felidae <- taxon(name = "Felidae", rank = "family", id = 9681)
    felis <- taxon(name = "Felis", rank = "genus", id = 9682)
    catus <- taxon(name = "catus", rank = "species", id = 9685)
    panthera <- taxon(name = "Panthera", rank = "genus", id = 146712)
    tigris <- taxon(name = "tigris", rank = "species", id = 9696)
    plantae <- taxon(name = "Plantae", rank = "kingdom", id = 33090)
    solanaceae <- taxon(name = "Solanaceae", rank = "family", id = 4070)
    solanum <- taxon(name = "Solanum", rank = "genus", id = 4107)
    lycopersicum <- taxon(name = "lycopersicum", rank = "species", id = 49274)
    tuberosum <- taxon(name = "tuberosum", rank = "species", id = 4113)
    homo <- taxon(name = "homo", rank = "genus", id = 9605)
    sapiens <- taxon(name = "sapiens", rank = "species", id = 9606)
    hominidae <- taxon(name = "Hominidae", rank = "family", id = 9604)

    # define hierarchies
    tiger <- hierarchy(mammalia, felidae, panthera, tigris)
    cat <- hierarchy(mammalia, felidae, felis, catus)
    human <- hierarchy(mammalia, hominidae, homo, sapiens)
    mole <- hierarchy(mammalia, notoryctidae, notoryctes, typhlops)
    tomato <- hierarchy(plantae, solanaceae, solanum, lycopersicum)
    potato <- hierarchy(plantae, solanaceae, solanum, tuberosum)

    # make taxonomy
    (tax <- taxonomy(tiger, cat, human, tomato, potato))

Unlike the `hierarchies` class, each unique `taxon` object is only
represented once in the `taxonomy` object. Each taxon has a
corresponding entry in an [edge
list](https://en.wikipedia.org/wiki/Adjacency_list) that encode how it
is related to other taxa. This makes `taxonomy` more compact, but harder
to manipulate using standard indexing. To make manipulation easier,
there are functions like `filter_taxa` and `subtaxa` that will be
covered later. In general, the `taxonomy` and `taxmap` objects (covered
later) would be instantiated using a parser like `parse_tax_data`. This
is covered in detail in the parsing vignette.

#### supertaxa

A “supertaxon” is a taxon of a coarser rank that encompasses the taxon
of interest (e.g. “Homo” is a supertaxon of “sapiens”). The `supertaxa`
function returns the supertaxa of all or a subset of the taxa in a
`taxonomy` object.

    supertaxa(tax)

By default, the taxon IDs for the supertaxa of all taxa are returned in
the same order they appear in the edge list. Taxon IDs (character) or
edge list indexes (integer) can be supplied to the `subset` option to
only return information for some taxa.

    supertaxa(tax, subset = "m")

What is returned can be modified with the `value` option:

    supertaxa(tax, subset = "m", value = "taxon_names")

    supertaxa(tax, subset = "m", value = "taxon_ranks")

You can also subset based on a logical test:

    supertaxa(tax, subset = taxon_ranks == "genus", value = "taxon_ranks")

The `subset` and `value` work the same for most of the following
functions as well. See `all_names(tax)` for what can be used with
`value` and `subset`. Note how `value` takes a character vector
(`"taxon_ranks"`), but `subset` can use the same value (`taxon_ranks`)
as a part of an expression. `taxon_ranks` is actually a function that is
run automatically when its name is used this way:

    taxon_ranks(tax)

This is an example of [Non-standard
evaluation](http://adv-r.had.co.nz/Computing-on-the-language.html)
(NSE). NSE makes codes easier to read an write. The call to `supertaxa`
could also have been written without NSE like so:

    supertaxa(tax, subset = taxon_ranks(tax) == "genus", value = "taxon_ranks")

#### subtaxa

The “subtaxa” of a taxon are all those of a finer rank encompassed by
that taxon. For example, *sapiens* is a subtaxon of *Homo*. The
`subtaxa` function returns all subtaxa for each taxon in a `taxonomy`
object.

    subtaxa(tax, value = "taxon_names")

This and the following functions behaves much like `supertaxa`, so we
will not go into the same details here.

#### roots

We call taxa that have no supertaxa “roots”. The `roots` function
returns these taxa.

    roots(tax, value = "taxon_names")

#### leaves

We call taxa without any subtaxa “leaves”. The `leaves` function returns
these taxa.

    leaves(tax, value = "taxon_names")

#### other functions

There are many other functions to interact with `taxonomy` object, such
as `stems` and `n_subtaxa`, but these will not be described here for
now.

### The “taxmap” class

The `taxmap` class is used to store any number of tables, lists, or
vectors associated with taxa. It is basically the same as the `taxonomy`
class, but with the following additions:

-   A list called `data` that stores arbitrary user data associated with
    taxa
-   A list called `funcs` that stores user defined functions

All the functions described above for the `taxonomy` class can be used
with the `taxmap` class.

    info <- data.frame(name = c("tiger", "cat", "mole", "human", "tomato", "potato"),
                       n_legs = c(4, 4, 4, 2, 0, 0),
                       dangerous = c(TRUE, FALSE, FALSE, TRUE, FALSE, FALSE))

    phylopic_ids <- c("e148eabb-f138-43c6-b1e4-5cda2180485a",
                      "12899ba0-9923-4feb-a7f9-758c3c7d5e13",
                      "11b783d5-af1c-4f4e-8ab5-a51470652b47",
                      "9fae30cd-fb59-4a81-a39c-e1826a35f612",
                      "b6400f39-345a-4711-ab4f-92fd4e22cb1a",
                      "63604565-0406-460b-8cb8-1abe954b3f3a")

    foods <- list(c("mammals", "birds"),
                  c("cat food", "mice"),
                  c("insects"),
                  c("Most things, but especially anything rare or expensive"),
                  c("light", "dirt"),
                  c("light", "dirt"))

    reaction <- function(x) {
      ifelse(x$data$info$dangerous,
             paste0("Watch out! That ", x$data$info$name, " might attack!"),
             paste0("No worries; its just a ", x$data$info$name, "."))
    }

    my_taxmap <- taxmap(tiger, cat, mole, human, tomato, potato,
                        data = list(info = info,
                                    phylopic_ids = phylopic_ids,
                                    foods = foods),
                        funcs = list(reaction = reaction))

In most functions that work with taxmap objects, the names of
list/vector data sets, table columns, or functions can be used as if
they were separate variables on their own (i.e. NSE). In the case of
functions, instead of returning the function itself, the results of the
functions are returned. To see what variables can be used this way, use
`all_names`.

    all_names(my_taxmap)

For example using `my_taxmap$data$info$n_legs` or `n_legs` will have the
same effect inside manipulation functions like `filter_taxa` described
below. This is similar to how `taxon_ranks` was used in `supertaxa` in a
previous section. To get the values of these variables, use `get_data`.

    get_data(my_taxmap)

Note how “taxon\_names” and “dangerous” are used below.

#### Filtering

In addition to all of the functions like `subtaxa` that work with
`taxonomy`, `taxmap` has a set of functions to manipulate data in a
taxonomic context using functions based on **dplyr**. Like many
operations on `taxmap` objects, there are a pair of functions that
modify the taxa as well as the associated data, which we call
“observations”. The `filter_taxa` and `filter_obs` functions are an
example of such a pair that can filter taxa and observations
respectively. For example, we can use `filter_taxa` to subset all taxa
with a name starting with “t”:

    filter_taxa(my_taxmap, startsWith(taxon_names, "t"))

There can be any number of filters that resolve to TRUE/FALSE vectors,
taxon ids, or edge list indexes. For example, below is a combination of
a TRUE/FALSE vectors and taxon id filter:

    filter_taxa(my_taxmap, startsWith(taxon_names, "t"), c("b", "r", "o"))

There are many options for `filter_taxa` that make it very flexible. For
example, the `supertaxa` option can make all the supertaxa of selected
taxa be preserved.

    filter_taxa(my_taxmap, startsWith(taxon_names, "t"), supertaxa = TRUE)

The `filter_obs` function works in a similar way, but subsets
observations in `my_taxmap$data`.

    filter_obs(my_taxmap, "info", dangerous == TRUE)

You can choose to filter out taxa whose observations did not pass the
filter as well:

    filter_obs(my_taxmap, "info", dangerous == TRUE, drop_taxa = TRUE)

Note how both the taxonomy and the associated data sets were filtered.
The `drop_obs` option can be used to specify which non-target (i.e. not
`"info"`) data sets are filtered when taxa are removed.

#### Sampling

The functions `sample_n_obs` and `sample_n_taxa` are similar to
`filter_obs` and `filter_taxa`, except taxa/observations are chosen
randomly. All of the options of the “filter\_” functions are available
to the “sample\_” functions

    set.seed(1)
    sample_n_taxa(my_taxmap, 3) # "3" here is a taxon index in the edge list
    set.seed(1)
    sample_n_taxa(my_taxmap, 3, supertaxa = TRUE)

#### Adding columns

Adding columns to tabular data sets is done using `mutate_obs`.

    mutate_obs(my_taxmap, "info",
               new_col = "Im new",
               newer_col = paste0(new_col, "er!"))

Note how you can use newly created columns in the same call.

#### Subsetting columns

Subsetting columns in tabular data sets is done using `select_obs`.

    # Selecting a column by name
    select_obs(my_taxmap, "info", dangerous)

    # Selecting a column by index
    select_obs(my_taxmap, "info", 3)

    # Selecting a column by regular expressions (i.e. TRUE/FALSE)
    select_obs(my_taxmap, "info", matches("^dange"))

#### Sorting

Sorting the edge list and observations is done using `arrage_taxa` and
`arrange_obs`.

    arrange_taxa(my_taxmap, taxon_names)
    arrange_obs(my_taxmap, "info", name)

#### Parsing data

The `taxmap` class has the ability to contain and manipulate very
complex data. However, this can make it difficult to parse the data into
a `taxmap` object. For this reason, there are three functions to help
creating `taxmap` objects from nearly any kind of data that a taxonomy
can be associated with or derived from. The figure below shows
simplified versions of how to create `taxmap` objects from different
types of data in different formats.

The `parse_tax_data` and `lookup_tax_data` have, in addition to the
functionality above, the ability to include additional data sets that
are somehow associated with the source data sets (e.g. share a common
identifier). Elements in these data sets will be assigned the taxa
defined in the source data, so functions like `filter_taxa` and
`filter_obs` will work on all of the data set at once. See the parsing
vignette for more information.

Parsing Hierarchy and hierarchies objects
-----------------------------------------

A set of functions are available for parsing objects of class
`Hierarchy` and `hierarchies`. These functions are being ported from the
CRAN package `binomen`.

The functions below are “taxonomically aware” so that you can use for
example `>` and `<` operators to filter your taxonomic names data.

### pick

`pick()` - Pick out specific taxa, while others are dropped

    ex_hierarchy1
    # specific ranks by rank name
    pick(ex_hierarchy1, ranks("family"))
    # two elements by taxonomic name
    pick(ex_hierarchy1, nms("Poaceae", "Poa"))
    # two elements by taxonomic identifier
    pick(ex_hierarchy1, ids(4479, 4544))
    # combine types
    pick(ex_hierarchy1, ranks("family"), ids(4544))

### pop

`pop()` - Pop out taxa, that is, drop them

    ex_hierarchy1
    # specific ranks by rank name
    pop(ex_hierarchy1, ranks("family"))
    # two elements by taxonomic name
    pop(ex_hierarchy1, nms("Poaceae", "Poa"))
    # two elements by taxonomic identifier
    pop(ex_hierarchy1, ids(4479, 4544))
    # combine types
    pop(ex_hierarchy1, ranks("family"), ids(4544))

### span

`span()` - Select a range of taxa, either by two names, or relational
operators

    ex_hierarchy1
    # keep all taxa between family and genus
    # - by rank name, taxonomic name or ID
    span(ex_hierarchy1, nms("Poaceae", "Poa"))

    # keep all taxa greater than genus
    span(ex_hierarchy1, ranks("> genus"))

    # keep all taxa greater than or equal to genus
    span(ex_hierarchy1, ranks(">= genus"))

    # keep all taxa less than Felidae
    span(ex_hierarchy2, nms("< Felidae"))

    ## Multiple operator statements - useful with larger classifications
    ex_hierarchy3
    span(ex_hierarchy3, ranks("> genus"), ranks("< phylum"))

For more information
--------------------

This vignette is meant to be just an outline of what `taxa` can do. In
the future, we plan to release additional, in-depth vignettes for
specific topics. More information for specific functions and examples
can be found on their man pages by typing the name of the function
prefixed by a `?` in an R session. For example, `?filter_taxa` will pull
up the help page for `filter_taxa`.

Use cases
---------

-   use in [binomen](https://github.com/ropensci/binomen):
    -   if this pkg does classes, `binomen` can focus on
        [verbs](https://github.com/ropensci/binomen#verbs), e.g.,
        manipulating taxonomic classes, doing `split-apply-combine` type
        things
-   use in [taxize](https://github.com/ropensci/taxize):
    -   as we don’t want to break things, probably ideal to have
        coercion fxns, e.g., `as.taxon()`, which will convert e.g., the
        output of `get_uid()` to a `taxa` taxonomic class, which we can
        then go downstream and do things with (i.e., whatever we build
        on top of the classes)
    -   Or we could even have output of `get_*()` functions do coercion
        to `taxa` classes on output since they are just simple S3
        classes without print methods right now
-   use in [metacoder](https://github.com/grunwaldlab/metacoder): This
    will eventually replace the similar classes used in metacoder.

Contributors
------------

-   [Scott Chamberlain](https://github.com/sckott)
-   [Zachary Foster](https://github.com/zachary-foster)

Comments and contributions
--------------------------

We welcome comments, criticisms, and especially contributions! GitHub
issues are the preferred way to report bugs, ask questions, or request
new features. You can submit issues here:

<a href="https://github.com/ropensci/taxa/issues" class="uri">https://github.com/ropensci/taxa/issues</a>

Meta
----

-   Please [report any issues or
    bugs](https://github.com/ropensci/taxa/issues).
-   License: MIT
-   Get citation information for `taxa` in R doing
    `citation(package = 'taxa')`
-   Please note that this project is released with a [Contributor Code
    of Conduct](code_of_conduct.md). By participating in this project
    you agree to abide by its terms.

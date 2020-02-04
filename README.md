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
functions (e.g. subsetting) that are broadly useful.

There are two distinct types of classes in `taxa`:

-   Classes that are concerned only with taxonomic information: `taxon`,
    `taxonomy`, `hierarchy`, etc.
-   A class called `taxmap` that is concerned with combining taxonomic
    data with user-defined data of any type (e.g. molecular sequences,
    abundance counts etc.)

Diagram of class concepts for `taxa` classes:

<img src="vignettes/class_diagram.png" title="taxa classes diagram" width="718">

Relationship between classes implemented in the taxa package.
Diamond-tipped arrows indicate that objects of one class are used in
another class. For example, a database object can stored in the
taxon\_rank, taxon\_name, or taxon\_id objects. A standard arrow
indicates inheritance. For example, the taxmap class inherits the
taxonomy class. `*` means that the object (e.g. a database object) can
be replaced by a simple character vector. `?` means that the data is
optional (Note: being able to replace objects with characters might be
going away soon).

Install
-------

For the latest "stable" release, use the CRAN version:

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
    #> <database> ncbi
    #>   url: http://www.ncbi.nlm.nih.gov/taxonomy
    #>   description: NCBI Taxonomy Database
    #>   id regex: *
    ncbi$name
    #> [1] "ncbi"
    ncbi$url
    #> [1] "http://www.ncbi.nlm.nih.gov/taxonomy"

To save on memory, a selection of common databases is provided with the
package (`database_list`) and any in this list can be used by name
instead of making a new database object (e.g. `"ncbi"` instead of the
`ncbi` above).

    database_list
    #> $ncbi
    #> <database> ncbi
    #>   url: http://www.ncbi.nlm.nih.gov/taxonomy
    #>   description: NCBI Taxonomy Database
    #>   id regex: .*
    #> 
    #> $gbif
    #> <database> gbif
    #>   url: http://www.gbif.org/developer/species
    #>   description: GBIF Taxonomic Backbone
    #>   id regex: .*
    #> 
    #> $bold
    #> <database> bold
    #>   url: http://www.boldsystems.org
    #>   description: Barcode of Life
    #>   id regex: .*
    #> 
    #> $col
    #> <database> col
    #>   url: http://www.catalogueoflife.org
    #>   description: Catalogue of Life
    #>   id regex: .*
    #> 
    #> $eol
    #> <database> eol
    #>   url: http://eol.org
    #>   description: Encyclopedia of Life
    #>   id regex: .*
    #> 
    #> $nbn
    #> <database> nbn
    #>   url: https://nbn.org.uk
    #>   description: UK National Biodiversity Network
    #>   id regex: .*
    #> 
    #> $tps
    #> <database> tps
    #>   url: http://www.tropicos.org/
    #>   description: Tropicos
    #>   id regex: .*
    #> 
    #> $itis
    #> <database> itis
    #>   url: http://www.itis.gov
    #>   description: Integrated Taxonomic Information System
    #>   id regex: .*

#### rank

Taxa might have defined ranks (e.g. species, family, etc.), ambiguous
ranks (e.g. "unranked", "unknown"), or no rank information at all. The
particular selection and format of valid ranks varies with database, so
the database can be optionally defined. If no database is defined, any
ranks in any order are allowed.

    taxon_rank(name = "species", database = "ncbi")
    #> <TaxonRank> species
    #>   database: ncbi

#### `taxon_name`

The taxon name can be defined in the same way as rank.

    taxon_name("Poa", database = "ncbi")
    #> <TaxonName> Poa
    #>   database: ncbi

#### taxon\_id

Each database has its set of unique taxon IDs. These IDs are better than
using the taxon name directly because they are guaranteed to be unique,
whereas there are often duplicates of taxon names (e.g. *Orestias
elegans* is the name of both an orchid and a fish).

    taxon_id(12345, database = "ncbi")
    #> <TaxonId> 12345
    #>   database: ncbi

### The "taxon" class

The `taxon` class combines the classes containing the name, rank, and ID
for the taxon. There is also a place to define an authority of the
taxon.

    (x <- taxon(
      name = taxon_name("Poa annua"),
      rank = taxon_rank("species"),
      id = taxon_id(93036),
      authority = "Linnaeus"
    ))
    #> <Taxon>
    #>   name: Poa annua
    #>   rank: species
    #>   id: 93036
    #>   authority: Linnaeus

Instead of the name, rank, and ID classes, simple character vectors can
be supplied. These will be converted to objects automatically.

    (x <- taxon(
      name = "Poa annua",
      rank = "species",
      id = 93036,
      authority = "Linnaeus"
    ))
    #> <Taxon>
    #>   name: Poa annua
    #>   rank: species
    #>   id: 93036
    #>   authority: Linnaeus

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
    #> <taxa> 
    #>   no. taxa:  3 
    #>   Poa annua / species / 93036 
    #>   Mammalia / class / 9681 
    #>   Plantae / kingdom / 33090

### The "hierarchy" class

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
    #> <Hierarchy>
    #>   no. taxon's:  3 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544 
    #>   Poa annua / species / 93036

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
    #> <Hierarchy>
    #>   no. taxon's:  3 
    #>   Felidae / family / 9681 
    #>   Puma / genus / 146712 
    #>   Puma concolor / species / 9696

    hierarchies(hier1, hier2)
    #> <Hierarchies> 
    #>   no. hierarchies:  2 
    #>   Poaceae / Poa / Poa annua 
    #>   Felidae / Puma / Puma concolor

### The "taxonomy" class

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
    #> <Taxonomy>
    #>   14 taxa: b. Mammalia, c. Plantae ... o. tuberosum
    #>   14 edges: NA->b, NA->c, b->d, b->e ... i->m, j->n, j->o

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

A "supertaxon" is a taxon of a coarser rank that encompasses the taxon
of interest (e.g. "Homo" is a supertaxon of "sapiens"). The `supertaxa`
function returns the supertaxa of all or a subset of the taxa in a
`taxonomy` object.

    supertaxa(tax)
    #> $b
    #> named integer(0)
    #> 
    #> $c
    #> named integer(0)
    #> 
    #> $d
    #> b 
    #> 1 
    #> 
    #> $e
    #> b 
    #> 1 
    #> 
    #> $f
    #> c 
    #> 2 
    #> 
    #> $g
    #> d b 
    #> 3 1 
    #> 
    #> $h
    #> d b 
    #> 3 1 
    #> 
    #> $i
    #> e b 
    #> 4 1 
    #> 
    #> $j
    #> f c 
    #> 5 2 
    #> 
    #> $k
    #> g d b 
    #> 6 3 1 
    #> 
    #> $l
    #> h d b 
    #> 7 3 1 
    #> 
    #> $m
    #> i e b 
    #> 8 4 1 
    #> 
    #> $n
    #> j f c 
    #> 9 5 2 
    #> 
    #> $o
    #> j f c 
    #> 9 5 2

By default, the taxon IDs for the supertaxa of all taxa are returned in
the same order they appear in the edge list. Taxon IDs (character) or
edge list indexes (integer) can be supplied to the `subset` option to
only return information for some taxa.

    supertaxa(tax, subset = "m")
    #> $m
    #> i e b 
    #> 8 4 1

What is returned can be modified with the `value` option:

    supertaxa(tax, subset = "m", value = "taxon_names")
    #> $m
    #>           i           e           b 
    #>      "homo" "Hominidae"  "Mammalia"

    supertaxa(tax, subset = "m", value = "taxon_ranks")
    #> $m
    #>        i        e        b 
    #>  "genus" "family"  "class"

You can also subset based on a logical test:

    supertaxa(tax, subset = taxon_ranks == "genus", value = "taxon_ranks")
    #> $g
    #>        d        b 
    #> "family"  "class" 
    #> 
    #> $h
    #>        d        b 
    #> "family"  "class" 
    #> 
    #> $i
    #>        e        b 
    #> "family"  "class" 
    #> 
    #> $j
    #>         f         c 
    #>  "family" "kingdom"

The `subset` and `value` work the same for most of the following
functions as well. See `all_names(tax)` for what can be used with
`value` and `subset`. Note how `value` takes a character vector
(`"taxon_ranks"`), but `subset` can use the same value (`taxon_ranks`)
as a part of an expression. `taxon_ranks` is actually a function that is
run automatically when its name is used this way:

    taxon_ranks(tax)
    #>         b         c         d         e         f         g         h 
    #>   "class" "kingdom"  "family"  "family"  "family"   "genus"   "genus" 
    #>         i         j         k         l         m         n         o 
    #>   "genus"   "genus" "species" "species" "species" "species" "species"

This is an example of [Non-standard
evaluation](http://adv-r.had.co.nz/Computing-on-the-language.html)
(NSE). NSE makes codes easier to read and write. The call to `supertaxa`
could also have been written without NSE like so:

    supertaxa(tax, subset = taxon_ranks(tax) == "genus", value = "taxon_ranks")
    #> $g
    #>        d        b 
    #> "family"  "class" 
    #> 
    #> $h
    #>        d        b 
    #> "family"  "class" 
    #> 
    #> $i
    #>        e        b 
    #> "family"  "class" 
    #> 
    #> $j
    #>         f         c 
    #>  "family" "kingdom"

#### subtaxa

The "subtaxa" of a taxon are all those of a finer rank encompassed by
that taxon. For example, *sapiens* is a subtaxon of *Homo*. The
`subtaxa` function returns all subtaxa for each taxon in a `taxonomy`
object.

    subtaxa(tax, value = "taxon_names")
    #> $b
    #>           d           g           k           h           l           e 
    #>   "Felidae"  "Panthera"    "tigris"     "Felis"     "catus" "Hominidae" 
    #>           i           m 
    #>      "homo"   "sapiens" 
    #> 
    #> $c
    #>              f              j              n              o 
    #>   "Solanaceae"      "Solanum" "lycopersicum"    "tuberosum" 
    #> 
    #> $d
    #>          g          k          h          l 
    #> "Panthera"   "tigris"    "Felis"    "catus" 
    #> 
    #> $e
    #>         i         m 
    #>    "homo" "sapiens" 
    #> 
    #> $f
    #>              j              n              o 
    #>      "Solanum" "lycopersicum"    "tuberosum" 
    #> 
    #> $g
    #>        k 
    #> "tigris" 
    #> 
    #> $h
    #>       l 
    #> "catus" 
    #> 
    #> $i
    #>         m 
    #> "sapiens" 
    #> 
    #> $j
    #>              n              o 
    #> "lycopersicum"    "tuberosum" 
    #> 
    #> $k
    #> named character(0)
    #> 
    #> $l
    #> named character(0)
    #> 
    #> $m
    #> named character(0)
    #> 
    #> $n
    #> named character(0)
    #> 
    #> $o
    #> named character(0)

This and the following functions behaves much like `supertaxa`, so we
will not go into the same details here.

#### roots

We call taxa that have no supertaxa "roots". The `roots` function
returns these taxa.

    roots(tax, value = "taxon_names")
    #>          b          c 
    #> "Mammalia"  "Plantae"

#### leaves

We call taxa without any subtaxa "leaves". The `leaves` function returns
these taxa.

    leaves(tax, value = "taxon_names")
    #> $b
    #>         k         l         m 
    #>  "tigris"   "catus" "sapiens" 
    #> 
    #> $c
    #>              n              o 
    #> "lycopersicum"    "tuberosum" 
    #> 
    #> $d
    #>        k        l 
    #> "tigris"  "catus" 
    #> 
    #> $e
    #>         m 
    #> "sapiens" 
    #> 
    #> $f
    #>              n              o 
    #> "lycopersicum"    "tuberosum" 
    #> 
    #> $g
    #>        k 
    #> "tigris" 
    #> 
    #> $h
    #>       l 
    #> "catus" 
    #> 
    #> $i
    #>         m 
    #> "sapiens" 
    #> 
    #> $j
    #>              n              o 
    #> "lycopersicum"    "tuberosum" 
    #> 
    #> $k
    #> named character(0)
    #> 
    #> $l
    #> named character(0)
    #> 
    #> $m
    #> named character(0)
    #> 
    #> $n
    #> named character(0)
    #> 
    #> $o
    #> named character(0)

#### other functions

There are many other functions to interact with `taxonomy` object, such
as `stems` and `n_subtaxa`, but these will not be described here for
now.

### The "taxmap" class

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
they were separate variables on their own (i.e. NSE). In the case of
functions, instead of returning the function itself, the results of the
functions are returned. To see what variables can be used this way, use
`all_names`.

    all_names(my_taxmap)
    #>         taxon_names           taxon_ids       taxon_indexes 
    #>       "taxon_names"         "taxon_ids"     "taxon_indexes" 
    #>     classifications         n_supertaxa       n_supertaxa_1 
    #>   "classifications"       "n_supertaxa"     "n_supertaxa_1" 
    #>           n_subtaxa         n_subtaxa_1            n_leaves 
    #>         "n_subtaxa"       "n_subtaxa_1"          "n_leaves" 
    #>          n_leaves_1         taxon_ranks             is_root 
    #>        "n_leaves_1"       "taxon_ranks"           "is_root" 
    #>             is_stem           is_branch             is_leaf 
    #>           "is_stem"         "is_branch"           "is_leaf" 
    #>        is_internode               n_obs             n_obs_1 
    #>      "is_internode"             "n_obs"           "n_obs_1" 
    #>      data$info$name    data$info$n_legs data$info$dangerous 
    #>              "name"            "n_legs"         "dangerous" 
    #>   data$phylopic_ids          data$foods      funcs$reaction 
    #>      "phylopic_ids"             "foods"          "reaction"

For example using `my_taxmap$data$info$n_legs` or `n_legs` will have the
same effect inside manipulation functions like `filter_taxa` described
below. This is similar to how `taxon_ranks` was used in `supertaxa` in a
previous section. To get the values of these variables, use `get_data`.

    get_data(my_taxmap)
    #> $taxon_names
    #>              b              c              d              e              f 
    #>     "Mammalia"      "Plantae"      "Felidae" "Notoryctidae"    "Hominidae" 
    #>              g              h              i              j              k 
    #>   "Solanaceae"     "Panthera"        "Felis"   "Notoryctes"         "homo" 
    #>              l              m              n              o              p 
    #>      "Solanum"       "tigris"        "catus"     "typhlops"      "sapiens" 
    #>              q              r 
    #> "lycopersicum"    "tuberosum" 
    #> 
    #> $taxon_ids
    #>   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p   q   r 
    #> "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" 
    #> 
    #> $taxon_indexes
    #>  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r 
    #>  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 
    #> 
    #> $classifications
    #>                                           b 
    #>                                  "Mammalia" 
    #>                                           c 
    #>                                   "Plantae" 
    #>                                           d 
    #>                          "Mammalia;Felidae" 
    #>                                           e 
    #>                     "Mammalia;Notoryctidae" 
    #>                                           f 
    #>                        "Mammalia;Hominidae" 
    #>                                           g 
    #>                        "Plantae;Solanaceae" 
    #>                                           h 
    #>                 "Mammalia;Felidae;Panthera" 
    #>                                           i 
    #>                    "Mammalia;Felidae;Felis" 
    #>                                           j 
    #>          "Mammalia;Notoryctidae;Notoryctes" 
    #>                                           k 
    #>                   "Mammalia;Hominidae;homo" 
    #>                                           l 
    #>                "Plantae;Solanaceae;Solanum" 
    #>                                           m 
    #>          "Mammalia;Felidae;Panthera;tigris" 
    #>                                           n 
    #>              "Mammalia;Felidae;Felis;catus" 
    #>                                           o 
    #> "Mammalia;Notoryctidae;Notoryctes;typhlops" 
    #>                                           p 
    #>           "Mammalia;Hominidae;homo;sapiens" 
    #>                                           q 
    #>   "Plantae;Solanaceae;Solanum;lycopersicum" 
    #>                                           r 
    #>      "Plantae;Solanaceae;Solanum;tuberosum" 
    #> 
    #> $n_supertaxa
    #> b c d e f g h i j k l m n o p q r 
    #> 0 0 1 1 1 1 2 2 2 2 2 3 3 3 3 3 3 
    #> 
    #> $n_supertaxa_1
    #> b c d e f g h i j k l m n o p q r 
    #> 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
    #> 
    #> $n_subtaxa
    #>  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r 
    #> 11  4  4  2  2  3  1  1  1  1  2  0  0  0  0  0  0 
    #> 
    #> $n_subtaxa_1
    #> b c d e f g h i j k l m n o p q r 
    #> 3 1 2 1 1 1 1 1 1 1 2 0 0 0 0 0 0 
    #> 
    #> $n_leaves
    #> b c d e f g h i j k l m n o p q r 
    #> 4 2 2 1 1 2 1 1 1 1 2 0 0 0 0 0 0 
    #> 
    #> $n_leaves_1
    #> b c d e f g h i j k l m n o p q r 
    #> 0 0 0 0 0 0 1 1 1 1 2 0 0 0 0 0 0 
    #> 
    #> $taxon_ranks
    #>         b         c         d         e         f         g         h 
    #>   "class" "kingdom"  "family"  "family"  "family"  "family"   "genus" 
    #>         i         j         k         l         m         n         o 
    #>   "genus"   "genus"   "genus"   "genus" "species" "species" "species" 
    #>         p         q         r 
    #> "species" "species" "species" 
    #> 
    #> $is_root
    #>     b     c     d     e     f     g     h     i     j     k     l     m 
    #>  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE 
    #>     n     o     p     q     r 
    #> FALSE FALSE FALSE FALSE FALSE 
    #> 
    #> $is_stem
    #>     b     c     d     e     f     g     h     i     j     k     l     m 
    #> FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE 
    #>     n     o     p     q     r 
    #> FALSE FALSE FALSE FALSE FALSE 
    #> 
    #> $is_branch
    #>     b     c     d     e     f     g     h     i     j     k     l     m 
    #> FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE 
    #>     n     o     p     q     r 
    #> FALSE FALSE FALSE FALSE FALSE 
    #> 
    #> $is_leaf
    #>     b     c     d     e     f     g     h     i     j     k     l     m 
    #> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE 
    #>     n     o     p     q     r 
    #>  TRUE  TRUE  TRUE  TRUE  TRUE 
    #> 
    #> $is_internode
    #>     b     c     d     e     f     g     h     i     j     k     l     m 
    #> FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE 
    #>     n     o     p     q     r 
    #> FALSE FALSE FALSE FALSE FALSE 
    #> 
    #> $n_obs
    #> b c d e f g h i j k l m n o p q r 
    #> 4 2 2 1 1 2 1 1 1 1 2 1 1 1 1 1 1 
    #> 
    #> $n_obs_1
    #> b c d e f g h i j k l m n o p q r 
    #> 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 
    #> 
    #> $name
    #>      m      n      o      p      q      r 
    #>  tiger    cat   mole  human tomato potato 
    #> Levels: cat human mole potato tiger tomato
    #> 
    #> $n_legs
    #> m n o p q r 
    #> 4 4 4 2 0 0 
    #> 
    #> $dangerous
    #>     m     n     o     p     q     r 
    #>  TRUE FALSE FALSE  TRUE FALSE FALSE 
    #> 
    #> $phylopic_ids
    #>                                      m 
    #> "e148eabb-f138-43c6-b1e4-5cda2180485a" 
    #>                                      n 
    #> "12899ba0-9923-4feb-a7f9-758c3c7d5e13" 
    #>                                      o 
    #> "11b783d5-af1c-4f4e-8ab5-a51470652b47" 
    #>                                      p 
    #> "9fae30cd-fb59-4a81-a39c-e1826a35f612" 
    #>                                      q 
    #> "b6400f39-345a-4711-ab4f-92fd4e22cb1a" 
    #>                                      r 
    #> "63604565-0406-460b-8cb8-1abe954b3f3a" 
    #> 
    #> $foods
    #> $foods$m
    #> [1] "mammals" "birds"  
    #> 
    #> $foods$n
    #> [1] "cat food" "mice"    
    #> 
    #> $foods$o
    #> [1] "insects"
    #> 
    #> $foods$p
    #> [1] "Most things, but especially anything rare or expensive"
    #> 
    #> $foods$q
    #> [1] "light" "dirt" 
    #> 
    #> $foods$r
    #> [1] "light" "dirt" 
    #> 
    #> 
    #> $reaction
    #> [1] "Watch out! That tiger might attack!"
    #> [2] "No worries; its just a cat."        
    #> [3] "No worries; its just a mole."       
    #> [4] "Watch out! That human might attack!"
    #> [5] "No worries; its just a tomato."     
    #> [6] "No worries; its just a potato."

Note how "taxon\_names" and "dangerous" are used below.

#### Filtering

In addition to all of the functions like `subtaxa` that work with
`taxonomy`, `taxmap` has a set of functions to manipulate data in a
taxonomic context using functions based on **dplyr**. Like many
operations on `taxmap` objects, there are a pair of functions that
modify the taxa as well as the associated data, which we call
"observations". The `filter_taxa` and `filter_obs` functions are an
example of such a pair that can filter taxa and observations
respectively. For example, we can use `filter_taxa` to subset all taxa
with a name starting with "t":

    filter_taxa(my_taxmap, startsWith(taxon_names, "t"))
    #> <Taxmap>
    #>   3 taxa: m. tigris, o. typhlops, r. tuberosum
    #>   3 edges: NA->m, NA->o, NA->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 3 x 4
    #>         taxon_id name   n_legs dangerous
    #>         <chr>    <fct>   <dbl> <lgl>    
    #>       1 m        tiger       4 TRUE     
    #>       2 o        mole        4 FALSE    
    #>       3 r        potato      0 FALSE    
    #>     phylopic_ids: a named vector of 'character' with 3 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 3 items named by taxa:
    #>        m, o, r
    #>   1 functions:
    #>     reaction

There can be any number of filters that resolve to TRUE/FALSE vectors,
taxon ids, or edge list indexes. For example, below is a combination of
a TRUE/FALSE vectors and taxon id filter:

    filter_taxa(my_taxmap, startsWith(taxon_names, "t"), c("b", "r", "o"))

There are many options for `filter_taxa` that make it very flexible. For
example, the `supertaxa` option can make all the supertaxa of selected
taxa be preserved.

    filter_taxa(my_taxmap, startsWith(taxon_names, "t"), supertaxa = TRUE)
    #> <Taxmap>
    #>   11 taxa: b. Mammalia, c. Plantae ... o. typhlops, r. tuberosum
    #>   11 edges: NA->b, NA->c, b->d, b->e ... h->m, j->o, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 4
    #>         taxon_id name  n_legs dangerous
    #>         <chr>    <fct>  <dbl> <lgl>    
    #>       1 m        tiger      4 TRUE     
    #>       2 d        cat        4 FALSE    
    #>       3 o        mole       4 FALSE    
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, d, o, b, l, r
    #>   1 functions:
    #>     reaction

The `filter_obs` function works in a similar way, but subsets
observations in `my_taxmap$data`.

    filter_obs(my_taxmap, "info", dangerous == TRUE)
    #> <Taxmap>
    #>   17 taxa: b. Mammalia, c. Plantae ... r. tuberosum
    #>   17 edges: NA->b, NA->c, b->d, b->e ... k->p, l->q, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 2 x 4
    #>         taxon_id name  n_legs dangerous
    #>         <chr>    <fct>  <dbl> <lgl>    
    #>       1 m        tiger      4 TRUE     
    #>       2 p        human      2 TRUE     
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction

You can choose to filter out taxa whose observations did not pass the
filter as well:

    filter_obs(my_taxmap, "info", dangerous == TRUE, drop_taxa = TRUE)
    #> <Taxmap>
    #>   7 taxa: b. Mammalia, d. Felidae ... m. tigris, p. sapiens
    #>   7 edges: NA->b, b->d, b->f, d->h, f->k, h->m, k->p
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 2 x 4
    #>         taxon_id name  n_legs dangerous
    #>         <chr>    <fct>  <dbl> <lgl>    
    #>       1 m        tiger      4 TRUE     
    #>       2 p        human      2 TRUE     
    #>     phylopic_ids: a named vector of 'character' with 2 items
    #>        m. e148eabb-f138-43[truncated] ... p. 9fae30cd-fb59-4a[truncated]
    #>     foods: a list of 2 items named by taxa:
    #>        m, p
    #>   1 functions:
    #>     reaction

Note how both the taxonomy and the associated data sets were filtered.
The `drop_obs` option can be used to specify which non-target (i.e. not
`"info"`) data sets are filtered when taxa are removed.

#### Sampling

The functions `sample_n_obs` and `sample_n_taxa` are similar to
`filter_obs` and `filter_taxa`, except taxa/observations are chosen
randomly. All of the options of the "filter\_" functions are available
to the "sample\_" functions

    set.seed(1)
    sample_n_taxa(my_taxmap, 3) # "3" here is a taxon index in the edge list
    #> <Taxmap>
    #>   3 taxa: g. Solanaceae, i. Felis, m. tigris
    #>   3 edges: NA->g, NA->i, NA->m
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 4 x 4
    #>         taxon_id name   n_legs dangerous
    #>         <chr>    <fct>   <dbl> <lgl>    
    #>       1 m        tiger       4 TRUE     
    #>       2 i        cat         4 FALSE    
    #>       3 g        tomato      0 FALSE    
    #>       # … with 1 more row
    #>     phylopic_ids: a named vector of 'character' with 4 items
    #>        m. e148eabb-f138-43[truncated] ... g. 63604565-0406-46[truncated]
    #>     foods: a list of 4 items named by taxa:
    #>        m, i, g, g
    #>   1 functions:
    #>     reaction
    set.seed(1)
    sample_n_taxa(my_taxmap, 3, supertaxa = TRUE)
    #> <Taxmap>
    #>   7 taxa: b. Mammalia, c. Plantae ... i. Felis, m. tigris
    #>   7 edges: NA->b, NA->c, b->d, c->g, d->h, d->i, h->m
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 4
    #>         taxon_id name  n_legs dangerous
    #>         <chr>    <fct>  <dbl> <lgl>    
    #>       1 m        tiger      4 TRUE     
    #>       2 i        cat        4 FALSE    
    #>       3 b        mole       4 FALSE    
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... g. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, i, b, b, g, g
    #>   1 functions:
    #>     reaction

#### Adding columns

Adding columns to tabular data sets is done using `mutate_obs`.

    mutate_obs(my_taxmap, "info",
               new_col = "Im new",
               newer_col = paste0(new_col, "er!"))
    #> <Taxmap>
    #>   17 taxa: b. Mammalia, c. Plantae ... r. tuberosum
    #>   17 edges: NA->b, NA->c, b->d, b->e ... k->p, l->q, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 6
    #>         taxon_id name  n_legs dangerous new_col newer_col
    #>         <chr>    <fct>  <dbl> <lgl>     <chr>   <chr>    
    #>       1 m        tiger      4 TRUE      Im new  Im newer!
    #>       2 n        cat        4 FALSE     Im new  Im newer!
    #>       3 o        mole       4 FALSE     Im new  Im newer!
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction

Note how you can use newly created columns in the same call.

#### Subsetting columns

Subsetting columns in tabular data sets is done using `select_obs`.

    # Selecting a column by name
    select_obs(my_taxmap, "info", dangerous)
    #> <Taxmap>
    #>   17 taxa: b. Mammalia, c. Plantae ... r. tuberosum
    #>   17 edges: NA->b, NA->c, b->d, b->e ... k->p, l->q, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 2
    #>         taxon_id dangerous
    #>         <chr>    <lgl>    
    #>       1 m        TRUE     
    #>       2 n        FALSE    
    #>       3 o        FALSE    
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction

    # Selecting a column by index
    select_obs(my_taxmap, "info", 3)
    #> <Taxmap>
    #>   17 taxa: b. Mammalia, c. Plantae ... r. tuberosum
    #>   17 edges: NA->b, NA->c, b->d, b->e ... k->p, l->q, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 2
    #>         taxon_id n_legs
    #>         <chr>     <dbl>
    #>       1 m             4
    #>       2 n             4
    #>       3 o             4
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction

    # Selecting a column by regular expressions (i.e. TRUE/FALSE)
    select_obs(my_taxmap, "info", matches("^dange"))
    #> <Taxmap>
    #>   17 taxa: b. Mammalia, c. Plantae ... r. tuberosum
    #>   17 edges: NA->b, NA->c, b->d, b->e ... k->p, l->q, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 2
    #>         taxon_id dangerous
    #>         <chr>    <lgl>    
    #>       1 m        TRUE     
    #>       2 n        FALSE    
    #>       3 o        FALSE    
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction

#### Sorting

Sorting the edge list and observations is done using `arrage_taxa` and
`arrange_obs`.

    arrange_taxa(my_taxmap, taxon_names)
    #> <Taxmap>
    #>   17 taxa: n. catus, d. Felidae ... r. tuberosum, o. typhlops
    #>   17 edges: i->n, b->d, d->i, b->f ... g->l, h->m, l->r, j->o
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 4
    #>         taxon_id name  n_legs dangerous
    #>         <chr>    <fct>  <dbl> <lgl>    
    #>       1 m        tiger      4 TRUE     
    #>       2 n        cat        4 FALSE    
    #>       3 o        mole       4 FALSE    
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction
    arrange_obs(my_taxmap, "info", name)
    #> <Taxmap>
    #>   17 taxa: b. Mammalia, c. Plantae ... r. tuberosum
    #>   17 edges: NA->b, NA->c, b->d, b->e ... k->p, l->q, l->r
    #>   3 data sets:
    #>     info:
    #>       # A tibble: 6 x 4
    #>         taxon_id name  n_legs dangerous
    #>         <chr>    <fct>  <dbl> <lgl>    
    #>       1 n        cat        4 FALSE    
    #>       2 p        human      2 TRUE     
    #>       3 o        mole       4 FALSE    
    #>       # … with 3 more rows
    #>     phylopic_ids: a named vector of 'character' with 6 items
    #>        m. e148eabb-f138-43[truncated] ... r. 63604565-0406-46[truncated]
    #>     foods: a list of 6 items named by taxa:
    #>        m, n, o, p, q, r
    #>   1 functions:
    #>     reaction

#### Parsing data

The `taxmap` class has the ability to contain and manipulate very
complex data. However, this can make it difficult to parse the data into
a `taxmap` object. For this reason, there are three functions to help
creating `taxmap` objects from nearly any kind of data that a taxonomy
can be associated with or derived from. The figure below shows
simplified versions of how to create `taxmap` objects from different
types of data in different formats.

<img src="vignettes/parsing_guide.png" title="parsing diagram" width="800">

The `parse_tax_data` and `lookup_tax_data` have, in addition to the
functionality above, the ability to include additional data sets that
are somehow associated with the source data sets (e.g. share a common
identifier). Elements in these data sets will be assigned the taxa
defined in the source data, so functions like `filter_taxa` and
`filter_obs` will work on all of the data set at once. See the parsing
vignette for more information.

Parsing Hierarchy and hierarchies objects
-----------------------------------------

A set of functions are available for parsing objects of class
`Hierarchy` and `hierarchies`. These functions are being ported from the
CRAN package `binomen`.

The functions below are "taxonomically aware" so that you can use for
example `>` and `<` operators to filter your taxonomic names data.

### pick

`pick()` - Pick out specific taxa, while others are dropped

    ex_hierarchy1
    #> <Hierarchy>
    #>   no. taxon's:  3 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544 
    #>   Poa annua / species / 93036
    # specific ranks by rank name
    pick(ex_hierarchy1, ranks("family"))
    #> <Hierarchy>
    #>   no. taxon's:  1 
    #>   Poaceae / family / 4479
    # two elements by taxonomic name
    pick(ex_hierarchy1, nms("Poaceae", "Poa"))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544
    # two elements by taxonomic identifier
    pick(ex_hierarchy1, ids(4479, 4544))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544
    # combine types
    pick(ex_hierarchy1, ranks("family"), ids(4544))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544

### pop

`pop()` - Pop out taxa, that is, drop them

    ex_hierarchy1
    #> <Hierarchy>
    #>   no. taxon's:  3 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544 
    #>   Poa annua / species / 93036
    # specific ranks by rank name
    pop(ex_hierarchy1, ranks("family"))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Poa / genus / 4544 
    #>   Poa annua / species / 93036
    # two elements by taxonomic name
    pop(ex_hierarchy1, nms("Poaceae", "Poa"))
    #> <Hierarchy>
    #>   no. taxon's:  1 
    #>   Poa annua / species / 93036
    # two elements by taxonomic identifier
    pop(ex_hierarchy1, ids(4479, 4544))
    #> <Hierarchy>
    #>   no. taxon's:  1 
    #>   Poa annua / species / 93036
    # combine types
    pop(ex_hierarchy1, ranks("family"), ids(4544))
    #> <Hierarchy>
    #>   no. taxon's:  1 
    #>   Poa annua / species / 93036

### span

`span()` - Select a range of taxa, either by two names, or relational
operators

    ex_hierarchy1
    #> <Hierarchy>
    #>   no. taxon's:  3 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544 
    #>   Poa annua / species / 93036
    # keep all taxa between family and genus
    # - by rank name, taxonomic name or ID
    span(ex_hierarchy1, nms("Poaceae", "Poa"))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544

    # keep all taxa greater than genus
    span(ex_hierarchy1, ranks("> genus"))
    #> <Hierarchy>
    #>   no. taxon's:  1 
    #>   Poaceae / family / 4479

    # keep all taxa greater than or equal to genus
    span(ex_hierarchy1, ranks(">= genus"))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Poaceae / family / 4479 
    #>   Poa / genus / 4544

    # keep all taxa less than Felidae
    span(ex_hierarchy2, nms("< Felidae"))
    #> <Hierarchy>
    #>   no. taxon's:  2 
    #>   Puma / genus / 146712 
    #>   Puma concolor / species / 9696

    ## Multiple operator statements - useful with larger classifications
    ex_hierarchy3
    #> <Hierarchy>
    #>   no. taxon's:  6 
    #>   Chordata / phylum / 158852 
    #>   Vertebrata / subphylum / 331030 
    #>   Teleostei / class / 161105 
    #>   Salmonidae / family / 161931 
    #>   Salmo / genus / 161994 
    #>   Salmo salar / species / 161996
    span(ex_hierarchy3, ranks("> genus"), ranks("< phylum"))
    #> <Hierarchy>
    #>   no. taxon's:  3 
    #>   Vertebrata / subphylum / 331030 
    #>   Teleostei / class / 161105 
    #>   Salmonidae / family / 161931

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
    -   as we don't want to break things, probably ideal to have
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

<https://github.com/ropensci/taxa/issues>

Meta
----

-   Please [report any issues or
    bugs](https://github.com/ropensci/taxa/issues).
-   License: MIT
-   Get citation information for `taxa` in R doing
    `citation(package = 'taxa')`
-   Please note that this project is released with a [Contributor Code
    of Conduct](CONDUCT.md). By participating in this project you agree
    to abide by its terms.

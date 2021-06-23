#--------------------------------------------------------------------------------
# Default database definitions
#--------------------------------------------------------------------------------


#' All known taxonomic ranks
#'
#' A list of taxonomic ranks from all databases used combined into a single
#' vector to make it easier to maintain the relative order of ranks when data
#' from multiple databases are combined.
#'
#' @section Attribution:
#'
#' This list was adapted from a similar one in the `taxize` package.
#'
#'
#' @keywords internal
rank_ref <- c(
  'domain' = 10,
  'superkingdom' = 20,
  'kingdom' = 30,
  'subkingdom' = 40,
  'superphylum' = 50,
  'infrakingdom' = 50,
  'phylum' = 60,
  'division' = 60,
  'subphylum' = 70,
  'subdivision' = 70,
  'infradivision' = 80,
  'superclass' = 90,
  'class' = 100,
  'subclass' = 110,
  'infraclass' = 120,
  'megacohort' = 130,
  'supercohort' = 140,
  'cohort' = 150,
  'subcohort' = 160,
  'infracohort' = 170,
  'superorder' = 180,
  'order' = 190,
  'suborder' = 200,
  'infraorder' = 210,
  'parvorder' = 220,
  'superfamily' = 230,
  'family' = 240,
  'subfamily' = 250,
  'tribe' = 260,
  'subtribe' = 270,
  'genus' = 280,
  'subgenus' = 290,
  'section' = 300,
  'subsection' = 310,
  'species group' = 320,
  'species subgroup' = 330,
  'species' = 340,
  'infraspecies' = 350,
  'subspecies' = 360,
  'variety' = 370,
  'varietas' = 370,
  'subvariety' = 380,
  'race' = 380,
  'stirp' = 390,
  'form' = 400,
  'forma' = 400,
  'morph' = 400,
  'aberration' = 410,
  'subform' = 420,
  'unspecified' = NA,
  'no rank' = NA,
  'clade' = NA
)


#' Database list
#'
#' The list of known databases.
#'
#' @keywords internal
database_ref <- c(

  taxon_db_def(
    name =     "ncbi",
    url =      "http://www.ncbi.nlm.nih.gov/taxonomy",
    desc =     "NCBI Taxonomy Database",
    id_regex = "[0-9]+",
    rank_levels  = list(NULL)
  ),

  taxon_db_def(
    name =     "gbif",
    url =      "http://www.gbif.org/developer/species",
    desc =     "GBIF Taxonomic Backbone",
    id_regex = "[0-9]+",
    rank_levels  = list(rank_ref[c("kingdom", "phylum", "order", "family", "genus", "species")])
  ),

  taxon_db_def(
    name =     "bold",
    url =      "http://www.boldsystems.org",
    desc =     "Barcode of Life",
    id_regex = "[0-9]+",
    rank_levels  =   list(rank_ref[c("phylum", "class", "order", "family", "subfamily",
                                                    "genus", "species", "subspecies")])
  ),

  taxon_db_def(
    name =     "col",
    url =      "http://www.catalogueoflife.org",
    desc =     "Catalogue of Life",
    id_regex = "[a-z0-9]{32}",
    rank_levels  =   list(NULL)
  ),

  taxon_db_def(
    name =     "eol",
    url =      "http://eol.org",
    desc =     "Encyclopedia of Life",
    id_regex = "[0-9]+",
    rank_levels  =   list(NULL)
  ),

  taxon_db_def(
    name =     "nbn",
    url =      "https://nbn.org.uk",
    desc =     "UK National Biodiversity Network",
    id_regex = "[A-Z]{5}[0-9]{10}",
    rank_levels  =   list(NULL)
  ),

  taxon_db_def(
    name =     "tps",
    url =      "http://www.tropicos.org/",
    desc =     "Tropicos",
    id_regex = "[0-9]+",
    rank_levels  =   list(NULL)
  ),

  taxon_db_def(
    name =     "itis",
    url =      "http://www.itis.gov",
    desc =     "Integrated Taxonomic Information System",
    id_regex = "[0-9]+",
    rank_levels  =   list(NULL)
  )
)


#--------------------------------------------------------------------------------
# getters/setters
#--------------------------------------------------------------------------------

#' Defines valid taxonomic databases
#'
#' @param name (character) name of the database
#' @param url (character) url for the database
#' @param desc (character) description of the database
#' @param id_regex (character) id regex
#'
#' @section Attribution:
#'
#' This code is copied from the code handling options in [knitr].
#'
#' @keywords internal
default_db_ref <- function(defaults = list()) {
  definitions <- defaults
  initial_value <- defaults

  merge_list = function(x, y) {
    x[names(y)] = y
    x
  }

  get <- function(name = NULL, value = NULL) {
    db_names <- vctrs::field(definitions, 'name')
    if (is.null(name)) {
      if (is.null(value)) {
        return(definitions)
      } else {
        return(stats::setNames(vctrs::field(definitions, value),
                               db_names))
      }
    } else {
      db <- definitions[db_names == name]
      if (is.null(value)) {
        if (name %in% db_names) {
          return(db)
        } else {
          stop(call. = FALSE, 'Unknown database: "', name, '"')
        }
      } else {
        return(vctrs::field(db, value))
      }
    }
  }

  set <- function(name, url = NA, desc = NA, id_regex = NA, rank_levels = NULL) {
    addition <- taxon_db_def(
      name = name,
      url = url,
      desc = desc,
      id_regex = id_regex,
      rank_levels = list(rank_levels)
    )
    db_names <- vctrs::field(definitions, 'name')
    new_defs <- definitions
    if (name %in% db_names) {
      new_defs[name == db_names] <- addition
    } else {
      new_defs <- c(new_defs, addition)
    }
    definitions <<- new_defs
  }

  reset <- function() {
    definitions <<- initial_value
  }

  list(get = get, set = set, reset = reset)
}


#' Valid taxonomy databases
#'
#' This defines the valid taxonomic databases that can be used in [taxon_db]
#' objects and objects that use [taxon_db] objects, such as [taxon_id] and
#' [taxon]. `db_ref$get` can be used to see information for the databases. Users
#' can add their own custom databases to the list using `db_ref$set`. For each
#' database the following information is included:
#' * The URL for the website associated with the database
#' * A short description
#' * The regular expression that defines valid taxon IDs
#' * The ranks used in the database if specified
#'
#' @section Attribution:
#'
#' This code is based on the code handling options in [knitr].
#'
#' @examples
#'
#' # List all database definitions
#' db_ref$get()
#'
#' # Get a specific database definition
#' db_ref$get('ncbi')
#'
#' # Add or overwrite a database definition
#' db_ref$set(
#'   name = "my_new_database",
#'   url = "http://www.my_tax_database.com",
#'   desc = "I just made this up",
#'   id_regex = ".*"
#' )
#'
#' # Reset definitions to default values
#' db_ref$reset()
#'
#' @export
db_ref <- default_db_ref(database_ref)


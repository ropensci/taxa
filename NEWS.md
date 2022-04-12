taxa 0.4.2
============

* Experimenting with using `''` instead of `NA` for missing values at the suggestion of Davis Vaughan ([issue #212](https://github.com/ropensci/taxa/issues/212)).
* Fix failing CRAN tests due to `vctrs` update.

taxa 0.4.1
==========

Minor update

* Fixed `taxonomy` printing error
* Removed `default.stringsAsFactors` since it is depreciated.

taxa 0.4.0
==========

LARGE CHANGES:

The beginning of a complete rewrite of the `taxa` package to make the more basic component classes more like base R vectors.
The `taxmap` class is not yet reimplemented, but will be similar to the class in the previous versions of taxa.
The old version of `taxa` has been incorporated into the `metacoder` package until this version of taxa is mature, at which time `metacoder` will also use this version.

taxa 0.3.4
==========

### Bug fixes

* Fixed bug in `n_obs` that would cause an error when used on an object with tables with columns named by numbers.
* Various minor bug fixes

taxa 0.3.3
==========

### Bug fixes

* Numeric column names in tables in `taxmap` are now supported
* Various small bug fixes

taxa 0.3.2
==========

### Bug fixes

* Parsers now correclty handle zero-length inputs ([issue #185](https://github.com/ropensci/taxa/issues/185)).
* `taxonomy_table` option `add_id_col` now works ([issue #191](https://github.com/ropensci/taxa/issues/191)).

### Improvements

* The `parse_tax_data` option `class_col` now accepts negative column indexes, meaning "all other columns".

taxa 0.3.1
==========

### New features

* Added the `taxonomy_table` function that converts the information in a `taxmap` or `taxonomy` object into a table with taxa as rows and ranks as columns.
* Added the `print_tree` function that prints text-based trees of `taxmap` or `taxonomy` objects ([issue #173](https://github.com/ropensci/taxa/issues/173)).
* Added `get_dataset` function to get a single data set from `taxmap` objects. Useful for piping with `%>%`.
* `filter_taxa` and `filter_obs` can now subset anything that has names, length, and can be subset, not just tables, lists, and vectors. For example, `DNAbin` objects from the `ape` package can now be used in `taxmap` objects ([issue #178](https://github.com/ropensci/taxa/issues/178)).

### Improvements

* Parsers are somewhat faster and use less RAM ([issue #177](https://github.com/ropensci/taxa/issues/177)).
* `taxmap` and `taxonomy` parsers now treat taxa with the same name and same place in the taxonomy, but different ranks, database IDs, or authorities, as different taxa.
* `filter_obs` can now filter multiple datasets at once if they are the same length ([issue #179](https://github.com/ropensci/taxa/issues/179)).
* `select_obs` and `arrange_obs` can now work on multiple datasets at once.

### Bug fixes

* Made the `"taxon_rank"` value for the `class_key` options work with `extract_tax_data`. 
* Fixed bug in `taxmap` print method when printing tables with only a taxon ID column ([issue #181](https://github.com/ropensci/taxa/issues/181)).

### Changes

* Option `target` in many functions renamed to `data` to make it more intuitive. 

taxa 0.2.1
==========

### Improvements

* `parse_tax_data` can now incorporate rank information which can be accessed by `result$taxon_ranks()` ([issue #113](https://github.com/ropensci/taxa/issues/113)).
* `taxmap` print methods now have more information and color ([issue #124](https://github.com/ropensci/taxa/issues/124)).
* Added `leaves_apply` function that works like `subtaxa_apply`, but on leaves ([issue #126](https://github.com/ropensci/taxa/issues/126)).
* Functions with a `value` option now return named taxon indexes by default, instead of unnamed taxon indexes ([issue #128](https://github.com/ropensci/taxa/issues/128)).
* `lookup_tax_data` and `extract_tax_data` can now use "fuzzy" matching when looking up taxon names, so taxon names can be misspelled and still be founds.
* `lookup_tax_data` and `extract_tax_data` now only look up unique sequence IDs, improving download speed.
* `filter_obs` now can filter out observations in non-target data sets that are associated with taxa that are removed when `drop_taxa = TRUE` ([issue #143](https://github.com/ropensci/taxa/issues/143)). This is done using `filter_taxa`, so the `supertaxa`, `subtaxa`, and `reassign_obs` options are now available to `filter_obs` to control how taxon removal is done.
* `lookup_tax_data` and `extract_tax_data` now have progress bars instead of printing lots of text when downloading information.
* `mutate_obs` now creates new vector/tables if the data set specified does not exist ([issue #121](https://github.com/ropensci/taxa/issues/124)).
* Add `filter_taxa` option `keep_order` that preserves input taxon order. It is `TRUE` by default, which changes how it used to work. Set to `FALSE` for old behavior.
* Using NSE with an ambiguous name (appears in multiple datasets) now produces a warning ([issue #153](https://github.com/ropensci/taxa/issues/153)).

### Changes

* The `simplify` option in many functions is now always handled the same way: If all vectors in a list are names, then unique key-value pairs are returned. Otherwise, names are ignored and unique values are returned.
* The `leaves` option now behaves like `subtaxa`, returning all leaves for each taxon. The old behavior can be replicated by setting the new `simplify` option to `TRUE` ([issue #127](https://github.com/ropensci/taxa/issues/127)).

### Bug fixes

* `filter_taxa` now has better error messages for invalid inputs ([issue #117](https://github.com/ropensci/taxa/issues/117)).
* Fix a bug that caused an error in `filter_taxa` when no taxa pass filter ([issue #116](https://github.com/ropensci/taxa/issues/116)).
* Fixed a bug in `parse_tax_data` when `class_key` was not named ([issue #131](https://github.com/ropensci/taxa/issues/131)).
* Fixed bug in `hierarchy` print method with `taxon_id` class was not used ([issue #138](https://github.com/ropensci/taxa/issues/138)).
* Fixed bug in `parse_tax_data` when all classification data is `NA.`
* Fixed bug in `taxmap` print method when printing zero-length lists and vectors ([issue #148](https://github.com/ropensci/taxa/issues/148)).

taxa 0.2.0
==========

### Bug fixes

* Fixed a few problems with using duplicated inputs to `subset` ([issue #88](https://github.com/ropensci/taxa/issues/85), [issue #89](https://github.com/ropensci/taxa/issues/85))
* Fixed a bug that caused an error when using unnamed vectors ([issue #86](https://github.com/ropensci/taxa/issues/86))
* Fixed a bug that prevents using sequence accession numbers ([issue #85](https://github.com/ropensci/taxa/issues/85))
* Fixed bug in `lookup_tax_data` and `extract_tax_data` that caused an error when one of the queries failed too download.
* Fixed bug that caused "data" argument of `obs_apply` to not work when passed as a variable ([issue #97](https://github.com/ropensci/taxa/issues/97))

### Improvements

* Added `map_data_` for mapping without using NSE.
* Make default dataset for `n_obs` and `n_obs_1` and make them available for NSE ([issue #91](https://github.com/ropensci/taxa/issues/91)
* `parse_tax_data`/`extract_tax_data` can now parse things like `phylum;Nitrosopumilales;order;Nitrosopumilaceae;family;` and split out the rank and taxon names by using multiple matches to the `class_regex` when `class_sep` is NULL. 
* `extract_tax_data` now gives warnings if a regex does not match.
* Added `n_supertaxa_1` function to get number of immediate supertaxa (always 1 or 0).
* Added `branches` function to go with `roots`, `leaves`, and `stems`. ([issue #56](https://github.com/ropensci/taxa/issues/56))
* Added `internodes` and `is_internode` functions to go with `roots`, `leaves`, `branches`, and `stems`. Useful for removing uninformative taxonomic ranks/taxa.
* Started to incorporate ability for `taxon`, `taxon_name`, `taxon_id`, `taxon_rank`, and `taxa` to handle `NULL` inputs as first class citizens to handle cases when you have essentially a blank taxon (use case comes from `taxize` package) [#95](https://github.com/ropensci/taxa/issues/95) [#107](https://github.com/ropensci/taxa/issues/107)
* data parsers: Put long, often unused columns last ([issue #93](https://github.com/ropensci/taxa/issues/93))
* When parsing classifications that have per-taxon info add input id column ([issue #92](https://github.com/ropensci/taxa/issues/92))
* New function `classification` as an abstraction to get either hierarchy of taxon indexes, names, or ids ([issue #57](https://github.com/ropensci/taxa/issues/57))
* New function `get_data_frame` for both `Taxonomy` and `Taxmap` objects that wraps around `get_data` to coerce into a `data.frame`. ([issue #58](https://github.com/ropensci/taxa/issues/58)) ([PR #105](https://github.com/ropensci/taxa/issues/105))

### Changes

* In the output of the taxmap parsing functions like `parse_tax_data`, I moved "taxon_id" and "input_index" columns to front and "input" to rear. Also "tax_data" now comes before "class_data".

taxa 0.1.0
==========

### NEW FEATURES

* Released to CRAN.

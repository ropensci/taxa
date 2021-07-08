#' taxa printing functions
#'
#' Functions used internally for printing information in taxon objects. They have to be exported to
#' work, but they are not intended to be directly used by most users.
#'
#' @name taxa_printing_funcs
NULL


#' taxa coercion functions
#'
#' Functions used internally for coercing taxon objects and other objects to common data types.
#' They have to be exported to work, but they are not intended to be directly used by most users.
#'
#' @name taxa_coercion_funcs
NULL


#' taxa casting functions
#'
#' Functions used internally for casting taxon objects to other types. They have to be exported to
#' work, but they are not intended to be directly used by most users.
#'
#' @name taxa_casting_funcs
NULL


#' taxa comparison functions
#'
#' Functions used internally for casting taxon objects to other types. They have to be exported to
#' work, but they are not intended to be directly used by most users.
#'
#' @name taxa_comparison_funcs
NULL


#' Embed a lifecycle badge in documentation
#'
#' @description
#'
#' Copied from the [tibble] source code.
#'
#' Use `lifecycle()` within a `Sexpr` macro to embed a
#' [lifecycle](https://www.tidyverse.org/lifecycle/) badge in your
#' documentation. The badge should appear first in the description:
#'
#' ```
#' \Sexpr[results=rd, stage=render]{mypkg:::lifecycle("questioning")}
#' ```
#'
#' The badge appears as an image in the HTML version of the
#' documentation. To make them available in your package, visit
#' <https://github.com/r-lib/rlang/tree/master/man/figures> and copy
#' all the files starting with `lifecycle-` in your `man/figures/`
#' folder.
#'
#' @param stage A lifecycle stage as a string, one of:
#'   `"experimental"`, `"maturing"`, `"stable"`, `"questioning"`,
#'   `"archived"`, `"soft-deprecated"`, `"deprecated"`, `"defunct"`.
#'
#' @noRd
NULL

lifecycle <- function(stage) {
  url <- paste0("https://www.tidyverse.org/lifecycle/#", stage)
  img <- lifecycle_img(stage, url)

  sprintf(
    "\\ifelse{html}{%s}{\\strong{%s}}",
    img,
    upcase1(stage)
  )
}

lifecycle_img <- function(stage, url) {
  file <- sprintf("lifecycle-%s.svg", stage)
  stage_alt <- upcase1(stage)

  switch(stage,

         experimental = ,
         maturing = ,
         stable = ,
         questioning = ,
         archived =
           sprintf(
             "\\out{<a href='%s'><img src='%s' alt='%s lifecycle'></a>}",
             url,
             file.path("figures", file),
             stage_alt
           )
         ,

         `soft-deprecated` = ,
         deprecated = ,
         defunct =
           sprintf(
             "\\figure{%s}{options: alt='%s lifecycle'}",
             file,
             stage_alt
           ),

         rlang::abort(sprintf("Unknown lifecycle stage `%s`", stage))

  )
}

upcase1 <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

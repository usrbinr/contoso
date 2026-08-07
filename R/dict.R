#' Data dictionary for the Contoso dataset
#'
#' Reads the machine-readable data dictionary shipped with the package and
#' returns it as a tibble with one row per column of every table. The
#' dictionary follows the [data-dict](https://data-dict.tidyverse.org/) schema
#' and documents the traps -- notably that `store_key` 999999 is a sentinel for
#' the online channel rather than a real location, and that `store.status` is
#' missing (never `"Open"`) for stores trading normally.
#'
#' @return A tibble with columns `table`, `rows` (row count of the whole
#'   table), `column`, `type`, `constraints`, `units`, `missing`, `values` (a
#'   list column of permitted values for enums) and `description`.
#' @examples
#' contoso_dict_columns()
#'
#' # one table
#' subset(contoso_dict_columns(), table == "store")
#'
#' # which columns can be missing?
#' subset(contoso_dict_columns(), missing > 0, c(table, column, missing))
#' @export
contoso_dict_columns <- function() {
  dict <- yaml::read_yaml(
    system.file("extdata", "data-dict.yaml", package = "contoso")
  )

  purrr::map(dict$tables, \(tbl) tibble::tibble(
    table       = tbl$name,
    rows        = tbl$rows,
    column      = purrr::map_chr(tbl$columns, "name"),
    type        = purrr::map_chr(tbl$columns, "type", .default = NA),
    constraints = purrr::map_chr(tbl$columns, \(col) paste(col$constraints, collapse = ", ")),
    units       = purrr::map_chr(tbl$columns, "units", .default = NA),
    missing     = purrr::map_int(tbl$columns, "missing", .default = 0L),
    values      = purrr::map(tbl$columns, "values"),
    description = trimws(purrr::map_chr(tbl$columns, "description", .default = NA))
  )) |>
    purrr::list_rbind()
}

## Builds inst/extdata/cloud/data-dict.yaml -- the data dictionary for the
## cloud datasets behind create_contoso_duckdb(size = "medium" | "large" | "mega").
##
## inst/extdata/small/data-dict.yaml describes the small dataset (and the
## package's own data frames). It is the source of truth for every *field*
## here: types, constraints, assertions, relationships and glossary are copied
## from it, so the two dictionaries stay consistent. Only the parts that
## describe observed data -- `range`, `examples`, enum `values` -- are measured
## again, and only the prose that is factually different is overridden below.
##
## `range` is unioned across medium, large and mega so one dictionary covers all
## three. That is sound because the spec treats `range` as descriptive: nothing
## is validated against it and a value outside it is not an error.

library(cli)

base_url <- "https://pub-6aa63519a4b945948cb8c88949b320ca.r2.dev"
folders  <- c(medium = "contoso_1m", large = "contoso_10m", mega = "contoso_100m")
ref      <- "contoso_1m" # the size we scan locally; smallest of the three
tables   <- c("sales", "orders", "orderrows", "product", "customer", "store",
              "calendar", "fx")

pkg       <- rprojroot::find_root(rprojroot::is_r_package)
cache     <- file.path(pkg, "data-raw", "cloud", ref)
valid     <- file.path(pkg, "data-raw", "cloud", "validate")
default_p <- file.path(pkg, "inst", "extdata", "small", "data-dict.yaml")
out_p     <- file.path(pkg, "inst", "extdata", "cloud", "data-dict.yaml")

# ---- 1. cache the reference size locally -----------------------------------

dir.create(cache, recursive = TRUE, showWarnings = FALSE)
tables |> purrr::walk(\(t) {
  f <- file.path(cache, paste0(t, ".parquet"))
  if (!file.exists(f)) {
    cli_alert_info("Downloading {t}.parquet")
    utils::download.file(sprintf("%s/%s/%s.parquet", base_url, ref, t), f,
                         mode = "wb", quiet = TRUE)
  }
})

# ---- 1b. rewrite a validation copy with modern Parquet annotations ---------
#
# The cloud files were written by DuckDB, which annotates dates with the
# deprecated `converted_type: DATE` and no `logical_type`. DuckDB reads that
# back as a DATE, so `create_contoso_duckdb()` is unaffected, but `data-dict`
# (parquet-rs) honours only `logical_type` and so sees all 11 date columns as
# plain integers. nanoparquet writes `DateType()`, so validate against a
# rewritten copy. Values are unchanged -- only the type annotation differs.

dir.create(valid, recursive = TRUE, showWarnings = FALSE)
tables |> purrr::walk(\(t) {
  dst <- file.path(valid, paste0(t, ".parquet"))
  if (file.exists(dst)) return(invisible())
  cli_alert_info("Normalising {t}.parquet")
  DBI::dbConnect(duckdb::duckdb()) |>
    (\(cn) {
      on.exit(DBI::dbDisconnect(cn, shutdown = TRUE))
      DBI::dbGetQuery(cn, sprintf("select * from '%s'",
                                  file.path(cache, paste0(t, ".parquet"))))
    })() |>
    nanoparquet::write_parquet(dst)
})

# ---- 2. draft from the real data, and use it as a consistency check --------

draft_p <- file.path(valid, "data-dict.yaml")
invisible(unlink(draft_p))
invisible(system2("data-dict", c("draft", "--output", draft_p,
                       file.path(valid, paste0(tables, ".parquet"))),
        stdout = FALSE))

default <- yaml::read_yaml(default_p)
draft   <- yaml::read_yaml(draft_p)

cols_of <- \(d) d$tables |>
  purrr::set_names(purrr::map_chr(d$tables, "name")) |>
  purrr::map(\(t) purrr::map_chr(t$columns, "name"))

if (!identical(cols_of(default), cols_of(draft))) {
  cli_abort(c(
    "Cloud schema does not match {.file data-dict.yaml}.",
    i = "Reconcile the two dictionaries before regenerating."
  ))
}
cli_alert_success("Cloud schema matches the default dictionary ({length(tables)} tables).")

# ---- 3. measure: union ranges across all three sizes, values/examples from ref

con <- DBI::dbConnect(duckdb::duckdb())
on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
invisible(DBI::dbExecute(con, "INSTALL httpfs; LOAD httpfs;"))

# Footer statistics only -- no column data is read, so mega costs the same as
# medium despite being 8 GB.
stats <- folders |>
  purrr::map(\(f) tables |>
    purrr::set_names() |>
    purrr::map(\(t) DBI::dbGetQuery(con, sprintf(
      "select path_in_schema col,
              min(stats_min_value) mn, max(stats_max_value) mx
       from parquet_metadata('%s/%s/%s.parquet') group by all", base_url, f, t))))

ref_tbl <- \(t) sprintf("'%s'", file.path(valid, paste0(t, ".parquet")))

# `range` for a column: the union of what each size observed.
union_range <- function(tbl, col, type) {
  vals <- folders |> purrr::imap(\(f, nm) {
    s <- stats[[nm]][[tbl]]
    s[s$col == col, c("mn", "mx"), drop = FALSE]
  }) |> purrr::list_rbind()

  if (nrow(vals) == 0 || all(is.na(vals$mn))) return(NULL)

  if (grepl("^date", type)) {
    list(as.Date(min(vals$mn)), as.Date(max(vals$mx)))
  } else {
    list(min(as.numeric(vals$mn)), max(as.numeric(vals$mx)))
  }
}

# `values` for an enum: the distinct set, measured on the reference size.
enum_values <- function(tbl, col) {
  DBI::dbGetQuery(con, sprintf(
    "select distinct %s v from %s where %s is not null order by 1", col,
    ref_tbl(tbl), col))$v
}

# `examples`: five evenly spaced values along the sorted distinct values, the
# baseline the spec recommends.
examples_for <- function(tbl, col) {
  v <- DBI::dbGetQuery(con, sprintf(
    "with d as (select distinct %s v from %s where %s is not null),
          o as (select v, row_number() over (order by v) i, count(*) over () n from d)
     select v from o
     where i in (1,
                 greatest(1, round(n * 0.25)),
                 greatest(1, round(n * 0.50)),
                 greatest(1, round(n * 0.75)),
                 n)
     order by v", col, ref_tbl(tbl), col))$v
  unique(v)
}

# ---- 4. prose that is genuinely different from the small dataset -----------
# Everything not named here is inherited verbatim from data-dict.yaml.

top_description <- "
  Synthetic retail sales for the fictional Contoso company, arranged as a star
  schema: one denormalised fact table (`sales`), its normalised equivalents
  (`orders` + `orderrows`), and five dimension tables (`product`, `customer`,
  `store`, `calendar`, `fx`). This dictionary describes the three cloud sizes
  served by `create_contoso_duckdb(size = \"medium\" | \"large\" | \"mega\")`,
  which share a schema and differ only in row count."

top_details <- "This dataset is **synthetic**. Names, addresses, birthdays, occupations,
employers, vehicles and coordinates are filler describing no real person,
and nothing derives from real trading.

## Not the same data as the bundled tables

`size = \"small\"` and the package's own data frames come from a different
generator run, described by `extdata/small/data-dict.yaml`. These three sizes cover
2016-2026 rather than 2021-2024, and their `customer` table is a full
catalogue that includes customers who never place an order.

## One dictionary, three sizes

`medium`, `large` and `mega` share every column, type and constraint;
`product` and `store` are byte-identical across all of them, as are
`calendar` and `fx`. Only row counts and the `order_key` range differ, so
`range` here is the union across the three. `order_key` and the other
`number(id)` columns carry no `range` at all, because it scales with size.

## Money is USD

Every money column is USD regardless of the order's `currency_code`, so
amounts sum directly across orders. Multiply by `sales.exchange_rate` for
the currency the order was placed in.

## One trap

`store_key` 999999 is the online channel, a sentinel row carrying -1 and
`--` placeholders that pollute geographic aggregates unless filtered."

overrides <- list(
  "customer" = list(details = "
    The full customer catalogue, including customers who have never ordered:
    18,082 of the 104,990 in `medium` have no sales line. This is the opposite
    of the bundled `customer` table, which ships only customers that transact,
    so an inner join to `sales` here *does* drop customers."),

  "customer.start_date" = list(description = "
    Undocumented upstream and not interpretable as a relationship start:
    it predates the customer's own `birthday` for about 15% of customers."),

  "customer.end_date" = list(description = "
    Undocumented upstream. Always populated, and mostly falls in the future
    (70% in `medium`)."),

  "product.price" = list(description = "
    Catalogue unit price, USD. From 2023-07-03 onward every `sales.unit_price`
    equals this exactly; every earlier line differs, scaled by a
    category-and-date price index. Note the cutover is a year later than in
    the bundled dataset."),

  "calendar" = list(details = "
    Spans whole calendar years (2016-2026), so it extends past the trading
    period at both ends -- 503 of its days carry no orders in `medium`. Join
    from `calendar` when you need a dense series with explicit zeros."),

  "fx" = list(details = "
    The grain is `(date, from_currency, to_currency)`; all three columns
    together form the key. Joining on a date and one currency alone matches
    five rows, so filter `from_currency` (usually to `USD`) before joining.
    Identical across all three cloud sizes.")
)

# Relationships whose *meaning* differs from the small dataset.
rel_overrides <- list(
  "sales.customer_key = customer.customer_key" =
    "`customer` is a full catalogue here, so an inner join drops the
     customers who never ordered. Join from `customer` with a left join to
     keep them.",
  "sales.product_key = product.product_key" =
    "Every product in the catalogue sells at least once at these sizes, so
     unlike the bundled dataset an inner join loses no products."
)

# ---- 5. assemble ----------------------------------------------------------

trim_prose <- \(x) gsub("[ \t]*\n[ \t]*", "\n", trimws(x))

build_column <- function(tbl, col) {
  type <- col$type
  key  <- paste0(tbl, ".", col$name)
  ov   <- overrides[[key]]

  out <- list(name = col$name)
  if (!is.null(col$label)) out$label <- col$label
  if (!is.null(type))      out$type  <- type

  if (identical(type, "enum")) out$values <- enum_values(tbl, col$name)

  # `range` is required for ordered numeric and temporal types, and omitted for
  # `number`/`number(id)`, where it is optional and would scale with size.
  if (!is.null(type) && grepl("^(number\\((ordinal|quantity)\\)|date|datetime)$", type)) {
    out$range <- union_range(tbl, col$name, type)
  }

  if (!is.null(col$constraints)) out$constraints <- col$constraints

  out$description <- trim_prose(ov$description %||% col$description)
  if (!is.null(ov$details %||% col$details)) {
    out$details <- trim_prose(ov$details %||% col$details)
  }
  if (!is.null(col$units))   out$units   <- col$units
  if (!is.null(col$display)) out$display <- col$display

  # `examples` wherever the default carried them.
  if (!is.null(col$examples)) out$examples <- examples_for(tbl, col$name)
  out
}

`%||%` <- \(a, b) if (is.null(a)) a <- b else a

build_table <- function(t) {
  ov  <- overrides[[t$name]]
  out <- list(name = t$name)
  out$description <- trim_prose(ov$description %||% t$description)
  if (!is.null(ov$details %||% t$details)) {
    out$details <- trim_prose(ov$details %||% t$details)
  }
  out$source <- list(parquet = sprintf("../../../data-raw/cloud/validate/%s.parquet", t$name))
  if (!is.null(t$origin))      out$origin      <- t$origin
  if (!is.null(t$constraints)) out$constraints <- t$constraints
  out$columns <- t$columns |> purrr::map(\(col) build_column(t$name, col))
  out
}

cloud <- list()
cloud[["$version"]]    <- default[["$version"]]
cloud[["$learn_more"]] <- default[["$learn_more"]]
cloud$name        <- "Contoso (cloud)"
cloud$description <- trim_prose(top_description)
cloud$details     <- trim_prose(top_details)
cloud$origin      <- default$origin
# The cloud data has its own lineage -- it is not rebuilt with the package.
# Date it by its last change: the 2026-09-20 fx de-duplication.
cloud$version     <- list(date = "2026-09-20")
cloud$tables      <- default$tables |> purrr::map(build_table)

cloud$relationships <- default$relationships |> purrr::map(\(r) {
  ov <- rel_overrides[[r$join]]
  if (!is.null(ov)) r$description <- trim_prose(ov)
  r
})
cloud$glossary <- default$glossary

# ---- 6. emit --------------------------------------------------------------

source(file.path(pkg, "data-raw", "yaml-emit.R"))
dir.create(dirname(out_p), recursive = TRUE, showWarnings = FALSE)
writeLines(emit_dict(cloud), out_p)
cli_alert_success("Wrote {.file {out_p}}")

# ---- 7. validate ----------------------------------------------------------

c("validate-spec", "validate-meta", "validate-data") |>
  purrr::walk(\(cmd) {
    status <- system2("data-dict", c(cmd, out_p))
    if (status != 0) cli_abort("{cmd} failed.")
  })

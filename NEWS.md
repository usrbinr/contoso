# contoso 2.4.0

* `read_reports()` now returns 1,127 reports covering May 2016 to the end of
  2025, up from 118 covering 2025. The 2016-2024 reports tell one continuous
  fictional story that leads into the 2025 reports. Authors change roles
  over the years, and each year from 2017 has its own Annual Operating Plan
  memo. The figures still come from the "mega" dataset, and some reports in
  every year carry deliberate errors. `inst/extdata/reports.rds` grows from
  about 90 KB to about 730 KB.

* About 100 of the 2025 reports were rewritten so the world is fully
  fictional: the PC refresh is now driven by the end of support for Lumen 10
  (a fictional operating system) instead of Windows 10, and no real
  retailers or events are named. The Litware recall now matches the data:
  it is a safety inspection, and the affected models were never off sale.

* New glossary of the terms the reports use, with the phrasings to search for:
  `system.file("extdata", "reports", "glossary.yaml", package = "contoso")`.

# contoso 2.3.0

## New features

* `read_reports()` returns 118 fictional internal business reports about
  Contoso's 2025 trading (weekly sales flashes, monthly e-commerce, supply
  chain and plant reviews, quarterly regional reviews, pricing committee
  minutes, operations notices, industry notes and the Annual Operating Plan).
  The figures come from the "mega" cloud dataset. Some reports carry
  deliberate errors, for testing financial planning and analysis assistants.
  The reports ship compressed in `inst/extdata/reports.rds` (about 90 KB).

* `export_reports()` writes the reports as one YAML file each, the layout
  document stores and retrieval tools expect. This adds 'yaml12' to Imports.

* New vignette, `vignette("business-reports")`, describing the reports. New
  articles on the website: "Getting started" and "Searching the reports with
  ragnar".

## Breaking changes

* Removed `contoso_dict_columns()`. The data dictionary is a standard
  [data-dict](https://data-dict.tidyverse.org/) file, so the `data-dict` CLI
  already reads, validates and renders it, and `yaml::read_yaml()` reads it in
  R. Use `system.file("extdata", "small", "data-dict.yaml", package = "contoso")`
  to find it.

## Dependencies

* `yaml` has moved from Imports to Suggests; it was only needed by the
  function removed above.

* `Depends` is now R (>= 4.1.0), which the package code has in fact required
  for some time -- it uses the native pipe `|>` and the `\(x)` function
  shorthand.

## Cloud dataset fixes

* Fixed `size = "large"`, where every row of `fx` was present twice (200,900
  rows over 100,450 distinct rates, exact duplicates). Joining `sales` to `fx`
  doubled the row count and any revenue converted through it. `medium` and
  `mega` were unaffected, and `contoso_10m/fx.parquet` is now byte-identical
  to the file the other sizes already shared. This is the same duplication
  fixed for `sales` in 2.2.0; `fx` was missed at the time.

## Documentation

* The bundled data dictionary now validates against the
  [data-dict](https://data-dict.tidyverse.org/) spec at all three levels
  (`validate-spec`, `validate-meta`, `validate-data`). Removed the
  non-spec `rows` and `missing` keys, added the required `range` to every
  ordered column, and recorded the composite primary keys on `sales` and
  `orderrows` (`order_key` + `line_number`) and on `fx` (`date` +
  `from_currency` + `to_currency`).

* Corrected the dictionary where it contradicted the data: `line_number` is
  zero-based, not 1-based, and the `sales`-to-`fx` join was documented as
  `many-to-one` when it fans out five-to-one unless `from_currency` is
  filtered.

* The derived measures in `sales` are now written as checkable assertions
  rather than prose, so `data-dict validate-data` verifies that
  `gross_revenue`, `net_revenue`, `unit_discount`, `discounts`, `cogs`,
  `gross_margin` and `unit_margin` still follow their documented formulas.

* The dictionary for the cloud datasets ships as
  `inst/extdata/cloud/data-dict.yaml`, covering `size = "medium"`, `"large"`
  and `"mega"`. It carries the same types, constraints, assertions,
  relationships and glossary as the small dictionary; only the observed `range`,
  `examples` and the descriptions that are genuinely different differ.

* The reports returned by `read_reports()` have their own data dictionary,
  `inst/extdata/reports/data-dict.yaml`, describing each column and noting
  that some reports are deliberately wrong.

# contoso 2.2.0

## Breaking changes

* `customer` now has one row per customer (3,165 rows, down from 7,794).
  Previous versions built it by joining the customer catalogue onto `sales`,
  which repeated each customer once per sales line they appeared on. This made
  `customer_key` non-unique, so joining `customer` to `sales`, `orders` or any
  other table silently multiplied rows. No attribute varied within a customer,
  so the deduplication loses no data, but any code that relied on the old row
  count — or that worked around the fan-out with `distinct()` — should be
  reviewed. Thanks to [Hadley Wickham](https://github.com/hadley/contoso) for
  reporting.

* The cloud dataset behind `create_contoso_duckdb(size = "small")` carried the
  same fan-out and has been corrected, so it again matches the bundled
  `customer`. The `medium`, `large` and `mega` sizes were never affected.

## Cloud dataset fixes

* Column types are now consistent across all four sizes. Previously date
  columns were stored as strings in `medium` and `large` — so comparisons on
  `order_date` and friends were string comparisons, and date arithmetic failed
  — while `small` and `mega` used real dates. Integer widths also varied
  (`DOUBLE`, `INTEGER`, `BIGINT`) between sizes, and in `medium`
  `sales.order_date` was a date while `orders.order_date` was a string. Dates
  are now `DATE`, keys and counts `BIGINT`, and measures `DOUBLE`, everywhere.

* Fixed `size = "large"`, where every row of `sales` was present twice
  (47,439,870 rows over 23,719,935 order lines, exact duplicates). Any revenue,
  cost, margin or quantity total taken from that size was doubled. The
  documented row count for `large` was the inflated figure and is now
  23,719,935. Other sizes were unaffected.

* Fixed `product_code` in `medium` and `large`, which was stored as an integer
  and had lost its leading zero (`101001` rather than `0101001`), so it did not
  match the same product's code in `small` and `mega`.

# contoso 2.1.0
* updated storage from Blaze to CloudeFare
* fixed typos in documentation

# contoso 2.0.1
* converted site docs from pkgdown to qrtdown

# contoso 2.0.0
* cran submission

# contoso 1.3.0
* Switched from MotherDuck to Cloudflare R2 cloud storage for dataset hosting
* Now works on all platforms including Windows
* Changed size parameter to use descriptive names: "small", "medium", "large", "mega"
* Removed `db_dir` parameter (no longer needed)

# contoso 1.2.2
* create_contoso_duckdb() will not work if you are using windows due to lack of support from motherduck
* [see here for more information](https://motherduck.com/docs/integrations/language-apis-and-drivers/r/#considerations-and-limitations)

# contoso 1.2.1
* fixed create_contoso_duckdb() due to error created by table name changed
* updated tests

# contoso 1.2.0
* changed 'date' table name to 'calendar' to avoid namespace conflicts with lubridate and base packages

# contoso 1.1.1
* Patch to fixed launch_ui function



# contoso 1.1.0
* launch_ui function added
* pkgdown instead of altdocs
* new logo


# contoso 1.0.0

* Support for 100M row database now supported
* unit tests added

# contoso 0.1.0

* website Replace pkgdown with altdocs
* 100k+ contoso packages are attached from motherduck database
* contoso database sizes increased to 10M rows



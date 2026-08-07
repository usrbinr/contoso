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



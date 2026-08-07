## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local: Pop!_OS 24.04 LTS, R 4.6.1 (x86_64-pc-linux-gnu)

## Reverse dependencies

One reverse dependency, 'motherduck', which lists 'contoso' in Suggests. It
refers to "contoso" only as the name of a remote database in a non-evaluated
vignette article, and does not use any data object from this package, so it is
unaffected by the change below. I maintain both packages.

## Notes for the reviewer

This release changes the `customer` dataset in a way that is not backward
compatible, so the version has been bumped to 2.2.0 and the change is documented
first in NEWS.md.

Up to 2.1.0, `customer` was built by joining the customer catalogue onto the
`sales` table, which repeated each customer once per sales line they appeared on
(7794 rows for 3165 customers). `customer_key` was therefore not unique and any
join to the table silently multiplied rows. The duplicates have been collapsed to
one row per customer. No attribute varied within a customer, so no data is lost.

The examples and tests for `create_contoso_duckdb()` stream Parquet files from
remote storage. They are wrapped in `\dontrun{}` and `skip_on_cran()`
respectively, so no example or test accesses the network during checking.

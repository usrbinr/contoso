## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local: Pop!_OS 24.04 LTS, R 4.6.1 (x86_64-pc-linux-gnu)

## Reverse dependencies

One reverse dependency, 'motherduck', which lists 'contoso' in Suggests. It
refers to "contoso" only as the name of a remote database in a non-evaluated
vignette article, and does not call any function or use any data object from
this package, so it is unaffected by the removal below. I maintain both
packages.

## Notes for the reviewer

This release adds two exported functions, `read_reports()` and
`export_reports()`, for a corpus of 118 short fictional business reports
shipped as one xz-compressed file (`inst/extdata/reports.rds`, about 90 KB).
`export_reports()` writes only to the directory the user passes; its example
writes to `tempdir()` and removes the files afterwards. This adds 'yaml12' to
Imports.

This release removes the exported function `contoso_dict_columns()`, so the
version has been bumped to 2.3.0 and the change is documented first in NEWS.md.

The function returned the package's data dictionary as a tibble. That
dictionary is a standard data-dict file
(<https://data-dict.tidyverse.org/>), which external tooling and
`yaml::read_yaml()` already read, so the wrapper added nothing. The
dictionaries now ship as `inst/extdata/small/data-dict.yaml`,
`inst/extdata/cloud/data-dict.yaml` and, for the new reports,
`inst/extdata/reports/data-dict.yaml`, one per directory so that data-dict
tooling can be pointed at any of them.

Removing the function left 'yaml' used only by the tests, so it has moved
from Imports to Suggests. 'tibble' stays in Imports: the new
`read_reports()` returns a tibble.

`Depends` has been raised from R (>= 3.5) to R (>= 4.1.0), which the package
code has in fact required for some time: it uses the native pipe `|>` and the
`\(x)` function shorthand.

The examples and tests for `create_contoso_duckdb()` stream Parquet files from
remote storage. They are wrapped in `\dontrun{}` and `skip_on_cran()`
respectively, so no example or test accesses the network during checking.

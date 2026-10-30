## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local: Pop!_OS 24.04 LTS, R 4.6.1 (x86_64-pc-linux-gnu)

## Reverse dependencies

One reverse dependency, 'motherduck', which lists 'contoso' in Suggests. It
refers to "contoso" only as the name of a remote database in a non-evaluated
vignette article, and does not call any function or use any data object from
this package, so it is unaffected by this release. I maintain both
packages.

## Notes for the reviewer

This release extends the corpus of fictional business reports returned by
`read_reports()` from 118 reports covering 2025 to 1,127 reports covering
2016-2025. They still ship as one xz-compressed file
(`inst/extdata/reports.rds`), which grows from about 90 KB to about 730 KB.
It also adds a glossary of the terms the reports use, as
`inst/extdata/reports/glossary.yaml`. There are no changes to exported
functions or dependencies.

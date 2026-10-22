test_that("read_reports returns every report with its metadata", {
  reports <- read_reports()
  expect_equal(nrow(reports), 118L)
  expect_named(reports, c("id", "title", "unit", "author", "report_type",
                          "period_start", "period_end", "published", "body"))
  expect_false(anyDuplicated(reports$id) > 0)
  expect_s3_class(reports$published, "Date")
})

test_that("export_reports writes one YAML file per report and will not overwrite", {
  dir <- withr::local_tempdir()
  paths <- suppressMessages(export_reports(dir))
  expect_length(paths, 118L)
  expect_true(all(file.exists(paths)))

  r <- yaml12::read_yaml(file.path(dir, "aop-2025.yaml"))
  expect_equal(r$published, "2024-12-16")
  expect_match(r$body, "^# 2025 Annual Operating Plan")

  expect_error(suppressMessages(export_reports(dir)), "already exist")
  expect_no_error(suppressMessages(export_reports(dir, overwrite = TRUE)))
})

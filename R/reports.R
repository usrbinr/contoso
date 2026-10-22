#' Read the Contoso business reports
#'
#' Returns 118 fictional internal business documents written about Contoso's
#' 2025 trading, one row per report: the metadata a document system would
#' record, plus the Markdown text in `body`. The figures in the reports come
#' from the "mega" dataset (`create_contoso_duckdb("mega")`), not the bundled
#' tables, which end in 2024. Use [export_reports()] to get them as files.
#'
#' @return A tibble with columns `id`, `title`, `unit`, `author`,
#'   `report_type`, `period_start`, `period_end`, `published` (the last three
#'   are `Date`) and `body`.
#' @export
#' @examples
#' reports <- read_reports()
#' reports[, c("id", "published")]
read_reports <- function() {
  tibble::as_tibble(readRDS(system.file("extdata", "reports.rds", package = "contoso")))
}

#' Write the Contoso business reports to files
#'
#' Writes each report from [read_reports()] as a YAML file named
#' `<id>.yaml`, holding the metadata fields and the Markdown text in `body`.
#' `yaml12::read_yaml()` reads a file back in one call.
#'
#' @param dir Directory to write to. Created if it does not exist.
#' @param overwrite Replace files that already exist?
#'
#' @return The paths of the written files, invisibly.
#' @export
#' @examples
#' dir <- file.path(tempdir(), "contoso-reports")
#' paths <- export_reports(dir)
#' yaml12::read_yaml(paths[1])$title
#' unlink(dir, recursive = TRUE)
export_reports <- function(dir, overwrite = FALSE) {
  reports <- read_reports()
  paths <- file.path(dir, paste0(reports$id, ".yaml"))

  if (!overwrite && any(file.exists(paths))) {
    cli::cli_abort(c(
      "Report files already exist in {.path {dir}}.",
      i = "Use {.code overwrite = TRUE} to replace them."
    ))
  }

  cli::cli_inform("Writing {length(paths)} report files to {.path {normalizePath(dir, mustWork = FALSE)}}.")
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)

  dates <- c("period_start", "period_end", "published")
  reports[dates] <- lapply(reports[dates], format)

  reports |>
    purrr::pwalk(\(...) {
      report <- list(...)
      writeLines(yaml12::format_yaml(report), file.path(dir, paste0(report$id, ".yaml")))
    })

  cli::cli_alert_success("Wrote {length(paths)} files.")
  invisible(paths)
}

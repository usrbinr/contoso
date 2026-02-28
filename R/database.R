#' @param size Dataset size: "small", "medium", "large", or "mega"
#'
#' @title Creates DuckDB database with Contoso datasets
#' @name create_contoso_duckdb
#'
#' @description
#' Creates a DuckDB connection with Contoso datasets loaded from cloud storage.
#' The datasets are stored as Parquet files on Cloudflare R2 and streamed directly
#' into DuckDB.
#'
#' @details
#' The `create_contoso_duckdb()` function creates views for the following Contoso datasets:
#'
#' - `sales`: Contains sales transaction data.
#' - `product`: Contains details about products, including attributes like product name, manufacturer, and category.
#' - `customer`: Contains customer demographic and geographic information.
#' - `store`: Contains information about store locations and attributes.
#' - `fx`: Contains foreign exchange rate data for currency conversion.
#' - `calendar`: Contains various date-related information, including day, week, month, and year.
#' - `orders`: Contains order header information.
#' - `orderrows`: Contains order line items.
#'
#' Available sizes (approximate sales rows):
#' - `small`: ~8,000 rows
#' - `medium`: ~2.3 million rows
#' - `large`: ~47 million rows
#' - `mega`: ~237 million rows
#'
#' @return A list containing:
#' - `sales`, `product`, `customer`, `store`, `fx`, `calendar`, `orders`, `orderrows`: lazy `tbl` objects
#' - `con`: the DuckDB connection (use `DBI::dbDisconnect(db$con, shutdown = TRUE)` when done)
#'
#' @examples
#' \dontrun{
#'   db <- create_contoso_duckdb(size = "small")
#'   db$sales |> head()
#'   DBI::dbDisconnect(db$con, shutdown = TRUE)
#' }
#' @export
create_contoso_duckdb <- function(size = "small") {
  stopifnot(is.character(size))
  size <- tolower(size)
  size <- match.arg(size, choices = c("small", "medium", "large", "mega"), several.ok = FALSE)

  # Map size names to folder names
  size_to_folder <- c(
    "small" = "contoso_100k",
    "medium" = "contoso_1m",
    "large" = "contoso_10m",
    "mega" = "contoso_100m"
  )
  folder <- size_to_folder[[size]]

  # Cloudflare R2 public bucket URL
  r2_base_url <- "https://pub-6aa63519a4b945948cb8c88949b320ca.r2.dev"

  # Create DuckDB connection
  con <- DBI::dbConnect(duckdb::duckdb())

  # Install and load httpfs extension
  DBI::dbExecute(con, "INSTALL httpfs; LOAD httpfs;")

  # Table names
  tables_vec <- c("sales", "product", "customer", "store", "orders", "orderrows", "fx", "calendar")

  # Create views for each table pointing to R2 parquet files
  purrr::walk(tables_vec, \(tbl) {
    parquet_url <- sprintf("%s/%s/%s.parquet", r2_base_url, folder, tbl)
    DBI::dbExecute(con, sprintf("CREATE VIEW %s AS SELECT * FROM read_parquet('%s');", tbl, parquet_url))
  })

  # Create lazy tbl references
  out <- tables_vec |>
    purrr::set_names() |>
    purrr::map(\(tbl) dplyr::tbl(con, tbl)) |>
    c(list(con = con))

  return(out)
}


#' @title Launch the DuckDB UI in your browser
#'
#' @name launch_ui
#'
#' @description
#' The `launch_ui()` function installs and launches the DuckDB UI extension
#' for an active DuckDB database connection. This allows users to interact
#' with the database via a web-based graphical interface.
#'
#' Your connection from [create_contoso_duckdb()] is returned in the list.
#'
#' @param .con A valid `DBIConnection` object connected to a DuckDB database.
#' The function will check that the connection is valid before proceeding.
#'
#' @details
#' The function performs the following steps:
#'
#' * Checks that the provided DuckDB connection is valid.
#'    If the connection is invalid, it aborts with a descriptive error message.
#' * Installs the `ui` extension into the connected DuckDB instance.
#' * Calls the `start_ui()` procedure to launch the DuckDB UI in your browser.
#'
#' This provides a convenient way to explore and manage DuckDB databases
#' interactively without needing to leave the R environment.
#'
#' @return
#' The function is called for its side effects and does not return a value.
#' It launches the DuckDB UI and opens it in your default web browser.
#' @seealso
#' - [create_contoso_duckdb()] for creating example Contoso datasets in DuckDB.
#' - [DBI::dbConnect()] and [DBI::dbDisconnect()] for managing DuckDB connections.
#' - [duckdb::duckdb()] for creating a DuckDB driver instance.
#' @examples
#' \dontrun{
#' # Connect to DuckDB
#' db <- create_contoso_duckdb()
#'
#' # Launch the DuckDB UI
#' launch_ui(db$con)
#'
#' # Clean up
#' DBI::dbDisconnect(db$con, shutdown = TRUE)
#' }
#'
#' @export
launch_ui <- function(.con){

  if (!DBI::dbIsValid(.con)) {

    cli::cli_abort("Database connection is invalid, please reconnect before proceeding.")
  }

  DBI::dbExecute(.con,"install ui;")

  DBI::dbExecute(.con,"CALL start_ui()")

  invisible(NULL)
}

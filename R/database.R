#' @param db_dir "temp" or "in_memory"
#'
#' @param size "100k","1M", "10M", or "100M"
#'
#' @title Creates duckdb versions of Contoso datasets
#' @name create_contoso_duckdb
#'
#' @details
#' The `create_contonso_duckd()` function registers the following Contoso datasets as DuckDB tables:
#'
#' - `sales`: Contains sales transaction data.
#' - `product`: Contains details about products, including attributes like product name, manufacturer, and category.
#' - `customer`: Contains customer demographic and geographic information.
#' - `store`: Contains information about store locations and attributes.
#' - `fx`: Contains foreign exchange rate data for currency conversion.
#' - `calendar`: Contains various date-related information, including day, week, month, and year.
#' - `con`: the duckdb connection to your database
#'
#' You can choose to store the database in memory or in a temporary directory. If you choose "temp", the database will be created in a temporary file on disk. If you choose "in_memory", the database will be created entirely in memory and will be discarded after the R session ends.
#'
#' @return A list of lazy `tbl` objects that are references to the Contoso datasets stored in the DuckDB database. The list contains the following tables:
#'
#' - `sales`
#' - `product`
#' - `customer`
#' - `store`
#' - `fx`
#' - `store`
#' - `orderrows`
#' - `calendar`
#'
#' @examples
#' # Create a DuckDB version of Contoso datasets stored in memory
#'
#' \dontrun{
#'  create_contoso_duckdb(db_dir = "in_memory",size="100K")
#' }
#' @export
create_contoso_duckdb <- function(db_dir= c("in_memory"),size="100K"){

  db_dir <- match.arg(db_dir, choices = c("temp", "in_memory"),several.ok = FALSE)

  # size <- "1M"
  stopifnot(is.character(size))
  size <- tolower(size)
  size_vec <- match.arg(size,choices=c("100k","1m","10m","100m"),several.ok = FALSE)

  if(db_dir=="temp"){
    db_dir <-   tempfile()
    con <- suppressWarnings(DBI::dbConnect(duckdb::duckdb(db_dir)))
  }else{
    con <- suppressWarnings(DBI::dbConnect(duckdb::duckdb()))
  }


  #attach motherduck database

suppressWarnings(DBI::dbExecute(con,"INSTALL motherduck;"))

suppressWarnings(DBI::dbExecute(con,"ATTACH 'md:_share/contoso/5cd50a2d-d482-4160-b260-f10091290db9' as contoso"))

tables_vec <- c("sales","product","customer","store","orders","orderrows","fx","calendar")

schema_options_vec <- c("100k"="small","1m"="medium","10m"="large","100m"="mega")

schema_vec <- schema_options_vec[size_vec] |> unname()

sql_vec <- lapply(
  tables_vec,
  function(x) DBI::Id("contoso", schema_vec, x)
)


# there's a better way to do this but I'm lazy

sales_db <- dplyr::tbl(con,sql_vec[[1]])
product_db <- dplyr::tbl(con,sql_vec[[2]])
customer_db <- dplyr::tbl(con,sql_vec[[3]])
store_db <- dplyr::tbl(con,sql_vec[[4]])
orders_db <- dplyr::tbl(con,sql_vec[[5]])
orderrows_db <- dplyr::tbl(con,sql_vec[[6]])
fx_db <- dplyr::tbl(con,sql_vec[[7]])
calendar_db <- dplyr::tbl(con,sql_vec[[8]])


out <- list(
  sales=sales_db
  ,product=product_db
  ,customer=customer_db
  ,store=store_db
  ,fx=fx_db
  ,calendar=calendar_db
  ,orders=orders_db
  ,orderrows=orderrows_db
  ,con=con
)



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

}




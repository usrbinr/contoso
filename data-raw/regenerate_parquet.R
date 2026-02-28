# Regenerate Parquet files with consistent schemas across all sizes
#
# This script:
# 1. Reads local parquet files from data-raw/output/
# 2. Transforms to consistent schema with standardized column names
# 3. Saves as Parquet files locally
# 4. Upload to Cloudflare R2 using rclone

library(dplyr)
library(cli)
library(arrow)

# Size mappings
sizes <- c(
  "small" = "contoso_100k",
  "medium" = "contoso_1m",
  "large" = "contoso_10m",
  "mega" = "contoso_100m"
)

# Target schemas (columns to keep, in order) - with standardized names
target_schemas <- list(
  sales = c("order_key", "line_number", "order_date", "delivery_date",
            "customer_key", "store_key", "product_key", "quantity",
            "unit_price", "net_price", "unit_cost", "currency_code",
            "exchange_rate", "gross_revenue", "net_revenue", "unit_discount",
            "discounts", "cogs", "gross_margin", "unit_margin"),

  customer = c("customer_key", "geo_area_key", "start_date", "end_date",
               "continent", "gender", "title", "given_name", "middle_initial",
               "surname", "street_address", "city", "state", "state_full",
               "zip_code", "country", "country_full", "birthday", "age",
               "occupation", "company", "vehicle", "latitude", "longitude"),

  store = c("store_key", "store_code", "geo_area_key", "country_code",
            "country_name", "state", "open_date", "close_date",
            "description", "square_meters", "status"),

  product = c("product_key", "product_code", "product_name", "manufacturer",
              "brand", "color", "weight_unit", "weight", "cost", "price",
              "category_key", "category_name", "sub_category_key", "sub_category_name"),

  orders = c("order_key", "customer_key", "store_key", "order_date",
             "delivery_date", "currency_code"),

  orderrows = c("order_key", "line_number", "product_key", "quantity",
                "unit_price", "net_price", "unit_cost"),

  fx = c("date", "from_currency", "to_currency", "exchange"),

  calendar = c("date", "date_key", "year", "year_quarter", "year_quarter_number",
               "quarter", "year_month", "year_month_short", "year_month_number",
               "month", "month_short", "month_number", "day_of_week",
               "day_of_week_short", "day_of_week_number", "working_day",
               "working_day_number")
)

# Column renames: new_name = "old_name" (dplyr rename format)
column_renames <- list(
  sales = c(gross_margin = "margin"),
  customer = c(start_date = "start_dt", end_date = "end_dt"),
  calendar = c(day_of_week = "dayof_week", day_of_week_short = "dayof_week_short",
               day_of_week_number = "dayof_week_number")
)

# Input/output directories
input_base <- "data-raw/output"
output_base <- "data-raw/output_renamed"
if (!dir.exists(output_base)) dir.create(output_base, recursive = TRUE)

tables <- c("sales", "product", "customer", "store", "orders", "orderrows", "fx", "calendar")

# Process each size
purrr::walk(names(sizes), \(size_name) {
  folder <- sizes[[size_name]]
  cli_h1("Processing {size_name} ({folder})")

  input_dir <- file.path(input_base, folder)
  output_dir <- file.path(output_base, folder)
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

  purrr::walk(tables, \(tbl_name) {
    cli_progress_step("Processing {tbl_name}")

    input_path <- file.path(input_dir, paste0(tbl_name, ".parquet"))
    df <- read_parquet(input_path)

    cli_alert_info("  Source columns ({ncol(df)}): {paste(names(df), collapse = ', ')}")

    # Apply column renames if defined for this table
    if (tbl_name %in% names(column_renames)) {
      renames <- column_renames[[tbl_name]]
      # Filter to only columns that exist
      renames <- renames[renames %in% names(df)]
      df <- df |> rename(!!!renames)
    }

    # Select only target columns (in order)
    target_cols <- target_schemas[[tbl_name]]
    df <- df |> select(all_of(target_cols))

    cli_alert_success("  Final columns ({ncol(df)}): {paste(names(df), collapse = ', ')}")

    # Write to parquet
    output_path <- file.path(output_dir, paste0(tbl_name, ".parquet"))
    write_parquet(df, output_path)
    cli_alert_success("  Wrote {nrow(df)} rows to {output_path}")
  })

  cli_alert_success("Completed {size_name}")
})

cli_h1("Done!")
cli_alert_info("Upload to Cloudflare R2 using rclone:")
cli_code("rclone sync {output_base}/ r2:contoso --progress")

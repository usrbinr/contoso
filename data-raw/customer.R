## code to prepare `customer` dataset goes here


dir <- "data-raw"

# One row per customer. The source catalogue holds 104,990 customers, of which
# only those that actually transact are shipped -- keeping the whole catalogue
# would take the package well past the CRAN size limit.
#
# Note this is a semi_join, not a left_join onto sales: joining the dimension
# onto the fact table fans it out to sales-line grain and destroys
# customer_key's uniqueness, which is what happened up to 2.1.0.

sales <- readr::read_csv(file.path(dir,"sales.csv"),name_repair = janitor::make_clean_names,show_col_types = FALSE) |>
    dplyr::select(customer_key)

customer <- readr::read_csv(file.path(dir,"customer.csv"),name_repair = janitor::make_clean_names,show_col_types = FALSE) |>
    dplyr::semi_join(sales, by = dplyr::join_by(customer_key)) |>
    dplyr::rename(start_date = start_dt, end_date = end_dt) |>
    dplyr::arrange(customer_key)

rm(sales)

stopifnot(
    "customer_key must be unique" = !anyDuplicated(customer$customer_key),
    "every customer must transact" = nrow(customer) == 3165L
)

customer_labels <- list(
    customer_key = "Unique customer identifier",
    geo_area_key = "Geographical area identifier",
    start_date = "Start date of customer record",
    end_date = "End date of customer record",
    continent = "Continent of the customer",
    gender = "Gender of the customer",
    title = "Title of the customer (e.g., Mr., Mrs., Dr.)",
    given_name = "First name of the customer",
    middle_initial = "Middle initial of the customer",
    surname = "Last name of the customer",
    street_address = "Street address of the customer",
    city = "City where the customer resides",
    state = "State or region where the customer resides",
    state_full = "Full name of the state or region",
    zip_code = "Postal code of the customer’s address",
    country = "Country where the customer resides",
    country_full = "Full name of the country",
    birthday = "Birthday of the customer",
    age = "Age of the customer",
    occupation = "Occupation of the customer",
    company = "Company where the customer works",
    vehicle = "Vehicle owned by the customer",
    latitude = "Latitude of the customer's location",
    longitude = "Longitude of the customer's location"
)

# Example: Assuming 'customers' is your data frame
labelled::var_label(customer) <- customer_labels

usethis::use_data(customer, overwrite = TRUE)


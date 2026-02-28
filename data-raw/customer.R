## code to prepare `customer` dataset goes here


dir <- "data-raw"

sales <- readr::read_csv(file.path(dir,"sales.csv"),name_repair = janitor::make_clean_names,show_col_types = FALSE) |>
    dplyr::select(customer_key)

customer <- sales |>
    dplyr::left_join(
    readr::read_csv(file.path(dir,"customer.csv"),name_repair = janitor::make_clean_names,show_col_types = FALSE)
    ,by=dplyr::join_by(customer_key)
    )

rm(sales)

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


#' Sales Data from the Contonso Dataset
#'
#' This dataset contains information about sales orders, including order details, pricing, and customer data from the Contonso dataset.
#' It provides insights into the transactions that have occurred, including order dates, delivery dates, customer and store information,
#' as well as product details.
#'
#' @format A data frame with sales columns:
#' \describe{
#'   \item{order_key}{\code{double} Unique identifier for each order.}
#'   \item{line_number}{\code{double} Line number within the order (for multi-line orders).}
#'   \item{order_date}{\code{Date} Date when the order was placed.}
#'   \item{delivery_date}{\code{Date} Date when the order was delivered.}
#'   \item{customer_key}{\code{double} Unique identifier for the customer who placed the order.}
#'   \item{store_key}{\code{double} Unique identifier for the store where the order was placed.}
#'   \item{product_key}{\code{double} Unique identifier for the product in the order.}
#'   \item{quantity}{\code{double} The quantity of the product ordered.}
#'   \item{unit_price}{\code{double} The price per unit of the product.}
#'   \item{net_price}{\code{double} The total net price for the product, considering any discounts.}
#'   \item{unit_cost}{\code{double} The cost per unit of the product.}
#'   \item{currency_code}{\code{character} The currency code used for the transaction (e.g., USD, EUR).}
#'   \item{exchange_rate}{\code{double} The exchange rate applied to the currency, if applicable.}
#'   \item{gross_revenue}{\code{double} A product's unit_price multiplied by quantity.}
#'   \item{net_revenue}{\code{double} A product's net_price multiplied by quantity.}
#'   \item{unit_discount}{\code{double} A product's unit_price minute net_price.}
#'   \item{discounts}{\code{double} A product's unit_discount multiplied by quantity.}
#'   \item{cogs}{\code{double} A product's unit_cost multiplied by quantity.}
#'   \item{margin}{\code{double} A product's net_revenue minus cogs.}
#'   \item{unit_margin}{\code{double} A product margin divided by quantity.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"sales"



#' Customer Data from the Contonso Dataset
#'
#' This dataset contains information about customers from the Contonso dataset, including demographic details, geographical information,
#' contact information, and other personal attributes. It provides insights into customer profiles, including location, age, occupation,
#' and more.
#'
#' @format A data frame with 23 columns:
#' \describe{
#'   \item{customer_key}{\code{double} Unique identifier for each customer.}
#'   \item{geo_area_key}{\code{double} Unique identifier for the geographical area the customer resides in.}
#'   \item{start_dt}{\code{Date} Date when the customer relationship began.}
#'   \item{end_dt}{\code{Date} Date when the customer relationship ended, if applicable.}
#'   \item{continent}{\code{character} The continent where the customer resides.}
#'   \item{gender}{\code{character} The gender of the customer (e.g., 'Male', 'Female').}
#'   \item{title}{\code{character} The title of the customer (e.g., 'Mr.', 'Ms.').}
#'   \item{given_name}{\code{character} The given (first) name of the customer.}
#'   \item{middle_initial}{\code{character} The middle initial of the customer, if applicable.}
#'   \item{surname}{\code{character} The surname (last name) of the customer.}
#'   \item{street_address}{\code{character} The street address of the customer.}
#'   \item{city}{\code{character} The city where the customer resides.}
#'   \item{state}{\code{character} The state or province where the customer resides.}
#'   \item{state_full}{\code{character} The full name of the state or province.}
#'   \item{zip_code}{\code{character} The postal (ZIP) code of the customer's address.}
#'   \item{country}{\code{character} The country where the customer resides, using the country code.}
#'   \item{country_full}{\code{character} The full name of the country where the customer resides.}
#'   \item{birthday}{\code{Date} The date of birth of the customer.}
#'   \item{age}{\code{double} The age of the customer.}
#'   \item{occupation}{\code{character} The customer's occupation or profession.}
#'   \item{company}{\code{character} The company the customer is associated with, if applicable.}
#'   \item{vehicle}{\code{character} The type or make of vehicle the customer owns or drives.}
#'   \item{latitude}{\code{double} The latitude of the customer's address.}
#'   \item{longitude}{\code{double} The longitude of the customer's address.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"customer"

#' Calendar Dimension Data from the Contonso Dataset
#'
#' This dataset contains calendar-related information used for time-based analysis in the Contonso dataset. It includes various representations
#' of date-related attributes, such as year, quarter, month, and day, along with indicators for working days. It is useful for time-series
#' analysis and aggregating data by different time periods.
#'
#' @format A data frame with 17 columns:
#' \describe{
#'   \item{date}{\code{Date} The actual date for the record.}
#'   \item{date_key}{\code{double} Unique identifier for the date (often in YYYYMMDD format).}
#'   \item{year}{\code{double} The year part of the date.}
#'   \item{year_quarter}{\code{character} The year and quarter (e.g., "2025 Q1").}
#'   \item{year_quarter_number}{\code{double} The numerical representation of the quarter (e.g., 1, 2, 3, 4).}
#'   \item{quarter}{\code{character} The quarter of the year (e.g., "Q1", "Q2").}
#'   \item{year_month}{\code{character} The year and month (e.g., "2025-03").}
#'   \item{year_month_short}{\code{character} A shortened version of year and month (e.g., "2025 Mar").}
#'   \item{year_month_number}{\code{double} The numerical representation of the year-month (e.g., 202503 for March 2025).}
#'   \item{month}{\code{character} The month name (e.g., "March").}
#'   \item{month_short}{\code{character} The abbreviated month name (e.g., "Mar").}
#'   \item{month_number}{\code{double} The numerical representation of the month (e.g., 3 for March).}
#'   \item{dayof_week}{\code{character} The full name of the day of the week (e.g., "Monday").}
#'   \item{dayof_week_short}{\code{character} The abbreviated day of the week (e.g., "Mon").}
#'   \item{dayof_week_number}{\code{double} The numerical representation of the day of the week (e.g., 1 for Monday).}
#'   \item{working_day}{\code{double} Indicator of whether the date is a working day (1 for working day, 0 for non-working day).}
#'   \item{working_day_number}{\code{double} A numerical indicator for working day (e.g., 1 for working day, 0 for non-working day).}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"calendar"

#' Store Data from the Contonso Dataset
#'
#' This dataset contains information about stores within the Contonso dataset. It includes details about the store's geographic
#' location, operational status, and physical characteristics such as size and opening/closing dates. It provides insights into the
#' store network of the company.
#'
#' @format A data frame with 11 columns:
#' \describe{
#'   \item{store_key}{\code{double} Unique identifier for each store.}
#'   \item{store_code}{\code{double} A code that uniquely identifies the store.}
#'   \item{geo_area_key}{\code{double} Unique identifier for the geographical area where the store is located.}
#'   \item{country_code}{\code{character} The country code where the store is located (e.g., "US", "DE").}
#'   \item{country_name}{\code{character} The full name of the country where the store is located.}
#'   \item{state}{\code{character} The state or province where the store is located.}
#'   \item{open_date}{\code{Date} The date when the store was opened.}
#'   \item{close_date}{\code{Date} The date when the store was closed, if applicable.}
#'   \item{description}{\code{character} A description of the store (e.g., "Flagship store", "Outlet store").}
#'   \item{square_meters}{\code{double} The physical size of the store in square meters.}
#'   \item{status}{\code{character} The operational status of the store (e.g., "Open", "Closed").}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"store"

#' Order Data from the Contonso Dataset
#'
#' This dataset contains information about customer orders, including order dates, delivery dates, and store details.
#'
#' @format A data frame with 5 columns:
#' \describe{
#'   \item{order_key}{\code{double} Unique identifier for the order.}
#'   \item{customer_key}{\code{double} Unique identifier for the customer who placed the order.}
#'   \item{store_key}{\code{double} Unique identifier for the store where the order was placed.}
#'   \item{order_date}{\code{Date} The date when the order was placed.}
#'   \item{delivery_date}{\code{Date} The date when the order is expected to be delivered.}
#'   \item{currency_code}{\code{character} The currency code used for the order (e.g., USD, EUR).}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"orders"



#' Order Rows Data from the Contonso Dataset
#'
#' This dataset contains detailed information about the individual items (rows) within each order in the Contonso dataset. It includes
#' details such as the product, quantity, pricing, and cost of each item in an order. This dataset is useful for analyzing the breakdown
#' of order components and individual product sales.
#'
#' @format A data frame with 7 columns:
#' \describe{
#'   \item{order_key}{\code{double} Unique identifier for the order to which the item belongs.}
#'   \item{line_number}{\code{double} Line number within the order, identifying each product line.}
#'   \item{product_key}{\code{double} Unique identifier for the product in the order row.}
#'   \item{quantity}{\code{double} The quantity of the product ordered.}
#'   \item{unit_price}{\code{double} The price per unit of the product.}
#'   \item{net_price}{\code{double} The total net price for the product, considering any applicable discounts.}
#'   \item{unit_cost}{\code{double} The cost per unit of the product.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"orderrows"

#' Foreign Exchange Data from the Contonso Dataset
#'
#' This dataset contains information about foreign exchange (FX) rates between different currencies. It includes details about the
#' exchange rate for a given date, as well as the currencies involved. This dataset is useful for analyzing currency conversions
#' and understanding the exchange rates between different currencies over time.
#'
#' @format A data frame with 4 columns:
#' \describe{
#'   \item{date}{\code{Date} The date of the exchange rate.}
#'   \item{from_currency}{\code{character} The code of the source currency (e.g., "USD", "EUR").}
#'   \item{to_currency}{\code{character} The code of the target currency (e.g., "GBP", "JPY").}
#'   \item{exchange}{\code{double} The exchange rate between the source and target currencies on the given date.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"fx"


#' Product Data from the Contonso Dataset
#'
#' This dataset contains information about products in the Contonso dataset. It includes product details such as identifiers,
#' descriptions, pricing, weight, and categorization. This dataset is useful for analyzing product characteristics, pricing, and
#' product-related sales insights.
#'
#' @format A data frame with 14 columns:
#' \describe{
#'   \item{product_key}{\code{double} Unique identifier for each product.}
#'   \item{product_code}{\code{character} A code that uniquely identifies the product.}
#'   \item{product_name}{\code{character} The name or description of the product.}
#'   \item{manufacturer}{\code{character} The name of the manufacturer of the product.}
#'   \item{brand}{\code{character} The brand of the product.}
#'   \item{color}{\code{character} The color of the product.}
#'   \item{weight_unit}{\code{character} The unit of measurement for the product's weight (e.g., "kg", "lbs").}
#'   \item{weight}{\code{double} The weight of the product.}
#'   \item{cost}{\code{double} The cost price of the product.}
#'   \item{price}{\code{double} The selling price of the product.}
#'   \item{category_key}{\code{double} Unique identifier for the category to which the product belongs.}
#'   \item{category_name}{\code{character} The name of the category to which the product belongs.}
#'   \item{sub_category_key}{\code{double} Unique identifier for the subcategory to which the product belongs.}
#'   \item{sub_category_name}{\code{character} The name of the subcategory to which the product belongs.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"product"



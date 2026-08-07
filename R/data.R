#' Sales Data from the Contoso Dataset
#'
#' This dataset contains information about sales orders, including order details, pricing, and customer data from the Contoso dataset.
#' It provides insights into the transactions that have occurred, including order dates, delivery dates, customer and store information,
#' as well as product details.
#'
#' Each row is one line item on one order --- the same grain as [orderrows].
#' This is the denormalised fact table: it repeats every column of [orders] and
#' [orderrows], adds the day's `exchange_rate`, and pre-computes seven revenue,
#' cost and margin measures.
#'
#' @section Currency:
#' Every money column is in \strong{USD}, regardless of the order's
#' `currency_code`, so amounts sum directly across orders. Multiply by
#' `exchange_rate` to express an amount in the currency the order was placed in.
#'
#' @format A data frame with 7,794 rows and 20 columns:
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
#'   \item{net_price}{\code{double} The price \emph{per unit} after discount,
#'     in USD. Despite the name this is a unit figure, not a line total.}
#'   \item{unit_cost}{\code{double} The cost per unit of the product.}
#'   \item{currency_code}{\code{character} The currency the order was placed in
#'     (e.g., USD, EUR). Does \strong{not} describe the money columns, which are
#'     all USD.}
#'   \item{exchange_rate}{\code{double} The USD-to-\code{currency_code} rate on
#'     \code{order_date}, from [fx]. 1.0 for USD orders. It has not been applied to
#'     the money columns --- multiply if you want local currency.}
#'   \item{gross_revenue}{\code{double} A product's unit_price multiplied by quantity.}
#'   \item{net_revenue}{\code{double} A product's net_price multiplied by quantity.}
#'   \item{unit_discount}{\code{double} A product's unit_price minus net_price.}
#'   \item{discounts}{\code{double} A product's unit_discount multiplied by quantity.}
#'   \item{cogs}{\code{double} Cost of goods sold. A product's unit_cost multiplied by quantity.}
#'   \item{gross_margin}{\code{double} A product's net_revenue minus cogs.}
#'   \item{unit_margin}{\code{double} A product's gross_margin divided by quantity.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"sales"



#' Customer Data from the Contoso Dataset
#'
#' This dataset contains information about customers from the Contoso dataset, including demographic details, geographical information,
#' contact information, and other personal attributes. It provides insights into customer profiles, including location, age, occupation,
#' and more.
#'
#' Each row is one customer. Only customers that placed at least one order are
#' included, so every `customer_key` here appears in [sales].
#'
#' @section Changed in 2.2.0:
#' Up to version 2.1.0 this table was built by joining the customer catalogue
#' onto `sales`, which repeated each customer once per sales line they appeared
#' on: 7,794 rows for 3,165 customers. `customer_key` was therefore not unique
#' and any join to this table silently multiplied rows. The duplicates have
#' been collapsed. No attribute varied within a customer, so nothing was lost.
#'
#' @format A data frame with 3,165 rows and 24 columns:
#' \describe{
#'   \item{customer_key}{\code{double} Unique identifier for each customer. A
#'     primary key: unique and never missing.}
#'   \item{geo_area_key}{\code{double} Unique identifier for the geographical area the customer resides in.}
#'   \item{start_date}{\code{Date} Date when the customer relationship began.}
#'   \item{end_date}{\code{Date} Date when the customer relationship ended, if applicable.}
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

#' Calendar Dimension Data from the Contoso Dataset
#'
#' This dataset contains calendar-related information used for time-based analysis in the Contoso dataset. It includes various representations
#' of date-related attributes, such as year, quarter, month, and day, along with indicators for working days. It is useful for time-series
#' analysis and aggregating data by different time periods.
#'
#' Spans whole calendar years, so it extends past the trading period at both
#' ends. Join from `calendar` when you need a dense series with explicit zeros.
#'
#' @format A data frame with 1,461 rows and 17 columns:
#' \describe{
#'   \item{date}{\code{Date} The actual date for the record.}
#'   \item{date_key}{\code{double} The date as \code{YYYYMMDD}.}
#'   \item{year}{\code{double} The year part of the date.}
#'   \item{year_quarter}{\code{character} Quarter and year, formatted \code{"Q1-2021"}.}
#'   \item{year_quarter_number}{\code{double} A continuous quarter counter,
#'     \code{year * 4 + quarter}, running from 8085. \strong{Not} 1-4 --- use
#'     \code{quarter} for the within-year number.}
#'   \item{quarter}{\code{character} The quarter within the year (e.g., "Q1", "Q2").}
#'   \item{year_month}{\code{character} Month and year, formatted \code{"January 2021"}.}
#'   \item{year_month_short}{\code{character} Month and year, formatted \code{"Jan 2021"}.}
#'   \item{year_month_number}{\code{double} A continuous month counter,
#'     \code{year * 12 + month}, running from 24253. \strong{Not} \code{YYYYMM}.}
#'   \item{month}{\code{character} The month name (e.g., "March").}
#'   \item{month_short}{\code{character} The abbreviated month name (e.g., "Mar").}
#'   \item{month_number}{\code{double} The month within the year, 1-12.}
#'   \item{day_of_week}{\code{character} The full name of the day of the week (e.g., "Monday").}
#'   \item{day_of_week_short}{\code{character} The abbreviated day of the week (e.g., "Mon").}
#'   \item{day_of_week_number}{\code{double} The day within the week, starting
#'     \strong{Sunday = 1}, not Monday.}
#'   \item{working_day}{\code{double} Indicator of whether the date is a working day
#'     (1 for working day, 0 for non-working day). This is the flag.}
#'   \item{working_day_number}{\code{double} A \strong{cumulative} count of working
#'     days elapsed, running 0-1003. Not a flag: it increments on working days and
#'     repeats on non-working days.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"calendar"

#' Store Data from the Contoso Dataset
#'
#' This dataset contains information about stores within the Contoso dataset. It includes details about the store's geographic
#' location, operational status, and physical characteristics such as size and opening/closing dates. It provides insights into the
#' store network of the company.
#'
#' @section The online channel:
#' `store_key` 999999 is the online channel, not a location. It carries sentinel
#' values throughout: `store_code` and `geo_area_key` are -1, `country_code` is
#' `"--"`, `country_name` and `state` are literally `"Online"`, and
#' `square_meters` is missing. Filter it out before any geographic or
#' floor-space aggregate. It accounts for a little over half of all sales lines.
#'
#' @format A data frame with 74 rows (73 physical stores plus the online
#'   channel) and 11 columns:
#' \describe{
#'   \item{store_key}{\code{double} Unique identifier for each store. 999999 is
#'     the online channel sentinel.}
#'   \item{store_code}{\code{double} A code identifying the \emph{site}.
#'     \strong{Not unique} --- a site with successive premises shares one code
#'     across several \code{store_key} values. -1 on the online row.}
#'   \item{geo_area_key}{\code{double} The geographical area, on the same
#'     numbering as \code{customer$geo_area_key}. No geo-area table ships with
#'     the package, so this resolves to nothing on its own. -1 on the online row.}
#'   \item{country_code}{\code{character} The country code where the store is
#'     located (e.g., "US", "DE"), plus the placeholder \code{"--"} on the online row.}
#'   \item{country_name}{\code{character} The full name of the country, plus the
#'     pseudo-country \code{"Online"}.}
#'   \item{state}{\code{character} The state or region, always spelled out ---
#'     unlike \code{customer$state}, which is often abbreviated. Literally
#'     \code{"Online"} on the online row.}
#'   \item{open_date}{\code{Date} The date when the store was opened.}
#'   \item{close_date}{\code{Date} The date when the store was closed. Missing
#'     for stores still trading.}
#'   \item{description}{\code{character} Always \code{"Contoso Store <state>"}
#'     for physical stores, and \code{"Online store"} for the online row. Carries
#'     no store-format information.}
#'   \item{square_meters}{\code{double} The physical size of the store in square
#'     meters. Missing on the online row.}
#'   \item{status}{\code{character} Exceptional status only: \code{"Closed"} or
#'     \code{"Restructured"}. \strong{Missing, never "Open"}, for stores trading
#'     normally --- test with \code{is.na()} rather than comparing to a string.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"store"

#' Order Data from the Contoso Dataset
#'
#' This dataset contains information about customer orders, including order dates, delivery dates, and store details.
#'
#' @format A data frame with 3,242 rows and 6 columns:
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



#' Order Rows Data from the Contoso Dataset
#'
#' This dataset contains detailed information about the individual items (rows) within each order in the Contoso dataset. It includes
#' details such as the product, quantity, pricing, and cost of each item in an order. This dataset is useful for analyzing the breakdown
#' of order components and individual product sales.
#'
#' @format A data frame with 7,794 rows and 7 columns:
#' \describe{
#'   \item{order_key}{\code{double} Unique identifier for the order to which the item belongs.}
#'   \item{line_number}{\code{double} Line number within the order, identifying each product line.}
#'   \item{product_key}{\code{double} Unique identifier for the product in the order row.}
#'   \item{quantity}{\code{double} The quantity of the product ordered.}
#'   \item{unit_price}{\code{double} The price per unit of the product.}
#'   \item{net_price}{\code{double} The price \emph{per unit} after discount,
#'     in USD. Despite the name this is a unit figure, not a line total.}
#'   \item{unit_cost}{\code{double} The cost per unit of the product.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"orderrows"

#' Foreign Exchange Data from the Contoso Dataset
#'
#' This dataset contains information about foreign exchange (FX) rates between different currencies. It includes details about the
#' exchange rate for a given date, as well as the currencies involved. This dataset is useful for analyzing currency conversions
#' and understanding the exchange rates between different currencies over time.
#'
#' @format A data frame with 36,525 rows and 4 columns:
#' \describe{
#'   \item{date}{\code{Date} The date of the exchange rate.}
#'   \item{from_currency}{\code{character} The code of the source currency (e.g., "USD", "EUR").}
#'   \item{to_currency}{\code{character} The code of the target currency (e.g., "GBP", "JPY").}
#'   \item{exchange}{\code{double} The exchange rate between the source and target currencies on the given date.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"fx"


#' Product Data from the Contoso Dataset
#'
#' This dataset contains information about products in the Contoso dataset. It includes product details such as identifiers,
#' descriptions, pricing, weight, and categorization. This dataset is useful for analyzing product characteristics, pricing, and
#' product-related sales insights.
#'
#' @format A data frame with 2,517 rows and 14 columns:
#' \describe{
#'   \item{product_key}{\code{double} Unique identifier for each product.}
#'   \item{product_code}{\code{character} A code that uniquely identifies the product.}
#'   \item{product_name}{\code{character} The name or description of the product.}
#'   \item{manufacturer}{\code{character} The name of the manufacturer of the product.}
#'   \item{brand}{\code{character} The brand of the product.}
#'   \item{color}{\code{character} The color of the product.}
#'   \item{weight_unit}{\code{character} The unit \code{weight} is expressed in:
#'     \code{"grams"}, \code{"ounces"} or \code{"pounds"} --- never \code{"kg"}.
#'     Metric and imperial units are mixed, so \code{weight} is \strong{not
#'     comparable across rows} without converting. Missing where the product has
#'     no weight.}
#'   \item{weight}{\code{double} The weight of the product, in
#'     \code{weight_unit}. Not on a common scale --- see that column.}
#'   \item{cost}{\code{double} The cost price of the product.}
#'   \item{price}{\code{double} The selling price of the product.}
#'   \item{category_key}{\code{double} Unique identifier for the category to which the product belongs.}
#'   \item{category_name}{\code{character} The name of the category to which the product belongs.}
#'   \item{sub_category_key}{\code{double} Unique identifier for the subcategory to which the product belongs.}
#'   \item{sub_category_name}{\code{character} The name of the subcategory to which the product belongs.}
#' }
#' @source https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
"product"



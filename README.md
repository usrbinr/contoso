

![](man/figures/logo.png)

Contoso is a synthetic dataset containing sample sales transaction data
for the fictional “Contoso” company. It includes various supporting
tables for business intelligence, such as customer, store, product, and
currency exchange data.

This dataset is perfect for practicing time series analysis, joins,
financial modeling, or any business intelligence-related tasks.

It comes with a built-in dataset as well as the ability to create an
in-memory database with [duckdb](https://duckdb.org/)

The package comes with the following tables:

- **sales**:
  - Contains information about sales transactions, including the total
    sales amount, customer, store, and product involved.
- **customer**:
  - Contains details about customers, such as customer key, name,
    address, and demographic information.
- **store**:
  - Contains information about stores, including store key, name,
    location, and related details.
- **product**:
  - Contains information about products, such as product key, name,
    category, and price.
- **fx**:
  - Contains foreign exchange rate data, mapping currency pairs to their
    exchange rates on specific dates.
- **date**:
  - Contains date-related information, including date, week, month,
    quarter, and year for use in time-based analysis.
- **orders**:
  - Contains information about individual orders, including order key,
    customer key, order date, and store information.
- **orderrows**:
  - Contains detailed line items for each order, including product key,
    quantity, and price for each item in the order.

Built into the package is the 10K row version of the dataset.

Using `view()`, you can see the columns’ label using the
[labelled](https://larmarange.github.io/labelled/index.html) package.

> Inspiration to using
> [labelled](https://larmarange.github.io/labelled/index.html) comes
> from [Crystal Lewis](https://cghlewis.com/blog/dict_clean/) excellent
> blog post

If you want a larger dataset, there is also 100K, 1M, 10M and 100M row
version which can be created with `create_contoso_duckdb()` function.

This will create a local duckdb database which will attach the specified
row size version from a motherduck database into your local database.

## Source

The data is originally sourced from the
[sqlbi](https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data)
github site

### Dataset overview

![](man/figures/contoso.svg)

The relationship keys that join each of the tables are listed below.

| sales | customer | product | store | order | orderrows | fx |
|----|----|----|----|----|----|----|
| order_key |  |  |  | order_key | order_key |  |
| customer_key | customer_key |  |  | customer_key |  |  |
| store_key |  |  | store_key | store_key |  |  |
| product_key |  | product_key |  |  | product_key |  |
| currency_code |  |  |  |  |  | from_currency |

### Installation

You can install the development version of package from
[GitHub](https://github.com/usrbinr/contoso) with:

``` r
# install.packages("pak")
pak::pak("usrbinr/contoso")
```

### Example

Example of how to create a duckdb database with Contoso tables loaded is
below:

``` r
library(contoso)

# Creates a list of DuckDB database containing Contoso datasets
contoso_db <- create_contoso_duckdb(dir = "temp",size = "1m")

# Access the sales dataset from the database
sales_data <- contoso_db$sales
```

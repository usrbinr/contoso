

<!-- badges: start -->

<a href="https://CRAN.R-project.org/package=contoso"><img src="https://www.r-pkg.org/badges/version/contoso" alt="CRAN status" /></a>
<!-- badges: end -->

<img src="man/figures/logo.png" width="150" />

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
- **calendar**:
  - Contains date-related information, including date, week, month,
    quarter, and year for use in time-based analysis.
- **orders**:
  - Contains information about individual orders, including order key,
    customer key, order date, and store information.
- **orderrows**:
  - Contains detailed line items for each order, including product key,
    quantity, and price for each item in the order.

Built into the package is the smallest version of the dataset: 7,794
sales lines across 3,242 orders and 3,165 customers.

Every column is documented in a machine-readable data dictionary, which
`contoso_dict_columns()` returns as a tibble:

``` r
contoso_dict_columns()
```

Using `labelled::look_for()`, you can also see the columns’ labels from
the [labelled](https://larmarange.github.io/labelled/index.html)
package.

> Inspiration to using
> [labelled](https://larmarange.github.io/labelled/index.html) comes
> from [Crystal Lewis](https://cghlewis.com/blog/dict_clean/) excellent
> blog post

For larger datasets, use `create_contoso_duckdb()` with one of the
following sizes:

| Size   | Sales Rows  |
|--------|-------------|
| small  | 7,794       |
| medium | 2,349,091   |
| large  | 23,719,935  |
| mega   | 237,245,485 |

Column names and types are identical across all four sizes; only the row
counts differ.

## Data Storage

The larger datasets are stored as Parquet files on Cloudflare R2 cloud
storage and streamed directly into DuckDB via the public URL:

    https://pub-6aa63519a4b945948cb8c88949b320ca.r2.dev

## Source

The data is originally sourced from the
[sqlbi](https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data)
github site

### Dataset overview

![](man/figures/contoso.svg)

The relationship keys that join each of the tables are listed below.

<div id="hydxbcsdmc" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hydxbcsdmc table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#hydxbcsdmc thead, #hydxbcsdmc tbody, #hydxbcsdmc tfoot, #hydxbcsdmc tr, #hydxbcsdmc td, #hydxbcsdmc th {
  border-style: none;
}
&#10;#hydxbcsdmc p {
  margin: 0;
  padding: 0;
}
&#10;#hydxbcsdmc .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#hydxbcsdmc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#hydxbcsdmc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#hydxbcsdmc .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#hydxbcsdmc .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#hydxbcsdmc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#hydxbcsdmc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#hydxbcsdmc .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#hydxbcsdmc .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#hydxbcsdmc .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#hydxbcsdmc .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#hydxbcsdmc .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#hydxbcsdmc .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#hydxbcsdmc .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#hydxbcsdmc .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hydxbcsdmc .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#hydxbcsdmc .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#hydxbcsdmc .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#hydxbcsdmc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hydxbcsdmc .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#hydxbcsdmc .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hydxbcsdmc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#hydxbcsdmc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hydxbcsdmc .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#hydxbcsdmc .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hydxbcsdmc .gt_left {
  text-align: left;
}
&#10;#hydxbcsdmc .gt_center {
  text-align: center;
}
&#10;#hydxbcsdmc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#hydxbcsdmc .gt_font_normal {
  font-weight: normal;
}
&#10;#hydxbcsdmc .gt_font_bold {
  font-weight: bold;
}
&#10;#hydxbcsdmc .gt_font_italic {
  font-style: italic;
}
&#10;#hydxbcsdmc .gt_super {
  font-size: 65%;
}
&#10;#hydxbcsdmc .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#hydxbcsdmc .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#hydxbcsdmc .gt_indent_1 {
  text-indent: 5px;
}
&#10;#hydxbcsdmc .gt_indent_2 {
  text-indent: 10px;
}
&#10;#hydxbcsdmc .gt_indent_3 {
  text-indent: 15px;
}
&#10;#hydxbcsdmc .gt_indent_4 {
  text-indent: 20px;
}
&#10;#hydxbcsdmc .gt_indent_5 {
  text-indent: 25px;
}
&#10;#hydxbcsdmc .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#hydxbcsdmc div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| sales | customer | product | store | order | orderrows | fx |
|----|----|----|----|----|----|----|
| order_key |  |  |  | order_key | order_key |  |
| customer_key | customer_key |  |  | customer_key |  |  |
| store_key |  |  | store_key | store_key |  |  |
| product_key |  | product_key |  |  | product_key |  |
| currency_code |  |  |  |  |  | from_currency |

</div>

### Installation

You can install the package from CRAN:

``` r
install.packages("contoso")
```

Or install the development version from
[Codeberg](https://codeberg.org/usrbinr/contoso):

``` r
# install.packages("pak")
pak::pak("git::https://codeberg.org/usrbinr/contoso")
```

### Example

``` r
library(contoso)

# Create a DuckDB connection to Contoso datasets
db <- create_contoso_duckdb(size = "medium")

# Access the sales dataset
db$sales |> head()

# Launch the DuckDB UI to explore all tables interactively
launch_ui(db$con)

# Clean up when done
DBI::dbDisconnect(db$con, shutdown = TRUE)
```

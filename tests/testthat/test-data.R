test_that("customer is one row per customer", {
  expect_equal(nrow(customer), 3165L)
  expect_false(anyDuplicated(customer$customer_key) > 0)
  expect_false(anyNA(customer$customer_key))
})

test_that("joining customer to sales does not fan out", {
  # Regression test for the pre-2.2.0 bug, where `customer` was built at
  # sales-line grain and every join to it silently multiplied rows.
  joined <- dplyr::left_join(sales, customer, by = "customer_key")
  expect_equal(nrow(joined), nrow(sales))
})

test_that("every customer transacts and every sale has a customer", {
  expect_setequal(customer$customer_key, unique(sales$customer_key))
})

# The data dictionary is validated properly by `data-dict validate-data`, which
# needs the CLI. These tests are the part that can run anywhere: they check the
# shipped YAML still describes the shipped data frames.

dict_tables <- function() {
  path <- system.file("extdata", "small", "data-dict.yaml", package = "contoso")
  skip_if(path == "", "data-dict.yaml not installed")
  yaml::read_yaml(path)$tables
}

test_that("data dictionary documents exactly the shipped tables and columns", {
  tables <- dict_tables()

  expect_setequal(
    purrr::map_chr(tables, "name"),
    c("sales", "orders", "orderrows", "product", "customer", "store",
      "calendar", "fx")
  )

  tables |> purrr::walk(\(tbl) {
    d <- get(tbl$name, envir = asNamespace("contoso"))
    expect_equal(purrr::map_chr(tbl$columns, "name"), names(d), info = tbl$name)
  })
})

test_that("documented enum values match the data", {
  dict_tables() |> purrr::walk(\(tbl) {
    d <- get(tbl$name, envir = asNamespace("contoso"))
    tbl$columns |>
      purrr::keep(\(col) identical(col$type, "enum")) |>
      purrr::walk(\(col) {
        x <- d[[col$name]]
        expect_setequal(unlist(col$values), sort(unique(x[!is.na(x)])))
      })
  })
})

test_that("documented required columns have no missing values", {
  dict_tables() |> purrr::walk(\(tbl) {
    d <- get(tbl$name, envir = asNamespace("contoso"))
    tbl$columns |>
      purrr::keep(\(col) any(c("required", "primary_key") %in% unlist(col$constraints))) |>
      purrr::walk(\(col) {
        expect_false(anyNA(d[[col$name]]),
                     info = paste0(tbl$name, ".", col$name))
      })
  })
})

test_that("documented primary keys really are unique", {
  # `sales` and `orderrows` are keyed on (order_key, line_number), so the key
  # has to be tested as a whole rather than column by column.
  dict_tables() |> purrr::walk(\(tbl) {
    key <- tbl$columns |>
      purrr::keep(\(col) "primary_key" %in% unlist(col$constraints)) |>
      purrr::map_chr("name")
    if (length(key) == 0) return(invisible())

    d <- get(tbl$name, envir = asNamespace("contoso"))[key]
    expect_equal(nrow(unique(d)), nrow(d),
                 info = paste0(tbl$name, ": ", paste(key, collapse = " + ")))
  })
})

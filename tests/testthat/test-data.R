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

test_that("data dictionary matches the shipped data", {
  cols <- contoso_dict_columns()

  for (tbl in unique(cols$table)) {
    d <- get(tbl, envir = asNamespace("contoso"))
    documented <- cols$column[cols$table == tbl]

    expect_equal(documented, names(d), info = tbl)
    expect_equal(
      unique(cols$rows[cols$table == tbl]), nrow(d),
      info = paste(tbl, "row count")
    )
  }
})

test_that("documented missing counts and enum values match the data", {
  cols <- contoso_dict_columns()

  for (i in seq_len(nrow(cols))) {
    x <- get(cols$table[i], envir = asNamespace("contoso"))[[cols$column[i]]]

    expect_equal(
      cols$missing[i], sum(is.na(x)),
      info = paste0(cols$table[i], ".", cols$column[i], " missing count")
    )

    if (!is.null(cols$values[[i]])) {
      expect_setequal(cols$values[[i]], sort(unique(x[!is.na(x)])))
    }
  }
})

test_that("documented primary keys really are unique", {
  cols <- contoso_dict_columns()
  pks <- cols[grepl("primary_key", cols$constraints), ]

  for (i in seq_len(nrow(pks))) {
    x <- get(pks$table[i], envir = asNamespace("contoso"))[[pks$column[i]]]
    expect_false(
      anyDuplicated(x) > 0,
      info = paste0(pks$table[i], ".", pks$column[i])
    )
  }
})

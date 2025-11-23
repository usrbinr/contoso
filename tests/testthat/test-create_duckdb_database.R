# tests/testthat/test-create_contoso_duckdb.R

describe("create_contoso_duckdb()", {


    testthat::skip_on_cran()

    it("creates a DuckDB database containing all expected tables", {


        # Create a small in-memory Contoso DuckDB instance
        result <- create_contoso_duckdb(
            db_dir = "in_memory",
            size   = "100K"
        )

        # List of tables that should be present in the returned list / connection object
        expected_names <- c(
            "sales", "product", "customer", "store", "fx",
            "calendar", "orders", "orderrows", "con"
        )

        # Verify all expected tables exist
        expect_true(all(expected_names %in% names(result)))

        # Verify no unexpected tables are present
        expect_setequal(names(result), expected_names)
    })
})

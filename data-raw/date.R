## code to prepare `date` dataset goes here


dir <- "data-raw"

calendar <- readr::read_csv(file.path(dir,"date.csv"),name_repair = janitor::make_clean_names,show_col_types = FALSE)

date_labels <- list(
    date = "Full date",
    date_key = "Unique date identifier",
    year = "Year of the date",
    year_quarter = "Year and quarter of the date",
    year_quarter_number = "Quarter number within the year",
    quarter = "Quarter of the year (Q1, Q2, Q3, Q4)",
    year_month = "Year and month of the date",
    year_month_short = "Short year and month (e.g., 2023-05)",
    year_month_number = "Numeric representation of the year and month",
    month = "Month of the year (1-12)",
    month_short = "Short month name (e.g., Jan, Feb)",
    month_number = "Numeric month (1-12)",
    day_of_week = "Day of the week (e.g., Monday, Tuesday)",
    day_of_week_short = "Short form of the day of the week (e.g., Mon, Tue)",
    day_of_week_number = "Numeric day of the week (1 = Sunday, 7 = Saturday)",
    working_day = "Indicates if it's a working day (TRUE/FALSE)",
    working_day_number = "Numeric representation of the working day only (1 = Monday, 2=Tuesday, 0 = weekend)"
)

# Example: Assuming 'dates' is your data frame
labelled::var_label(calendar) <- date_labels


usethis::use_data(calendar, overwrite = TRUE)

# contoso 2.0.0
* cran submission

# contoso 1.3.0
* Switched from MotherDuck to Backblaze B2 cloud storage for dataset hosting
* Now works on all platforms including Windows
* Changed size parameter to use descriptive names: "small", "medium", "large", "mega"
* Removed `db_dir` parameter (no longer needed)

# contoso 1.2.2
* create_contoso_duckdb() will not work if you are using windows due to lack of support from motherduck
* [see here for more information](https://motherduck.com/docs/integrations/language-apis-and-drivers/r/#considerations-and-limitations)

# contoso 1.2.1
* fixed create_contoso_duckdb() due to error created by table name changed
* updated tests

# contoso 1.2.0
* changed 'date' table name to 'calendar' to avoid namespace conflicts with lubridate and base packages

# contoso 1.1.1
* Patch to fixed launch_ui function



# contoso 1.1.0
* launch_ui function added
* pkgdown instead of altdocs
* new logo


# contoso 1.0.0

* Support for 100M row database now supported
* unit tests added

# contoso 0.1.0

* website Replace pkgdown with altdocs
* 100k+ contoso packages are attached from motherduck database
* contoso database sizes increased to 10M rows



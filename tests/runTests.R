
## SET UP ----

  # Install required packages
  ## Required because module is not an R package
  install.packages(
    c("testthat", "SpaDES.core", "SpaDES.project", "googledrive"),
    type = "binary",
    repos = unique(c("predictiveecology.r-universe.dev", getOption("repos"))))

  # Cache Google Drive authorization
  ## Set authorization email and cache location
  options(
    gargle_oauth_email = "", ## Set personal email
    gargle_oauth_cache = "~/googledrive_oauth_cache"
  )
  googledrive::drive_auth()

  # Set location of input data (optional)
  # options("reproducible.inputPaths" = "~/data")


## RUN ALL TESTS ----

  # Run all tests
  testthat::test_dir("tests/testthat")

  # Run all tests with different reporters
  testthat::test_dir("tests/testthat", reporter = testthat::LocationReporter)
  testthat::test_dir("tests/testthat", reporter = testthat::SummaryReporter)


## RUN INDIVIDUAL TESTS ----

  ## Run SK 1998-2000 with AOI
  testthat::test_file("tests/testthat/test-SK_1998-2000_withAOI.R")


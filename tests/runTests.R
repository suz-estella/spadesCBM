
## SET UP ----

  # Install required packages
  ## Required because module is not an R package
  install.packages(
    c("testthat", "SpaDES.core", "SpaDES.project", "googledrive"),
    type = "binary",
    repos = unique(c("predictiveecology.r-universe.dev", getOption("repos"))))

  # Authorize Google Drive
  googledrive::drive_auth()


## OPTIONAL: SET TEST OPTIONS ----

  # Set custom module locations
  options("spadesCBM.test.module.CBM_core"        = "PredictiveEcology/CBM_core@development")
  options("spadesCBM.test.module.CBM_defaults"    = "PredictiveEcology/CBM_defaults@development")
  options("spadesCBM.test.module.CBM_vol2biomass" = "PredictiveEcology/CBM_vol2biomass@development")
  options("spadesCBM.test.module.CBM_dataPrep_SK" = "PredictiveEcology/CBM_dataPrep_SK@development")

  # Skip recreating the Python virtual environment
  options("spadesCBM.test.virtualEnv" = FALSE)

  # Suppress warnings from calls to setupProject, simInit, and spades
  options("spadesCBM.test.suppressWarnings" = TRUE)

  # Set custom input data location
  options("reproducible.inputPaths" = NULL)


## RUN ALL TESTS ----

  # Run all tests
  testthat::test_dir("tests/testthat")

  # Run all tests with different reporters
  testthat::test_dir("tests/testthat", reporter = testthat::LocationReporter)
  testthat::test_dir("tests/testthat", reporter = testthat::SummaryReporter)


## RUN INDIVIDUAL TESTS ----

  ## Run SK 1998-2000 with AOI
  testthat::test_file("tests/testthat/test-SK_1998-2000_withAOI.R")


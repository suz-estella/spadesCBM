
## SET UP ----

  # Install required packages
  ## Required because module is not an R package
  install.packages(
    c("testthat", "SpaDES.core", "SpaDES.project"),
    repos = unique(c("predictiveecology.r-universe.dev", getOption("repos"))))


## OPTIONS ----

  # Test repo branches instead of local submodules
  options("spades.test.modules" = c(
    CBM_core        = "PredictiveEcology/CBM_core@development",
    CBM_defaults    = "PredictiveEcology/CBM_defaults@development",
    CBM_vol2biomass = "PredictiveEcology/CBM_vol2biomass@development",
    CBM_dataprep_SK = "PredictiveEcology/CBM_dataprep_SK@development"
  ))

  # Suppress warnings from calls to setupProject, simInit, and spades
  options("spades.test.suppressWarnings" = TRUE)

  # Set custom input data location
  options("reproducible.inputPaths" = NULL)

  # Test recreating the Python virtual environment
  options("spades.test.virtualEnv" = TRUE)


## RUN ALL TESTS ----

  # Run all tests
  testthat::test_dir("tests/testthat")

  # Run all tests with different reporters
  testthat::test_dir("tests/testthat", reporter = testthat::LocationReporter)
  testthat::test_dir("tests/testthat", reporter = testthat::SummaryReporter)


## RUN INDIVIDUAL TESTS ----

  ## Run SK-small 1998-2000
  testthat::test_file("tests/testthat/test-SK-small_t1-1998-2000.R")

  ## Run SK-small 1985-2011
  testthat::test_file("tests/testthat/test-SK-small_t2-1985-2011.R")

  ## Run SK 1998-2000
  testthat::test_file("tests/testthat/test-SK_t1-1998-2000.R")

  ## Run SK 1985-2011
  testthat::test_file("tests/testthat/test-SK_t2-1985-2011.R")



if (!testthat::is_testing()){
  library(testthat)
  testthat::source_test_helpers(env = globalenv())
}

# Source work in progress SpaDES module testing functions
tempScript <- tempfile(fileext = ".R")
download.file(
  "https://raw.githubusercontent.com/suz-estella/SpaDES.core/refs/heads/suz-testthat/R/testthat.R",
  tempScript, quiet = TRUE)
source(tempScript)

# Set up testing global options
SpaDEStestSetGlobalOptions()

# Set up testing directories
spadesTestPaths <- SpaDEStestSetUpDirectories(copyModule = FALSE)


# Authorize Google Drive
googledrive::drive_auth(path = if (Sys.getenv("GOOGLE_AUTH") != "") Sys.getenv("GOOGLE_AUTH"))

# Set module list
moduleList <- .moduleLocations()

# Set Python virtual environment location to be within temporary directory
if (getOption("spades.test.virtualEnv", default = TRUE)){
  dir.create(file.path(spadesTestPaths$temp$root, "virtualenvs"))
  withr::local_envvar(
    list(RETICULATE_VIRTUALENV_ROOT = file.path(spadesTestPaths$temp$root, "virtualenvs")),
    .local_envir = if (testthat::is_testing()) testthat::teardown_env() else parent.frame())
}


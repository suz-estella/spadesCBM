
## STUDY AREA : Saskatchewan
## TIME SPAN  : 1985 - 2011
projectName <- "SK_1985-2011"

## Set up session ----

  # Install SpaDES.project
  install.packages("SpaDES.project", repos = "predictiveecology.r-universe.dev")

  # Set paths
  spadesCBMpath <- "~/spadesCBM" # Parent directory for SpaDES CBM projects
  projectPaths <- list(
    projectPath = file.path(spadesCBMpath, "projects", projectName),
    modulePath  = file.path(spadesCBMpath, "modules"),
    inputPath   = file.path(spadesCBMpath, "inputs")
  )
  dir.create(dirname(projectPaths$projectPath), recursive = TRUE, showWarnings = FALSE)


## Run SpaDES simulation ----

  # Set simulation time span
  times <- list(start = 1985, end = 2011)

  # Set up simulation
  simSetup <- SpaDES.project::setupProject(

    paths   = projectPaths,
    times   = times,
    modules = c(
      CBM_defaults    = "PredictiveEcology/CBM_defaults@main",
      CBM_dataPrep_SK = "PredictiveEcology/CBM_dataPrep_SK@main",
      CBM_vol2biomass = "PredictiveEcology/CBM_vol2biomass@main",
      CBM_core        = "PredictiveEcology/CBM_core@main"
    ),

    # Set options
    Restart   = TRUE,
    overwrite = TRUE,
    options   = list(
      repos = unique(c("predictiveecology.r-universe.dev", getOption("repos"))),
      spades.moduleCodeChecks = FALSE
    ),

    # Set packages required for set up
    require = c("reticulate", "PredictiveEcology/libcbmr"),

    # Set up Python
    functions = "PredictiveEcology/CBM_core@main/R/ReticulateFindPython.R",
    ret = {
      reticulate::virtualenv_create(
        "r-spadesCBM",
        python = if (!reticulate::virtualenv_exists("r-spadesCBM")){
          ReticulateFindPython(
            version        = ">=3.9,<=3.12.7",
            versionInstall = "3.10:latest",
            pyenvRoot      = tools::R_user_dir("r-spadesCBM")
          )
        },
        packages = c(
          "numpy<2",
          "pandas>=1.1.5",
          "scipy",
          "numexpr>=2.8.7",
          "numba",
          "pyyaml",
          "mock",
          "openpyxl",
          "libcbm"
        )
      )
      reticulate::use_virtualenv("r-spadesCBM")
    },

    # Set input: Output table
    outputs = as.data.frame(expand.grid(
      objectName = c("cbmPools", "NPP"),
      saveTime = sort(c(times$start, times$start + c(1:(times$end - times$start))))
    ))
  )

  # Run simulation
  simCBM <- SpaDES.core::simInitAndSpades2(simSetup)


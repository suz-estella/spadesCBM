
## Run simulation ----

  ## STUDY AREA : Saskatchewan
  ## TIME SPAN  : 1985 - 2011
  projectName <- "SK_1985-2011"
  times       <- list(start = 1985, end = 2011)

  # Install SpaDES.project
  install.packages("SpaDES.project", repos = "predictiveecology.r-universe.dev")

  # Set up simulation
  simSetup <- SpaDES.project::setupProject(

    Restart = interactive(),

    paths   = list(
      projectPath = file.path("~/spadesCBM/examples", projectName),
      modulePath  = file.path("~/spadesCBM/examples", projectName, "modules"),
      outputPath  = file.path("~/spadesCBM/examples", projectName, "outputs"),
      inputPath   = "~/spadesCBM/inputs",
      packagePath = "~/spadesCBM/packages",
      cachePath   = "~/spadesCBM/cache"
    ),
    modules = c(
      CBM_defaults    = "PredictiveEcology/CBM_defaults@d4f1a20",
      CBM_dataPrep_SK = "PredictiveEcology/CBM_dataPrep_SK@2e688b5",
      CBM_vol2biomass = "PredictiveEcology/CBM_vol2biomass@314a819",
      CBM_core        = "PredictiveEcology/CBM_core@bda6b64"
    ),
    times   = times,

    # Set options
    options = list(
      spades.moduleCodeChecks = FALSE
    ),

    # Set packages required for set up
    require = c("reticulate"),

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

  ## TODO: REMOVE TEMPORARY FIX: create CBM_vol2biomass figures directory without user input.
  ## This has already been fixed in the development branch.
  if (!interactive()) dir.create(file.path("~/spadesCBM/examples", projectName, "modules", "CBM_vol2biomass", "figures"),
                                 recursive = TRUE, showWarnings = FALSE)

  # Run simulation
  simCBM <- SpaDES.core::simInitAndSpades2(simSetup)


## Review results ----

  # View completed events
  completed(simCBM)

  # View outputs
  outputs(simCBM)

  # View module diagram
  moduleDiagram(simCBM)

  # View object diagram
  objectDiagram(simCBM)

  # Plot yearly forest products and yearly emissions for the length of the simulation
  CBMutils::carbonOutPlot(
    emissionsProducts = simCBM$emissionsProducts
  )

  # Plot carbon proportions above and below ground each simulation year
  CBMutils::barPlot(
    cbmPools = simCBM$cbmPools
  )

  # Plots the per-pixel average net primary production
  CBMutils::NPPplot(
    masterRaster = simCBM$masterRaster,
    spatialDT    = simCBM$spatialDT,
    NPP          = simCBM$NPP
  )

  # Plot the Total Carbon per pixel for the final simulation year
  CBMutils::spatialPlot(
    masterRaster = simCBM$masterRaster,
    spatialDT    = simCBM$spatialDT,
    cbmPools     = simCBM$cbmPools,
    years        = end(simCBM)
  )



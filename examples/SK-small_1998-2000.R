
## Run simulation ----

  ## STUDY AREA : Saskatchewan - Small AOI
  ## TIME SPAN  : 1998 - 2000
  projectName <- "SK-small_1998-2000"
  times       <- list(start = 1998, end = 2000)

  # Install SpaDES.project
  install.packages("SpaDES.project", repos = "predictiveecology.r-universe.dev")

  # Set up simulation
  simSetup <- SpaDES.project::setupProject(

    Restart = interactive(),

    paths   = list(projectPath = file.path("~/spadesCBM/examples", projectName),
                   inputPath   = "~/spadesCBM/inputs"),
    times   = times,
    modules = c(
      CBM_defaults    = "PredictiveEcology/CBM_defaults@main",
      CBM_dataPrep_SK = "PredictiveEcology/CBM_dataPrep_SK@main",
      CBM_vol2biomass = "PredictiveEcology/CBM_vol2biomass@main",
      CBM_core        = "PredictiveEcology/CBM_core@main"
    ),
    options   = list(
      repos = unique(c("predictiveecology.r-universe.dev", getOption("repos"))),
      spades.moduleCodeChecks = FALSE
    ),

    # Set packages required for set up
    require = c("reticulate", "terra"),

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

    # Set input: Study area
    masterRaster = {
      extent = terra::ext(c(xmin = -687696, xmax = -681036, ymin = 711955, ymax = 716183))
      masterRaster <- terra::rast(extent, res = 30)
      terra::crs(masterRaster) <- "PROJCRS[\"Lambert_Conformal_Conic_2SP\",\n    BASEGEOGCRS[\"GCS_GRS_1980_IUGG_1980\",\n        DATUM[\"D_unknown\",\n            ELLIPSOID[\"GRS80\",6378137,298.257222101,\n                LENGTHUNIT[\"metre\",1,\n                    ID[\"EPSG\",9001]]]],\n        PRIMEM[\"Greenwich\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]]],\n    CONVERSION[\"Lambert Conic Conformal (2SP)\",\n        METHOD[\"Lambert Conic Conformal (2SP)\",\n            ID[\"EPSG\",9802]],\n        PARAMETER[\"Latitude of false origin\",49,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8821]],\n        PARAMETER[\"Longitude of false origin\",-95,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8822]],\n        PARAMETER[\"Latitude of 1st standard parallel\",49,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8823]],\n        PARAMETER[\"Latitude of 2nd standard parallel\",77,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8824]],\n        PARAMETER[\"Easting at false origin\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8826]],\n        PARAMETER[\"Northing at false origin\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8827]]],\n    CS[Cartesian,2],\n        AXIS[\"easting\",east,\n            ORDER[1],\n            LENGTHUNIT[\"metre\",1,\n                ID[\"EPSG\",9001]]],\n        AXIS[\"northing\",north,\n            ORDER[2],\n            LENGTHUNIT[\"metre\",1,\n                ID[\"EPSG\",9001]]]]"
      masterRaster[] <- rep(1, terra::ncell(masterRaster))
      mr <- reproducible::prepInputs(
        destinationPath = projectPaths$inputPath,
        url        = "https://drive.google.com/file/d/1zUyFH8k6Ef4c_GiWMInKbwAl6m6gvLJW",
        targetFile = "ldSp_TestArea.tif",
        to         = masterRaster,
        method     = "near"
      )
      mr[mr[] == 0] <- NA
      mr
    },

    # Set input: Output table
    outputs = as.data.frame(expand.grid(
      objectName = c("cbmPools", "NPP"),
      saveTime = sort(c(times$start, times$start + c(1:(times$end - times$start))))
    ))
  )

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



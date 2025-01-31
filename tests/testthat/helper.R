
# Helper function: get or set default module locations
.moduleLocations <- function(moduleNames = c("CBM_core", "CBM_defaults", "CBM_vol2biomass", "CBM_dataPrep_SK")){
  sapply(setNames(moduleNames, moduleNames), function(moduleName){
    ifelse(
      is.null(getOption("spadesCBM.test.modulePath")),
      getOption(paste0("spadesCBM.test.module.", moduleName),
                default = paste0("PredictiveEcology/", moduleName, "@main")),
      moduleName
    )
  })
}


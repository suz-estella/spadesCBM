# SpaDES CBM

This repository contains resources for running [SpaDES](https://predictiveecology.org/SpaDES.html) simulations for modelling forest carbon balances with [Canada's Carbon Budget Model of the Canadian Forest Sector (CBM-CFS3)](https://natural-resources.canada.ca/climate-change/climate-change-impacts-forests/carbon-accounting/carbon-budget-model/13107).

## SpaDES Modules

### Key modules

-   [CBM_core](https://github.com/PredictiveEcology/spadesCBM)
-   [CBM_defaults](https://github.com/PredictiveEcology/spadesCBM)
-   [CBM_vol2biomass](https://github.com/PredictiveEcology/CBM_vol2biomass)

### Study area data preparation modules

-   [CBM_dataPrep_SK](https://github.com/PredictiveEcology/CBM_dataPrep_SK)
-   [CBM_dataPrep_RIA](https://github.com/PredictiveEcology/CBM_dataPrep_RIA)

## How to use

### Running simulations

The `projects` directory contains sub-directories initialized as SpaDES projects. Each contains an R script that can be used to run a SpaDES simulation. Each project has a set study area, time span, and sometimes other custom inputs or parameters.

Simulation R scripts can be run as standalone scripts or within a locally cloned version of this repository.

### Reviewing simulation results

See the [`CBM_core` module](https://github.com/PredictiveEcology/spadesCBM) for more information about the simulation outputs.

```         
# View completed events
completed(simCBM)

# View outputs
outputs(simCBM)

# View module diagram
moduleDiagram(simCBM)

# View object diagram
objectDiagram(simCBM)
```

##### Plotting results

```  
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
```

# dhscmort: DHS childhood mortality indicators, tables, and graphical visualisations

`dhscmort` is a Stata command for synthetic cohort estimation of neonatal, infant, child, and under-five mortality rates using Demographic and Health Surveys (DHS) Birth Recode (`BR`) datasets. 

It provides automated weighted mortality estimation, generates individual-level binary mortality indicators for secondary modeling, and produces publication-ready data visualisations.

---

## Features

- **Synthetic Cohort Life Tables**: Implements standard DHS synthetic cohort methodologies across discrete age intervals.
- **Multiple indicators**: Simultaneously calculates or isolates:
  - **NNMR**: Neonatal Mortality Rate (0 months)
  - **PNNMR**: Post-Neonatal Mortality Rate (1-11 months)
  - **IMR**: Infant Mortality Rate (0-11 months)
  - **CMR**: Child Mortality Rate (12-59 months)
  - **U5MR**: Under-Five Mortality Rate (0-59 months)
- **Flexible reference periods**: Supports 5-, 10-, or 15-year historical recall periods (`period()`).
- **Disaggregation**: Stratifies estimates by categorical or numeric background variables (`by()`).
- **Automated visualisation**: Generates custom vertical (`bar`) and horizontal (`hbar`) bar charts with dynamic y-axis scaling and export options.
- **Data generation**: Automatically saves binary mortality indicator variables (`mrt_*`) directly into the active dataset for subsequent survey-weighted regression modeling.

---

## Cite this repository

Tsawe, M. (2026). dhscmort: A Stata command for DHS childhood mortality estimation and visualisation (Version 0.0.5).

[Download citation 💾](https://github.com/MlulekiT/dhscmort/releases/download/v0.0.5/dhscmort.ris)

---

## Author
**Mluleki Tsawe**  
Population Dynamics Sub-programme  
Population and Health Research Entity  
North-West University, Mahikeng Campus  
South Africa  

---

## Installation

You can install `dhscmort` directly in Stata using the following command (_copy it to your Stata command line_):

```stata
net install dhscmort, from("https://raw.githubusercontent.com/MlulekiT/dhscmort/main") replace


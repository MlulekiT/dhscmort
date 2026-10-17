# dhscmort: DHS childhood mortality indicators, tables, and graphs in Stata

[![Stata](https://img.shields.io/badge/Stata-14%2C16%2C17-blue)](https://www.stata.com/)
[![Version](https://img.shields.io/github/v/release/MlulekiT/dhscmort)](https://github.com/MlulekiT/dhscmort/releases)
[![Issues](https://img.shields.io/github/issues/MlulekiT/dhscmort)](https://github.com/MlulekiT/dhscmort/issues)
[![Licence](https://img.shields.io/badge/Licence-MIT-yellow.svg)](LICENSE)

`dhscmort` estimates neonatal, post-neonatal, infant, child, and under-five mortality rates from Demographic and Health Surveys (DHS) **Birth Recode (`BR`) datasets** using the standard DHS synthetic cohort approach. It produces weighted mortality estimates, supports disaggregation by background characteristics, generates publication-ready bar charts, and creates binary mortality variables (`mrt_*`) in the active dataset for further statistical analysis.

**Status:** Early release (v0.0.5). The command has been successfully tested on Stata 14, 16, and 17.

---

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Indicators](#indicators)
- [Data requirements](#data-requirements)
- [Usage examples](#usage-examples)
- [Options](#options)
- [Methodology](#methodology)
- [Validation](#validation)
- [Limitations](#limitations)
- [Citation](#citation)
- [Changelog](#changelog)
- [Issues and contributions](#issues-and-contributions)
- [Licence](#licence)
- [Author and contact](#author-and-contact)

---

## Features

- **Synthetic Cohort Life Tables**: Implements standard DHS synthetic cohort methodologies across discrete age intervals.
- **Multiple indicators**: Calculates all five indicators together (NNMR, PNNMR, IMR, CMR, and U5MR) or any one on its own.
- **Flexible reference periods**: Estimates three non-overlapping five-year windows before the survey (0-4, 5-9 and 10-14 years) through the `period()` option.
- **Subgroup disaggregation**: Produces estimates by categorical or numeric background characteristics using the `by()` option.
- **Automated visualisation**: Generates publication-ready vertical (`bar`) and horizontal (`hbar`) charts.
- **Graph export**: Exports graphs to file, for example PNG, PDF, SVG, and JPG, using the `export()` option.
- **Data generation**: Automatically creates binary mortality variables (`mrt_*`) in the active dataset for further survey-weighted analysis.
- **DHS-oriented workflow**: Designed specifically for DHS Birth Recode (`BR`) datasets.

---

## Installation

Install `dhscmort` directly from GitHub:

```stata
net install dhscmort, from("https://raw.githubusercontent.com/MlulekiT/dhscmort/main") replace
```

Open the help file after installation:

```stata
help dhscmort
```

### Requirements

| Requirement | Description |
|-------------|-------------|
| Stata Version | Tested on Stata 14, 16, and 17 |
| Data | DHS Birth Recode (`BR`) dataset |
| Dependencies | No additional user-written packages required |

> **Note:** DHS microdata are not distributed with this repository and remain subject to The DHS Program's terms of use.

---

## Quick start

The following example uses the official DHS model dataset `ZZBR62FL`, available from the [DHS Program Model Datasets](https://dhsprogram.com/data/Download-Model-Datasets.cfm) page (and will work with any DHS BR file).

```stata
use "ZZBR62FL", clear

dhscmort indicators
```

### Example output

```text
dhscmort INDICATORS (Years: 0-4)

+------------------------------------------------------------------+
| Category |     NNMR |    PNNMR |      IMR |      CMR |      U5MR |
|----------+----------+----------+----------+----------+-----------|
|    Total | 37.89216 | 50.64660 | 88.53876 | 67.53707 | 150.09612 |
+------------------------------------------------------------------+
```

### Disaggregate estimates

Estimate mortality indicators by place of residence:

```stata
dhscmort indicators, by(v025)
```

### Example output

```text
dhscmort INDICATORS (Years: 0-4)

+-------------------------------------------------------------------+
| Category |     NNMR |    PNNMR |       IMR |      CMR |      U5MR |
|----------+----------+----------+-----------+----------+-----------|
|    urban | 45.88801 | 54.91006 | 100.79807 | 67.13706 | 161.16786 |
|    rural | 33.84292 | 48.39629 |  82.23921 | 67.75731 | 144.42426 |
|    Total | 37.89216 | 50.64660 |  88.53876 | 67.53707 | 150.09612 |
+-------------------------------------------------------------------+
```

*NNMR, PNNMR, IMR, CMR, and U5MR are conventionally reported per 1 000 live births. The child mortality rate (CMR) represents the probability of dying between ages 1 and 5 years among children who survive to age 12 months.*

### Produce and export a graph

```stata
dhscmort indicators, by(v024) graph(hbar) title("Childhood mortality by region") name(gr1) export("mortality_region.png")
```

---

## Indicators

`dhscmort` estimates five standard childhood mortality indicators.

| Indicator | Name | Definition |
|-----------|------|------------|
| **NNMR** | Neonatal Mortality Rate | Probability of dying during the first month of life |
| **PNNMR** | Post-Neonatal Mortality Rate | Infant mortality minus neonatal mortality: deaths after the neonatal period but before age one |
| **IMR** | Infant Mortality Rate | Probability of dying before the first birthday |
| **CMR** | Child Mortality Rate | Probability of dying between ages one and five, conditional on surviving to age one |
| **U5MR** | Under-Five Mortality Rate | Probability of dying before the fifth birthday |

### Mathematical relationships

The indicators are mathematically linked:

- **IMR = NNMR + PNNMR** (equivalently, PNNMR = IMR − NNMR)  
  Example: `37.89 + 50.65 = 88.54`

- Under-five mortality combines infant mortality and conditional child mortality:

```text
U5MR = 1000 × [1 − (1 − IMR/1000) × (1 − CMR/1000)]
```

This relationship ensures that under-five mortality reflects the cumulative probability of death before age five. In the example output it gives approximately 150.10 per 1 000.

### Reference periods

| Option | Reference window | Output label |
|----------|----------------|--------------|
| `period(5)` *(default)* | 0-4 years before survey | `Years: 0-4` |
| `period(10)` | 5-9 years before survey | `Years: 5-9` |
| `period(15)` | 10-14 years before survey | `Years: 10-14` |

---

## Data requirements

`dhscmort` is designed for DHS Birth Recode (`BR`) datasets.

| Variable | Description |
|-----------|-------------|
| `v005` | Woman's sample weight |
| `v008` | Date of interview (CMC) |
| `b3` | Child's date of birth (CMC) |
| `b5` | Child's survival status |
| `b7` | Age at death in months |

Common subgroup covariates include:

- `v025` - Place of residence
- `v024` - Region
- `v106` - Educational attainment
- `v190` - Household wealth quintile

---

## Usage examples

### Estimate all indicators

```stata
dhscmort indicators
```

### Estimate individual indicators

```stata
dhscmort NNMR
dhscmort PNNMR
dhscmort IMR
dhscmort CMR
dhscmort U5MR
```

### Disaggregate by background characteristics

```stata
dhscmort indicators, by(v024)                // region
dhscmort indicators, by(v106)                // educational attainment
dhscmort indicators, by(v190) period(10)     // wealth quintile, years 5-9
dhscmort indicators, by(v025)                // place of residence
```

### Graphs and visualisations

```stata
dhscmort indicators, by(v024) graph(bar) angle(45) title("Childhood mortality by region") name(gr001) ///
export("indicators_region_bar.png")
```

```stata
dhscmort indicators, by(v024) graph(hbar) title("Childhood mortality by region") name(gr002) ///
export("indicators_region_hbar.png")
```

```stata
dhscmort U5MR, by(v106) graph(bar) scheme(s2color) title("Under-five mortality by maternal education") ///
name(gr003) export("U5MR_maternal_education.png")
```

---

## Options

| Option | Purpose |
|----------|---------|
| `by(varname)` | Disaggregate estimates by a background variable |
| `period(#)` | Select the reference window: `5` (0-4 years before survey), `10` (5-9) or `15` (10-14) |
| `graph(bar)` | Produce a vertical bar chart |
| `graph(hbar)` | Produce a horizontal bar chart |
| `angle(#)` | Rotate category labels |
| `legplace(string)` | Set legend position |
| `title(string)` | Specify a custom graph title |
| `name(string)` | Name graph in Stata memory |
| `export(filename)` | Export graph to file |
| `scheme(string)` | Apply a Stata graph scheme |

---

## Methodology

`dhscmort` follows the standard DHS synthetic cohort life-table approach across the following age segments:

- 0 months
- 1-2 months
- 3-5 months
- 6-11 months
- 12-23 months
- 24-35 months
- 36-47 months
- 48-59 months

### References

1. Croft, T. N., Allen, C. K., Zachary, B. W., et al. (2023). [*Guide to DHS Statistics (DHS-8)*](https://www.dhsprogram.com/pubs/pdf/DHSG1/Guide_to_DHS_Statistics_DHS-8.pdf). ICF.
2. Croft, T. N., Marshall, A. M. J., Allen, C. K., et al. (2018). [*Guide to DHS Statistics (DHS-7)*](https://www.dhsprogram.com/pubs/pdf/DHSG1/Guide_to_DHS_Statistics_DHS-7_v2.pdf). ICF.
3. The DHS Program. [*DHS Indicators Stata Code: Chapter 08 - Childhood Mortality*](https://github.com/DHSProgram/DHS-Indicators-Stata/tree/master/Chap08_CM).

---

## Validation

The command has been tested on multiple DHS Birth Recode datasets from different countries and produces estimates consistent with expected DHS childhood mortality patterns.

For additional verification, users are encouraged to compare estimates against official DHS reports and DHS STATcompiler:

https://www.statcompiler.com/en/

Any substantial discrepancies should be investigated in relation to survey-specific characteristics, data quality, dataset versions, weighting procedures, and reference period definitions.

For methodological details, see the
[DHS Guide to Statistics (DHS-8): Early Childhood Mortality](https://dhsprogram.com/data/Guide-to-DHS-Statistics/Early_Childhood_Mortality.htm).

---

## Limitations

- Does not replace knowledge of DHS sampling design, weighting, or data quality.
- Estimates depend on the completeness and quality of retrospective birth histories.

---

## Citation

If you use `dhscmort` in research, please cite the version used:

```text
Tsawe, M. (2026). dhscmort: A Stata command for DHS childhood mortality estimation and visualisation (Version 0.0.5) [Computer software]. GitHub. https://github.com/MlulekiT/dhscmort
```

[Download Citation (.RIS) 💾](https://github.com/MlulekiT/dhscmort/releases/download/v0.0.5/dhscmort.ris)

---

## Changelog

| Version | Notes |
|----------|--------|
| **v0.0.5** | Initial public release featuring childhood mortality estimation, mortality tables, subgroup disaggregation, graphing functionality, graph export, and binary mortality indicator generation. |

---

## Issues and contributions

Bug reports, feature requests, and suggestions are welcome through [GitHub Issues](https://github.com/MlulekiT/dhscmort/issues).

When reporting an issue, please include:

- Stata version
- DHS survey and survey year
- Relevant command and options used
- Observed output
- Expected output
- Reproducible example (where possible)

Please do **not** upload restricted DHS microdata to public repositories or issue trackers.

---

## Licence

Copyright © 2026 Mluleki Tsawe.

This project is licensed under the [MIT Licence](LICENSE), a permissive open-source licence that allows use, modification, distribution, and commercial use of the software.

For the full licence text, see the [LICENSE](LICENSE) file.

---

## Author and contact

**Dr Mluleki Tsawe**

Senior Lecturer in Population Studies and Demography

Population Dynamics Sub-programme  
Population and Health Research Entity (PHRE)

North-West University, Mahikeng Campus, South Africa

- 🌐 [Personal Website](https://mlulekit.github.io)
- 💻 [GitHub Profile](https://github.com/MlulekiT)
- 🆔 [ORCID: 0000-0002-0580-5508](https://orcid.org/0000-0002-0580-5508)

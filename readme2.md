# dhscmort

**DHS childhood mortality indicators, tables, and graphical visualisations in Stata**

`dhscmort` is a Stata command for synthetic cohort estimation of neonatal, post-neonatal, infant, child, and under-five mortality using Demographic and Health Surveys (DHS) Birth Recode (`BR`) datasets.

The package implements the DHS synthetic cohort life-table approach, produces weighted mortality estimates, supports subgroup analysis by background characteristics, generates mortality indicator variables for further modelling, and creates publication-ready graphical outputs.

> **Status:** Early Release (v0.0.5)  
> Estimates are currently being validated against official DHS results.

---

## Features

### Childhood Mortality Indicators

`dhscmort` estimates five standard DHS childhood mortality indicators:

| Indicator | Description |
|------------|------------|
| **NNMR** | Neonatal Mortality Rate (0 months) |
| **PNNMR** | Post-Neonatal Mortality Rate (1–11 months) |
| **IMR** | Infant Mortality Rate (0–11 months) |
| **CMR** | Child Mortality Rate (12–59 months) |
| **U5MR** | Under-Five Mortality Rate (0–59 months) |

### Additional Functionality

- **Synthetic cohort life tables** using DHS methodology.
- **Weighted mortality estimation** using DHS sample weights.
- **Flexible reference periods**: 5-, 10-, and 15-year windows.
- **Disaggregation** by any categorical background characteristic.
- **Publication-ready graphs** using bar and horizontal bar charts.
- **Automated export** of graphical output.
- **Binary mortality indicator generation** (`mrt_*`) for secondary analysis and regression modelling.

---

## Installation

Install directly from GitHub within Stata:

```stata
net install dhscmort, ///
    from("https://raw.githubusercontent.com/MlulekiT/dhscmort/main") replace
```

Open the help file:

```stata
help dhscmort
```

---

## Data Requirements

`dhscmort` is designed for DHS Birth Recode (`BR`) datasets.

Commonly used variables include:

| Variable | Description |
|-----------|-------------|
| `v005` | Sample weight |
| `v008` | Date of interview (CMC) |
| `b3` | Child date of birth (CMC) |
| `b5` | Survival status |
| `b7` | Age at death in months |

DHS datasets are not distributed with this package. Researchers must obtain access through the DHS Program.

---

## Quick Start

The example below uses the DHS model dataset `ZZBR62FL`.

```stata
use ZZBR62FL, clear

dhscmort indicators
```

Example output:

```text
dhscmort INDICATORS (Years: 0-4)

+-------------------------------------------------------------+
| Category | NNMR | PNNMR | IMR | CMR | U5MR |
|----------+-------+--------+--------+--------+---------|
| Total    | 37.89 | 50.65 | 88.54 | 67.54 | 150.10 |
+-------------------------------------------------------------+
```

---

## Disaggregated Estimates

Estimate indicators by place of residence:

```stata
dhscmort indicators, by(v025)
```

Example output:

```text
dhscmort INDICATORS (Years: 0-4)

+-------------------------------------------------------------+
| Category | NNMR | PNNMR | IMR | CMR | U5MR |
|----------+-------+--------+--------+--------+---------|
| Urban    | 45.89 | 54.91 | 100.80 | 67.14 | 161.17 |
| Rural    | 33.84 | 48.40 | 82.24 | 67.76 | 144.42 |
| Total    | 37.89 | 50.65 | 88.54 | 67.54 | 150.10 |
+-------------------------------------------------------------+
```

---

## Graphical Outputs

### Horizontal Bar Chart

```stata
dhscmort indicators, by(v024) graph(hbar) ///
    title("Childhood mortality by region") ///
    name(gr1) ///
    export("mortality_region.png")
```

### Vertical Bar Chart

```stata
dhscmort indicators, by(v024) graph(bar) angle(45) ///
    title("Childhood mortality by region") ///
    name(gr2) ///
    export("mortality_region.png")
```

### Under-Five Mortality by Maternal Education

```stata
dhscmort U5MR, by(v106) graph(bar) ///
    title("Under-five mortality by maternal education") ///
    export("u5mr_education.png")
```

---

## Reference Periods

The `period()` option selects the retrospective reference window.

| Option | Reference Window |
|----------|------------------|
| `period(5)` | 0–4 years before survey |
| `period(10)` | 5–9 years before survey |
| `period(15)` | 10–14 years before survey |

Example:

```stata
dhscmort indicators, period(10)
```

---

## Usage Examples

### Estimate All Indicators

```stata
dhscmort indicators
```

### Estimate Individual Indicators

```stata
dhscmort NNMR
dhscmort PNNMR
dhscmort IMR
dhscmort CMR
dhscmort U5MR
```

### Stratify by Region

```stata
dhscmort indicators, by(v024)
```

### Stratify by Education

```stata
dhscmort indicators, by(v106)
```

### Stratify by Wealth Quintile

```stata
dhscmort indicators, by(v190)
```

### Stratify by Residence

```stata
dhscmort indicators, by(v025)
```

---

## Main Options

| Option | Purpose |
|----------|---------|
| `by(varname)` | Stratify estimates |
| `period(#)` | Specify reference period |
| `graph(bar)` | Vertical bar chart |
| `graph(hbar)` | Horizontal bar chart |
| `angle(#)` | Rotate labels |
| `title()` | Graph title |
| `name()` | Graph name |
| `export()` | Export graph |
| `scheme()` | Stata graph scheme |

For full syntax:

```stata
help dhscmort
```

---

## Methodological Approach

`dhscmort` follows the standard DHS synthetic cohort life-table method for estimating childhood mortality.

The method uses complete birth histories to estimate mortality probabilities within the following age segments:

- 0 months
- 1–2 months
- 3–5 months
- 6–11 months
- 12–23 months
- 24–35 months
- 36–47 months
- 48–59 months

These probabilities are combined to derive standard DHS childhood mortality indicators.

---

## Validation

Validation is ongoing.

Current validation strategy includes comparison against:

- DHS Chapter 08 Childhood Mortality code.
- DHS model datasets.
- Published DHS Final Reports.
- Official DHS mortality estimates.

Users are encouraged to compare results against DHS publications before use in official reporting.

---

## Limitations

- Estimates depend on the completeness of birth histories.
- Small population subgroups may produce unstable estimates.
- Results should not be interpreted as causal.
- DHS methodology assumptions remain applicable.
- Users should document survey, period and software version used.

---

## Citation

If you use `dhscmort` in research, please cite:

> Tsawe, M. (2026). *dhscmort: A Stata command for DHS childhood mortality estimation and visualisation* (Version 0.0.5) [Computer software]. GitHub.  
> https://github.com/MlulekiT/dhscmort

---

## Changelog

### Version 0.0.5

- Initial public release.
- Childhood mortality estimation using synthetic cohort life tables.
- Graphical output and export functionality.
- Mortality indicator generation for secondary analyses.

---

## Reporting Issues

Bug reports and feature requests are welcome.

When reporting an issue, please include:

- Stata version
- DHS survey name and year
- Command used
- Output obtained
- Expected output
- Reproducible example where possible

Please do **not** upload restricted DHS datasets to public GitHub issues.

---

## Author

**Dr Mluleki Tsawe**  
Senior Lecturer in Population Studies and Demography  
Population Dynamics Sub-programme  
Population and Health Research Entity (PHRE)  
North-West University, Mahikeng Campus, South Africa

- Website: https://mlulekit.github.io
- GitHub: https://github.com/MlulekiT
- ORCID: https://orcid.org/0000-0002-3403-7708

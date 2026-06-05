# Bayesian Workplace Stress Analysis

![R](https://img.shields.io/badge/R-4.3%2B-blue?logo=r)
![Quarto](https://img.shields.io/badge/Quarto-1.4%2B-blueviolet?logo=quarto)
![Bayesian](https://img.shields.io/badge/Bayesian%20Modeling-brms%20%7C%20rstanarm-orange)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)

## Project Goal

This project develops a Bayesian hierarchical analysis of workplace stress and well-being among early childhood educators. The focus is behavioral data science applied to occupational psychology: how stress, job demands, work resources, and repeated measurement structure can be modeled with uncertainty.

## Data Source

Data comes from the open project **Early Childhood Educators' Work and Stress Study** hosted on LDbase.

Expected raw files:

```text
data/raw/
|-- TP1_FINAL_public_V5.csv
|-- TP2_FINAL_public_V3.csv
|-- TP3_FINAL_public.csv
|-- TP4_FINAL_public_V3.csv
|-- haircortisoltp1and2.csv
|-- Master Codebook Teacher Job and Stress Study for sharing 2025.06.12_0_0.pdf
`-- Master Codebook Teacher Job and Stress Study for sharing 2025.06.12_noendnote_1.docx
```

Raw data is not tracked in Git. Download it from LDbase and place it in `data/raw/`.

## Planned Analysis

1. Audit raw files, IDs, time points, missingness, and candidate psychological constructs.
2. Build a longitudinal analysis table across time points.
3. Identify stress, job demand, job resource, and well-being measures using the codebook.
4. Fit Bayesian models in stages:
   - simple Bayesian regression;
   - hierarchical model with repeated measures;
   - longitudinal model with educator-level partial pooling;
   - optional center-level or classroom-level partial pooling if identifiers support it.
5. Interpret posterior uncertainty, practical effect sizes, and model diagnostics.
6. Publish a Quarto report through GitHub Pages.

## Project Structure

```text
bayesian-workplace-stress-analysis/
|-- README.md
|-- .gitignore
|
|-- analysis/
|   `-- bayesian_workplace_stress.qmd
|
|-- R/
|   |-- data_dictionary.R
|   |-- prepare_data.R
|   `-- model_functions.R
|
|-- scripts/
|   |-- check_environment.ps1
|   `-- render_report.ps1
|
|-- reports/
|   `-- figures/
|
|-- docs/
|
`-- data/
    |-- raw/
    `-- processed/
```

## Setup

Validate the local R and Quarto environment:

```powershell
.\scripts\check_environment.ps1
```

Render the report:

```powershell
.\scripts\render_report.ps1
```

## Author

Washington Casamen Nolasco  
Psychologist | Behavioral Data Scientist  
Focus: Bayesian modeling, psychometrics, people analytics, behavioral data science

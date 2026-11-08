# Agricultural Data Analysis

## Kenya maize-yield analysis using a reproducible R workflow

This project is an end-to-end agricultural data-analysis workflow using a public Kenya maize-yield time series. It covers data acquisition, validation, cleaning, exploratory analysis, visualization, regression modelling, robust inference, and reporting.

### Research question

> How has maize yield in Kenya changed over time, and what does the historical trend show about agricultural productivity?

This is a descriptive time-series analysis. It does not estimate causal effects.

### Dataset

Annual Kenya maize yield observations for **1960–2010**, measured in kg/ha. The reproducible CSV snapshot is `data/kenya_maize_yield.csv`. The public source identifies the FAOSTAT item **“Maize (corn)”**.

### Workflow

```text
01_load_real_data.R → 02_clean_data.R → 03_explore_data.R → 04_model.R → 05_export_results.R
```

The workflow also exports a histogram of the yield distribution and a separate annual line graph from the same 51 observations.\n\nRun the complete workflow with:

```r
source("projects/agricultural-data-analysis/R/00_run_analysis.R")
```

### Descriptive results

| Statistic | Value |
|---|---:|
| Observations | 51 |
| Period | 1960–2010 |
| Mean yield | 1,528.7 kg/ha |
| Median yield | 1,512.6 kg/ha |
| Minimum | 1,071.3 kg/ha |
| Maximum | 2,071.2 kg/ha |
| Standard deviation | 266.1 kg/ha |

The highest decade average in the series occurs in the 1980s at approximately **1,775 kg/ha**.

### Regression analysis

The project estimates:

`maize_yield_kg_ha = β0 + β1(year − 1960) + ε`

The estimated historical trend is **10.26 kg/ha per year**, equivalent to about **102.6 kg/ha per decade**. The heteroskedasticity-robust p-value is approximately **1.63 × 10⁻⁸** and R² is **0.328**.

The estimate describes a historical association with time. It should not be interpreted as evidence that time itself caused higher yields; weather, varieties, inputs, markets, institutions and policy also changed during the period.

### Outputs

- `outputs/tables/summary_statistics.csv`
- `outputs/tables/decade_summary.csv`
- `outputs/tables/trend_model.csv`
- `outputs/tables/model_fit.csv`
- `outputs/results.md`
- `outputs/figures/maize_yield_trend.svg`
- `outputs/figures/maize_yield_histogram.svg`
- `outputs/figures/maize_yield_annual_line.svg`

### R skills demonstrated

`readr`, `dplyr`, `ggplot2`, `lm()`, `sandwich`, robust inference, modular scripts, reproducible outputs, and distinction between association and causal inference.

### Data provenance

The project stores an analysis-ready snapshot of a public FAOSTAT-derived Kenya crop-yield series so that the analysis can be reproduced without requiring an API connection at run time.

### Limitations

The analysis is national-level and annual, the simple trend model does not identify mechanisms, and the current snapshot ends in 2010. A future iteration can extend the series and add documented covariates such as rainfall, fertilizer use, prices, and policy periods.

### Project status

**Real-data analytical project completed.**

# Agricultural Data Analysis

## Kenya maize-yield trend analysis using a reproducible R workflow

This project analyses Kenya's national maize yield from **1961 to 2024**, extending the earlier 51-observation series to the latest year currently covered by FAOSTAT's annual crop-production dataset. The workflow covers data sourcing, validation, descriptive analysis, log-linear regression, robust inference, exploratory structural-break screening and visual reporting.

### Research question

> How has maize yield in Kenya changed over time, and what do the long-run trend, structural changes and drought-period fluctuations reveal about historical agricultural productivity?

This is a descriptive national time-series analysis. It does not estimate causal effects of drought, agricultural policies, input use or technology.

### Dataset and coverage

The analysis uses **64 annual observations** for Kenya, item *Maize (corn)*, element *Yield*, from FAOSTAT's Crops and livestock products (QCL) domain. The source reports yield in hg/ha; the project stores kg/ha after dividing by ten.

| Feature | Value |
|---|---:|
| Observations | 64 |
| Period | 1961–2024 |
| Mean yield | 1,552.3 kg/ha |
| Median yield | 1,569.3 kg/ha |
| Minimum | 1,071.3 kg/ha (1965) |
| Maximum | 2,071.2 kg/ha (1982) |
| Yield in 2024 | 1,666.2 kg/ha |

**Data correction:** the former 51-observation extract was labelled 1960–2010, although the values match FAOSTAT reference years 1961–2011. This update corrects the calendar labels and extends the series through 2024. See [data provenance and refresh instructions](data/README.md).

### Main analytical results

**1. Log-linear trend**

The main model is:

`log(yield) = alpha + beta × (year − 1961) + error`

The estimated annual growth rate is **0.488% (approximately 0.49%)**. Its 95% Newey–West HAC confidence interval is **0.234% to 0.743%** (p ≈ 0.00029). The model R-squared is 0.307. HAC standard errors use three annual lags to make inference more robust to heteroskedasticity and short-run serial correlation.

The estimate is an average multiplicative trend. It should not be interpreted as a constant annual increase in kg/ha or as evidence that calendar time itself caused yields to rise.

**2. Structural-change screen**

A one-break segmented trend search selects **1982** as the first year of the second segment. The one-break model has BIC −276.55 compared with −247.87 for the no-break trend. The segmented estimates imply annual growth of **+1.238% before 1982** and **−0.267% from 1982 onwards**.

The breakpoint is selected from the yield data and coincides with the series maximum in 1982. It is a provisional statistical indication of a change in trajectory, not proof of a specific drought, policy or technology event. Breakpoint-selection uncertainty is not reflected in the ordinary HAC confidence intervals.

**3. Drought-period context**

The visualisations mark documented drought episodes including 1983–84, 1991–93, 1999–2000, 2007–09, 2016–17 and 2020–23. Pronounced national yield declines occur in some associated years, including 1984 (−18.4%), 2008 (−23.2%), 2009 (−7.1%) and 2016 (−21.6%).

These overlays are descriptive context, not causal attribution. National annual yield aggregates regions with different rainfall patterns, crop calendars and exposure. Identifying drought effects would require rainfall anomalies or drought indices matched to the relevant production areas and seasons.

### Visual outputs

The three portfolio charts use a consistent amber, teal, soft-blue and rust palette:

- `outputs/figures/maize_yield_trend.svg` — observed yield, fitted log-linear trend and the BIC-selected break marker.
- `outputs/figures/maize_yield_annual_column.svg` — annual yield columns, with drought-context years highlighted.
- `outputs/figures/maize_yield_annual_line.svg` — annual fluctuations and shaded drought-period context.

### Workflow

```text
00_run_analysis.R
  ├─ 01_load_real_data.R
  ├─ 02_clean_data.R
  ├─ 03_explore_data.R
  ├─ 04_model.R
  ├─ 05_export_results.R
  └─ 06_visualize_distribution_and_trend.R
```

Run the workflow from the repository root:

```r
source("projects/agricultural-data-analysis/R/00_run_analysis.R")
```

The loader uses the committed CSV snapshot by default. To refresh the extract directly from the official FAOSTAT normalized QCL bulk archive, set `refresh_from_faostat <- TRUE` in `R/01_load_real_data.R`, then rerun the workflow. Check for FAOSTAT schema or unit revisions when refreshing.

### Key outputs

- `data/kenya_maize_yield.csv` — 1961–2024 analysis-ready series.
- `outputs/tables/summary_statistics.csv` — descriptive statistics.
- `outputs/tables/decade_summary.csv` — decade-level summaries.
- `outputs/tables/trend_model_coefficients.csv` — log-linear coefficients and HAC inference.
- `outputs/tables/model_fit.csv` — fit statistics and transformed annual growth rate.
- `outputs/tables/break_selection.csv` — BIC comparison and selected breakpoint.
- `outputs/tables/break_segment_slopes.csv` — pre- and post-break annual growth rates.
- `outputs/tables/drought_context_yield_changes.csv` — selected annual yield changes during documented drought periods.
- `outputs/results.md` — generated results summary.
- `reports/maize-yield-trend-analysis.md` — detailed analysis, interpretation and limitations.

### Interpretation and limitations

The long-run model suggests a modest positive average trend, but this summary masks major fluctuations and a possible change in trajectory. Residual serial correlation remains a concern even when HAC inference is used. The analysis is national, annual and single-crop; it does not explain changes through weather, seed, fertiliser, pests, prices, policy, irrigation or farm-management variables.

Further work should link yield to seasonal rainfall and other explanatory variables, test alternative HAC lag lengths, assess sensitivity to influential years and examine structural breaks using formal multiple-break methods. The results should be treated as historical descriptive evidence, not causal estimates.

### Data sources

- FAOSTAT QCL: https://www.fao.org/faostat/en/#data/QCL
- FAOSTAT dataset catalogue (1961–2024; yield unit hg/ha): https://data.fao.org/catalog/iso/d24a448b-3b62-4c09-8c1d-4a39bb599876
- FAO, *Agricultural production statistics 2010–2024*: https://www.fao.org/statistics/highlights-archive/highlights-detail/agricultural-production-statistics-2010-2024/en
- World Bank, *Kenya Agricultural Sector Risk Assessment*: https://documents1.worldbank.org/curated/en/294711467992513646/pdf/97887-REVISED-WP-P148139-PUBLIC-Box393257B-Kenya-Agricultural-Sector-Risk-Assessment.pdf
- Kenya Meteorological Department, *State of the Climate Kenya 2023*: https://meteo.go.ke/documents/802/SoC_Kenya_2023_1.pdf

### Project status

**Completed descriptive time-series analysis, with the extended 1961–2024 series, log-linear trend model, exploratory one-break screen, drought-period context and reproducible R workflow.** The project does not claim causal estimates.

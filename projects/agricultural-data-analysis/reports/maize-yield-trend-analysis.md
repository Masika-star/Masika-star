# Kenya maize-yield trend analysis, 1961–2024

## 1. Research question and analytical approach

This project examines how Kenya's national maize yield has changed over time. It extends the original 51-observation series to the latest reference year currently covered by FAOSTAT's annual crop-production dataset, 2024, and replaces the earlier level-on-time model with a log-linear trend model.

The analysis addresses three related questions:

1. What is the average long-run rate of change in Kenya's maize yield?
2. Does a single time trend adequately describe the 64-year series, or is there evidence of a change in its trajectory?
3. Do large annual yield declines occur during documented drought episodes?

The analysis is descriptive. It does not estimate the causal effect of drought, agricultural policies, technology adoption or input use.

## 2. Data source, coverage and validation

The series contains **64 annual observations from 1961 through 2024** for Kenya, item **Maize (corn)**, element **Yield**, from FAOSTAT's *Crops and livestock products (QCL)* domain. FAOSTAT's QCL catalogue reports annual coverage from 1961 to 2024 and lists yield in hectograms per hectare (hg/ha). The project stores the observations in kilograms per hectare (kg/ha), applying:

\[
\text{yield}_{kg/ha}=\frac{\text{yield}_{hg/ha}}{10}
\]

The FAO's agricultural production release confirms that crop and livestock production data, including harvested area and yield, extend through 2024. The project uses an analysis-ready Kenya extract and includes an optional loader setting to refresh the data from the official normalized FAOSTAT QCL bulk archive. The source, conversion and refresh instructions are documented in the [data README](../data/README.md).

**Correction to the previous project version.** The former 51-value file was labelled 1960–2010. Its values match the FAOSTAT series for **1961–2011**, so the earlier file had a one-year calendar-label shift. This update corrects the labels and appends the subsequent observations through 2024. The numerical values were not shifted or interpolated; their year labels were corrected to the FAOSTAT reference years.

| Data feature | Value |
|---|---:|
| Observations | 64 |
| Period | 1961–2024 |
| Country | Kenya |
| Commodity | Maize (corn) |
| Measure | Yield |
| Stored unit | kg/ha |
| Source unit | hg/ha |

The working series is checked for unique years, consecutive annual observations, positive yield values and missing observations before modelling.

## 3. Descriptive analysis

| Statistic | Yield (kg/ha) |
|---|---:|
| Mean | 1,552.3 |
| Median | 1,569.3 |
| Standard deviation | 248.3 |
| Minimum | 1,071.3 (1965) |
| Maximum | 2,071.2 (1982) |
| 2024 value | 1,666.2 |

The 2024 observation was **1,666.2 kg/ha**, a **5.5% decline** from 1,763.4 kg/ha in 2023. Comparing only the first and last observations, yield increased by approximately 32.9% between 1961 and 2024. This endpoint comparison is useful context, but it hides substantial fluctuations and should not be substituted for a model of the full annual path.

The series does not increase smoothly. It contains substantial annual declines and recoveries, and the highest observation occurs in 1982. The visualisations therefore distinguish the long-run fitted trend from year-to-year movements.

## 4. Log-linear trend model

The main model is:

\[
\ln(Y_t)=\alpha+\beta(t-1961)+\varepsilon_t
\]

where \(Y_t\) is maize yield in kg/ha and \(t\) is calendar year. Centring year at 1961 makes the intercept correspond to the initial year while leaving the slope unchanged.

The estimated year coefficient is approximately:

\[
\hat\beta=0.004871
\]

Because the dependent variable is in logarithms, the exact annual percentage change is calculated as:

\[
100\left(\exp(\hat\beta)-1\right)
\]

This gives an estimated average annual growth rate of **0.488%**, or approximately **0.49% per year**. The 95% confidence interval, calculated using Newey–West heteroskedasticity- and autocorrelation-consistent (HAC) standard errors with three annual lags, is **0.234% to 0.743%** (HAC p-value approximately **0.00029**).

| Model result | Estimate |
|---|---:|
| Annual log coefficient | 0.004871 |
| Annual growth rate | 0.488% |
| 95% HAC confidence interval | 0.234% to 0.743% |
| HAC p-value | 0.00029 |
| R-squared | 0.307 |
| Durbin–Watson statistic | 0.930 |

The coefficient represents a **multiplicative average trend**, not a fixed increase in kilograms per hectare. The fitted trend indicates modest positive average growth across the complete period. The R-squared of 0.307 indicates that the linear time trend accounts for about 30.7% of the variation in log yield; much of the annual variation remains unexplained.

The Durbin–Watson statistic is below one, indicating positive serial correlation in the residuals. HAC standard errors help make statistical inference more robust to heteroskedasticity and short-run serial correlation, but they do not remove persistence from the model or explain its source. The result should therefore be interpreted as a parsimonious long-run trend, not as a complete dynamic model of maize productivity.

## 5. Structural change: a one-break segmented trend

A single log-linear trend may conceal changes in the rate of growth. To examine this possibility, the analysis searches for one unknown breakpoint. Candidate break years are restricted so that at least 14 observations fall on each side. The model with the lowest Bayesian Information Criterion (BIC) is selected.

The BIC screen selects **1982** as the first year of the second segment:

| Model comparison | BIC |
|---|---:|
| No-break log-linear trend | -247.87 |
| One-break model | -276.55 |
| Difference (one-break minus no-break) | -28.69 |

The segmented model estimates annual trends of:

| Period | Annual growth rate | HAC p-value | 95% HAC confidence interval |
|---|---:|---:|---:|
| Before 1982 | +1.238% | 0.0027 | +0.446% to +2.035% |
| From 1982 | -0.267% | 0.0067 | -0.456% to -0.077% |

These results suggest that the full-period average of +0.49% per year masks a change in the trajectory: a faster positive trend before the selected break and a small negative trend thereafter. The selected break year is also the year of the maximum recorded yield (2,071.2 kg/ha).

**The breakpoint is not itself a drought date or a causal explanation.** It is selected statistically from the yield data. Its proximity to the series maximum means the result should be treated as provisional and tested for sensitivity to influential observations and alternative specifications. The reported HAC intervals are conditional on the selected break and do not account for uncertainty created by searching over possible break years. A formal multiple-break procedure and out-of-sample or rolling-window checks would be appropriate extensions.

## 6. Drought episodes and annual yield movements

Kenyan climate and agricultural-risk literature documents several major drought episodes. The World Bank's Kenya Country Environmental Analysis identifies drought periods including 1983–1984, 1991–1993, 1999–2000 and 2007–2009. The World Bank's Kenya Agricultural Sector Risk Assessment also describes 1984, 2000 and 2009 as very dry years and reports adverse effects of growing-season drought on maize production in some regions. Kenya Meteorological Department reports that the beginning of 2023 followed five consecutive failed rainy seasons since November 2020.

Selected national yield movements around documented drought periods are shown below. The percentage change is calculated relative to the previous calendar year's yield.

| Drought episode context | Yield year | Yield (kg/ha) | Change from previous year |
|---|---:|---:|---:|
| 1983–1984 | 1984 | 1,443.7 | -18.4% |
| 1991–1993 | 1993 | 1,554.9 | -10.0% |
| 1999–2000 | 2000 | 1,440.0 | -2.8% |
| 2007–2009 | 2008 | 1,392.5 | -23.2% |
| 2007–2009 | 2009 | 1,294.3 | -7.1% |
| 2016–2017 | 2016 | 1,428.4 | -21.6% |
| 2020–2023 | 2021 | 1,523.8 | -14.1% |
| 2020–2023 | 2022 | 1,458.3 | -4.3% |

The declines in 1984, 2008–2009 and 2016 coincide with documented drought periods. The 2021–2022 observations also declined during the prolonged 2020–2023 drought affecting Kenya and the wider Horn of Africa. These patterns are consistent with the view that weather shocks are important risks to crop production.

However, **temporal coincidence is not evidence of causation**. Not every drought year produces a national decline, and national yield aggregates different agroecological zones, rainfall regimes and crop calendars. For example, the 2023 national yield recovered relative to 2022 despite the prolonged drought period having affected parts of the country. Rainfall conditions vary substantially between the high-potential maize belt and arid and semi-arid regions.

The shaded drought periods in the charts should consequently be read as historical context, not as estimated drought effects. A causal or explanatory drought analysis would need to match maize-yield observations with seasonal rainfall anomalies or drought indices at an appropriate spatial scale, and consider other determinants such as input availability, pests, prices and policy.

## 7. Overall interpretation

The extended FAOSTAT series indicates that Kenya's maize yield experienced a **modest positive average trend of approximately 0.49% per year between 1961 and 2024**. The result is statistically distinguishable from zero when inference is adjusted using Newey–West HAC standard errors. Nevertheless, the time trend explains only part of the variation and the annual observations exhibit substantial persistence.

The one-break screen suggests that a single average slope is inadequate: the estimated trajectory changes around the data-selected year 1982. The drought chronology provides context for several major annual declines, especially in 1984, 2008–2009 and 2016. Neither the breakpoint nor the drought overlays establish why yields changed. The evidence supports a careful historical description, not a causal account of agricultural productivity.

## 8. Limitations and next analytical steps

1. **National aggregation:** Country-level annual yield conceals county-level and agroecological variation. It cannot describe how individual smallholders or specific maize-growing zones were affected.
2. **Omitted explanatory variables:** Rainfall, temperature, seed varieties, fertiliser use, soil fertility, pest pressure, irrigation, prices and agricultural policies are not included. The trend coefficient captures all changes occurring alongside calendar time.
3. **Serial dependence:** The low Durbin–Watson statistic indicates persistent residuals. HAC standard errors improve inference but do not fully model time-series dynamics.
4. **Breakpoint-selection uncertainty:** The 1982 breakpoint is chosen by a one-break BIC search. It is exploratory and should be tested using formal multiple-break methods and sensitivity checks.
5. **Drought attribution:** The national annual series cannot identify the causal effect of drought. Weather data at county or agroecological-zone level and seasonal alignment would be required.
6. **Data revisions and source flags:** FAOSTAT may revise historical values. The compact CSV stores the analytical values and omits some source-flag metadata from the full bulk archive; the optional refresh process should be used to update the snapshot and then rerun all outputs.

The next logical extension is to merge the yield series with rainfall anomalies, test whether weather variables improve explanatory power, and assess break-date robustness before drawing policy conclusions.

## 9. Sources and reproducibility

- FAOSTAT, Crops and livestock products (QCL): https://www.fao.org/faostat/en/#data/QCL
- FAOSTAT QCL catalogue (coverage 1961–2024; yield unit hg/ha): https://data.fao.org/catalog/iso/d24a448b-3b62-4c09-8c1d-4a39bb599876
- FAO, *Agricultural production statistics 2010–2024* (31 December 2025): https://www.fao.org/statistics/highlights-archive/highlights-detail/agricultural-production-statistics-2010-2024/en
- World Bank, *Kenya Agricultural Sector Risk Assessment*: https://documents1.worldbank.org/curated/en/294711467992513646/pdf/97887-REVISED-WP-P148139-PUBLIC-Box393257B-Kenya-Agricultural-Sector-Risk-Assessment.pdf
- World Bank, *Kenya Country Environmental Analysis*: https://kcckp.go.ke/api/media/file/Kenya-Country-Environmental-Analysis-1.pdf
- Kenya Meteorological Department, *State of the Climate Kenya 2023*: https://meteo.go.ke/documents/802/SoC_Kenya_2023_1.pdf

The full workflow is in the `R/` directory. Run it from the repository root with:

```r
source("projects/agricultural-data-analysis/R/00_run_analysis.R")
```

The project uses public national-level data only. It does not publish confidential farmer-level observations.

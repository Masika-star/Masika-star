# Kenya maize-yield results, 1961–2024

## Data

The analysis uses 64 annual Kenya maize-yield observations for Maize (corn), 1961–2024. FAOSTAT's QCL catalogue currently covers agricultural production and yield through 2024. Yield is stored in kg/ha after converting the source unit hg/ha by dividing by ten.

The former 51-observation file was labelled 1960–2010 even though its values match FAOSTAT reference years 1961–2011. The calendar labels have been corrected, and the series has been extended through 2024.

## Log-linear trend

Model: log(yield) = alpha + beta × (year − 1961) + error.

- Annual log coefficient: 0.004871
- Exact transformed annual growth rate: **0.488%**
- 95% Newey–West HAC confidence interval: **0.234% to 0.743%**
- HAC p-value: **0.00029**
- R-squared: **0.307**
- Durbin–Watson statistic: **0.930**

The fitted coefficient is an average multiplicative trend, not a fixed increase in kg/ha. The low Durbin–Watson statistic indicates positive serial correlation remains in the residuals; HAC standard errors adjust inference but do not model the dynamics.

## One-break trend screen

A BIC-based one-break search selects **1982** as the first year of the second segment.

- No-break BIC: −247.87
- One-break BIC: −276.55
- Pre-1982 annual trend: **+1.238%** (HAC p = 0.0027)
- From 1982 annual trend: **−0.267%** (HAC p = 0.0067)

The breakpoint is data-selected and coincides with the series maximum in 1982. It is a provisional statistical indicator, not evidence of a specific causal event. Breakpoint-search uncertainty is not included in the reported HAC intervals.

## Drought context

Documented drought episodes overlap with selected national yield declines: 1984 (−18.4%), 2008 (−23.2%), 2009 (−7.1%), 2016 (−21.6%), 2021 (−14.1%) and 2022 (−4.3%). The drought overlays provide historical context only. National annual yield data alone cannot establish that drought caused these changes; matched rainfall data and regional outcomes would be needed.

## Interpretation

The full series indicates modest positive average yield growth over 1961–2024, but annual performance is volatile and a single linear trend masks a possible change in trajectory. This is a descriptive national time-series analysis, not a causal estimate.

See the [detailed analysis and interpretation](../reports/maize-yield-trend-analysis.md), the [project README](../README.md), and the [data source notes](../data/README.md).

# 05_export_results.R
# Export model tables and a detailed interpretation of the 1961–2024
# Kenya maize-yield time series. Run after 03_explore_data.R and 04_model.R.

library(readr)
library(dplyr)

project_dir <- "projects/agricultural-data-analysis"
data_dir <- file.path(project_dir, "data")
output_dir <- file.path(project_dir, "outputs")
table_dir <- file.path(output_dir, "tables")
report_dir <- file.path(project_dir, "reports")

dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(report_dir, recursive = TRUE, showWarnings = FALSE)

df <- read_csv(file.path(data_dir, "agricultural_clean.csv"),
               show_col_types = FALSE)
summary <- read_csv(file.path(table_dir, "summary_statistics.csv"),
                    show_col_types = FALSE)
trend <- read_csv(file.path(table_dir, "trend_model_coefficients.csv"),
                  show_col_types = FALSE)
fit <- read_csv(file.path(table_dir, "model_fit.csv"),
                show_col_types = FALSE)
break_selection <- read_csv(file.path(table_dir, "break_selection.csv"),
                            show_col_types = FALSE)
break_slopes <- read_csv(file.path(table_dir, "break_segment_slopes.csv"),
                         show_col_types = FALSE)
annual_changes <- read_csv(file.path(table_dir, "annual_yield_changes.csv"),
                           show_col_types = FALSE)

fmt <- function(x, digits = 2) {
  formatC(x, format = "f", digits = digits, big.mark = ",")
}

slope_row <- filter(trend, term == "year_index")
pre <- break_slopes[1, ]
post <- break_slopes[2, ]
selected_break <- break_selection$selected_break_year[[1]]
annual_rate <- fit$annual_growth_pct[[1]]
annual_rate_low <- fit$annual_growth_ci_low_pct[[1]]
annual_rate_high <- fit$annual_growth_ci_high_pct[[1]]
annual_rate_p <- fit$annual_growth_p_value[[1]]

drought_context <- tibble(
  year = c(1984, 1993, 2000, 2008, 2009, 2016, 2021, 2022),
  drought_episode = c(
    "1983–1984", "1991–1993", "1999–2000", "2007–2009",
    "2007–2009", "2016–2017", "2020–2023", "2020–2023"
  )
)

drought_table <- drought_context |>
  left_join(annual_changes, by = "year") |>
  select(drought_episode, year, maize_yield_kg_ha, annual_change_pct)

write_csv(
  drought_table,
  file.path(table_dir, "drought_context_yield_changes.csv")
)

results_lines <- c(
  "# Kenya maize-yield trend analysis",
  "",
  "## 1. Data and research question",
  "",
  sprintf(
    "This descriptive time-series analysis examines annual maize yield in Kenya over %d–%d, using %d observations.",
    min(df$year), max(df$year), nrow(df)
  ),
  "The question is whether national maize yield has followed a sustained long-run trend, how the trend changes over time, and whether major documented drought episodes coincide with pronounced annual movements.",
  "",
  "The series is FAOSTAT's Crops and livestock products (QCL) item Maize (corn), element Yield, area Kenya. FAOSTAT records yield in hectograms per hectare; the project stores kilograms per hectare after dividing by ten. The current QCL catalogue covers 1961–2024. The previous portfolio extract contained the same first 51 yield values but labelled them 1960–2010; the year labels have been corrected to 1961–2011 and the series extended through 2024.",
  "",
  "## 2. Descriptive evidence",
  "",
  "| Measure | Result |",
  "|---|---:|",
  sprintf("| Annual observations | %d |", nrow(df)),
  sprintf("| Period | %d–%d |", min(df$year), max(df$year)),
  sprintf("| Mean yield | %s kg/ha |", fmt(summary$mean_yield_kg_ha, 1)),
  sprintf("| Median yield | %s kg/ha |", fmt(summary$median_yield_kg_ha, 1)),
  sprintf("| Standard deviation | %s kg/ha |", fmt(summary$sd_yield_kg_ha, 1)),
  sprintf("| Minimum | %s kg/ha (%d) |", fmt(summary$min_yield_kg_ha, 1), summary$min_year),
  sprintf("| Maximum | %s kg/ha (%d) |", fmt(summary$max_yield_kg_ha, 1), summary$max_year),
  "",
  "The 2024 yield was 1,666.2 kg/ha, down 5.5% from 1,763.4 kg/ha in 2023. The full-period endpoint comparison is positive, but annual performance is volatile and the endpoint difference alone does not describe the intervening path.",
  "",
  "## 3. Log-linear trend model",
  "",
  "The main specification is:",
  "",
  "log(yield_t) = alpha + beta * (year_t - 1961) + error_t",
  "",
  sprintf(
    "The estimated time coefficient is %s log points per year (Newey–West HAC SE = %s; p = %s).",
    fmt(slope_row$estimate, 5), fmt(slope_row$hac_se, 5),
    format.pval(annual_rate_p, digits = 3)
  ),
  sprintf(
    "Transforming the coefficient gives an estimated annual growth rate of **%s%%**: 100 × [exp(beta) − 1]. Its 95%% HAC confidence interval is **%s%% to %s%%**.",
    fmt(annual_rate, 3), fmt(annual_rate_low, 3), fmt(annual_rate_high, 3)
  ),
  sprintf(
    "The model R-squared is %s and the Durbin–Watson statistic is %s.",
    fmt(fit$r_squared, 3), fmt(fit$durbin_watson, 2)
  ),
  "",
  "The coefficient is therefore an average multiplicative trend, not a constant increase in kilograms per hectare. The approximate interpretation is a 0.49% increase in yield per year over the full period. The exact percentage transformation is used because the dependent variable is in logarithms.",
  "",
  "Newey–West standard errors with three annual lags are used to make inference more robust to heteroskedasticity and short-run serial correlation. The Durbin–Watson statistic below one indicates that residual persistence remains substantial; HAC inference adjusts estimated uncertainty but does not itself model the dynamic process. The single-trend model should therefore be treated as a parsimonious summary, not a complete time-series description.",
  "",
  "## 4. Structural-change screen",
  "",
  sprintf(
    "A one-break segmented trend search, requiring at least %d annual observations on each side and selecting the candidate with the lowest BIC, selects **%d** as the first year of the second segment.",
    break_selection$minimum_segment_observations, selected_break
  ),
  sprintf(
    "The one-break BIC is %s, compared with %s for the no-break model (one-break minus no-break = %s).",
    fmt(break_selection$one_break_bic, 2),
    fmt(break_selection$no_break_bic, 2),
    fmt(break_selection$bic_difference_one_break_minus_no_break, 2)
  ),
  sprintf(
    "The estimated pre-break trend is %s%% per year (HAC p = %s), while the post-break trend is %s%% per year (HAC p = %s).",
    fmt(pre$annual_growth_pct, 3), format.pval(pre$p_value, digits = 3),
    fmt(post$annual_growth_pct, 3), format.pval(post$p_value, digits = 3)
  ),
  "",
  "The breakpoint is selected by the yield data, not imposed from an external chronology. It is a statistical indication of a change in trend, not proof of a specific policy shift, drought, conflict, or technology transition. It also coincides with the series maximum in 1982. The estimated change should be considered provisional because breakpoint searching creates selection uncertainty not reflected in the ordinary HAC intervals. Sensitivity to influential years and alternative break specifications should be assessed before making a strong historical claim.",
  "",
  "## 5. Drought episodes and annual yield movements",
  "",
  "Kenyan climate and agricultural risk sources document major drought periods including 1983–1984, 1991–1993, 1999–2000 and 2007–2009. Later assessments also record the 2016–2017 dry conditions and the five consecutive failed rainy seasons between late 2020 and early 2023. These are used as contextual periods in the charts, not as causal variables.",
  "",
  "| Drought episode context | Yield year | Yield (kg/ha) | Change from previous year |",
  "|---|---:|---:|---:|",
  sprintf(
    "| %s | %d | %s | %s%% |",
    drought_table$drought_episode,
    drought_table$year,
    vapply(drought_table$maize_yield_kg_ha, fmt, character(1), digits = 1),
    vapply(drought_table$annual_change_pct, fmt, character(1), digits = 1)
  ),
  "",
  "Large falls are visible in 1984, 2008–2009 and 2016, while the 2021–2022 observations also declined. Yet the national aggregate does not fall in every drought year or across every drought period. This is plausible because drought exposure differs by location, season and crop calendar, and the national estimate combines high-potential maize zones with drier areas. The series alone cannot establish that drought caused a given annual yield change.",
  "",
  "A stronger drought-impact analysis would merge yield with seasonal rainfall anomalies or drought indices at a matching spatial scale, ideally using county-level or agroecological-zone outcomes. The current national annual series does not contain those covariates.",
  "",
  "## 6. Interpretation and limitations",
  "",
  "The evidence supports a modest positive average long-run trend over 1961–2024, but not a smooth or uninterrupted rise in productivity. The full-period log-linear slope masks important changes in trajectory and substantial year-to-year volatility. The BIC-selected break suggests that one average growth rate may not adequately represent the entire 64-year series.",
  "",
  "The analysis is descriptive and national-level. It cannot isolate effects of rainfall, seed varieties, fertiliser use, soil conditions, pests and disease, policy, prices, irrigation, harvested-area composition or farm-management decisions. It also masks differences among counties, seasons and smallholder production systems. Persistent residuals suggest that future modelling should consider richer dynamic specifications, robustness to HAC lag choices, formal multiple-break tests and alternative time windows.",
  "",
  "The structural break should be described as a data-selected regime change, not labelled as a drought event. Drought periods are separately overlaid from external climate and risk documentation. Temporal coincidence between a drought and a fall in yield is not causal attribution.",
  "",
  "## 7. Data sources and reproducibility",
  "",
  "The data snapshot and scripts are stored in this repository. The data loader uses the committed CSV by default and contains an optional refresh setting for downloading the official FAOSTAT normalized QCL bulk file. Verify the current FAOSTAT bulk archive and schema when refreshing the data.",
  "",
  "FAOSTAT QCL: https://www.fao.org/faostat/en/#data/QCL  ",
  "FAOSTAT QCL catalogue (1961–2024, yield in hg/ha): https://data.fao.org/catalog/iso/d24a448b-3b62-4c09-8c1d-4a39bb599876  ",
  "FAO agricultural production release (2010–2024): https://www.fao.org/statistics/highlights-archive/highlights-detail/agricultural-production-statistics-2010-2024/en  ",
  "World Bank, Kenya Agricultural Sector Risk Assessment: https://documents1.worldbank.org/curated/en/294711467992513646/pdf/97887-REVISED-WP-P148139-PUBLIC-Box393257B-Kenya-Agricultural-Sector-Risk-Assessment.pdf  ",
  "World Bank, Kenya Country Environmental Analysis: https://kcckp.go.ke/api/media/file/Kenya-Country-Environmental-Analysis-1.pdf  ",
  "Kenya Meteorological Department, State of the Climate Kenya 2023: https://meteo.go.ke/documents/802/SoC_Kenya_2023_1.pdf",
  ""
)

writeLines(results_lines, file.path(output_dir, "results.md"))
writeLines(
  results_lines,
  file.path(report_dir, "maize-yield-trend-analysis.md")
)

cat("Detailed maize-yield results and report exported.\n")

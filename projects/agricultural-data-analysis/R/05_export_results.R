# 05_export_results.R
# Export model tables and a detailed, reproducible interpretation of the
# 1961–2024 Kenya maize-yield time series.

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
    "1983–1984",
    "1991–1993",
    "1999–2000",
    "2007–2009",
    "2007–2009",
    "2016–2017",
    "2020–2023",
    "2020–2023"
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
  "# Analytical results",
  "",
  sprintf("## Kenya maize yield, %d–%d", min(df$year), max(df$year)),
  "",
  sprintf(
    "The series contains **%d annual observations**. Mean yield was **%s kg/ha** and median yield was **%s kg/ha**.",
    nrow(df), fmt(summary$mean_yield_kg_ha), fmt(summary$median_yield_kg_ha)
  ),
  sprintf(
    "The minimum was **%s kg/ha** in %d and the maximum was **%s kg/ha** in %d.",
    fmt(summary$min_yield_kg_ha), summary$min_year,
    fmt(summary$max_yield_kg_ha), summary$max_year
  ),
  "",
  "## Log-linear trend",
  "",
  "log(yield) = alpha + beta * (year - 1961) + error",
  "",
  sprintf(
    "The estimated coefficient on year is **%s log points per year** (Newey–West HAC SE = %s; p = %s).",
    fmt(slope_row$estimate, 5), fmt(slope_row$hac_se, 5),
    format.pval(annual_rate_p, digits = 3)
  ),
  sprintf(
    "The exact transformed annual rate is **%s%%** (95%% HAC CI: %s%% to %s%%).",
    fmt(annual_rate, 3), fmt(annual_rate_low, 3),
    fmt(annual_rate_high, 3)
  ),
  sprintf(
    "The model R-squared is **%s**. The Durbin–Watson statistic is **%s**, indicating positive serial correlation in the residuals.",
    fmt(fit$r_squared, 3), fmt(fit$durbin_watson, 2)
  ),
  "",
  "The log-linear slope is interpreted as 100 * (exp(beta) - 1), rather than simply multiplying beta by 100. Newey–West standard errors with three annual lags are used for inference because annual yield observations can be heteroskedastic and serially correlated. HAC standard errors adjust inference; they do not remove the underlying persistence in the series.",
  "",
  "## One-break structural-change screen",
  "",
  sprintf(
    "A one-break segmented trend search, requiring at least %d observations on each side and selecting the breakpoint by BIC, identifies **%d** as the first year of the second segment.",
    break_selection$minimum_segment_observations, selected_break
  ),
  sprintf(
    "The one-break model has BIC **%s**, compared with **%s** for the no-break trend (difference = %s).",
    fmt(break_selection$one_break_bic, 2),
    fmt(break_selection$no_break_bic, 2),
    fmt(break_selection$bic_difference_one_break_minus_no_break, 2)
  ),
  sprintf(
    "The estimated pre-break annual trend is **%s%%** (HAC p = %s); the post-break trend is **%s%%** (HAC p = %s).",
    fmt(pre$annual_growth_pct, 3), format.pval(pre$p_value, digits = 3),
    fmt(post$annual_growth_pct, 3), format.pval(post$p_value, digits = 3)
  ),
  "",
  "The breakpoint is selected from the yield series itself. It is a statistical indication of a change in trend, not proof of a specific policy change, drought, or other causal event. The search is exploratory and its confidence intervals do not account for breakpoint-selection uncertainty. The selected year also coincides with the series maximum, so sensitivity to influential observations deserves further examination.",
  "",
  "## Drought episodes and annual yield movements",
  "",
  "Kenya's agricultural risk literature documents drought episodes including 1983–1984, 1991–1993, 1999–2000, 2007–2009, 2016–2017 and 2020–2023. The years below show selected annual movements in the national maize-yield series:",
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
  "The temporal overlap between drought episodes and yield declines is descriptive evidence only. National annual yield combines different agroecological zones and seasons; not every drought year produces a national decline, and a decline cannot be attributed to drought without linking yield to rainfall or other weather measures at an appropriate spatial and seasonal scale.",
  "",
  "## Interpretation and limitations",
  "",
  "The full-period model suggests a modest positive long-run average growth rate, but it should not be read as a smooth or uninterrupted improvement. The selected break indicates that the average trajectory changed during the series, while the drought chronology helps contextualise some pronounced annual falls.",
  "",
  "This is a national-level, single-crop time series. It cannot identify the contribution of rainfall, improved seed, fertiliser, soil conditions, pests, prices, policy, harvested-area composition or farm-management choices. It masks regional and seasonal differences, and its annual observations exhibit serial dependence. The selected one-break model is a useful diagnostic rather than a definitive structural-break test. A stronger explanatory analysis would add rainfall anomalies, input-use and policy variables, examine additional breaks with formal procedures, and test alternative HAC lag choices.",
  "",
  "## Data and reproducibility",
  "",
  sprintf(
    "The analysis uses FAOSTAT's Crops and livestock products (QCL) series for Kenya, Maize (corn), Element = Yield, covering %d–%d. FAOSTAT reports yield in hg/ha; the project stores kg/ha after division by 10.",
    min(df$year), max(df$year)
  ),
  "",
  "The former portfolio extract contained the same first 51 values but labelled them one year early (1960–2010). This update corrects those labels to the FAOSTAT reference years (1961–2011) and adds observations through 2024.",
  "",
  "FAOSTAT: https://www.fao.org/faostat/en/#data/QCL  ",
  "Dataset catalogue: https://data.fao.org/catalog/iso/d24a448b-3b62-4c09-8c1d-4a39bb599876  ",
  "FAO release: https://www.fao.org/statistics/highlights-archive/highlights-detail/agricultural-production-statistics-2010-2024/en",
  ""
)

writeLines(results_lines, file.path(output_dir, "results.md"))
writeLines(
  results_lines,
  file.path(report_dir, "maize-yield-trend-analysis.md")
)

cat("Detailed maize-yield results and report exported.\n")

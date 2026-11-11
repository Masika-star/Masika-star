# 04_model.R
# Log-linear trend model with HAC inference and a one-break segmented trend.
# This is a descriptive national time-series analysis, not a causal model.

library(dplyr)
library(readr)
library(sandwich)

project_dir <- "projects/agricultural-data-analysis"
data_dir <- file.path(project_dir, "data")
table_dir <- file.path(project_dir, "outputs", "tables")
dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)

df <- read_csv(file.path(data_dir, "agricultural_clean.csv"),
               show_col_types = FALSE) |>
  arrange(year)

stopifnot(nrow(df) == 64)
stopifnot(min(df$year) == 1961, max(df$year) == 2024)
stopifnot(all(df$maize_yield_kg_ha > 0))

df <- df |>
  mutate(
    log_yield = log(maize_yield_kg_ha),
    year_index = year - min(year)
  )

# -------------------------------------------------------------------
# 1. Overall log-linear trend: log(yield) = alpha + beta * year_index
# Newey-West HAC standard errors allow for heteroskedasticity and
# short-run serial correlation. Three annual lags are used.
# -------------------------------------------------------------------

trend_model <- lm(log_yield ~ year_index, data = df)
hac_vcov <- NeweyWest(
  trend_model, lag = 3, prewhite = FALSE, adjust = TRUE
)

beta <- coef(trend_model)
hac_se <- sqrt(diag(hac_vcov))
df_resid <- df.residual(trend_model)
t_stat <- beta / hac_se
p_value <- 2 * pt(abs(t_stat), df = df_resid, lower.tail = FALSE)
critical_t <- qt(0.975, df = df_resid)

trend_coefficients <- tibble(
  term = names(beta),
  estimate = as.numeric(beta),
  hac_se = as.numeric(hac_se),
  t_statistic = as.numeric(t_stat),
  p_value = as.numeric(p_value),
  conf_low = as.numeric(beta - critical_t * hac_se),
  conf_high = as.numeric(beta + critical_t * hac_se)
)

write_csv(
  trend_coefficients,
  file.path(table_dir, "trend_model_coefficients.csv")
)

slope <- unname(beta[["year_index"]])
slope_ci <- trend_coefficients |>
  filter(term == "year_index")

annual_growth_pct <- 100 * (exp(slope) - 1)
annual_growth_ci_low <- 100 * (exp(slope_ci$conf_low) - 1)
annual_growth_ci_high <- 100 * (exp(slope_ci$conf_high) - 1)

residuals <- residuals(trend_model)
durbin_watson <- sum(diff(residuals)^2) / sum(residuals^2)

model_fit <- tibble(
  observations = nobs(trend_model),
  first_year = min(df$year),
  last_year = max(df$year),
  r_squared = summary(trend_model)$r.squared,
  adjusted_r_squared = summary(trend_model)$adj.r.squared,
  residual_standard_error = sigma(trend_model),
  durbin_watson = durbin_watson,
  annual_growth_pct = annual_growth_pct,
  annual_growth_ci_low_pct = annual_growth_ci_low,
  annual_growth_ci_high_pct = annual_growth_ci_high,
  annual_growth_p_value = trend_coefficients$p_value[
    trend_coefficients$term == "year_index"
  ]
)

write_csv(model_fit, file.path(table_dir, "model_fit.csv"))

# -------------------------------------------------------------------
# 2. Search for one unknown breakpoint in a piecewise log-linear trend.
# Each segment has its own intercept and slope. A minimum of 14 annual
# observations is required in each segment. BIC penalises the four
# regression coefficients plus the estimated breakpoint location.
# The reported breakpoint is the first year of the second segment.
# -------------------------------------------------------------------

n <- nrow(df)
minimum_segment <- 14L
candidate_years <- df$year[
  (minimum_segment + 1L):(n - minimum_segment)
]

candidate_results <- lapply(candidate_years, function(candidate_year) {
  before <- filter(df, year < candidate_year)
  after <- filter(df, year >= candidate_year)

  model_before <- lm(log_yield ~ year_index, data = before)
  model_after <- lm(log_yield ~ year_index, data = after)

  rss <- sum(residuals(model_before)^2) +
    sum(residuals(model_after)^2)

  tibble(
    break_year = candidate_year,
    rss = rss,
    bic = n * log(rss / n) + 5 * log(n)
  )
}) |>
  bind_rows()

best_break <- candidate_results |>
  slice_min(bic, n = 1, with_ties = FALSE)

no_break_rss <- sum(residuals(trend_model)^2)
no_break_bic <- n * log(no_break_rss / n) + 2 * log(n)

break_year <- best_break$break_year[[1]]

break_selection <- tibble(
  observations = n,
  minimum_segment_observations = minimum_segment,
  no_break_bic = no_break_bic,
  one_break_bic = best_break$bic[[1]],
  bic_difference_one_break_minus_no_break = best_break$bic[[1]] - no_break_bic,
  selected_break_year = break_year
)

write_csv(
  break_selection,
  file.path(table_dir, "break_selection.csv")
)

# Fit a continuous-time segmented specification with a level shift and
# a slope change beginning in the selected break year.
df <- df |>
  mutate(
    post_break = as.integer(year >= break_year),
    time_after_break = pmax(year - break_year, 0)
  )

segmented_model <- lm(
  log_yield ~ year_index + post_break + time_after_break,
  data = df
)

segmented_vcov <- NeweyWest(
  segmented_model, lag = 3, prewhite = FALSE, adjust = TRUE
)

segmented_beta <- coef(segmented_model)
segmented_df <- df.residual(segmented_model)
segmented_critical_t <- qt(0.975, df = segmented_df)

slope_contrast <- function(weights, period_label) {
  estimate <- as.numeric(t(weights) %*% segmented_beta)
  variance <- as.numeric(
    t(weights) %*% segmented_vcov %*% weights
  )
  standard_error <- sqrt(variance)
  statistic <- estimate / standard_error
  p <- 2 * pt(abs(statistic), df = segmented_df, lower.tail = FALSE)
  lower <- estimate - segmented_critical_t * standard_error
  upper <- estimate + segmented_critical_t * standard_error

  tibble(
    period = period_label,
    log_slope = estimate,
    hac_se = standard_error,
    t_statistic = statistic,
    p_value = p,
    annual_growth_pct = 100 * (exp(estimate) - 1),
    conf_low_pct = 100 * (exp(lower) - 1),
    conf_high_pct = 100 * (exp(upper) - 1)
  )
}

break_slopes <- bind_rows(
  slope_contrast(
    c(0, 1, 0, 0),
    paste0("Before ", break_year)
  ),
  slope_contrast(
    c(0, 1, 0, 1),
    paste0("From ", break_year)
  )
)

write_csv(
  break_slopes,
  file.path(table_dir, "break_segment_slopes.csv")
)

# Save the selected segmented-model coefficients and their HAC inference.
segmented_se <- sqrt(diag(segmented_vcov))
segmented_t <- segmented_beta / segmented_se
segmented_p <- 2 * pt(
  abs(segmented_t), df = segmented_df, lower.tail = FALSE
)

segmented_coefficients <- tibble(
  term = names(segmented_beta),
  estimate = as.numeric(segmented_beta),
  hac_se = as.numeric(segmented_se),
  t_statistic = as.numeric(segmented_t),
  p_value = as.numeric(segmented_p),
  conf_low = as.numeric(
    segmented_beta - segmented_critical_t * segmented_se
  ),
  conf_high = as.numeric(
    segmented_beta + segmented_critical_t * segmented_se
  )
)

write_csv(
  segmented_coefficients,
  file.path(table_dir, "break_model_coefficients.csv")
)

# Annual percentage changes are retained for inspection of volatile years.
annual_changes <- df |>
  arrange(year) |>
  mutate(
    annual_change_pct = 100 * (
      maize_yield_kg_ha / lag(maize_yield_kg_ha) - 1
    )
  ) |>
  select(year, maize_yield_kg_ha, annual_change_pct)

write_csv(
  annual_changes,
  file.path(table_dir, "annual_yield_changes.csv")
)

cat(
  "Log-linear annual growth:", round(annual_growth_pct, 3), "%\n",
  "HAC p-value:", signif(model_fit$annual_growth_p_value, 4), "\n",
  "BIC-selected break year:", break_year, "\n"
)

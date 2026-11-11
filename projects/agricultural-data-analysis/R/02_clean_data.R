# 02_clean_data.R
# Validate the annual series and prepare variables for analysis.

library(dplyr)
library(readr)

project_dir <- "projects/agricultural-data-analysis"
data_dir <- file.path(project_dir, "data")

raw <- read_csv(file.path(data_dir, "agricultural_real_raw.csv"),
                show_col_types = FALSE)

stopifnot(nrow(raw) == 64)
stopifnot(!anyDuplicated(raw$year))
stopifnot(all(diff(raw$year) == 1))
stopifnot(all(raw$maize_yield_kg_ha > 0))

clean <- raw |>
  arrange(year) |>
  mutate(
    year = as.integer(year),
    year_index = year - min(year),
    decade = paste0(floor(year / 10) * 10, "s"),
    log_yield = log(maize_yield_kg_ha)
  )

write_csv(clean, file.path(data_dir, "agricultural_clean.csv"))

cat("Rows retained:", nrow(clean), "\n")
cat("Years:", min(clean$year), "-", max(clean$year), "\n")

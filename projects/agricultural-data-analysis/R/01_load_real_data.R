# 01_load_real_data.R
# Load and validate Kenya's FAOSTAT maize-yield series.
# Run from the repository root.
#
# The committed 1961–2024 CSV snapshot is used by default.
# Set refresh_from_faostat <- TRUE to download and filter the current QCL bulk file.

library(readr)
library(dplyr)

project_dir <- "projects/agricultural-data-analysis"
data_dir <- file.path(project_dir, "data")
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)

input_file <- file.path(data_dir, "kenya_maize_yield.csv")
refresh_from_faostat <- FALSE

if (refresh_from_faostat) {
  faostat_url <- paste0(
    "https://bulks-faostat.fao.org/production/",
    "Production_Crops_Livestock_E_All_Data_(Normalized).zip"
  )
  zip_file <- file.path(data_dir, "faostat_qcl_normalized.zip")
  archive_csv <- "Production_Crops_Livestock_E_All_Data_(Normalized).csv"

  if (!file.exists(zip_file)) {
    download.file(faostat_url, zip_file, mode = "wb", method = "auto")
  }

  faostat <- read_csv(
    unz(zip_file, archive_csv),
    show_col_types = FALSE,
    locale = locale(encoding = "UTF-8")
  )

  required <- c("Area", "Item", "Element", "Year", "Unit", "Value")
  stopifnot(all(required %in% names(faostat)))

  refreshed <- faostat |>
    filter(
      Area == "Kenya",
      Item == "Maize (corn)",
      Element == "Yield"
    ) |>
    transmute(
      year = as.integer(Year),
      maize_yield_kg_ha = case_when(
        Unit == "hg/ha" ~ Value / 10,
        Unit == "kg/ha" ~ Value,
        TRUE ~ NA_real_
      )
    ) |>
    filter(!is.na(maize_yield_kg_ha)) |>
    arrange(year)

  stopifnot(nrow(refreshed) > 0, !anyDuplicated(refreshed$year))
  write_csv(refreshed, input_file)
}

raw <- read_csv(input_file, show_col_types = FALSE)

stopifnot(all(c("year", "maize_yield_kg_ha") %in% names(raw)))
stopifnot(nrow(raw) == 64)
stopifnot(min(raw$year) == 1961, max(raw$year) == 2024)
stopifnot(!anyDuplicated(raw$year))
stopifnot(all(diff(raw$year) == 1))
stopifnot(all(is.finite(raw$maize_yield_kg_ha)))
stopifnot(all(raw$maize_yield_kg_ha > 0))

write_csv(raw, file.path(data_dir, "agricultural_real_raw.csv"))

cat(
  "Loaded", nrow(raw), "annual Kenya maize-yield observations from",
  min(raw$year), "to", max(raw$year), "\n"
)

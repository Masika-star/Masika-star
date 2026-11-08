# 00_run_analysis.R
# Master script for the real-data agricultural analysis project.
# Run from the repository root.

source("projects/agricultural-data-analysis/R/01_load_real_data.R")
source("projects/agricultural-data-analysis/R/02_clean_data.R")
source("projects/agricultural-data-analysis/R/03_explore_data.R")
source("projects/agricultural-data-analysis/R/04_model.R")
source("projects/agricultural-data-analysis/R/05_export_results.R")
source("projects/agricultural-data-analysis/R/06_visualize_distribution_and_trend.R")

message("Real-data agricultural analysis workflow completed.")

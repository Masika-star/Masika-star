# 03_explore_data.R
# Descriptive statistics and decade summaries for Kenya maize yield.

library(dplyr)
library(ggplot2)
library(readr)

project_dir <- "projects/agricultural-data-analysis"
data_dir <- file.path(project_dir, "data")
output_dir <- file.path(project_dir, "outputs")
figure_dir <- file.path(output_dir, "figures")
table_dir <- file.path(output_dir, "tables")

dir.create(figure_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)

df <- read_csv(file.path(data_dir, "agricultural_clean.csv"),
               show_col_types = FALSE)

summary_stats <- df |>
  summarise(
    n = n(),
    start_year = min(year),
    end_year = max(year),
    mean_yield_kg_ha = mean(maize_yield_kg_ha),
    median_yield_kg_ha = median(maize_yield_kg_ha),
    sd_yield_kg_ha = sd(maize_yield_kg_ha),
    min_yield_kg_ha = min(maize_yield_kg_ha),
    min_year = year[which.min(maize_yield_kg_ha)],
    max_yield_kg_ha = max(maize_yield_kg_ha),
    max_year = year[which.max(maize_yield_kg_ha)]
  )

write_csv(summary_stats, file.path(table_dir, "summary_statistics.csv"))

decade_summary <- df |>
  group_by(decade) |>
  summarise(
    mean_yield_kg_ha = mean(maize_yield_kg_ha),
    min_yield_kg_ha = min(maize_yield_kg_ha),
    max_yield_kg_ha = max(maize_yield_kg_ha),
    sd_yield_kg_ha = sd(maize_yield_kg_ha),
    n = n(),
    .groups = "drop"
  )

write_csv(decade_summary, file.path(table_dir, "decade_summary.csv"))

p <- ggplot(df, aes(year, maize_yield_kg_ha)) +
  geom_line(colour = "#55BFAE", linewidth = 0.8) +
  geom_point(colour = "#55BFAE", size = 1.5) +
  labs(
    title = "Kenya maize yield, 1961–2024",
    subtitle = "Annual FAOSTAT series · 64 observations",
    x = "Year",
    y = "Maize yield (kg/ha)"
  ) +
  scale_x_continuous(breaks = seq(1960, 2020, by = 10)) +
  theme_minimal(base_size = 12)

ggsave(
  file.path(figure_dir, "maize_yield_exploratory.png"),
  p, width = 9, height = 5.5, dpi = 300, bg = "white"
)

cat("Exploratory analysis completed.\n")

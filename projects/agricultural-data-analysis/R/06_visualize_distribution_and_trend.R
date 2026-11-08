# 06_visualize_distribution_and_trend.R
# Generate a year-by-year column chart and annual line graph from the same data.
# Run this script from the repository root after the cleaning step.

library(readr)
library(ggplot2)

data_file <- "projects/agricultural-data-analysis/data/kenya_maize_yield.csv"
output_dir <- "projects/agricultural-data-analysis/outputs/figures"

df <- read_csv(data_file, show_col_types = FALSE)

stopifnot(all(c("year", "maize_yield_kg_ha") %in% names(df)))
stopifnot(nrow(df) == 51, !anyDuplicated(df$year))
stopifnot(all(df$maize_yield_kg_ha > 0))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# 1. Annual column chart: year on the x-axis and yield (kg/ha) on the y-axis.
p_column <- ggplot(df, aes(x = year, y = maize_yield_kg_ha)) +
  geom_col(width = 0.8, fill = "#2f855a") +
  labs(
    title = "Annual maize yield in Kenya, 1960–2010",
    x = "Year",
    y = "Maize yield (kg/ha)",
    caption = "51 annual observations; yield measured in kg/ha"
  ) +
  scale_x_continuous(breaks = seq(1960, 2010, by = 10)) +
  scale_y_continuous(limits = c(0, 2200), breaks = seq(0, 2000, by = 500)) +
  theme_minimal(base_size = 12)

ggsave(file.path(output_dir, "maize_yield_annual_column.svg"),
       p_column, width = 9, height = 5.5, device = "svg")

# 2. Annual line graph: shows year-to-year movement in yield.
p_line <- ggplot(df, aes(x = year, y = maize_yield_kg_ha)) +
  geom_line(colour = "#2563eb", linewidth = 0.8) +
  geom_point(colour = "#2563eb", size = 1.8) +
  labs(
    title = "Annual maize yield in Kenya, 1960–2010",
    x = "Year",
    y = "Maize yield (kg/ha)",
    caption = "Annual observations from the same Kenya maize-yield dataset"
  ) +
  scale_x_continuous(breaks = seq(1960, 2010, by = 10)) +
  theme_minimal(base_size = 12)

ggsave(file.path(output_dir, "maize_yield_annual_line.svg"),
       p_line, width = 9, height = 5.5, device = "svg")

message("Annual column chart and line graph exported to ", output_dir)

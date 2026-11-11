# 06_visualize_distribution_and_trend.R
# Export three coordinated charts for Kenya maize yield, 1961–2024.
# The visual language uses amber, teal, soft blue and rust throughout.

library(readr)
library(dplyr)
library(ggplot2)

project_dir <- "projects/agricultural-data-analysis"
data_dir <- file.path(project_dir, "data")
table_dir <- file.path(project_dir, "outputs", "tables")
output_dir <- file.path(project_dir, "outputs", "figures")

AMBER <- "#E5A000"
TEAL  <- "#55BFAE"
BLUE  <- "#8EADD2"
RUST  <- "#E47759"
SLATE <- "#36434D"
MUTED <- "#687782"
GRID  <- "#E5EBF0"

theme_portfolio <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", colour = SLATE, size = 16,
                                margin = margin(b = 8)),
      plot.subtitle = element_text(colour = MUTED, size = 10),
      plot.caption = element_text(colour = MUTED, size = 8.5,
                                  margin = margin(t = 10)),
      axis.title = element_text(colour = SLATE, size = 10),
      axis.text = element_text(colour = MUTED, size = 9),
      axis.ticks = element_blank(),
      panel.grid.major = element_line(colour = GRID, linewidth = 0.35),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", colour = NA),
      panel.background = element_rect(fill = "white", colour = NA),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text = element_text(colour = SLATE, size = 9),
      plot.margin = margin(16, 18, 12, 14)
    )
}

df <- read_csv(file.path(data_dir, "agricultural_clean.csv"),
               show_col_types = FALSE) |>
  arrange(year)

break_selection <- read_csv(
  file.path(table_dir, "break_selection.csv"),
  show_col_types = FALSE
)

stopifnot(nrow(df) == 64)
stopifnot(min(df$year) == 1961, max(df$year) == 2024)
stopifnot(all(diff(df$year) == 1))
stopifnot(all(df$maize_yield_kg_ha > 0))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

selected_break <- break_selection$selected_break_year[[1]]
peak_row <- df[which.max(df$maize_yield_kg_ha), ]

# Documented drought episodes are contextual overlays, not causal labels.
drought_windows <- tibble(
  start = c(1983, 1991, 1999, 2007, 2016, 2020),
  end   = c(1984, 1993, 2000, 2009, 2017, 2023),
  episode = c(
    "1983–84", "1991–93", "1999–2000",
    "2007–09", "2016–17", "2020–23"
  )
)

drought_years <- unique(unlist(
  Map(seq, drought_windows$start, drought_windows$end)
))
df <- df |>
  mutate(
    is_drought_context = year %in% drought_years,
    drought_label = if_else(is_drought_context, "Drought episode context",
                            "Other years")
  )

x_breaks <- seq(1960, 2020, by = 10)

# 1. Log-linear long-run trend, exponentiated back to kg/ha.
trend_model <- lm(log(maize_yield_kg_ha) ~ year, data = df)
trend_grid <- tibble(
  year = seq(min(df$year), max(df$year), length.out = 300)
) |>
  mutate(
    fitted_log_yield = predict(trend_model, newdata = data.frame(year = year)),
    fitted_yield_kg_ha = exp(fitted_log_yield)
  )

p_trend <- ggplot(df, aes(year, maize_yield_kg_ha)) +
  geom_line(colour = TEAL, linewidth = 0.75, alpha = 0.95) +
  geom_point(colour = TEAL, size = 1.65) +
  geom_line(
    data = trend_grid,
    aes(year, fitted_yield_kg_ha),
    inherit.aes = FALSE,
    colour = RUST, linewidth = 1.0, linetype = "longdash"
  ) +
  geom_vline(
    xintercept = selected_break,
    colour = BLUE, linewidth = 0.9, linetype = "dotted"
  ) +
  annotate(
    "label", x = selected_break + 1, y = max(df$maize_yield_kg_ha) * 1.045,
    label = paste0("BIC-selected break: ", selected_break),
    hjust = 0, vjust = 1, size = 3, colour = SLATE,
    fill = "white", label.size = 0, alpha = 0.9
  ) +
  scale_x_continuous(breaks = x_breaks, limits = c(1960, 2025)) +
  scale_y_continuous(
    labels = function(x) format(x, big.mark = ",", scientific = FALSE)
  ) +
  labs(
    title = "Kenya maize yield: log-linear trend",
    subtitle = "Observed yield and exponentiated fitted log-yield trend",
    x = "Year", y = "Maize yield (kg/ha)",
    caption = "64 annual FAOSTAT observations · Dotted marker is a data-selected trend break, not a causal event"
  ) +
  theme_portfolio()

ggsave(file.path(output_dir, "maize_yield_trend.svg"),
       p_trend, width = 9, height = 5.5, device = "svg", bg = "white")

# 2. Annual columns: rust highlights years within documented drought episodes.
p_column <- ggplot(df, aes(year, maize_yield_kg_ha, fill = drought_label)) +
  geom_col(width = 0.78, show.legend = TRUE) +
  scale_fill_manual(
    values = c("Other years" = AMBER, "Drought episode context" = RUST)
  ) +
  scale_x_continuous(breaks = x_breaks, limits = c(1960, 2025)) +
  scale_y_continuous(
    breaks = seq(0, 2000, by = 500), limits = c(0, 2350),
    labels = function(x) format(x, big.mark = ",", scientific = FALSE)
  ) +
  labs(
    title = "Kenya maize yield by year",
    subtitle = "Annual observations; drought-context years highlighted",
    x = "Year", y = "Maize yield (kg/ha)",
    caption = "Drought shading indicates documented episode years; it does not imply that drought alone caused each yield movement"
  ) +
  theme_portfolio()

ggsave(file.path(output_dir, "maize_yield_annual_column.svg"),
       p_column, width = 9, height = 5.5, device = "svg", bg = "white")

# 3. Annual movement with drought windows shaded in pale rust.
p_line <- ggplot(df, aes(year, maize_yield_kg_ha)) +
  geom_rect(
    data = drought_windows,
    aes(xmin = start - 0.5, xmax = end + 0.5, ymin = -Inf, ymax = Inf),
    inherit.aes = FALSE, fill = RUST, alpha = 0.12
  ) +
  geom_line(colour = TEAL, linewidth = 0.9) +
  geom_point(colour = TEAL, size = 1.8) +
  geom_point(
    data = peak_row, aes(year, maize_yield_kg_ha),
    inherit.aes = FALSE, colour = RUST, size = 3.3
  ) +
  scale_x_continuous(breaks = x_breaks, limits = c(1960, 2025)) +
  scale_y_continuous(
    labels = function(x) format(x, big.mark = ",", scientific = FALSE)
  ) +
  labs(
    title = "Annual fluctuations and drought context",
    subtitle = "Shaded intervals mark documented national drought episodes",
    x = "Year", y = "Maize yield (kg/ha)",
    caption = "Shading is contextual only; the series contains no rainfall controls. Peak yield: 1982."
  ) +
  theme_portfolio()

ggsave(file.path(output_dir, "maize_yield_annual_line.svg"),
       p_line, width = 9, height = 5.5, device = "svg", bg = "white")

message("Three updated 1961–2024 charts exported to ", output_dir)

# 06_visualize_distribution_and_trend.R
# Generate three coordinated portfolio charts from the same 51 annual observations.
# Run from the repository root after preparing the Kenya maize-yield data.

library(readr)
library(ggplot2)

# Palette sampled from the visual reference: amber, teal, soft blue and rust.
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
                                margin = margin(b = 10)),
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

data_file <- "projects/agricultural-data-analysis/data/kenya_maize_yield.csv"
output_dir <- "projects/agricultural-data-analysis/outputs/figures"
df <- read_csv(data_file, show_col_types = FALSE)

stopifnot(all(c("year", "maize_yield_kg_ha") %in% names(df)))
stopifnot(nrow(df) == 51, !anyDuplicated(df$year))
stopifnot(all(df$maize_yield_kg_ha > 0), all(diff(df$year) == 1))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
peak_row <- df[which.max(df$maize_yield_kg_ha), ]
df$is_peak <- df$year == peak_row$year
x_breaks <- seq(1960, 2010, by = 10)
y_breaks <- seq(1000, 2200, by = 200)

# 1. Long-run trend: observed yields, fitted linear trend and 95% confidence band.
trend_model <- lm(maize_yield_kg_ha ~ year, data = df)
trend_grid <- data.frame(year = seq(min(df$year), max(df$year), length.out = 200))
trend_grid <- cbind(
  trend_grid,
  as.data.frame(predict(trend_model, newdata = trend_grid,
                        interval = "confidence", level = 0.95))
)

p_trend <- ggplot(df, aes(year, maize_yield_kg_ha)) +
  geom_ribbon(data = trend_grid, aes(x = year, ymin = lwr, ymax = upr),
              inherit.aes = FALSE, fill = BLUE, alpha = 0.28) +
  geom_line(colour = TEAL, linewidth = 0.8) +
  geom_point(colour = TEAL, fill = TEAL, shape = 21, size = 2.2, stroke = 0.45) +
  geom_line(data = trend_grid, aes(year, fit), inherit.aes = FALSE,
            colour = RUST, linewidth = 0.8, linetype = "longdash") +
  scale_x_continuous(breaks = x_breaks, limits = c(1959, 2011)) +
  scale_y_continuous(breaks = y_breaks, limits = c(900, 2200)) +
  labs(
    title = "Kenya maize yield: long-run trend",
    x = "Year", y = "Maize yield (kg/ha)",
    caption = "51 annual observations · Shaded area: 95% confidence interval for fitted mean trend"
  ) +
  theme_portfolio()

ggsave(file.path(output_dir, "maize_yield_trend.svg"),
       p_trend, width = 9, height = 5.5, device = "svg", bg = "white")

# 2. Annual columns: amber bars; rust marks the maximum observation.
p_column <- ggplot(df, aes(year, maize_yield_kg_ha, fill = is_peak)) +
  geom_col(width = 0.72, show.legend = FALSE) +
  scale_fill_manual(values = c("FALSE" = AMBER, "TRUE" = RUST)) +
  scale_x_continuous(breaks = x_breaks, limits = c(1959, 2011)) +
  scale_y_continuous(
    breaks = seq(0, 2000, by = 500), limits = c(0, 2350),
    labels = function(x) format(x, big.mark = ",", scientific = FALSE)
  ) +
  labs(
    title = "Kenya maize yield by year",
    x = "Year", y = "Maize yield (kg/ha)",
    caption = sprintf("51 annual observations · Rust highlights the %d peak: %s kg/ha",
                      peak_row$year, format(round(peak_row$maize_yield_kg_ha), big.mark = ","))
  ) +
  theme_portfolio()

ggsave(file.path(output_dir, "maize_yield_annual_column.svg"),
       p_column, width = 9, height = 5.5, device = "svg", bg = "white")

# 3. Annual line: teal shows year-to-year movement; rust marks the peak year.
p_line <- ggplot(df, aes(year, maize_yield_kg_ha)) +
  geom_line(colour = TEAL, linewidth = 0.9) +
  geom_point(colour = TEAL, fill = TEAL, shape = 21, size = 2.2, stroke = 0.45) +
  geom_point(data = peak_row, aes(year, maize_yield_kg_ha),
             inherit.aes = FALSE, colour = RUST, size = 3.2) +
  scale_x_continuous(breaks = x_breaks, limits = c(1959, 2011)) +
  scale_y_continuous(breaks = y_breaks, limits = c(900, 2200)) +
  labs(
    title = "Year-to-year movement in Kenya maize yield",
    x = "Year", y = "Maize yield (kg/ha)",
    caption = "51 annual observations · Annual fluctuations are distinct from the fitted long-run trend"
  ) +
  theme_portfolio()

ggsave(file.path(output_dir, "maize_yield_annual_line.svg"),
       p_line, width = 9, height = 5.5, device = "svg", bg = "white")

message("Three portfolio charts exported to ", output_dir)

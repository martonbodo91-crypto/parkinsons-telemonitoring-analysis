# ==============================================================
# 06_visualizations.R
# Parkinson's Telemonitoring Analysis
# Final visualizations for exploratory analysis and model results
# ==============================================================

library(tidyverse)
library(scales)

# --------------------------------------------------------------
# Load data and model outputs
# --------------------------------------------------------------

parkinsons <- read.csv("data/processed/cleaned_parkinsons.csv")

dir.create("plots", recursive = TRUE, showWarnings = FALSE)

# --------------------------------------------------------------
# 1. Distribution of motor_UPDRS
# --------------------------------------------------------------

motor_mean <- mean(parkinsons$motor_UPDRS, na.rm = TRUE)
motor_median <- median(parkinsons$motor_UPDRS, na.rm = TRUE)

hist_data <- ggplot_build(
  ggplot(parkinsons, aes(x = motor_UPDRS)) +
    geom_histogram(bins = 30)
)$data[[1]]

max_freq <- max(hist_data$count, na.rm = TRUE)

motor_updrs_distribution <- ggplot(parkinsons, aes(x = motor_UPDRS)) +
  geom_histogram(
    bins = 30,
    fill = "#2181BD",
    color = "white",
    linewidth = 0.6
  ) +
  geom_vline(
    xintercept = motor_mean,
    linewidth = 2,
    color = "#111111"
  ) +
  geom_vline(
    xintercept = motor_median,
    linewidth = 2,
    linetype = "dashed",
    color = "#555555"
  ) +
  annotate(
    "text",
    x = motor_mean + 7,
    y = max_freq * 0.88,
    label = paste0(
      "The mean motor_UPDRS score\nis approximately ",
      round(motor_mean, 1)
    ),
    hjust = 0,
    size = 5,
    fontface = "bold",
    color = "#111111"
  ) +
  annotate(
    "segment",
    x = motor_mean + 14.5,
    xend = motor_mean,
    y = max_freq * 0.85,
    yend = max_freq * 0.55,
    arrow = arrow(length = unit(0.25, "cm")),
    linewidth = 1.0,
    color = "#111111"
  ) +
  annotate(
    "text",
    x = motor_median - 16,
    y = max_freq * 0.52,
    label = paste0(
      "The median motor_UPDRS score\nis approximately ",
      round(motor_median, 1)
    ),
    hjust = 0,
    size = 5,
    fontface = "bold",
    color = "#333333"
  ) +
  annotate(
    "segment",
    x = motor_median - 14,
    xend = motor_median,
    y = max_freq * 0.47,
    yend = max_freq * 0.25,
    arrow = arrow(length = unit(0.22, "cm")),
    linewidth = 1.0,
    color = "#333333"
  ) +
  scale_x_continuous(
    breaks = pretty_breaks(n = 10),
    expand = expansion(mult = c(0.02, 0.04))
  ) +
  labs(
    title = "Distribution of motor_UPDRS scores",
    subtitle = "Distribution of motor symptom severity scores among Parkinson’s patients.",
    x = "motor_UPDRS",
    y = "Frequency",
    caption = "Source: Parkinson's Telemonitoring Dataset | Own visualization"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(
      size = 26,
      face = "bold",
      color = "#111111",
      margin = ggplot2::margin(b = 8)
    ),
    plot.subtitle = element_text(
      size = 14,
      color = "#666666",
      margin = ggplot2::margin(b = 22)
    ),
    plot.caption = element_text(
      size = 10,
      color = "#777777",
      hjust = 0,
      margin = ggplot2::margin(t = 20)
    ),
    axis.title = element_text(
      color = "#555555",
      size = 12
    ),
    axis.text = element_text(
      color = "#666666",
      size = 11,
      face = "bold"
    ),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(
      color = "#E6E6E6",
      linewidth = 0.5
    ),
    plot.background = element_rect(
      fill = "white",
      color = "#CCCCCC",
      linewidth = 0.8
    ),
    panel.background = element_rect(
      fill = "white",
      color = NA
    ),
    plot.margin = ggplot2::margin(30, 35, 30, 35)
  )

ggsave(
  "plots/motor_updrs_distribution.png",
  motor_updrs_distribution,
  width = 12,
  height = 8,
  dpi = 300
)

# --------------------------------------------------------------
# 2. Age vs motor_UPDRS
# --------------------------------------------------------------

age_vs_motor_updrs <- ggplot(parkinsons, aes(x = age, y = motor_UPDRS)) +
  geom_point(
    data = subset(parkinsons, sex == 1),
    aes(color = "Female"),
    alpha = 0.1,
    size = 5
  ) +
  geom_point(
    data = subset(parkinsons, sex == 0),
    aes(color = "Male"),
    alpha = 0.1,
    size = 5
  ) +
  geom_smooth(
    data = subset(parkinsons, sex == 1),
    aes(color = "Female"),
    method = "lm",
    se = FALSE,
    linewidth = 1.5
  ) +
  geom_smooth(
    data = subset(parkinsons, sex == 0),
    aes(color = "Male"),
    method = "lm",
    se = FALSE,
    linewidth = 1.5
  ) +
  scale_color_manual(
    values = c(
      "Female" = "#f48f50",
      "Male" = "#5491ca"
    ),
    name = "Sex"
  ) +
  labs(
    title = "Age and motor symptom severity in Parkinson’s disease",
    subtitle = "Comparison of motor symptom severity by age and sex",
    caption = "Source: Parkinson's Telemonitoring Dataset | Own visualization",
    x = "Age",
    y = "motor_UPDRS"
  ) +
  scale_y_continuous(
    breaks = seq(5, 40, by = 5)
  ) +
  coord_cartesian(ylim = c(5, 40)) +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(size = 26, face = "bold"),
    plot.subtitle = element_text(size = 14, margin = ggplot2::margin(b = 25)),
    axis.title.x = element_text(size = 16, margin = ggplot2::margin(t = 15)),
    axis.title.y = element_text(size = 16, margin = ggplot2::margin(r = 15)),
    plot.caption = element_text(hjust = 0, color = "#777777"),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    legend.position = c(0.85, 0.10),
    legend.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "grey85", linewidth = 0.6),
    panel.grid.minor = element_blank()
  )

ggsave(
  "plots/age_vs_motor_updrs.png",
  age_vs_motor_updrs,
  width = 12,
  height = 8,
  dpi = 300
)

# --------------------------------------------------------------
# 3. Boxplot of motor_UPDRS
# --------------------------------------------------------------

motor_updrs_boxplot <- ggplot(parkinsons, aes(x = "", y = motor_UPDRS)) +
  geom_boxplot(
    width = 0.35,
    fill = "#008CF0",
    color = "#004170",
    alpha = 0.40,
    linewidth = 0.70,
    outlier.shape = NA
  ) +
  geom_jitter(
    width = 0.08,
    alpha = 0.18,
    size = 2,
    color = "#3c7685"
  ) +
  stat_summary(
    fun = mean,
    geom = "point",
    shape = 23,
    size = 7,
    fill = "#3C678E",
    color = "#1C2B3E",
    stroke = 1
  ) +
  scale_y_continuous(
    breaks = seq(5, 40, by = 5)
  ) +
  coord_cartesian(ylim = c(5, 40)) +
  labs(
    title = "Boxplot of motor_UPDRS scores",
    subtitle = "Boxplot with individual observations and mean value",
    x = NULL,
    y = "motor_UPDRS"
  ) +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(
      size = 24,
      face = "bold",
      hjust = 0
    ),
    plot.subtitle = element_text(
      size = 14,
      color = "#555555",
      margin = ggplot2::margin(b = 20)
    ),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave(
  "plots/motor_updrs_boxplot.png",
  motor_updrs_boxplot,
  width = 9,
  height = 8,
  dpi = 300
)

# --------------------------------------------------------------
# 4. HNR vs motor_UPDRS
# --------------------------------------------------------------

parkinsons <- parkinsons %>%
  mutate(
    highlight = ifelse(
      HNR > median(HNR, na.rm = TRUE),
      "High HNR",
      "Low HNR"
    )
  )

hnr_vs_motor_updrs <- ggplot(parkinsons, aes(x = HNR, y = motor_UPDRS)) +
  geom_point(
    aes(color = highlight),
    alpha = 0.55,
    size = 2.5
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linewidth = 1.2,
    color = "#111111"
  ) +
  annotate(
    "curve",
    x = 31, y = 28,
    xend = 25, yend = 22,
    curvature = 0.25,
    arrow = arrow(length = unit(0.25, "cm")),
    linewidth = 0.8,
    color = "#222222"
  ) +
  annotate(
    "text",
    x = 31, y = 29,
    label = "Higher HNR generally suggests\nclearer voice quality.",
    hjust = 0,
    size = 4.5,
    fontface = "bold",
    color = "#444444"
  ) +
  scale_color_manual(
    values = c(
      "High HNR" = "#2c7fb8",
      "Low HNR" = "#f03b20"
    ),
    name = "Voice clarity group"
  ) +
  labs(
    title = "HNR and motor symptom severity",
    subtitle = "Relationship between voice clarity and motor_UPDRS scores",
    x = "HNR",
    y = "motor_UPDRS",
    caption = "Source: Parkinson's Telemonitoring Dataset | Own visualization"
  ) +
  theme_minimal(base_size = 15)

ggsave(
  "plots/hnr_vs_motor_updrs.png",
  hnr_vs_motor_updrs,
  width = 12,
  height = 8,
  dpi = 300
)

# --------------------------------------------------------------
# 5. Random Forest predicted vs actual
# --------------------------------------------------------------

if (file.exists("data/processed/random_forest_predictions.csv") &&
    file.exists("data/processed/random_forest_metrics.csv")) {

  rf_results <- read.csv("data/processed/random_forest_predictions.csv")
  rf_metrics <- read.csv("data/processed/random_forest_metrics.csv")

  R2_rf <- rf_metrics$R2[1]
  rmse_rf <- rf_metrics$RMSE[1]

  predicted_vs_actual_rf <- ggplot(rf_results, aes(x = actual, y = predicted)) +
    geom_point(
      alpha = 0.45,
      size = 4,
      color = "#1F5D8C"
    ) +
    geom_abline(
      slope = 1,
      intercept = 0,
      linewidth = 1.5,
      linetype = "dashed",
      color = "#04346e"
    ) +
    annotate(
      "text",
      x = min(rf_results$actual, na.rm = TRUE),
      y = max(rf_results$predicted, na.rm = TRUE) - 5,
      label = paste0(
        "Random Forest performance\n",
        "R² = ", round(R2_rf, 3), "\n",
        "RMSE = ", round(rmse_rf, 2)
      ),
      hjust = 0,
      size = 5,
      fontface = "bold",
      color = "#222222"
    ) +
    labs(
      title = "Predicted vs actual motor_UPDRS scores",
      subtitle = "Random Forest predictions compared with observed motor symptom severity",
      x = "Actual motor_UPDRS",
      y = "Predicted motor_UPDRS",
      caption = "Source: Parkinson's Telemonitoring Dataset"
    ) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(
        size = 24,
        face = "bold",
        color = "#111111",
        margin = ggplot2::margin(b = 8)
      ),
      plot.subtitle = element_text(
        size = 14,
        color = "#555555",
        margin = ggplot2::margin(b = 22)
      ),
      plot.caption = element_text(
        hjust = 0,
        color = "#777777"
      ),
      panel.grid.minor = element_blank()
    )

  ggsave(
    "plots/predicted_vs_actual_rf.png",
    predicted_vs_actual_rf,
    width = 12,
    height = 8,
    dpi = 300
  )
}

# --------------------------------------------------------------
# 6. Random Forest feature importance
# --------------------------------------------------------------

if (file.exists("data/processed/random_forest_feature_importance.csv")) {

  importance_df <- read.csv("data/processed/random_forest_feature_importance.csv")

  feature_importance_rf <- ggplot(
    importance_df,
    aes(x = reorder(feature, IncNodePurity), y = IncNodePurity)
  ) +
    geom_col(
      fill = "#0c5a95",
      width = 0.65
    ) +
    coord_flip() +
    labs(
      title = "Feature importance in the RF model",
      subtitle = "The most influential predictors used to estimate motor symptom severity",
      x = NULL,
      y = "Increase in node purity",
      caption = "Source: Parkinson's Telemonitoring Dataset | Own visualization"
    ) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(
        size = 24,
        face = "bold",
        color = "#111111",
        margin = ggplot2::margin(b = 8)
      ),
      plot.subtitle = element_text(
        size = 14,
        color = "#555555",
        margin = ggplot2::margin(b = 22)
      ),
      axis.title.x = element_text(
        size = 13,
        color = "#555555",
        margin = ggplot2::margin(t = 12)
      ),
      axis.text = element_text(
        size = 12,
        color = "#444444",
        face = "bold"
      ),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_line(
        color = "#E5E5E5",
        linewidth = 0.5
      )
    )

  ggsave(
    "plots/feature_importance_rf.png",
    feature_importance_rf,
    width = 12,
    height = 8,
    dpi = 300
  )
}

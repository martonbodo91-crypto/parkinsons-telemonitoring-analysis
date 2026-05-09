# ==============================
# Parkinson's Telemonitoring Analysis
# ==============================
# ==============================================================
# Parkinson’s Telemonitoring Dataset – Variable Description
# ==============================================================

# -------------------------
# IDENTIFIERS / DEMOGRAPHY
# -------------------------

# subject#      : Patient ID (unique identifier for each patient)
# age           : Age of the patient (in years)
# sex           : Biological sex (0 = male, 1 = female)

# -------------------------
# TIME VARIABLE
# -------------------------

# test_time     : Time in days since the patient's first measurement
#                 (makes the dataset longitudinal)

# -------------------------
# CLINICAL OUTCOMES
# -------------------------

# motor_UPDRS   : Motor symptoms score (movement-related Parkinson severity)
# total_UPDRS   : Total clinical score (overall Parkinson severity)
#                 Higher values = more severe condition

# -------------------------
# VOICE / ACOUSTIC FEATURES
# -------------------------

# Jitter(%)       : Frequency variation in voice (percent)
# Jitter(Abs)     : Absolute frequency variation
# Jitter:RAP      : Relative Average Perturbation
# Jitter:PPQ5     : Five-point Period Perturbation Quotient
# Jitter:DDP      : Difference of Differences of Periods

# Shimmer         : Amplitude variation in voice
# Shimmer(dB)     : Amplitude variation in decibels
# Shimmer:APQ3    : 3-point Amplitude Perturbation Quotient
# Shimmer:APQ5    : 5-point Amplitude Perturbation Quotient
# Shimmer:APQ11   : 11-point Amplitude Perturbation Quotient
# Shimmer:DDA     : Average absolute differences of amplitudes

# NHR             : Noise-to-Harmonics Ratio (voice noisiness)
# HNR             : Harmonics-to-Noise Ratio (voice clarity)

# RPDE            : Recurrence Period Density Entropy (nonlinear dynamic measure)
# DFA             : Detrended Fluctuation Analysis (signal complexity measure)
# PPE             : Pitch Period Entropy (pitch variability entropy)

# --------------------------------------------------------------
# DATA STRUCTURE SUMMARY
# --------------------------------------------------------------
# - Multiple patients
# - Multiple measurements per patient
# - Longitudinal dataset
# - Goal (typical use): Predict total_UPDRS from voice features
# --------------------------------------------------------------


# ==============================
# 1. LIBRARIES
# ==============================
library(tidyverse)
library(skimr)
library(randomForest)
library(car)
library(scales)


# ==============================
# 2. DATA IMPORT
# ==============================

parkinsons <- read.csv("/Users/marci/Desktop/rep_first_project copy/parkinsons+telemonitoring 3/parkinsons_updrs.csv")

# Oszlopnevek tisztítása
names(parkinsons) <- make.names(names(parkinsons))

# ==============================
# 3. INITIAL EXPLORATION
# ==============================

skim(parkinsons)
glimpse(parkinsons)

# Missing values check
colSums(is.na(parkinsons))

# ==============================
# 4. EDA (Exploratory Data Analysis)
# ==============================

# 1.1 Histogram

# Alap statisztikák az annotációkhoz
motor_mean <- mean(parkinsons$motor_UPDRS, na.rm = TRUE)
motor_median <- median(parkinsons$motor_UPDRS, na.rm = TRUE)

# Hisztogram adat előkészítése, hogy tudjunk max frekvenciát számolni
hist_data <- ggplot_build(
  ggplot(parkinsons, aes(x = motor_UPDRS)) +
    geom_histogram(bins = 30)
)$data[[1]]

max_freq <- max(hist_data$count, na.rm = TRUE)

# Ábra
histo1 <- ggplot(parkinsons, aes(x = motor_UPDRS)) +
  geom_histogram(
    bins = 30,
    fill = "#2181BD",
    color = "white",
    linewidth = 0.6
  ) +

  
  # Átlag vonal
  geom_vline(
    xintercept = motor_mean,
    linewidth = 2,
    color = "#111111"
  ) +
  
  # Medián vonal
  geom_vline(
    xintercept = motor_median,
    linewidth = 2,
    linetype = "dashed",
    color = "#555555"
  ) +
  
  # Átlag annotáció
  annotate(
    "text",
    x = motor_mean + 7,
    y = max_freq * 0.88,
   label = paste0("The mean motor_UPDRS score\nis approximately ",
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
  
  # Medián annotáció
  annotate(
    "text",
    x = motor_median - 16,
    y = max_freq * 0.52,
    label = paste0(
      "The median motor_UPDRS score \nis approximately ",
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
  
  scale_y_continuous(
    breaks = pretty_breaks(n = 6),
    expand = expansion(mult = c(0, 0.15))
  ) +
  
  labs(
    title = "Histogram of motor_UPDRS scores",
    subtitle = "Distribution of motor symptom severity scores among Parkinson’s patients.",
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
# 1.2 Scatter: Age vs motor_UPDRS
scatter1 <- ggplot(parkinsons, aes(x = age, y = motor_UPDRS)) +
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
    panel.grid.minor = element_blank(),
    plot.margin = ggplot2::margin(20, 30, 20, 20)
  )


# Correlation
cor(parkinsons$age, parkinsons$motor_UPDRS)

# Summary stats
summary(parkinsons$motor_UPDRS)
sd(parkinsons$motor_UPDRS)


# 1.3 Boxplot of distribution of motor_UPDRS scores
boxplot2 <- ggplot(parkinsons, aes(x = "", y = motor_UPDRS)) +
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
      size = 15,
      hjust = 0,
      margin = ggplot2::margin(b = 20)
    ),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.y = element_text(
      size = 15,
      margin = ggplot2::margin(r = 12)
    ),
    axis.text.y = element_text(size = 13),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(
      color = "grey86",
      linewidth = 0.6
    ),
    plot.background = element_rect(fill = "#F7F7F7", color = NA),
    panel.background = element_rect(fill = "#F7F7F7", color = NA),
    plot.margin = ggplot2::margin(20, 30, 20, 20)
  )


# ==============================
# 5. CORRELATION ANALYSIS
# ==============================

numeric_data <- parkinsons %>% select(where(is.numeric))

cor_matrix <- cor(numeric_data)

cor_with_target <- cor_matrix[, "motor_UPDRS"] %>%
  sort(decreasing = TRUE)

print(cor_with_target)

# ==============================
# 6. FEATURE VISUALIZATION
# ==============================

selected_features <- c("PPE", "Shimmer.APQ11", "Jitter.RAP", "HNR")

feature_correlations <- parkinsons %>%
  select(all_of(selected_features), motor_UPDRS) %>%
  summarise(
    across(
      all_of(selected_features),
      ~ cor(.x, motor_UPDRS, use = "complete.obs")
    )
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Feature",
    values_to = "Correlation_with_motor_UPDRS"
  ) %>%
  arrange(desc(abs(Correlation_with_motor_UPDRS)))

print(feature_correlations)

# Highlight variable for HNR visualization
# If HNR is above the median, it is labeled as "High HNR";
# otherwise it is labeled as "Low HNR".


parkinsons <- parkinsons %>%
  mutate(
    highlight = ifelse(
      HNR > median(HNR, na.rm = TRUE),
      "High HNR",
      "Low HNR"
    )
  )

Clearer_voice <- ggplot(parkinsons, aes(x = HNR, y = motor_UPDRS)) +
  
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
      "High HNR" = "#D6BD3E",
      "Low HNR" = "#7E7A91"
    )
  ) +
  
  labs(
    title = "Clearer voice, lower motor severity?",
    subtitle = "Higher HNR values tend to be associated with lower motor_UPDRS scores, although the relationship is weak.",
    x = "HNR",
    y = "Motor UPDRS",
    color = NULL,
    caption = "Source: Parkinson's Telemonitoring Dataset | Own visualization"
  ) +
  
  theme_minimal(base_size = 15) +
  
  theme(
    plot.title = element_text(face = "bold", size = 28),
    plot.subtitle = element_text(size = 15, color = "#333333"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#E6E6E6"),
    legend.position = "top",
    plot.caption = element_text(hjust = 0, color = "#777777")
  )


# ==============================
# 7. TRAIN / TEST SPLIT
# ==============================

set.seed(42)

train_subjects <- sample(
  unique(parkinsons$subject.),
  size = 0.8 * length(unique(parkinsons$subject.))
)

train <- parkinsons %>% filter(subject. %in% train_subjects)
test  <- parkinsons %>% filter(!subject. %in% train_subjects)


# ==============================
# 8. LINEAR MODEL
# ==============================

lm_model <- lm(
  motor_UPDRS ~ PPE + Shimmer.APQ11 + Jitter.RAP + HNR + age + sex,
  data = train
)

summary(lm_model)

# Multicollinearity check
vif(lm_model)

# Prediction - Linear Model
pred_lm <- predict(lm_model, test)

# RMSE - Linear Model
rmse_lm <- sqrt(mean((test$motor_UPDRS - pred_lm)^2))
print(rmse_lm)

# R² - Linear Model
R2_lm <- cor(pred_lm, test$motor_UPDRS)^2
print(R2_lm)


# ==============================
# 9. RANDOM FOREST MODEL
# ==============================

rf_model <- randomForest(
  motor_UPDRS ~ PPE + Shimmer.APQ11 + Jitter.RAP + HNR + age + sex,
  data = train,
  importance = TRUE
)

# Prediction - Random Forest
pred_rf <- predict(rf_model, test)


# ==============================
# 10/A RANDOM FOREST EVALUATION
# ==============================

# R² - Random Forest
R2_rf <- cor(pred_rf, test$motor_UPDRS)^2
print(R2_rf)


# RMSE - Random Forest
rmse_rf <- sqrt(mean((test$motor_UPDRS - pred_rf)^2))
print(rmse_rf)

# ==============================
# 10/B. PREDICTED VS ACTUAL PLOT
# ==============================

rf_results <- data.frame(
  actual = test$motor_UPDRS,
  predicted = pred_rf
)

predicted_plot <- ggplot(rf_results, aes(x = actual, y = predicted)) +
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
    x = min(rf_results$actual, na.rm = TRUE) + 0,
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
    axis.title = element_text(
      size = 13,
      color = "#555555"
    ),
    axis.text = element_text(
      size = 12,
      color = "#444444",
      face = "bold"
    ),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(
      color = "#E5E5E5",
      linewidth = 0.5
    ),
    plot.caption = element_text(
      size = 10,
      color = "#777777",
      hjust = 0,
      margin = ggplot2::margin(t = 18)
    ),
    plot.background = element_rect(
      fill = "white",
      color = "#D0D0D0",
      linewidth = 0.8
    ),
    panel.background = element_rect(
      fill = "white",
      color = NA
    ),
    plot.margin = ggplot2::margin(25, 35, 25, 25)
  )

# ==============================
# 10/C. FEATURE IMPORTANCE PLOT
# ==============================

importance_df <- importance(rf_model) %>%
  as.data.frame() %>%
  rownames_to_column("feature") %>%
  arrange(desc(IncNodePurity))

importance_plot <- ggplot(
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
    ),
    plot.caption = element_text(
      size = 10,
      color = "#777777",
      hjust = 0,
      margin = ggplot2::margin(t = 18)
    ),
    plot.background = element_rect(
      fill = "white",
      color = "#D0D0D0",
      linewidth = 0.8
    ),
    panel.background = element_rect(
      fill = "white",
      color = NA
    ),
    plot.margin = ggplot2::margin(25, 35, 25, 25)
  )

# ==============================
# 11. MODEL COMPARISON TABLE
# ==============================

model_comparison <- data.frame(
  Model = c("Linear Regression", "Random Forest"),
  RMSE = c(rmse_lm, rmse_rf),
  R2 = c(R2_lm, R2_rf)
)
print(model_comparison)

cat("Actual motor_UPDRS summary:\n")
print(summary(test$motor_UPDRS))

cat("\nPredicted motor_UPDRS summary:\n")
print(summary(pred_rf))
#A modell nem teljesen hibás, de erősen középre húzza a becsléseket. Emiatt a magasabb motor_UPDRS értékeket nem tudja jól megjósolni. Ez inkább modell- és adatprobléma, nem egyszerű kódhiba.

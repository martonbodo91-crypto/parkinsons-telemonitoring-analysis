# ==============================================================
# 03_correlation_analysis.R
# Parkinson's Telemonitoring Analysis
# Correlation analysis with motor_UPDRS
# ==============================================================

library(tidyverse)

# --------------------------------------------------------------
# Load cleaned data
# --------------------------------------------------------------

parkinsons <- read.csv("data/processed/cleaned_parkinsons.csv")

# --------------------------------------------------------------
# Numeric correlation matrix
# --------------------------------------------------------------

numeric_data <- parkinsons %>%
  select(where(is.numeric))

cor_matrix <- cor(
  numeric_data,
  use = "complete.obs"
)

cor_with_target <- cor_matrix[, "motor_UPDRS"] %>%
  sort(decreasing = TRUE)

print(cor_with_target)

# --------------------------------------------------------------
# Selected feature correlations
# --------------------------------------------------------------

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

# Simple age correlation
age_motor_correlation <- cor(
  parkinsons$age,
  parkinsons$motor_UPDRS,
  use = "complete.obs"
)

print(age_motor_correlation)

# --------------------------------------------------------------
# Save correlation outputs
# --------------------------------------------------------------

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

write.csv(
  data.frame(
    Feature = names(cor_with_target),
    Correlation_with_motor_UPDRS = as.numeric(cor_with_target)
  ),
  "data/processed/correlations_with_motor_updrs.csv",
  row.names = FALSE
)

write.csv(
  feature_correlations,
  "data/processed/selected_feature_correlations.csv",
  row.names = FALSE
)

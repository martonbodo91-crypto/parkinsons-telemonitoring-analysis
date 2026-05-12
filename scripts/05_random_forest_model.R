# ==============================================================
# 05_random_forest_model.R
# Parkinson's Telemonitoring Analysis
# Random Forest model for motor_UPDRS
# ==============================================================

library(tidyverse)
library(randomForest)

# --------------------------------------------------------------
# Load cleaned data
# --------------------------------------------------------------

parkinsons <- read.csv("data/processed/cleaned_parkinsons.csv")

# --------------------------------------------------------------
# Train / test split by subject
# The same seed and split logic are used as in the linear model.
# --------------------------------------------------------------

set.seed(42)

train_subjects <- sample(
  unique(parkinsons$subject.),
  size = 0.8 * length(unique(parkinsons$subject.))
)

train <- parkinsons %>%
  filter(subject. %in% train_subjects)

test <- parkinsons %>%
  filter(!subject. %in% train_subjects)

# --------------------------------------------------------------
# Random Forest model
# --------------------------------------------------------------

rf_model <- randomForest(
  motor_UPDRS ~ PPE + Shimmer.APQ11 + Jitter.RAP + HNR + age + sex,
  data = train,
  importance = TRUE
)

print(rf_model)

# --------------------------------------------------------------
# Prediction and evaluation
# --------------------------------------------------------------

pred_rf <- predict(rf_model, test)

R2_rf <- cor(pred_rf, test$motor_UPDRS)^2
rmse_rf <- sqrt(mean((test$motor_UPDRS - pred_rf)^2))

print(R2_rf)
print(rmse_rf)

rf_results <- data.frame(
  actual = test$motor_UPDRS,
  predicted = pred_rf
)

importance_df <- importance(rf_model) %>%
  as.data.frame() %>%
  rownames_to_column("feature") %>%
  arrange(desc(IncNodePurity))

rf_metrics <- data.frame(
  Model = "Random Forest",
  RMSE = rmse_rf,
  R2 = R2_rf
)

# --------------------------------------------------------------
# Model comparison
# --------------------------------------------------------------

lm_metrics_path <- "data/processed/linear_regression_metrics.csv"

if (file.exists(lm_metrics_path)) {
  lm_metrics <- read.csv(lm_metrics_path)

  model_comparison <- bind_rows(
    lm_metrics,
    rf_metrics
  )

  print(model_comparison)

  write.csv(
    model_comparison,
    "data/processed/model_comparison.csv",
    row.names = FALSE
  )
}

cat("Actual motor_UPDRS summary:\n")
print(summary(test$motor_UPDRS))

cat("\nPredicted motor_UPDRS summary:\n")
print(summary(pred_rf))

# --------------------------------------------------------------
# Save model outputs
# --------------------------------------------------------------

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

write.csv(
  rf_results,
  "data/processed/random_forest_predictions.csv",
  row.names = FALSE
)

write.csv(
  importance_df,
  "data/processed/random_forest_feature_importance.csv",
  row.names = FALSE
)

write.csv(
  rf_metrics,
  "data/processed/random_forest_metrics.csv",
  row.names = FALSE
)

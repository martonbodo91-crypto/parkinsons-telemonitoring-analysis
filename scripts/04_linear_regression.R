# ==============================================================
# 04_linear_regression.R
# Parkinson's Telemonitoring Analysis
# Linear regression model for motor_UPDRS
# ==============================================================

library(tidyverse)
library(car)

# --------------------------------------------------------------
# Load cleaned data
# --------------------------------------------------------------

parkinsons <- read.csv("data/processed/cleaned_parkinsons.csv")

# --------------------------------------------------------------
# Train / test split by subject
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
# Linear model
# --------------------------------------------------------------

lm_model <- lm(
  motor_UPDRS ~ PPE + Shimmer.APQ11 + Jitter.RAP + HNR + age + sex,
  data = train
)

print(summary(lm_model))

# Multicollinearity check
vif_values <- vif(lm_model)
print(vif_values)

# --------------------------------------------------------------
# Prediction and evaluation
# --------------------------------------------------------------

pred_lm <- predict(lm_model, test)

rmse_lm <- sqrt(mean((test$motor_UPDRS - pred_lm)^2))
R2_lm <- cor(pred_lm, test$motor_UPDRS)^2

print(rmse_lm)
print(R2_lm)

lm_results <- data.frame(
  actual = test$motor_UPDRS,
  predicted = pred_lm
)

lm_metrics <- data.frame(
  Model = "Linear Regression",
  RMSE = rmse_lm,
  R2 = R2_lm
)

# --------------------------------------------------------------
# Save model outputs
# --------------------------------------------------------------

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

write.csv(
  lm_results,
  "data/processed/linear_regression_predictions.csv",
  row.names = FALSE
)

write.csv(
  lm_metrics,
  "data/processed/linear_regression_metrics.csv",
  row.names = FALSE
)

write.csv(
  data.frame(
    Feature = names(vif_values),
    VIF = as.numeric(vif_values)
  ),
  "data/processed/linear_regression_vif.csv",
  row.names = FALSE
)

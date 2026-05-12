# ==============================================================
# 02_exploratory_analysis.R
# Parkinson's Telemonitoring Analysis
# Basic descriptive statistics and exploratory summaries
# ==============================================================

library(tidyverse)
library(skimr)

# --------------------------------------------------------------
# Load cleaned data
# --------------------------------------------------------------

parkinsons <- read.csv("data/processed/cleaned_parkinsons.csv")

# --------------------------------------------------------------
# Dataset overview
# --------------------------------------------------------------

skim(parkinsons)
glimpse(parkinsons)

# Missing values check
missing_values <- colSums(is.na(parkinsons))
print(missing_values)

# --------------------------------------------------------------
# Descriptive statistics for the main clinical target
# --------------------------------------------------------------

motor_summary <- summary(parkinsons$motor_UPDRS)
motor_sd <- sd(parkinsons$motor_UPDRS, na.rm = TRUE)

print(motor_summary)
print(motor_sd)

# --------------------------------------------------------------
# Descriptive statistics by sex
# sex: 0 = male, 1 = female
# --------------------------------------------------------------

motor_by_sex <- parkinsons %>%
  group_by(sex) %>%
  summarise(
    n = n(),
    mean_motor_UPDRS = mean(motor_UPDRS, na.rm = TRUE),
    median_motor_UPDRS = median(motor_UPDRS, na.rm = TRUE),
    sd_motor_UPDRS = sd(motor_UPDRS, na.rm = TRUE),
    .groups = "drop"
  )

print(motor_by_sex)

# --------------------------------------------------------------
# Save exploratory summaries
# --------------------------------------------------------------

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

write.csv(
  motor_by_sex,
  "data/processed/motor_updrs_by_sex.csv",
  row.names = FALSE
)

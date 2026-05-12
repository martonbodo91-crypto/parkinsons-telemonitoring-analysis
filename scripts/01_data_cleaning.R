# ==============================================================
# 01_data_cleaning.R
# Parkinson's Telemonitoring Analysis
# Data import, basic cleaning, and processed dataset export
# ==============================================================

library(tidyverse)
library(skimr)

# --------------------------------------------------------------
# Data import
# --------------------------------------------------------------

raw_data_path <- "data/raw/parkinsons_updrs.csv"

parkinsons <- read.csv(raw_data_path)

# Clean column names so names such as "subject#" become valid R names.
names(parkinsons) <- make.names(names(parkinsons))

# --------------------------------------------------------------
# Initial checks
# --------------------------------------------------------------

skim(parkinsons)
glimpse(parkinsons)

missing_values <- colSums(is.na(parkinsons))
print(missing_values)

# --------------------------------------------------------------
# Save cleaned dataset
# --------------------------------------------------------------

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

write.csv(
  parkinsons,
  "data/processed/cleaned_parkinsons.csv",
  row.names = FALSE
)

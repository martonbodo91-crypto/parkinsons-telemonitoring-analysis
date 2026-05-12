# Required packages for the Parkinson's Telemonitoring Analysis project

packages <- c(
  "tidyverse",
  "skimr",
  "randomForest",
  "car",
  "scales"
)

install_if_missing <- function(package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
}

invisible(lapply(packages, install_if_missing))

invisible(lapply(packages, library, character.only = TRUE))
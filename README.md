# Parkinson’s Telemonitoring Analysis

A healthcare data analysis project in R using the Oxford Parkinson’s Disease Telemonitoring Dataset.

The project explores whether voice-related biomedical features are associated with Parkinson’s disease motor symptom severity, measured by `motor_UPDRS`. The analysis includes exploratory data analysis, correlation analysis, linear regression, Random Forest modeling, model evaluation, and feature importance analysis.

This project was built as part of my data analysis learning journey and portfolio development, with a focus on healthcare data, statistical analysis, data visualization, and introductory machine learning.

---

## Project Question

Can voice-based biomedical measurements help estimate motor symptom severity in Parkinson’s disease?

More specifically, the project focuses on:

- exploring the structure and quality of the dataset,
- understanding the distribution of `motor_UPDRS`,
- analyzing relationships between acoustic voice features and motor symptom severity,
- comparing a linear regression model with a Random Forest model,
- evaluating model performance using RMSE and R²,
- identifying the most influential predictors in the Random Forest model.

---

## Dataset

The project uses the Oxford Parkinson’s Disease Telemonitoring Dataset.

According to the dataset description, it contains biomedical voice measurements from 42 people with early-stage Parkinson’s disease who participated in a six-month telemonitoring study. Each row represents one voice recording, resulting in 5,875 observations.

The dataset includes:

- patient identifier,
- age,
- sex,
- time since recruitment,
- motor UPDRS score,
- total UPDRS score,
- biomedical voice measurements.

The main outcome variable used in this project is:

- `motor_UPDRS`: clinician-rated motor symptom severity score.

---

## Main Variables

### Patient and time-related variables

| Variable | Description |
|---|---|
| `subject.` | Patient identifier after cleaning the original `subject#` column name |
| `age` | Age of the patient |
| `sex` | Biological sex; 0 = male, 1 = female |
| `test_time` | Time since recruitment into the study |

### Clinical variables

| Variable | Description |
|---|---|
| `motor_UPDRS` | Motor symptom severity score |
| `total_UPDRS` | Total Parkinson’s disease severity score |

### Voice-related biomedical features

| Feature group | Variables |
|---|---|
| Jitter features | `Jitter...`, `Jitter.Abs.`, `Jitter.RAP`, `Jitter.PPQ5`, `Jitter.DDP` |
| Shimmer features | `Shimmer`, `Shimmer.dB.`, `Shimmer.APQ3`, `Shimmer.APQ5`, `Shimmer.APQ11`, `Shimmer.DDA` |
| Noise / harmonic features | `NHR`, `HNR` |
| Nonlinear voice features | `RPDE`, `DFA`, `PPE` |

---

## Tools and Packages

The analysis is written in R and uses the following packages:

- `tidyverse`
- `skimr`
- `ggpubr`
- `randomForest`
- `car`

---

## Analysis Workflow

### 1. Data Import and Initial Exploration

The dataset is imported from a CSV file. The first step checks the structure of the dataset using summary and inspection functions.

The workflow includes:

- reading the dataset,
- inspecting the data structure,
- checking variable types,
- creating a numeric-only dataset for correlation analysis,
- cleaning column names with `make.names()`.

### 2. Missing Value Check

The project checks missing values using column-wise aggregation.

In the provided dataset, no missing values were detected.

### 3. Exploratory Data Analysis

The exploratory analysis focuses on `motor_UPDRS` and its relationship with demographic and voice-related variables.

The project includes visualizations such as:

- histogram of `motor_UPDRS`,
- boxplot of `motor_UPDRS`,
- scatter plot of `age` vs `motor_UPDRS`,
- scatter plots of selected voice features vs `motor_UPDRS`.

Selected voice features explored in detail include:

- `PPE`,
- `Shimmer.APQ11`,
- `Jitter.RAP`,
- `Jitter.PPQ5`,
- `Jitter.DDP`,
- `HNR`.

### 4. Correlation Analysis

The project calculates correlations between numeric variables and `motor_UPDRS` to identify which variables show stronger linear relationships with motor symptom severity.

This step helps guide the selection of predictors for modeling.

### 5. Linear Regression Model

A linear regression model is built to predict `motor_UPDRS` using selected voice and demographic variables:

```r
motor_UPDRS ~ PPE + Shimmer.APQ11 + Jitter.RAP + HNR + age + sex
```

The model is evaluated using:

- model summary,
- R²,
- RMSE,
- VIF values for multicollinearity checking.

In the current analysis, the linear model explains only a limited part of the variation in `motor_UPDRS`, with an R² of approximately 0.10.

### 6. Random Forest Model

A Random Forest regression model is trained using the same selected predictors.

The code uses an 80/20 random row-based train-test split:

- 80% of rows for training,
- 20% of rows for testing.

The Random Forest model is evaluated using:

- RMSE,
- R² based on the correlation between predicted and actual values,
- feature importance.

Because the dataset contains repeated measurements from the same patients, a row-based split may overestimate performance. A patient-level split would be a stronger validation approach for future improvement.

---

## Model Evaluation

The project compares linear regression and Random Forest models.

| Model | Evaluation approach |
|---|---|
| Linear Regression | RMSE calculated on the full dataset used for fitting |
| Random Forest | RMSE and R² calculated on the test set after an 80/20 row-based split |

The linear regression model provides a simple and interpretable baseline. The Random Forest model captures more complex, nonlinear relationships, but its performance should be interpreted carefully because repeated measurements from the same patients can make row-based train-test splits overly optimistic.

---

## Feature Importance

The Random Forest model is also used to inspect feature importance.

The selected predictors are:

- `PPE`,
- `Shimmer.APQ11`,
- `Jitter.RAP`,
- `HNR`,
- `age`,
- `sex`.

Feature importance helps identify which variables contributed most strongly to the Random Forest predictions in the current model.

---

## Key Findings

Based on the current analysis:

- The dataset contains repeated telemonitoring measurements from patients with Parkinson’s disease.
- `motor_UPDRS` is used as the main target variable for motor symptom severity.
- No missing values were detected in the dataset.
- Age shows a visible relationship with `motor_UPDRS` in the exploratory analysis.
- Selected voice-related features show some relationship with `motor_UPDRS`, but the linear regression model explains only a limited part of the variance.
- The Random Forest model performs better than the linear regression model in the current row-based split.
- The Random Forest result should be interpreted carefully because repeated measurements from the same patients may lead to optimistic performance estimates.

---

## Limitations

This project is an exploratory portfolio analysis and has several limitations:

- The train-test split is row-based, not patient-based.
- Repeated measurements from the same patients may appear in both training and test sets.
- The linear regression model uses only a selected subset of predictors.
- The project focuses on `motor_UPDRS`, although the dataset also contains `total_UPDRS`.
- The analysis is not intended for clinical diagnosis or medical decision-making.

---

## Future Improvements

Possible next steps:

- use a patient-level train-test split based on `subject.`,
- compare additional machine learning models,
- tune Random Forest hyperparameters,
- add cross-validation,
- analyze `total_UPDRS` as a second target variable,
- create polished portfolio-ready visualizations,
- save generated plots into a dedicated `plots/` folder,
- write a short article explaining the analysis and results.

---

## Files

| File | Description |
|---|---|
| `parkinson.r` | Main R analysis script |
| `parkinsons_updrs.csv` | Dataset used in the analysis |
| `parkinsons_updrs.names` | Dataset description and variable information |

---

## How to Run the Project

1. Clone the repository.
2. Open the project in RStudio or Visual Studio Code.
3. Install the required R packages.
4. Place `parkinsons_updrs.csv` in the project folder.
5. Update the CSV path in `parkinson.r` if needed.
6. Run the script step by step.

Required packages:

```r
install.packages(c("tidyverse", "skimr", "ggpubr", "randomForest", "car"))
```

---

## Citation

If using this dataset, cite the original study:

Tsanas, A., Little, M. A., McSharry, P. E., & Ramig, L. O. (2009). Accurate telemonitoring of Parkinson’s disease progression by non-invasive speech tests. IEEE Transactions on Biomedical Engineering.

---

## Goal

My goal with this project is to strengthen my skills in healthcare data analysis, statistical modeling, data visualization, and introductory machine learning.

I am especially interested in healthcare, neuroscience, and biomedical datasets, and in turning complex data into clear, meaningful, and visually engaging insights.

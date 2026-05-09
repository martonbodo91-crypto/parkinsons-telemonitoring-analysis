# Parkinson’s Telemonitoring Analysis

A healthcare data analysis project focused on exploring Parkinson’s disease telemonitoring data using R.

The project investigates how voice-related biomedical features may be connected to Parkinson’s disease severity, especially motor_UPDRS scores. I built this project as part of my data analysis learning journey and portfolio development, with a focus on healthcare data, statistical analysis, data visualization, and introductory machine learning.

The main goal was not only to build predictive models, but also to understand the dataset, explore meaningful patterns, and communicate the results clearly through visualizations and interpretation.

---

## Technologies

- R
- tidyverse
- ggplot2
- skimr
- randomForest
- car
- scales
- Visual Studio Code
- GitHub

---

##  Project Overview

The dataset contains telemonitoring data from people with Parkinson’s disease. It includes demographic variables, clinical scores, and several voice-related biomedical features.

The analysis focuses mainly on `motor_UPDRS`, which represents motor symptom severity in Parkinson’s disease.

Main areas of the project:

- Exploratory Data Analysis
- Missing value checking
- Distribution analysis
- Correlation analysis
- Feature visualization
- Linear Regression modeling
- Random Forest modeling
- Model evaluation
- Feature importance analysis

---

## Dataset

The dataset includes repeated measurements from multiple patients, making it a longitudinal dataset.

Key variable groups:

### Patient and time-related variables

- `subject.`: patient identifier
- `age`: age of the patient
- `sex`: biological sex
- `test_time`: time since the first measurement

### Clinical outcome variables

- `motor_UPDRS`: motor symptom severity score
- `total_UPDRS`: total Parkinson’s disease severity score

### Voice-related biomedical features

- Jitter features
- Shimmer features
- NHR
- HNR
- RPDE
- DFA
- PPE

These voice features were used to explore whether acoustic patterns may be related to Parkinson’s disease severity.

---

##  What the Project Does

This project walks through a complete beginner-friendly healthcare data analysis workflow.

### Explore the data

I started by checking the structure of the dataset, missing values, variable types, and summary statistics.

### Visualize motor symptom severity

I created visualizations to understand the distribution of `motor_UPDRS` scores, including:

- Histogram
- Boxplot
- Age vs motor_UPDRS scatter plot

### Analyze correlations

I calculated correlations between numeric variables and `motor_UPDRS` to identify which features may be more strongly related to motor symptom severity.

### Explore selected voice biomarkers

I selected several voice-related features, such as:

- PPE
- Shimmer.APQ11
- Jitter.RAP
- HNR

These features were analyzed separately to better understand their relationship with `motor_UPDRS`.

### Build predictive models

I trained two models:

- Linear Regression
- Random Forest

The models were used to predict `motor_UPDRS` scores based on selected voice features and demographic variables.

### Evaluate model performance

The models were evaluated using:

- RMSE
- R²

I also created a predicted vs actual plot to visually inspect the Random Forest model’s performance.

### Analyze feature importance

Finally, I used Random Forest feature importance to understand which predictors had the strongest influence in the model.

---

##  Visualizations

The project includes several visualizations, such as:

- Distribution of motor_UPDRS scores
- Age and motor symptom severity by sex
- Boxplot of motor_UPDRS scores
- HNR and motor_UPDRS relationship
- Predicted vs actual motor_UPDRS scores
- Random Forest feature importance

Example visualizations can be found in the `plots/` folder.

---

##  The Process

I started the project by understanding the structure of the Parkinson’s Telemonitoring Dataset. First, I explored the variables, checked for missing values, and reviewed the meaning of the most important clinical and voice-related features.

After that, I focused on the clinical outcome variable `motor_UPDRS`, because it represents motor symptom severity. I created a histogram and a boxplot to understand how the values were distributed across the dataset.

Next, I explored how age and sex relate to motor symptom severity. This helped me understand whether demographic variables might play a role in the analysis.

Then I moved on to correlation analysis. I calculated the relationship between numeric variables and `motor_UPDRS`, which helped me identify potentially relevant predictors.

Based on this step, I selected several voice-related biomedical features, including PPE, Shimmer.APQ11, Jitter.RAP, and HNR. I examined these features more closely because they are related to voice quality, pitch variation, and acoustic irregularity.

After the exploratory phase, I split the data into training and testing sets by patient ID. - Data Science

## Goal

My goal is to stand out in healthcare data analysis by developing strong skills in data visualization, statistical analysis, and Data Science.

I am especially interested in working with healthcare, neuroscience, and biomedical datasets, and turning complex data into clear, meaningful, and visually engaging insights.

## How to reach me

You can reach me here on GitHub or through my LinkedIn profile.

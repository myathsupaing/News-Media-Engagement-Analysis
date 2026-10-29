
# Marketing Case Analysis: Drivers of Online Article Engagement

## Project Overview

This project investigates which content characteristics, multimedia features, sentiment indicators, and publication timing variables are associated with online article engagement.

Using R and the `Global_media_data.csv` dataset, the analysis combines exploratory data analysis (EDA), data cleaning, correlation analysis, Principal Component Analysis (PCA), multiple linear regression, and k-means clustering to explore engagement patterns and identify distinct article profiles.

The project demonstrates how statistical analysis and unsupervised learning can support data-driven content and marketing decisions.

## Objectives

1. **Explore engagement drivers:** Investigate associations between article engagement and content characteristics, multimedia features, sentiment, and publication timing.

2. **Develop a regression model:** Examine how selected explanatory variables relate to log-transformed engagement using multiple linear regression and model diagnostics.

3. **Identify article profiles:** Apply k-means clustering to group articles with similar characteristics and explore differences in engagement across clusters.

## Tools and Technologies

- **Language:** R (4.0 or later)
- **Environment:** RStudio
- **Statistical methods:** Correlation analysis, PCA, multiple linear regression, and ANOVA
- **Machine learning:** K-means clustering
- **Data preparation:** Missing-value handling, duplicate removal, and log transformations
- **Model diagnostics:** Variance Inflation Factor (VIF), Breusch–Pagan test, and residual diagnostic plots
- **Visualisation:** Correlation heatmaps, histograms, boxplots, scree plots, elbow plots, and silhouette analysis

## Dataset Overview

The dataset contains article-level observations, with each row representing an individual online article.

| Category | Variables | Description |
| :--- | :--- | :--- |
| Target variable | `Engagement` | Measures article engagement |
| Content characteristics | `Title_Word_Count`, `Content_Word_Count`, `Avg_Word_Length`, `Keyword_Total` | Article length and keyword usage |
| Multimedia and links | `Image_Count`, `Video_Count`, `External_Links`, `Internal_Links` | Multimedia elements and linking features |
| Tag performance | `Tag_Perf_*` | Tag performance indicators |
| Reference impact | `Ref_Avg_Impact`, `Ref_Min_Impact`, `Ref_Max_Impact` | Reference-related impact measures |
| Genre indicators | `Genre_*` | Article genre classifications |
| Topic weights | `Topic_A_Weight`–`Topic_E_Weight` | Topic distribution across five dimensions |
| Sentiment and subjectivity | Overall and title-level sentiment variables | Emotional tone and subjectivity |
| Publication timing | `Is_Weekend`, `Pub_Day_*`, `Days_Elapsed` | Publication day and timing characteristics |
| Record identifier | `Record_ID` | Unique article identifier, excluded from modelling |

## Analytical Workflow

### 1. Exploratory Data Analysis

- Examine dataset structure, dimensions, and summary statistics.
- Generate descriptive statistics using `psych::describe()`.
- Explore publication patterns across weekdays and weekends.
- Review distributions of engagement and explanatory variables.

### 2. Data Cleaning and Transformation

- Remove observations with missing values and remove duplicate records.
- Exclude `Record_ID` from the analytical dataset.
- Apply logarithmic transformations to engagement and selected count and performance variables.
- Apply shifted logarithmic transformations to selected variables containing negative values.

The target variable is transformed using:

```r
log_engagement = log(Engagement + 1)
```

This transformation reduces right-skewness and provides the response variable for the regression analysis.

### 3. Correlation Analysis and Feature Selection

- Visualise correlations among six genre indicators and five topic weights.
- Calculate correlations between candidate explanatory variables and log-transformed engagement.
- Apply an absolute correlation threshold of `0.05` as an exploratory screening rule.
- Examine correlations among predictors to identify potential multicollinearity and redundant features.

Correlation screening helps identify candidate variables for further analysis but does not establish statistical significance or causation.

### 4. Principal Component Analysis

PCA is applied to six genre indicators and five topic weights to reduce dimensionality.

The analysis includes:

- Standardising input variables.
- Examining eigenvalues and the scree plot.
- Applying the Kaiser criterion (eigenvalues greater than 1).
- Reviewing cumulative explained variance and component loadings.
- Retaining three principal components (`PC1`, `PC2`, and `PC3`) for the regression model.

The retained components represent patterns across the original genre and topic variables.

### 5. Multiple Linear Regression

Multiple linear regression examines associations between selected explanatory variables and log-transformed article engagement.

**Model specification:**

```r
log_engagement ~ PC1 + PC2 + PC3 +
  log_tag_perf_avg_avg +
  log_ref_avg_impact +
  log_image_count +
  log_video_count +
  log_external_links +
  Keyword_Total +
  Title_Subjectivity +
  Title_Sentiment +
  Is_Weekend
```

**Model diagnostics:**

- **Variance Inflation Factor (VIF):** Assesses multicollinearity among predictors.
- **Breusch–Pagan test:** Tests for heteroscedasticity in regression residuals.
- **Residual diagnostic plots:** Help assess model assumptions and identify potential problems.

Regression coefficients are interpreted as conditional associations rather than evidence of causation.

### 6. K-Means Clustering

K-means clustering identifies groups of articles with similar characteristics.

Two feature sets are compared:

- **Reduced feature set:** Five variables representing tag performance, publication timing, multimedia usage, and title subjectivity.
- **Full feature set:** Twelve variables used for comparison.

The clustering procedure includes:

- Standardising clustering variables using `scale()`.
- Evaluating candidate cluster counts using the elbow method and average silhouette width.
- Fitting a three-cluster model (`k = 3`, `nstart = 25`) with a fixed random seed.

```r
set.seed(20252001)
```

Cluster profiles and centres are examined to understand the characteristics of each group. Descriptive labels, such as weekday-oriented, weekend-oriented, or multimedia-oriented, should only be assigned if supported by the resulting profiles.

A one-way ANOVA is used to examine whether mean log-transformed engagement differs across the three clusters.

## Key Outputs

| Analysis Stage | Outputs |
| :--- | :--- |
| Exploratory analysis | Dataset summaries and descriptive statistics |
| Correlation analysis | Genre and topic correlation heatmap |
| Distribution analysis | Engagement histograms and transformed-variable boxplots |
| Feature selection | Correlation table with inclusion and exclusion flags |
| PCA | Scree plot, eigenvalues, component loadings, and explained variance |
| Regression | Model summary, VIF results, Breusch–Pagan test, and residual diagnostic plots |
| Clustering | Cluster centres, cluster sizes, median engagement, and ANOVA results |
| Final visualisations | Log-transformed engagement by cluster, elbow plot, and silhouette plot |

The main report figure is a boxplot comparing log-transformed engagement across the three clusters.

Plots are displayed in the RStudio plotting window and can be exported using **Export → Save as Image**.

## Installation and Setup

### Prerequisites

Install [R](https://cran.r-project.org/) and preferably [RStudio](https://posit.co/download/rstudio-desktop/).

### Install Required Packages

Run the following command in the R console:

```r
install.packages(c(
  "tidyverse",
  "psych",
  "corrplot",
  "factoextra",
  "car",
  "lmtest",
  "cluster"
))
```

Install these packages once. The script can load them when required.

### Repository Structure

```text
marketing-case-analysis/
├── data/
│   ├── Global media data dictionary.docx
│   └── Global_media_data.csv
├── README.md
└── marketing case analysis-5.R
```


### Configure the Dataset Path

### Dataset

Download the dataset: [Global_media_data.csv](data/Global_media_data.csv).

Download the [Data Dictionary](data/Global%20media%20data%20dictionary.docx) for descriptions of the dataset variables.


### Run the Analysis

1. Download or clone this repository to your computer.
2. Download the [R analysis script](marketing_case_analysis.R).
3. Open the script in RStudio.
4. Confirm that the dataset path is correct.
5. Install any required packages that are not already available.
6. Run the script section by section or from top to bottom.
7. Review the console output, regression diagnostics, and generated plots.
8. Export the figures required for reporting.

## Reproducibility and Interpretation

A fixed random seed helps make the k-means initialisation reproducible under the same data, preprocessing, software environment, and model settings. Cluster numbering is arbitrary and should not be interpreted as a ranking.

The three-cluster solution should be evaluated using the elbow method, silhouette scores, and the interpretability of the resulting cluster profiles.

Differences in engagement across clusters should be interpreted alongside the assumptions and limitations of the statistical tests. The findings describe patterns and associations in the analysed dataset rather than establish causal relationships.

## Limitations

- **Missing data:** Removing all observations with missing values may reduce the sample size or introduce bias if missingness is systematic.
- **Feature selection:** The correlation threshold of `0.05` is an exploratory screening rule and does not establish statistical significance.
- **PCA interpretation:** Principal components may be less directly interpretable than the original genre and topic variables.
- **Regression assumptions:** Conclusions depend on model assumptions, predictor selection, and data quality.
- **Clustering sensitivity:** Results depend on feature selection, scaling, the chosen number of clusters, and the characteristics of the dataset.

## Author

**Myat Hsu Paing @ Maria**

- [LinkedIn](https://www.linkedin.com/in/maria-paing/)
- [GitHub](https://github.com/myathsupaing)

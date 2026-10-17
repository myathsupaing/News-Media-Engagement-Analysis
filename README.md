Marketing Case Analysis: Drivers of Online Article Engagement

An R analysis of the `Global_media_data.csv` dataset that explores which content, multimedia, sentiment and timing features are associated with article engagement. It combines descriptive statistics, Principal Component Analysis (PCA), multiple linear regression and k-means clustering.
---
Contents
File	Description
`marketing case analysis-5.R`	Full analysis script: cleaning, transformation, feature selection, PCA, regression and clustering
`Global_media_data.csv`	Input dataset (not included; see Data below)
---
Requirements
R 4.0 or later (RStudio recommended)
R packages:
Package	Used for
`tidyverse`	General data handling
`psych`	`describe()` descriptive statistics
`corrplot`	Correlation heatmap
`skimr`	Data overview
`factoextra`	PCA scree plot (`fviz_eig`)
`car`	Variance Inflation Factor (`vif`)
`lmtest`	Breusch–Pagan heteroscedasticity test (`bptest`)
`cluster`	Silhouette analysis
Install everything in one go:
```r
install.packages(c("tidyverse", "psych", "corrplot", "skimr",
                   "factoextra", "car", "lmtest", "cluster"))
```
---
Data
The script expects a CSV with one row per article, including:
Target: `Engagement`
Content: `Title_Word_Count`, `Content_Word_Count`, `Avg_Word_Length`, `Keyword_Total`, word-rate variables
Multimedia & links: `Image_Count`, `Video_Count`, `External_Links`, `Internal_Links`
Tag performance: `Tag_Perf_*` (min / avg / max combinations)
Reference impact: `Ref_Avg_Impact`, `Ref_Min_Impact`, `Ref_Max_Impact`
Genre dummies: `Genre_Lifestyle`, `Genre_Entertainment`, `Genre_Business`, `Genre_SocialMedia`, `Genre_Tech`, `Genre_International`
Topic weights: `Topic_A_Weight` … `Topic_E_Weight`
Sentiment & subjectivity: overall and title-level sentiment, polarity and intensity variables
Timing: `Is_Weekend`, `Pub_Day_Mon` … `Pub_Day_Sun`, `Days_Elapsed`
ID: `Record_ID` (dropped during cleaning)
Setting the file path
The script reads from a hard-coded Windows path:
```r
data <- read.csv("C:/Users/myath/Desktop/marketing/Global_media_data.csv", stringsAsFactors = FALSE)
```
Change this to wherever the CSV lives on your machine, or place the CSV in your working directory and use:
```r
data <- read.csv("Global_media_data.csv", stringsAsFactors = FALSE)
```
---
Analysis pipeline
1. Data exploration
Structure, dimensions, summary statistics (`summary`, `describe`) and the weekday/weekend split of articles.
2. Data cleaning
Removes rows with missing values (`na.omit`)
Removes duplicate rows
Drops `Record_ID`, which carries no analytical value
3. Correlation of genre and topic variables
A colour-coded correlation matrix (`corrplot`) of the 6 genre dummies and 5 topic weights, used to justify combining them with PCA.
4. Distributions and transformations
Histograms show `Engagement` is heavily right-skewed; `log(Engagement + 1)` gives a near-normal distribution
Skewed count and performance variables are transformed with `log(x + 1)`
Variables that can take negative values (`Tag_Perf_Avg_Min`, `Tag_Perf_Min_Avg`, `Tag_Perf_Min_Min`) use a shifted transform `log(x + 2)`
Boxplots of log-transformed multimedia features and of log engagement by weekday vs. weekend
5. Feature selection
Every candidate variable is correlated with `log_engagement`. Variables with |r| ≥ 0.05 are flagged INCLUDE; the rest are flagged exclude. Pairwise correlations within variable groups (word rates, tag performance, reference impact, timing, sentiment) are then checked to avoid multicollinearity, keeping one representative per group.
6. Principal Component Analysis
PCA (scaled) on the 11 genre and topic variables. The scree plot, eigenvalues (Kaiser criterion, eigenvalue > 1) and cumulative variance support retaining 3 components (`PC1`, `PC2`, `PC3`), which are added to the dataset and used in place of the original 11 variables.
7. Multiple linear regression
```r
log_engagement ~ PC1 + PC2 + PC3 +
                 log_tag_perf_avg_avg + log_ref_avg_impact +
                 log_image_count + log_video_count + log_external_links +
                 Keyword_Total + Title_Subjectivity + Title_Sentiment +
                 Is_Weekend
```
Diagnostics:
VIF to check multicollinearity
Breusch–Pagan test for heteroscedasticity
The four standard residual diagnostic plots
8. K-means clustering
Reduced feature set (5 variables): `log_tag_perf_avg_avg`, `Is_Weekend`, `log_image_count`, `log_video_count`, `Title_Subjectivity`
Full feature set (12 variables) used for comparison
All variables are standardised with `scale()` before clustering
K chosen with the elbow method and average silhouette width
Final model: k = 3, `nstart = 25`, `set.seed(20252001)` for reproducibility
Clusters are interpreted as Weekday, Weekend and Multimedia
Median engagement per cluster is reported, and a one-way ANOVA tests whether log engagement differs significantly across clusters
---
Outputs
Output	Section
Genre/topic correlation heatmap	3
Engagement and log-engagement histograms	4
Multimedia and weekday/weekend boxplots	4
Feature-selection correlation table	5
PCA scree plots, eigenvalues, loadings	6
Regression summary, VIF, residual plots	7
Cluster centres, sizes, median engagement, ANOVA	8
Main report figure: Log engagement by cluster boxplot	8
Appendix figures: elbow plots (full and reduced), silhouette plot	8
All plots appear in the R plotting window; export them via Export → Save as Image in RStudio or wrap the code in `png()` / `dev.off()`.
---
How to run
Install the packages listed above.
Update the CSV path in the import step.
Open the script in RStudio and run it top to bottom (`Ctrl + Shift + Enter`), or section by section to inspect each output.
The k-means elbow and silhouette loops run k-means many times with `nstart = 25`, so they may take a minute or two on a large dataset.
---
Known issues to fix before running
The script will not run cleanly top to bottom as written. These are small fixes:
Log variables used before they are created. The multimedia boxplot (`log_image_count`, etc.) and the weekday/weekend boxplot (`log_engagement`) come before the "Create log transformed variables" block. Move that block up to just after data cleaning.
`bptest(model)` refers to a model that doesn't exist. Change it to `bptest(model_final)`.
`factoextra` is loaded but never installed. Add `install.packages("factoextra")` (or use the combined install line above).
`psych` is installed and loaded twice. The second `install.packages("psych")` / `library(psych)` can be removed.
Unused objects. The first `kmeans_vars` (14 variables) is overwritten later and never used; the `skimr` package is loaded but not called. Both can be removed or put to use.
`install.packages()` calls inside the script reinstall packages on every run. Consider running them once and commenting them out.
---
Reproducibility
`set.seed(20252001)` is set before each k-means run so cluster assignments, elbow curves and silhouette scores are reproducible. Note that cluster numbering (1, 2, 3) depends on the seed; if you change it, check the cluster centres before reusing the "Weekday / Weekend / Multimedia" labels in the final boxplot.

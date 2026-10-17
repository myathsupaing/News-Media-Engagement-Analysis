#Install and Load Required Packages
install.packages("tidyverse")
install.packages("psych")
install.packages("corrplot")
install.packages("skimr")

library(tidyverse)
library(psych)
library(corrplot)
library(skimr)

#Import the Dataset
data <- read.csv("C:/Users/myath/Desktop/marketing/Global_media_data.csv", stringsAsFactors = FALSE)

#View structure
str(data)
head(data)
dim(data)
colnames(data)
summary(data)
describe(data)

prop.table(table(data$Is_Weekend)) * 100

#Data cleaning
colSums(is.na(data))
data <- na.omit(data)
data <- data[!duplicated(data), ]

#Remove ID column because because it does not add analytical value.
data$Record_ID <- NULL

install.packages("psych")
library(psych)
describe(data)

#Descriptive statistics
summary(data)

#Descriptive Statistics  for key variables
genre_topic_vars <- data[, c(
  "Genre_Lifestyle", "Genre_Entertainment", "Genre_Business", 
  "Genre_SocialMedia", "Genre_Tech", "Genre_International",
  "Topic_A_Weight", "Topic_B_Weight", "Topic_C_Weight", 
  "Topic_D_Weight", "Topic_E_Weight")]

cor_matrix_genre_topic <- cor(genre_topic_vars, use = "complete.obs")
round(cor_matrix_genre_topic, 3)

corrplot(cor_matrix_genre_topic,
         method      = "color",
         type        = "full",
         tl.cex      = 0.75,
         tl.col      = "black",
         addCoef.col = "black",
         number.cex  = 0.55,
         col         = colorRampPalette(c("#2166AC","white","#B2182B"))(200),
         title       = "Genre and topic variable correlations",
         mar         = c(0, 0, 2, 0))

#Outlier analysis
#Histogram
hist(data$Engagement,
     main = "Distribution of Engagement",
     xlab = "Engagement",
     ylab = "Density of Articles",
     probability = TRUE,
     breaks = 40,
     col = "lightblue")

lines(density(data$Engagement), col = "darkred", lwd = 2)

#Histogram log transformation
hist(log(data$Engagement + 1),
     main = "Distribution of Log Engagement",
     xlab = "Engagement",
     ylab = "Density of Articles",
     probability = TRUE,
     breaks = 40,
     col = "lightblue")

lines(density(log(data$Engagement + 1)),
      col = "darkred",
      lwd = 3)

multimedia_log <- data[, c(
  "log_image_count",
  "log_video_count",
  "log_external_links",
  "log_internal_links"
)]

par(mar = c(5, 8, 4, 2))  # increase left margin

boxplot(multimedia_log,
        horizontal = TRUE,
        las = 1,
        col = c("#9ecae1", "#6baed6", "#3182bd", "#08519c"),
        main = "Distribution of Log-Transformed Multimedia Features",
        xlab = "Log(Number of Elements)",
        cex.axis = 0.9,
        outline = TRUE)


data$Is_Weekend_Factor <- factor(data$Is_Weekend,
                                 levels = c(0,1),
                                 labels = c("Weekday", "Weekend"))

boxplot(log_engagement ~ Is_Weekend_Factor,
        data = data,
        horizontal = TRUE,
        col = c("#9ecae1", "#3182bd"),
        main = "Log Engagement by Publication Timing",
        ylab = "Log(Engagement + 1)",
        xlab = "")


# Create log transformed variables
data$log_engagement            <- log(data$Engagement + 1)
data$log_content_word_count    <- log(data$Content_Word_Count + 1)
data$log_external_links        <- log(data$External_Links + 1)
data$log_internal_links        <- log(data$Internal_Links + 1)
data$log_image_count           <- log(data$Image_Count + 1)
data$log_video_count           <- log(data$Video_Count + 1)
data$log_tag_perf_avg_avg      <- log(data$Tag_Perf_Avg_Avg + 1)
data$log_tag_perf_max_avg      <- log(data$Tag_Perf_Max_Avg + 1)
data$log_tag_perf_avg_max      <- log(data$Tag_Perf_Avg_Max + 1)
data$log_tag_perf_max_min      <- log(data$Tag_Perf_Max_Min + 1)
data$log_tag_perf_min_max      <- log(data$Tag_Perf_Min_Max + 1)
data$log_tag_perf_max_max      <- log(data$Tag_Perf_Max_Max + 1)
data$log_ref_avg_impact        <- log(data$Ref_Avg_Impact + 1)
data$log_ref_min_impact        <- log(data$Ref_Min_Impact + 1)
data$log_ref_max_impact        <- log(data$Ref_Max_Impact + 1)
data$log_overall_subjectivity  <- log(data$Overall_Subjectivity + 1)
data$log_title_abs_sentiment   <- log(data$Title_Abs_Sentiment + 1)

#shifted log transformation
data$log_tag_perf_avg_min      <- log(data$Tag_Perf_Avg_Min + 2)
data$log_tag_perf_min_avg      <- log(data$Tag_Perf_Min_Avg + 2)
data$log_tag_perf_min_min      <- log(data$Tag_Perf_Min_Min + 2)

#check every variable vs log(engagement) (feature selection) ~ to reduce dimensionality
candidate_vars <- data[, c(
  "Title_Word_Count", "log_content_word_count",
  "Avg_Word_Length", "Keyword_Total",
  "log_image_count", "log_video_count",
  "log_external_links", "log_internal_links",
  "log_tag_perf_avg_avg", "log_tag_perf_max_avg",
  "log_tag_perf_min_avg", "log_tag_perf_avg_max",
  "log_tag_perf_avg_min", "log_tag_perf_max_min",
  "log_tag_perf_min_min", "log_tag_perf_min_max",
  "log_tag_perf_max_max",
  "log_ref_avg_impact", "log_ref_min_impact", "log_ref_max_impact",
  "Genre_Lifestyle", "Genre_Entertainment", "Genre_Business",
  "Genre_SocialMedia", "Genre_Tech", "Genre_International",
  "Topic_A_Weight", "Topic_B_Weight", "Topic_C_Weight",
  "Topic_D_Weight", "Topic_E_Weight",
  "log_overall_subjectivity", "Overall_Sentiment",
  "Global_Pos_Rate", "Global_Neg_Rate",
  "Avg_Pos_Intensity", "Min_Pos_Intensity", "Max_Pos_Intensity",
  "Avg_Neg_Intensity", "Min_Neg_Intensity", "Max_Neg_Intensity",
  "Pos_to_NonNeutral_Rate", "Neg_to_NonNeutral_Rate",
  "Title_Subjectivity", "Title_Sentiment",
  "Title_Abs_Subjectivity", "log_title_abs_sentiment",
  "Unique_Words_Rate", "Non_Stop_Words_Rate", "Unique_Non_Stop_Rate",
  "Is_Weekend", "Pub_Day_Mon", "Pub_Day_Tue", "Pub_Day_Wed",
  "Pub_Day_Thu", "Pub_Day_Fri", "Pub_Day_Sat", "Pub_Day_Sun",
  "Days_Elapsed"
)]

cor_results <- cor(candidate_vars,
                   data$log_engagement,
                   use = "complete.obs")

cor_table <- data.frame(
  Variable    = rownames(cor_results),
  Correlation = round(cor_results[, 1], 4)
)

cor_table$Abs_Corr <- abs(cor_table$Correlation)
cor_table$Decision <- ifelse(cor_table$Abs_Corr >= 0.05,
                             "INCLUDE", "exclude")
cor_table <- cor_table[order(-cor_table$Abs_Corr), ]

print(cor_table, row.names = FALSE)

#check variables vs each other ~ to detect multicollinearity
# word rate variables
cor(data$Unique_Words_Rate,   data$Non_Stop_Words_Rate)
cor(data$Unique_Words_Rate,   data$Unique_Non_Stop_Rate)
cor(data$Non_Stop_Words_Rate, data$Unique_Non_Stop_Rate)

# tag performance group
cor(data$log_tag_perf_avg_avg, data$log_tag_perf_max_avg)
cor(data$log_tag_perf_avg_avg, data$log_tag_perf_min_avg)
cor(data$log_tag_perf_avg_avg, data$log_tag_perf_max_min)
cor(data$log_tag_perf_avg_avg, data$log_tag_perf_avg_min)
cor(data$log_tag_perf_avg_avg, data$log_tag_perf_avg_max)
cor(data$log_tag_perf_avg_avg, data$log_tag_perf_min_min)

# reference impact group
cor(data$log_ref_avg_impact, data$log_ref_min_impact)
cor(data$log_ref_avg_impact, data$log_ref_max_impact)
cor(data$log_ref_min_impact, data$log_ref_max_impact)

# timing group
cor(data$Is_Weekend, data$Pub_Day_Sat)
cor(data$Is_Weekend, data$Pub_Day_Sun)

# sentiment group
cor(data$log_overall_subjectivity, data$Title_Subjectivity)
cor(data$log_overall_subjectivity, data$Title_Sentiment)
cor(data$log_overall_subjectivity, data$log_title_abs_sentiment)
cor(data$Title_Subjectivity,       data$Title_Sentiment)
cor(data$Title_Subjectivity,       data$log_title_abs_sentiment)
cor(data$Title_Sentiment,          data$log_title_abs_sentiment)

#pca
library(factoextra)

pca_vars <- data[, c(
  "Genre_Lifestyle", "Genre_Entertainment", "Genre_Business",
  "Genre_SocialMedia", "Genre_Tech", "Genre_International",
  "Topic_A_Weight", "Topic_B_Weight", "Topic_C_Weight",
  "Topic_D_Weight", "Topic_E_Weight"
)]

pca_result <- prcomp(pca_vars, scale. = TRUE)
summary(pca_result)
fviz_eig(pca_result, addlabels = TRUE)

pca_result$rotation

# eigenvalues — variance explained by each component
eigenvalues <- pca_result$sdev^2
eigenvalues

# cumulative variance explained
cumulative_pct <- round(cumsum(eigenvalues / sum(eigenvalues)) * 100, 2)
cumulative_pct

# scree plot
plot(eigenvalues,
     type = "b",
     main = "Scree plot — PCA on genre and topic variables",
     xlab = "Principal component",
     ylab = "Eigenvalue",
     pch  = 19,
     col  = "steelblue")
abline(h = 1, lty = 2, col = "red")

data$PC1 <- pca_result$x[, 1]
data$PC2 <- pca_result$x[, 2]
data$PC3 <- pca_result$x[, 3]

# print loadings for all 11 variables across PC1, PC2, PC3
loadings <- as.data.frame(round(pca_result$rotation[, 1:3], 3))
print(loadings)


#Regression
model_final <- lm(log_engagement ~
                    PC1 + PC2 + PC3 +
                    log_tag_perf_avg_avg +
                    log_ref_avg_impact +
                    log_image_count +
                    log_video_count +
                    log_external_links +
                    Keyword_Total +
                    Title_Subjectivity +
                    Title_Sentiment +
                    Is_Weekend,
                  data = data)

summary(model_final)

#Check multicollinearity
install.packages("car")
library(car)

vif(model_final)

plot(model_final, which = 1)

install.packages("lmtest")
library(lmtest)
bptest(model)

# produce all four diagnostic plots
par(mfrow = c(2, 2))
plot(model_final)
par(mfrow = c(1, 1))

# ============================================================

# Select same variables as regression
kmeans_vars <- data[, c(
  "PC1", "PC2", "PC3",
  "log_tag_perf_avg_avg",
  "log_ref_avg_impact",
  "log_image_count",
  "log_video_count",
  "log_external_links",
  "Keyword_Total",
  "log_overall_subjectivity",
  "log_title_abs_sentiment",
  "Title_Subjectivity",
  "Title_Sentiment",
  "Is_Weekend"
)]

# Reduced feature set
kmeans_vars_reduced <- data[, c(
  "log_tag_perf_avg_avg",
  "Is_Weekend",
  "log_image_count",
  "log_video_count",
  "Title_Subjectivity"
)]

# Scale reduced variables
kmeans_scaled_reduced <- scale(kmeans_vars_reduced)

# Elbow method - reduced
wss_reduced <- sapply(1:10, function(k){
  kmeans(kmeans_scaled_reduced, centers = k, nstart = 25)$tot.withinss
})

plot(1:10, wss_reduced,
     type = "b", pch = 19,
     xlab = "Number of clusters (K)",
     ylab = "Within-cluster sum of squares",
     main = "Elbow Method for K-Means (Reduced Features)")

# Run k-means with k = 3 on reduced features
library(cluster)
set.seed(20252001)
kmeans_model_reduced <- kmeans(kmeans_scaled_reduced,
                               centers = 3,
                               nstart  = 25)

# View cluster centers and sizes
print(kmeans_model_reduced$centers)
print(kmeans_model_reduced$size)

# Add cluster to data
data$cluster_reduced <- as.factor(kmeans_model_reduced$cluster)

# Median engagement per cluster
aggregate(Engagement ~ cluster_reduced,
          data = data,
          FUN  = median)

# ANOVA
anova_result <- aov(log_engagement ~ cluster_reduced, data = data)
summary(anova_result)
##################
# Full feature set for silhouette comparison
kmeans_vars <- data[, c(
  "log_tag_perf_avg_avg",
  "Is_Weekend",
  "log_image_count",
  "log_video_count",
  "Title_Subjectivity",
  "PC1", "PC2", "PC3",
  "log_ref_avg_impact",
  "log_external_links",
  "Keyword_Total",
  "Title_Sentiment"
)]

kmeans_scaled <- scale(kmeans_vars)

# Elbow method - full features
set.seed(20252001)
wss <- sapply(1:10, function(k){
  kmeans(kmeans_scaled, centers = k, nstart = 25)$tot.withinss
})

plot(1:10, wss,
     type = "b", pch = 19,
     xlab = "Number of clusters (K)",
     ylab = "Within-cluster sum of squares",
     main = "Elbow Method for K-Means (Full Features)")

# Silhouette scores - reduced features only
set.seed(20252001)
sil_scores <- numeric(10)
for (k in 2:10) {
  km <- kmeans(kmeans_scaled_reduced, centers = k, nstart = 25)
  sil <- silhouette(km$cluster, dist(kmeans_scaled_reduced))
  sil_scores[k] <- mean(sil[, 3])
}
sil_scores

#Plots
# =============================================
# MAIN REPORT — Plot 4 only (Engagement Boxplot)
# =============================================

par(mfrow = c(1, 1))

boxplot(log_engagement ~ cluster_reduced,
        data   = data,
        col    = c("#3182bd", "#e6550d", "#31a354"),
        xlab   = "Cluster",
        ylab   = "Log Engagement",
        main   = "Log Engagement by Cluster",
        names  = c("Cluster 1\nWeekday", 
                   "Cluster 2\nWeekend", 
                   "Cluster 3\nMultimedia"))
# =============================================
# APPENDIX — Plots 1, 2, and 3
# =============================================

par(mfrow = c(2, 2))

# Plot 1 — Elbow Method (Full Feature Set)
set.seed(20252001)
wss <- sapply(1:10, function(k){
  kmeans(kmeans_scaled, centers = k, nstart = 25)$tot.withinss
})
plot(1:10, wss,
     type = "b", pch = 19,
     xlab = "Number of clusters (K)",
     ylab = "Within-cluster sum of squares",
     main = "Elbow Method (Full Features)")

# Plot 2 — Elbow Method (Reduced Feature Set)
set.seed(20252001)
wss_reduced <- sapply(1:10, function(k){
  kmeans(kmeans_scaled_reduced, centers = k, nstart = 25)$tot.withinss
})
plot(1:10, wss_reduced,
     type = "b", pch = 19,
     xlab = "Number of clusters (K)",
     ylab = "Within-cluster sum of squares",
     main = "Elbow Method (Reduced Features)")
abline(v = 2, lty = 2, col = "red")

# Plot 3 — Silhouette Scores
plot(2:10, sil_scores[2:10],
     type = "b", pch = 19,
     xlab = "Number of clusters (K)",
     ylab = "Average silhouette width",
     main = "Silhouette Method")
abline(v = which.max(sil_scores),
       lty = 2,
       col = "red")
####################


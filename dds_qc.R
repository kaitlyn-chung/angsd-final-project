library(tidyverse)
library(DESeq2)
library(magrittr)
library(pheatmap)
library(PNWColors)

# calculates correlation coefficient of samples with pearsons method
corr_coeff <- cor(assay(rlog_transformed), method = "pearson")

# generates heatmap of correlations between samples
as.dist(1 - corr_coeff, upper=TRUE) %>% 
  as.matrix %>%
  pheatmap::pheatmap(main = "Pearson correlation", treeheight_row = 0)

# same as before, but just the dendrogram
as.dist(1 - corr_coeff) %>%
  hclust %>%
  plot(labels=colnames(.))

# plot PCA, colored by patient
colData(rlog_transformed)$sampleID <- sub("_.*", "", colnames(rlog_transformed))
plotPCA(rlog_transformed, 
        intgroup = "sampleID", 
        ntop = 1000) +  
  labs(color = "sampleID") +  
  theme_minimal() + 
  ggtitle("PCA plot by patient") +
  scale_color_manual(values = pnw_palette("Sailboat", 8, type = "continuous"))

# plot PCA, colored by condition
plotPCA(rlog_transformed, 
        intgroup = "condition", 
        ntop = 1000) +  
  labs(color = "condition") +  
  theme_minimal() + 
  ggtitle("PCA plot by condition") +
  scale_color_manual(values = pnw_palette("Sailboat", 2, type = "discrete"))

# plot PCA by hand to evaluate PC1-14
mat <- assay(rlog_transformed)
rv <- rowVars(mat)
top_variable <- order(rv, decreasing = TRUE)[seq_len(1000)]
pca <- prcomp(t(mat[top_variable, ]))

# variance explained calc
var_explained <- (pca$sdev^2) / sum(pca$sdev^2)
pc_labels <- paste0("PC", seq_along(var_explained))
barplot(var_explained, 
        names.arg = pc_labels, 
        main = "Variance Explained by Each Principal Component",
        ylab = "Proportion of Variance",
        xlab = "Principal Component")

library(pheatmap)
corr_coeff <- cor(assay(rlog_transformed), method = "pearson")
as.dist(1 - corr_coeff, upper=TRUE) %>% 
  as.matrix %>%
  pheatmap::pheatmap(main = "Pearson correlation", treeheight_row = 0)

as.dist(1 - corr_coeff) %>%
  hclust %>%
  plot(labels=colnames(.))

colData(rlog_transformed)$sampleID <- sub("_.*", "", colnames(rlog_transformed))
plotPCA(rlog_transformed, intgroup = "sampleID", ntop = 1000) +  labs(color = "Sample ID") +  theme_bw()
plotPCA(rlog_transformed, intgroup = "condition", ntop = 1000) +  labs(color = "condition") +  theme_bw()

mat <- assay(rlog_transformed)
rv <- rowVars(mat)
top_variable <- order(rv, decreasing = TRUE)[seq_len(1000)]
pca <- prcomp(t(mat[top_variable, ]))

# Variance explained
var_explained <- (pca$sdev^2) / sum(pca$sdev^2)
pc_labels <- paste0("PC", seq_along(var_explained))
barplot(var_explained, 
        names.arg = pc_labels, 
        main = "Variance Explained by Each Principal Component",
        ylab = "Proportion of Variance",
        xlab = "Principal Component")

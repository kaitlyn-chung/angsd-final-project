library(tidyverse)
library(DESeq2)
library(pheatmap)
library(EnhancedVolcano)
library(org.Hs.eg.db)
library(clusterProfiler)
library(enrichplot)

dds_nav <- readRDS("dds_nav.rds")

# DE analysis - normalization across sequencing depth, dispersion estimation, fit binomial GLM and Wald stats
dds_nav %<>% DESeq()

# maximize genes that are statistically significant (a little p-hacky)
df_results <- results(dds_nav, independentFiltering = TRUE, alpha = 0.05)

# generate plot to see how many genes are in each p-adj bin
df_results$padj %>% hist(breaks=19, main="Adjusted p-values for paired treatment-patient samples")

# create subset of genes that are statistically significant
df_results_sorted <- df_results %>% `[`(order(.$padj),)
genes_dge <- rownames(subset(df_results_sorted, padj < 0.05))
rlog_dge <- rlog_transformed[genes_dge,] %>% assay

# looking at counts for select GBM-related genes
p53_status <- rlog_transformed[c("TP53","MDM2","IDH1","IDH2"),] %>% assay
View(p53_status)

# heatmap but with initial clustering
pheatmap(rlog_dge,scale="row",show_rownames = TRUE, fontsize_row = 6)

# heatmap but put on and pre treatment next to each other for each patient
sample_info <- data.frame(
  sample   = colnames(rlog_dge),
  patient  = sub("_.*", "", colnames(rlog_dge)),
  treatment = sub("[0-9]*_", "", colnames(rlog_dge))
)
rownames(sample_info) <- sample_info$sample
sample_info <- sample_info %>%
  dplyr::mutate(
    treatment = factor(treatment, levels = c("preT", "onT"))
  ) %>%
  dplyr::arrange(patient, treatment)
rlog_dge_ordered <- rlog_dge[, sample_info$sample]

pheatmap(rlog_dge_ordered, show_rownames=FALSE, scale="row", cluster_cols = FALSE)

# comparison of logFC shrinkage
vp1 <- EnhancedVolcano(df_results, lab=rownames(df_results), x='log2FoldChange', y='padj', pCutoff=0.05)
df_results_shrunk <- lfcShrink(dds_nav, coef=2, type="apeglm")
vp2 <- EnhancedVolcano(df_results_shrunk, lab=rownames(df_results_shrunk), x='log2FoldChange', y='padj', pCutoff=0.05)
vp1 + vp2
vp2

# GO term enrichment
hg38 <- org.Hs.eg.db # bioconductor 

# look at specific GO terms
res_go <- enrichGO(gene=genes_dge,
                   universe=rownames(dds_nav),
                   ont="ALL",
                   keyType="SYMBOL",
                   minGSSize = 3,
                   maxGSSize = 800,
                   pvalueCutoff = 0.05,
                   OrgDb = hg38,
                   pAdjustMethod = "BH")
gene_list <- df_results$log2FoldChange # extract log2fold change from statistically sig genes
names(gene_list) <- rownames(df_results) # assign genes to row indexes
gene_list <- sort(gene_list, decreasing = TRUE)

res_go[1,] %>% str

dotplot(res_go, showCategory = 20) +  
  ggtitle("Top enriched GO terms") +  
  scale_y_discrete(labels = function(x) str_wrap(x, width = 50)) +
  theme(axis.text.y = element_text(size = 10))

# look at gene sets
gse <- gseGO(geneList=gene_list,
             ont ="ALL",
             keyType = "SYMBOL",
             minGSSize = 3,
             maxGSSize = 800,
             pvalueCutoff = 0.05,
             verbose = TRUE,
             OrgDb = hg38,
             pAdjustMethod = "BH")

# all ontologies
dotplot(gse, showCategory=10, split=".sign", label_format=NULL) + 
  scale_y_discrete(labels = function(x) str_wrap(x, width = 50)) +
  facet_grid(.~.sign) + 
  theme(axis.text.y = element_text(size = 10)) 

# split by ontology
dotplot(gse, showCategory=10, split="ONTOLOGY", label_format=NULL) + 
  facet_grid(ONTOLOGY ~ ., scales = "free_y") + 
  theme(axis.text.y = element_text(size = 10))

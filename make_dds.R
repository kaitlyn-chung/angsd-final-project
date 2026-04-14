library(tidyverse)
library(DESeq2)
library(magrittr)
feature_counts <- read.table("feature_counts.txt", header=TRUE)
original_column_names <- names(feature_counts)
names(feature_counts) <- sub(
  ".*STAR_aligned\\.([^\\.]+)\\.Aligned.*\\.bam$",
  "\\1",
  original_column_names
)
row.names(feature_counts) <- make.names(feature_counts$Geneid)
gene_counts <- feature_counts[, -c(1:6)]
fc_row_data <- feature_counts[, 1:6]
column_data <- data.frame(
  patient   = sub("_.*", "", colnames(gene_counts)),
  condition = sub(".*_", "", colnames(gene_counts)),
  row.names = colnames(gene_counts)
)
dds_nav <- DESeqDataSetFromMatrix(countData=gene_counts, colData=column_data, design = ~ patient + condition)
rowData(dds_nav) <- fc_row_data
dds_nav$condition %<>% relevel(ref="pre")
dds_nav <- dds_nav[, order(dds_nav$condition)]
keep_genes <- rowSums(counts(dds_nav)) > 0
dds_nav <- dds_nav[keep_genes, ]
dds_nav <- estimateSizeFactors(dds_nav)
counts_normalized <- counts(dds_nav, normalized=TRUE)
assay(dds_nav, "log_norm_counts") <- log2(counts_normalized + 1)
rlog_transformed <- rlog(dds_nav, blind=FALSE)

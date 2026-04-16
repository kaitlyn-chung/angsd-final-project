library(DESeq2)
library(clusterProfiler)
library(org.Hs.eg.db)
library(KEGGREST)
library(enrichplot)
library(dplyr)

df_results <- readRDS("df_results.rds")
dds_nav <- readRDS("dds_nav.rds")

all_genes <- rownames(df_results)

ids <- bitr(all_genes,
            fromType = "SYMBOL",
            toType   = "ENTREZID",
            OrgDb    = hg38)

gene_list_entrez <- gene_list[ids$SYMBOL]
names(gene_list_entrez) <- ids$ENTREZID
gene_list_entrez <- sort(gene_list_entrez, decreasing = TRUE)

# KEGG GSEA
kegg_gsea <- gseKEGG(
  geneList  = gene_list_entrez,
  organism  = "hsa",
  minGSSize = 10,
  pvalueCutoff = 1 # to look at ALL p53 signaling genes, not just what is significant
)

# Extract p53
p53_gsea <- kegg_gsea@result %>%
  dplyr::filter(ID == "hsa04115")
p53_gsea[, c("NES", "pvalue", "p.adjust")]

gseaplot2(
  kegg_gsea,
  geneSetID = "hsa04115",
  title = "GSEA: p53 signaling pathway"
)

# pull out genes from rlog_dge
pathway_info <- keggGet("hsa04115")
gene_list <- pathway_info[[1]]$GENE
gene_list <- gene_list[seq(2, length(gene_list), by = 2)]
gene_list <- sub(";.*", "", gene_list)

p53_genes_in_data <- intersect(
  gene_list,
  rownames(rlog_dge)
)

p53_genes_in_data  # the single gene identified

df_results["CDKN1A",] # find p-value

# plot significance across samples
par(mfrow=c(1,3))
plotCounts(dds_nav,gene=which.min(df_results$padj), main="MMP9 \nMost significant")
plotCounts(dds_nav,gene = p53_genes_in_data, normalized=TRUE)
plotCounts(dds_nav,gene=which.max(df_results$padj), main="RAC3 \nLeast significant")

par(mfrow=c(1,2))
plotCounts(dds_nav,gene = "TP53", normalized=TRUE)
plotCounts(dds_nav,gene = "MDM2", normalized=TRUE)
df_results["MDM2",] 
df_results["TP53",] 
# ==============================================
#
# Outputs in results/plots/:
#   volcano_*.png          - statische Volcano-Plots (ggplot2)
#   glimma_mds.html        - interaktiver MDS-Plot (Sample-Uebersicht)
#   heatmap_top_degs.png   - Heatmap der Top-DEGs (pheatmap)
#
# ==============================================

library(limma)
library(Biobase)
library(hgu133plus2.db)
library(ggplot2)
library(ggrepel)
library(pheatmap)
library(RColorBrewer)
library(Glimma)

# -----------------------------------------------
# Daten laden
# -----------------------------------------------
cat("Lade Daten...\n")
eset <- readRDS("data/processed/eset_clean.rds")
fit2 <- readRDS("data/processed/limma_fit.rds")
cat("Geladen:", ncol(eset), "Samples,", nrow(eset), "Probes\n")

dir.create("results/plots", showWarnings = FALSE, recursive = TRUE)

# Subtyp-Faktor (gleiche Reihenfolge wie in Script 04)
subtype <- factor(pData(eset)$subtype_cit256,
                  levels = c("basL", "lumA", "lumB", "lumC"))
contrasts_list <- colnames(fit2$contrasts)

# -----------------------------------------------
# Gen-Annotation (einmal berechnen, wiederverwenden)
# -----------------------------------------------
cat("Annotiere Probes...\n")
probe_ids    <- rownames(exprs(eset))
gene_symbols <- mapIds(hgu133plus2.db, keys = probe_ids,
                       column = "SYMBOL", keytype = "PROBEID",
                       multiVals = "first")
gene_names   <- mapIds(hgu133plus2.db, keys = probe_ids,
                       column = "GENENAME", keytype = "PROBEID",
                       multiVals = "first")

# fit2 mit Annotation versehen (Glimma nutzt fit$genes automatisch)
fit2$genes <- data.frame(
    PROBEID  = probe_ids,
    SYMBOL   = as.character(gene_symbols),
    GENENAME = as.character(gene_names),
    stringsAsFactors = FALSE
)

# -----------------------------------------------
# Schritt 1: Statische Volcano-Plots (ggplot2 + ggrepel)
# -----------------------------------------------
cat("\n1) Statische Volcano-Plots (ggplot2)...\n")
for (contr in contrasts_list) {
    tt <- topTable(fit2, coef = contr, number = Inf,
                   adjust.method = "BH", sort.by = "P")

    # Kategorien fuer Farbcodierung
    tt$category <- "ns"
    tt$category[tt$adj.P.Val < 0.05 & tt$logFC >  1] <- "up"
    tt$category[tt$adj.P.Val < 0.05 & tt$logFC < -1] <- "down"

    # Top 15 signifikante Gene fuer Labels
    top_genes <- tt[tt$category != "ns" & !is.na(tt$SYMBOL), ]
    top_genes <- head(top_genes[order(top_genes$adj.P.Val), ], 15)

    group_up <- strsplit(contr, "_vs_")[[1]][1]
    group_dn <- strsplit(contr, "_vs_")[[1]][2]

    p <- ggplot(tt, aes(x = logFC, y = -log10(adj.P.Val), color = category)) +
        geom_point(alpha = 0.6, size = 1) +
        scale_color_manual(
            values = c("up" = "#e41a1c", "down" = "#377eb8", "ns" = "grey75"),
            labels = c("up"   = paste("up in", group_up),
                       "down" = paste("up in", group_dn),
                       "ns"   = "n.s.")
        ) +
        geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "grey30") +
        geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "grey30") +
        geom_text_repel(data = top_genes, aes(label = SYMBOL),
                        size = 3, max.overlaps = 20, show.legend = FALSE) +
        labs(title = paste("Volcano Plot:", gsub("_", " ", contr)),
             x = "log2 Fold Change",
             y = "-log10(adj. P-Value)",
             color = NULL) +
        theme_bw() +
        theme(legend.position = "bottom")

    outfile <- paste0("results/plots/volcano_", contr, ".png")
    ggsave(outfile, p, width = 8, height = 7, dpi = 150)
    cat("  Gespeichert:", outfile, "\n")
}

# -----------------------------------------------
# Schritt 2a: Statischer MDS-Plot 
# -----------------------------------------------
cat("\n2a) Statischer MDS-Plot (ggplot2)...\n")
mds <- plotMDS(exprs(eset), top = 500, plot = FALSE)
mds_df <- data.frame(
    dim1    = mds$x,
    dim2    = mds$y,
    subtype = as.character(subtype),
    pcr     = pData(eset)$pcr,
    row.names = sampleNames(eset)
)

subtype_colors <- c(basL = "#ff7f00", lumA = "#4daf4a",
                    lumB = "#377eb8", lumC = "#e41a1c")
pcr_shapes     <- c("non-pCR" = 16, "pCR" = 15)   # Kreis vs. Quadrat

p_mds <- ggplot(mds_df, aes(x = dim1, y = dim2,
                             color = subtype, shape = pcr)) +
    geom_point(size = 3, alpha = 0.85) +
    scale_color_manual(values = subtype_colors, name = "Subtyp") +
    scale_shape_manual(values = pcr_shapes,     name = "pCR") +
    labs(title = "MDS-Plot (Top-500-Gene)",
         x = paste0("dim1 (", round(mds$var.explained[1] * 100, 1), "% Varianz)"),
         y = paste0("dim2 (", round(mds$var.explained[2] * 100, 1), "% Varianz)")) +
    theme_bw() +
    theme(legend.position = "right")

ggsave("results/plots/mds_static.png", p_mds, width = 7, height = 6, dpi = 150)
cat("  Gespeichert: results/plots/mds_static.png\n")

# -----------------------------------------------
# Schritt 2b: Glimma MDS-Plot (interaktiv, HTML)
# -----------------------------------------------
cat("\n2b) Glimma MDS-Plot (interaktiv)...\n")
glimmaMDS(exprs(eset),
          groups = data.frame(Subtype = as.character(subtype),
                              pCR     = pData(eset)$pcr),
          html = "results/plots/glimma_mds.html")
cat("  Gespeichert: results/plots/glimma_mds.html\n")

# -----------------------------------------------
# Schritt 3: Heatmap der Top-DEGs (Union aus allen Kontrasten)
# -----------------------------------------------
cat("\n3) Heatmap der Top-DEGs...\n")

# Top 30 Probes pro Kontrast -> Union
top_probes <- c()
for (contr in contrasts_list) {
    tt <- topTable(fit2, coef = contr, number = 30,
                   adjust.method = "BH", sort.by = "P")
    top_probes <- union(top_probes, rownames(tt))
}
cat("  Anzahl Top-Probes (Union):", length(top_probes), "\n")

# Expression-Matrix der Top-Probes
heat_mat <- exprs(eset)[top_probes, ]

heat_labels <- gene_symbols[top_probes]
heat_labels[is.na(heat_labels)] <- top_probes[is.na(heat_labels)]
rownames(heat_mat) <- make.unique(as.character(heat_labels))

# Z-Score pro Gen (Zeile) -> vergleichbare Farbskala
heat_mat_z <- t(scale(t(heat_mat)))

# Spalten-Annotation (Subtyp + pCR)
col_anno <- data.frame(
    Subtype = subtype,
    pCR     = pData(eset)$pcr,
    row.names = sampleNames(eset)
)
ann_colors <- list(
    Subtype = c(basL = "#e41a1c", lumA = "#4daf4a",
                lumB = "#377eb8", lumC = "#984ea3"),
    pCR     = c(pCR = "#fdae61", `non-pCR` = "grey70")
)

pheatmap(heat_mat_z,
         annotation_col    = col_anno,
         annotation_colors = ann_colors,
         show_rownames     = TRUE,
         show_colnames     = FALSE,
         fontsize_row      = 6,
         clustering_distance_cols = "euclidean",
         clustering_method = "ward.D2",
         color    = colorRampPalette(rev(brewer.pal(11, "RdBu")))(100),
         main     = "Top-DEGs (Union aus basL vs lumA/B/C)",
         filename = "results/plots/heatmap_top_degs.png",
         width    = 12,
         height   = 10)
cat("  Gespeichert: results/plots/heatmap_top_degs.png\n")


library(clusterProfiler)
library(enrichplot)
library(msigdbr)
library(dplyr)
library(tibble)
library(limma)
library(Biobase)
library(ggplot2)
# -----------------------------------------------
# Daten laden (Ergebnisse aus Skript 04)
# -----------------------------------------------
cat("Lade DEG-Ergebnisse aus Skript 04...\n")
deg_files <- list.files("results/deg", pattern = "^deg_.*\\.csv$", full.names = TRUE)
contrasts_list <- sub(".*deg_(.*)\\.csv$", "\\1", basename(deg_files))
cat("Kontraste:", paste(contrasts_list, collapse = ", "), "\n")

dir.create("results/pathway", showWarnings = FALSE, recursive = TRUE)

# Ergebnis-Liste aufbauen: DEG CSVs laden
# Pro Gen nur die Probe mit staerkstem |logFC| behalten

cat("\nBereite topTable-Ergebnisse vor...\n")
result <- list()
for (i in seq_along(contrasts_list)) {
    tt <- read.csv(deg_files[i], stringsAsFactors = FALSE)
    tt <- tt[!is.na(tt$SYMBOL) & tt$SYMBOL != "", ]
    tt <- tt[order(abs(tt$logFC), decreasing = TRUE), ]
    tt <- tt[!duplicated(tt$SYMBOL), ]
    result[[contrasts_list[i]]] <- tt
}
cat("Kontraste in result-Liste:", length(result), "\n")

# MSigDB aufbauen

cat("\nLade MSigDB (Homo sapiens)...\n")
msigdb <- msigdbr(species = "Homo sapiens")
cat(
    "MSigDB geladen:", nrow(msigdb), "Eintraege,",
    length(unique(msigdb$gs_collection)), "Kategorien\n"
)

# C5 = Gene Ontology (BP + CC + MF)
# term2gene: gs_id + gene_symbol  (fuer enricher/GSEA)
# term2name: gs_id + gs_name      (fuer lesbare Namen in Plots)
cat("Filtere C5 (Gene Ontology)...\n")
term2gene <- msigdb %>%
    dplyr::filter(gs_collection == "C5") %>%
    dplyr::select(gs_id, gene_symbol)

term2name <- msigdb %>%
    dplyr::filter(gs_collection == "C5") %>%
    dplyr::select(gs_id, gs_name) %>%
    distinct()

cat("C5 Gen-Sets:", length(unique(term2gene$gs_id)), "\n")


# ORA - Over-Representation Analysis

cat("\n--- ORA  ---\n")

enricher_result <- lapply(result, function(df) {
    universe <- df %>%
        dplyr::select(SYMBOL) %>%
        deframe()

    gene <- df %>%
        dplyr::filter(adj.P.Val < 0.05) %>% # Kap. 8.4.1: nur adj.P < 0.05
        dplyr::select(SYMBOL) %>%
        deframe()

    cat("  Signifikante Gene (adj.P<0.05):", length(gene), "\n")

    enricher(
        gene          = gene,
        pvalueCutoff  = 1, # alles fangen, spaeter per q-Value filtern
        pAdjustMethod = "BH",
        qvalueCutoff  = 1,
        universe      = universe,
        TERM2GENE     = term2gene,
        TERM2NAME     = term2name
    )
})

# Ergebnisse speichern und plotten
for (contr in contrasts_list) {
    er <- enricher_result[[contr]]
    if (is.null(er)) {
        cat("ORA", contr, ": NULL (kein Ergebnis)\n")
        next
    }
    er_df <- as.data.frame(er)
    if (nrow(er_df) == 0) {
        cat("ORA", contr, ": keine signifikanten Pathways\n")
        next
    }

    # CSV speichern
    ora_file <- paste0("results/pathway/ora_", contr, ".csv")
    write.csv(er_df, ora_file, row.names = FALSE)
    cat("ORA", contr, ":", nrow(er_df), "Pathways ->", ora_file, "\n")

    # Dotplot (Top 15, gefiltert auf q < 0.2)
    p_dot <- dotplot(er, showCategory = 15, font.size = 8) +
        ggtitle(paste("ORA (C5):", gsub("_", " ", contr))) +
        theme(
            plot.title = element_text(size = 10, face = "bold"),
            axis.text.y = element_text(size = 7)
        )

    plot_file <- paste0("results/pathway/ora_dotplot_", contr, ".png")
    ggsave(plot_file, p_dot, width = 10, height = 7, dpi = 150)
    cat("  Dotplot ->", plot_file, "\n")
}


# GSEA - Gene Set Enrichment Analysis

cat("\n--- GSEA ---\n")

gsea_result <- lapply(result, function(df) {
    # Rankliste: alle Gene, absteigend nach logFC geordnet
    gene <- df %>%
        dplyr::select(SYMBOL, logFC) %>%
        arrange(desc(logFC)) %>%
        deframe() # erster Spaltenname -> Namen, zweite Spalte -> Werte

    cat("  Gene in Rankliste:", length(gene), "\n")

    set.seed(42)
    GSEA(
        geneList     = gene,
        pvalueCutoff = 1, # alles fangen, spaeter filtern
        TERM2GENE    = term2gene,
        TERM2NAME    = term2name,
        eps          = 0,
        verbose      = FALSE
    )
})

# Ergebnisse speichern und plotten
for (contr in contrasts_list) {
    gr <- gsea_result[[contr]]
    if (is.null(gr)) {
        cat("GSEA", contr, ": NULL\n")
        next
    }
    gr_df <- as.data.frame(gr)
    if (nrow(gr_df) == 0) {
        cat("GSEA", contr, ": keine Ergebnisse\n")
        next
    }

    gr_sig <- gr_df[gr_df$p.adjust < 0.05, ]
    cat(
        "GSEA", contr, ": gesamt", nrow(gr_df),
        "Pathways, signifikant (p.adj<0.05):", nrow(gr_sig), "\n"
    )
    cat("  NES > 0 (up in basL):", sum(gr_sig$NES > 0, na.rm = TRUE), "\n")
    cat("  NES < 0 (down in basL):", sum(gr_sig$NES < 0, na.rm = TRUE), "\n")

    gsea_file <- paste0("results/pathway/gsea_", contr, ".csv")
    write.csv(gr_sig, gsea_file, row.names = FALSE)
    cat("  CSV ->", gsea_file, "\n")

    # Dotplot (Top 20, aufgeteilt in aktiviert/supprimiert)
    p_dot <- dotplot(gr,
        showCategory = 20,
        split = ".sign", font.size = 7
    ) +
        facet_grid(. ~ .sign) +
        ggtitle(paste("GSEA (C5):", gsub("_", " ", contr))) +
        theme(
            plot.title = element_text(size = 10, face = "bold"),
            strip.text = element_text(face = "bold"),
            axis.text.y = element_text(size = 6)
        )

    plot_file <- paste0("results/pathway/gsea_dotplot_", contr, ".png")
    ggsave(plot_file, p_dot, width = 14, height = 8, dpi = 150)
    cat("  Dotplot ->", plot_file, "\n")
}

# ==============================================
# Differentielle Expressionsanalyse mit limma
#
# Kontraste (Non-luminal vs jede luminale Subgruppe):
#   basL vs lumA
#   basL vs lumB
#   basL vs lumC
#
# ==============================================

library(limma)
library(Biobase)
library(hgu133plus2.db)

cat("Lade bereinigten ExpressionSet...\n")
eset <- readRDS("data/processed/eset_clean.rds")
cat("Geladen:", ncol(eset), "Samples,", nrow(eset), "Probes\n")

# Subtyp-Faktor als Gruppierungsvariable
subtype <- factor(pData(eset)$subtype_cit256,
                  levels = c("basL", "lumA", "lumB", "lumC"))
cat("\nSubtyp-Verteilung:\n")
print(table(subtype))

# -----------------------------------------------
# Schritt 1: Design-Matrix (Prof-Buch Kap. 7.5.1.1)
# ~0 + factor -> keine Intercept -> Gruppenmittelwerte direkt
# -----------------------------------------------
design <- model.matrix(~0 + subtype)
colnames(design) <- levels(subtype)
cat("\nDesign-Matrix Dimensionen:", nrow(design), "x", ncol(design), "\n")

# -----------------------------------------------
# Schritt 2: Kontraste definieren Prof-Buch Kap. 7.5.1.2
# -----------------------------------------------
contrast_matrix <- makeContrasts(
    basL_vs_lumA = basL - lumA,
    basL_vs_lumB = basL - lumB,
    basL_vs_lumC = basL - lumC,
    levels = design
)
cat("\nKontraste:\n")
print(contrast_matrix)

# -----------------------------------------------
# Schritt 3: limma Fit
# -----------------------------------------------
cat("\nFitte lineares Modell...\n")
fit  <- lmFit(exprs(eset), design)
fit2 <- contrasts.fit(fit, contrast_matrix)
fit2 <- eBayes(fit2)
cat("Fit abgeschlossen.\n")

# -----------------------------------------------
# Schritt 4: Probe-Annotation (hgu133plus2.db)
# Affymetrix Probe-ID -> Gen-Symbol + Beschreibung
# -----------------------------------------------
cat("\nAnnotiere Probes mit Gen-Symbolen...\n")
probe_ids    <- rownames(exprs(eset))
gene_symbols <- mapIds(hgu133plus2.db, keys = probe_ids,
                       column = "SYMBOL",   keytype = "PROBEID",
                       multiVals = "first")
gene_names   <- mapIds(hgu133plus2.db, keys = probe_ids,
                       column = "GENENAME", keytype = "PROBEID",
                       multiVals = "first")

# -----------------------------------------------
# Schritt 5: Ergebnisse pro Kontrast extrahieren + speichern
# -----------------------------------------------
dir.create("results/deg", showWarnings = FALSE, recursive = TRUE)

contrasts_list <- colnames(contrast_matrix)
for (contr in contrasts_list) {
    cat("\n--- Kontrast:", contr, "---\n")
    tt <- topTable(fit2, coef = contr, number = Inf,
                   adjust.method = "BH", sort.by = "P")
    tt$PROBEID  <- rownames(tt)
    tt$SYMBOL   <- gene_symbols[rownames(tt)]
    tt$GENENAME <- gene_names[rownames(tt)]
    tt <- tt[, c("PROBEID", "SYMBOL", "GENENAME",
                 "logFC", "AveExpr", "t", "P.Value", "adj.P.Val", "B")]

    # Signifikante Gene (adj.P < 0.05, |logFC| > 1)
    n_sig <- sum(tt$adj.P.Val < 0.05 & abs(tt$logFC) > 1, na.rm = TRUE)
    n_up  <- sum(tt$adj.P.Val < 0.05 & tt$logFC >  1, na.rm = TRUE)
    n_dn  <- sum(tt$adj.P.Val < 0.05 & tt$logFC < -1, na.rm = TRUE)
    cat("Signifikant (adj.P<0.05, |logFC|>1):", n_sig,
        "(up:", n_up, ", down:", n_dn, ")\n")

    outfile <- paste0("results/deg/deg_", contr, ".csv")
    write.csv(tt, file = outfile, row.names = FALSE)
    cat("Gespeichert:", outfile, "\n")
}

# fit2-Objekt speichern fuer spaetere Plots (Volcano, Heatmap)
saveRDS(fit2, file = "data/processed/limma_fit.rds")
cat("\nlimma Fit-Objekt gespeichert: data/processed/limma_fit.rds\n")

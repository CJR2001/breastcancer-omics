library(GEOquery)
library(Biobase)

# Normalisierter ExpressionSet laden
cat("Lade normalisierten ExpressionSet...\n")
eset <- readRDS("data/processed/eset_normalized.rds")
cat("Geladen:", ncol(eset), "Samples,", nrow(eset), "Probes\n")

# Phenodaten von GEO herunterladen
cat("Lade Metadaten von GEO (GSE231629)...\n")
gse <- getGEO("GSE231629", GSEMatrix = TRUE, getGPL = FALSE)
gse <- gse[[1]]
pheno <- pData(gse)

# GSM IDs aus unseren Sample-Namen extrahieren
# Format: "GSM7294844_Sample001.CEL.gz" -> "GSM7294844"
our_gsm <- sub("_.*", "", sampleNames(eset))

# PhenoData auf unsere Samples matchen
pheno_matched <- pheno[our_gsm, ]
rownames(pheno_matched) <- sampleNames(eset)

# Saubere Spalten extrahieren
# cit256 subtype: lumA, lumB, basL, normL, mApo
pheno_matched$subtype_cit256 <- sub("cit256 subtype: ", "",
                                     pheno_matched$`cit256 subtype:ch1`)

# pam50 subtype: Luminal_A, Luminal_B, Basal-like, Normal-like, HER2-enriched
pheno_matched$subtype_pam50 <- sub("pam50 subtype: ", "",
                                    pheno_matched$`pam50 subtype:ch1`)

# RCB status: 0 = pCR, 1-3 = Resttumor
pheno_matched$rcb <- as.numeric(sub("rcb status: ", "",
                                     pheno_matched$`rcb status:ch1`))

# Binaere pCR Variable: RCB 0 = pCR, RCB 1-3 = non-pCR
pheno_matched$pcr <- ifelse(pheno_matched$rcb == 0, "pCR", "non-pCR")

# Non-luminal vs luminal Gruppe (fuer Hauptvergleich)
# Non-luminal: basL, mApo | Luminal: lumA, lumB
pheno_matched$luminal_group <- ifelse(
    pheno_matched$subtype_cit256 %in% c("basL", "mApo"),
    "Non-luminal",
    "Luminal"
)

# PhenoData ans ExpressionSet haengen (laut Prof-Buch Kap. 7.1.1)
pData(eset) <- pheno_matched

# Subtyp-Verteilung ausgeben
cat("\nSubtyp-Verteilung (CIT256):\n")
print(table(pheno_matched$subtype_cit256))

cat("\nLuminal vs Non-luminal:\n")
print(table(pheno_matched$luminal_group))

cat("\npCR-Rate gesamt:\n")
print(table(pheno_matched$pcr))

cat("\npCR-Rate nach Luminal-Gruppe:\n")
print(table(pheno_matched$luminal_group, pheno_matched$pcr))

# Outlier entfernen (bestaetigt aus qc_before + qc_after)
# Sample029 = GSM7294872: 3 Kriterien pre-norm, 1 post-norm
# Sample104 = GSM7294947: 5 Kriterien pre-norm, 2 post-norm
outliers <- c("GSM7294872_Sample029.CEL.gz", "GSM7294947_Sample104.CEL.gz")

cat("\nEntferne Outlier:\n")
cat(paste(" -", outliers), sep = "\n")

keep <- !sampleNames(eset) %in% outliers
eset_clean <- eset[, keep]

cat("\nFinaler Datensatz:", ncol(eset_clean), "Samples,", nrow(eset_clean), "Probes\n")

cat("\nSubtyp-Verteilung nach Outlier-Entfernung:\n")
print(table(pData(eset_clean)$subtype_cit256))

# Bereinigten ExpressionSet speichern
saveRDS(eset_clean, file = "data/processed/eset_clean.rds")
cat("\nBereinigter ExpressionSet gespeichert: data/processed/eset_clean.rds\n")

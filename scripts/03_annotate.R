# ==============================================
# 03_annotate.R
# Sample-Annotationen laden + Outlier + Subgruppen
# GSE231629 | Jensen et al. 2023
#
# Finale Gruppenstruktur (nach Prof-Feedback):
#   lumA (n=25), lumB (n=35), lumC (n=13) -> je eigene Gruppe
#   basL (n=17)                            -> Non-luminal
#   mApo                                   -> Ausschluss (n=2, zu wenig Power)
#   normL                                  -> Ausschluss (normales Gewebe)
#   QC-Outlier: Sample029, Sample104       -> Ausschluss
# ==============================================

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
pheno_matched$subtype_cit256 <- sub("cit256 subtype: ", "",
                                     pheno_matched$`cit256 subtype:ch1`)

pheno_matched$subtype_pam50 <- sub("pam50 subtype: ", "",
                                    pheno_matched$`pam50 subtype:ch1`)

# RCB status: 0 = pCR, 1-3 = Resttumor
pheno_matched$rcb <- as.numeric(sub("rcb status: ", "",
                                     pheno_matched$`rcb status:ch1`))

# Binaere pCR Variable
pheno_matched$pcr <- ifelse(pheno_matched$rcb == 0, "pCR", "non-pCR")

# PhenoData ans ExpressionSet haengen (laut Prof-Buch Kap. 7.1.1)
pData(eset) <- pheno_matched

# Subtyp-Verteilung vor Ausschluss
cat("\nSubtyp-Verteilung vor Ausschluss:\n")
print(table(pheno_matched$subtype_cit256))

# -----------------------------------------------
# Schritt 1: QC-Outlier entfernen
# Sample029 = GSM7294872: 3 Kriterien pre-norm, 1 post-norm
# Sample104 = GSM7294947: 5 Kriterien pre-norm, 2 post-norm
# -----------------------------------------------
outliers <- c("GSM7294872_Sample029.CEL.gz", "GSM7294947_Sample104.CEL.gz")
keep <- !sampleNames(eset) %in% outliers
eset <- eset[, keep]
cat("\nNach QC-Outlier Entfernung:", ncol(eset), "Samples\n")

# -----------------------------------------------
# Schritt 2: mApo und normL ausschliessen
# mApo: n=2, zu wenig statistische Power (Prof-Empfehlung)
# normL: normales Gewebe, kein Tumorsubtyp
# -----------------------------------------------
exclude_subtypes <- c("mApo", "normL")
keep2 <- !pData(eset)$subtype_cit256 %in% exclude_subtypes
eset_clean <- eset[, keep2]
cat("Nach Ausschluss mApo + normL:", ncol(eset_clean), "Samples\n")

# Finale Subtyp-Verteilung
cat("\nFinale Subtyp-Verteilung:\n")
print(table(pData(eset_clean)$subtype_cit256))

cat("\npCR-Rate pro Subtyp:\n")
print(table(pData(eset_clean)$subtype_cit256, pData(eset_clean)$pcr))

# Bereinigten ExpressionSet speichern
saveRDS(eset_clean, file = "data/processed/eset_clean.rds")
cat("\nBereinigter ExpressionSet gespeichert: data/processed/eset_clean.rds\n")
cat("Finale Analysebasis:", ncol(eset_clean), "Samples,", nrow(eset_clean), "Probes\n")

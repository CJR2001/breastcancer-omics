# ==============================================
# 01_load_qc.R
# CEL Files einlesen + QC vor Normalisierung
# GSE231629 | Jensen et al. 2023
# ==============================================

library(affy)
library(arrayQualityMetrics)

# Pfad zu den entpackten CEL Files
cel_path <- "data/raw/GSE231629_RAW/"

# CEL Files einlesen
cat("Lese CEL Files ein...\n")
raw_data <- ReadAffy(celfile.path = cel_path)
cat("Eingelesen:", length(sampleNames(raw_data)), "Samples\n")

# QC VOR Normalisierung
cat("Starte QC vor Normalisierung...\n")
arrayQualityMetrics(
    expressionset = raw_data,
    outdir        = "results/qc_before",
    force         = TRUE,
    do.logtransform = TRUE
)
cat("QC Report gespeichert in results/qc_before/\n")
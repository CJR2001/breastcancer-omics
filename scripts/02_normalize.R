library(affy)
library(arrayQualityMetrics)

# Pfad zu den CEL Files
cel_path <- "data/raw/GSE231629_RAW/"

# CEL Files einlesen
cat("Lese CEL Files ein...\n")
raw_data <- ReadAffy(celfile.path = cel_path)
cat("Eingelesen:", length(sampleNames(raw_data)), "Samples\n")

# RMA Normalisierung (Background correction + Quantile normalization + Summarization)
cat("Starte RMA Normalisierung...\n")
eset <- rma(raw_data)
cat("Normalisierung abgeschlossen.\n")
cat("Dimensionen Expression Matrix:", nrow(eset), "Probes x", ncol(eset), "Samples\n")

# Normalized Expression Matrix speichern
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
write.csv(exprs(eset), file = "data/processed/rma_normalized.csv")
saveRDS(eset, file = "data/processed/eset_normalized.rds")
cat("Normalisierte Daten gespeichert: data/processed/rma_normalized.csv\n")
cat("ExpressionSet gespeichert: data/processed/eset_normalized.rds\n")

# QC NACH Normalisierung
cat("Starte QC nach Normalisierung...\n")
arrayQualityMetrics(
    expressionset = eset,
    outdir        = "results/qc_after",
    force         = TRUE,
    do.logtransform = FALSE   # RMA Output ist bereits log2-transformiert
)
cat("QC Report gespeichert in results/qc_after/\n")

# Outlier aus Pre-Normalisierungs QC (>= 2 Kriterien geflaggt)
# Basierend auf results/qc_before/index.html
outliers_pre <- c("GSM7294872", "GSM7294947", "meisten x in Tabelle in index.html -> Array metadata")

cat("\nBekannte Pre-Norm Outlier (>= 2 Kriterien):\n")
cat(paste(" -", outliers_pre), sep = "\n")
cat("\n-> Post-Normalisierungs QC in results/qc_after/ pruefen\n")
cat("-> Dann 03_annotate.R ausfuehren\n")

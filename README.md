# Breast Cancer Omics Project

Re-analysis of GSE231629 (Jensen et al., NPJ Breast Cancer 2023)

## Hypothese
Non-luminale Subtypen (Basal-like, mApo) zeigen im Vergleich zu 
luminalen Subtypen (LumA, LumB) signifikant unterschiedlich 
exprimierte Gene, die mit dem Ansprechen auf neoadjuvante 
Chemotherapie (pCR) assoziiert sind.

## Datensatz
- GEO: GSE231629
- Platform: Affymetrix HG-U133 Plus 2.0 (GPL570)
- Samples: 109

## Workflow
1. CEL Files einlesen (affy)
2. QC vor Normalisierung (arrayQualityMetrics)
3. RMA Normalisierung
4. QC nach Normalisierung
5. Sample-Annotation + Outlier/Subtyp-Filter (GEOquery)
6. DEG Analyse (limma)
7. Volcano Plot + Heatmap
8. Pathway Analyse (WikiPathways)

## Setup: Benötigte R-Pakete

### Bioconductor Packages
```r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c(
    "affy",
    "arrayQualityMetrics",
    "limma",
    "hgu133plus2.db",
    "Biobase",
    "Glimma"
))
```

### GEOquery (separat, falls BiocManager-Installation fehlschlägt)
```r
install.packages("GEOquery", repos = "https://bioconductor.org/packages/3.18/bioc")
```

### CRAN Dependencies (werden für arrayQualityMetrics benötigt)
```r
install.packages(c(
    "svglite",
    "RSQLite",
    "statmod",
    "ggplot2",
    "ggrepel",
    "pheatmap",
    "RColorBrewer"
), repos = "https://cloud.r-project.org")
```

### Verifizieren
```r
library(affy)
library(arrayQualityMetrics)
library(limma)
library(hgu133plus2.db)
library(GEOquery)
library(Glimma)
library(ggplot2)
library(ggrepel)
library(pheatmap)
library(RColorBrewer)
```

## Ausführung der Skripte
```bash
Rscript scripts/01_load_qc.R      # CEL Files + QC vor Normalisierung
Rscript scripts/02_normalize.R    # RMA Normalisierung + QC danach
Rscript scripts/03_annotate.R     # Metadaten + Outlier/Subtyp-Filter
Rscript scripts/04_deg.R          # limma DEG-Analyse
Rscript scripts/05_plots.R        # Volcano + Heatmap + Glimma HTMLs
```

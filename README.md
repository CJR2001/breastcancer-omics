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
5. DEG Analyse (limma)
6. Volcano Plot + Heatmap
7. Pathway Analyse (WikiPathways)

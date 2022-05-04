---
title: "1. Day 01"
day: "Day 01"
---

---

## Presentations for {{< param "day" >}}

- Introduction to Hi-C **\[40min\]**: [HTML](/{{<myPackageUrl>}}Presentations/day01/intro_hic.html) | [PDF](/{{<myPackageUrl>}}Presentations/day01/NGS_analysis.pdf)
- Streamlining NGS processing pipelines with Snakemake **\[20min\]**: [HTML](/{{<myPackageUrl>}}Presentations/day01/snakemake_pipelines.html) | [PDF](/{{<myPackageUrl>}}Presentations/day01/snakemake_pipelines.pdf)

---

## Demonstrations for {{< param "day" >}}

- Processing Hi-C data from the start **\[60min\]** [[HTML](/{{<myPackageUrl>}}Exercices/day01/1-1_processing_hic.html) | [Rmd](/{{<myPackageUrl>}}Exercices/day01/1-1_processing_hic.Rmd)]

    You will be working with published wild type yeast (_S. cerevisiae_) data from [Dauban, L. et al., 2020](https://www.cell.com/molecular-cell/fulltext/S1097-2765(20)30040-X). The dataset we will use is subsampled from [SRR10687276](https://www.ncbi.nlm.nih.gov/sra/SRR10687276[accn]).

- Improving the workflow with snakemake **\[60min\]** [[HTML](/{{<myPackageUrl>}}Exercices/day01/1-2_snakemake_pipeline.html) | [Rmd](/{{<myPackageUrl>}}Exercices/day01/1-2_snakemake_pipeline.Rmd)]

    You will be streamlining the process from the previous exercise to make it more reproducible, easily tweak parameters or add new samples. We will be adding another yeast library in M phase ([SRR8769549](https://www.ncbi.nlm.nih.gov/sra/SRR8769549[accn])) and doing basic comparisons between the conditions.



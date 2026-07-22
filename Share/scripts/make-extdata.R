## ---------------------------------------------------------------------------
## Example `inst/scripts/make-extdata.R` for Day 3.
##
## Bioconductor asks that every raw data file shipped in `inst/extdata/` is
## documented: where does it come from, and how was it generated? This script
## is an *example* of such documentation for the two toy files used throughout
## the workshop.
##
## The two files are a small subset of a cohesin (Scc1) ChIP-seq experiment
## in Saccharomyces cerevisiae:
##   - Scc1-vs-input.bw      : log2(Scc1 / input) coverage track (bigwig)
##   - Scc1-peaks.narrowPeak : Scc1 binding sites called with MACS2
## ---------------------------------------------------------------------------

## 1. Reads were aligned to the sacCer3 genome with bowtie2:
# bowtie2 -x sacCer3 -1 Scc1_R1.fq.gz -2 Scc1_R2.fq.gz | samtools sort -o Scc1.bam
# bowtie2 -x sacCer3 -1 input_R1.fq.gz -2 input_R2.fq.gz | samtools sort -o input.bam

## 2. A log2-ratio coverage track was computed with deeptools:
# bamCompare -b1 Scc1.bam -b2 input.bam --operation log2 -o Scc1-vs-input.bw

## 3. Peaks were called with MACS2:
# macs2 callpeak -t Scc1.bam -c input.bam -f BAMPE -g 12e6 -n Scc1

## 4. Both files were subset to a single chromosome, to keep them small enough
##    to be shipped with the package:
library(rtracklayer)

cov <- import("Scc1-vs-input.bw")
cov <- cov[seqnames(cov) == "chrIV"]
export(cov, "inst/extdata/Scc1-vs-input.bw")

peaks <- import("Scc1_peaks.narrowPeak")
peaks <- peaks[seqnames(peaks) == "chrIV"]
export(peaks, "inst/extdata/Scc1-peaks.narrowPeak")

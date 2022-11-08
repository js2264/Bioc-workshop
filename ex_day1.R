###
### -- Load packages
###

library(Biostrings)
library(GenomicRanges)
library(rtracklayer)
library(ggplot2)
library(rtracklayer)

###
### -- Parse fasta file and ce11 gene annotations
###

gseq <- readDNAStringSet('Share/Day1/ce11.fa')
genes <- import('Share/Day1/ce11_annotations.gtf')
seqlevels(genes) <- seqlevels(genes)[c(5, 4, 6, 3, 1, 2, 7)]
seqlevels(genes, pruning.mode = 'coarse') <- seqlevels(genes)[1:6]
seqlevelsStyle(genes) <- "UCSC"

###
### -- Create a list of tissue-specific forward TSSs
###

WINDOW_SIZE <- 300
TSSs <- resize(genes, fix = 'start', width = 1) |>
    resize(fix = 'center', width = WINDOW_SIZE)
tissues <- c("Germline", "Neurons", "Muscle", "Hypod.", "Intest.", "Ubiq.")
TSS_list <- lapply(tissues, function(tissue) {
    TSSs[TSSs$tissue == tissue & strand(TSSs) == '+']
})
names(TSS_list) <- tissues

###
### -- Create plotMotifDistance function
###

plotMotifDistance <- function(seqs, motif, n_mismatch = 1) {
    motif_occurences <- vmatchPattern(motif, seqs, max.mismatch = n_mismatch, fixed = FALSE)
    positions <- unlist(startIndex(motif_occurences))
    df <- data.frame(pos = positions - WINDOW_SIZE/2)
    ggplot(df, aes(x = pos)) +
        geom_histogram(binwidth = 5) +
        labs(
            x = "Distance to TSS",
            y = glue::glue("# of {motif} motifs"),
            caption = glue::glue("{length(positions)} motifs found amongst {length(seqs)} sequences")
        )
}

###
### -- Execute plotting function for each group of tissue-specific TSSs;
###    Do it for TATA box ("TATAWAA") and Inr sequence ("YYANWYY")
###

p <- lapply(names(TSS_list), function(tissue) {
    TSSs <- TSS_list[[tissue]]
    plotMotifDistance(
        gseq[TSSs],
        "TATAWAA",
        n_mismatch = 0
    ) + ggtitle(glue::glue("{tissue} TSSs"))
})
p <- cowplot::plot_grid(plotlist = p)
ggsave('TATA-boxes_tissue-specific-TSSs.pdf', width = 15, height = 15)

p <- lapply(names(TSS_list), function(tissue) {
    TSSs <- TSS_list[[tissue]]
    plotMotifDistance(
        gseq[TSSs],
        "YYANWYY",
        n_mismatch = 1
    ) + ggtitle(glue::glue("{tissue} TSSs"))
})
p <- cowplot::plot_grid(plotlist = p)
ggsave('Inr_tissue-specific-TSSs.pdf', width = 15, height = 15)


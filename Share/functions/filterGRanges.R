#' Filter out features that cannot be scored against a coverage track
#'
#' Removes genomic features that cannot be scored against a coverage track,
#' i.e. features located on a chromosome that is absent from the coverage
#' track, or features extending beyond the boundaries of their chromosome.
#' This avoids "out-of-bounds" errors when the coverage is later extracted
#' over each feature.
#'
#' @param l A `list` as returned by [importFiles()], with a `coverage`
#'   ([S4Vectors::RleList]) and a `features` ([GenomicRanges::GRanges])
#'   element.
#'
#' @return The input `list`, with its `features` element filtered.
#'
#' @importFrom GenomicRanges seqnames start end
#' @export
#'
#' @examples
#' bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
#' bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
#' l <- importFiles(bw_file, bed_file, width = 2000)
#' filterGRanges(l)
filterGRanges <- function(l) {
    coverage <- l$coverage
    features <- l$features
    chroms <- as.character(GenomicRanges::seqnames(features))
    ## Chromosome lengths are the lengths of each Rle in the coverage track
    chrom_lengths <- lengths(coverage)
    ## Keep features sitting on a covered chromosome ...
    on_covered_chrom <- chroms %in% names(coverage)
    ## ... and fully contained within that chromosome's boundaries
    within_bounds <- GenomicRanges::start(features) >= 1 &
        GenomicRanges::end(features) <= chrom_lengths[chroms]
    l$features <- features[on_covered_chrom & within_bounds]
    l
}

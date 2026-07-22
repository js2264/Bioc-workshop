#' Import a coverage track and a set of genomic features
#'
#' Imports a coverage track (e.g. a `bigwig` file) as an
#' [S4Vectors::RleList] and a set of genomic features (e.g. a `bed` or
#' `narrowPeak` file) as a [GenomicRanges::GRanges] object. Each feature is
#' resized to a fixed `width`, centered on the middle of the original feature,
#' so that all features can later be aggregated together.
#'
#' @param bw_file Path to a single coverage track file (e.g. a `.bw` file).
#' @param features_file Path to a single features file (e.g. a `.bed` or
#'   `.narrowPeak` file).
#' @param width Integer. The width (in bp) to which each feature is resized,
#'   centered on the feature center.
#'
#' @return A named `list` with two elements:
#'   * `coverage`: an [S4Vectors::RleList] with the genome-wide coverage.
#'   * `features`: a [GenomicRanges::GRanges] of features resized to `width`.
#'
#' @importFrom rtracklayer import
#' @importFrom GenomicRanges resize
#' @export
#'
#' @examples
#' bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
#' bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
#' l <- importFiles(bw_file, bed_file, width = 2000)
#' l
importFiles <- function(bw_file, features_file, width) {
    ## Import the coverage track as one Rle per chromosome (an RleList)
    coverage <- rtracklayer::import(bw_file, as = "RleList")
    ## Import the genomic features as a GRanges
    features <- rtracklayer::import(features_file)
    ## Resize every feature to a fixed width, centered on its center
    features <- GenomicRanges::resize(features, width = width, fix = "center")
    list(coverage = coverage, features = features)
}

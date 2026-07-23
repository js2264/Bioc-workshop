#' Aggregate the coverage of a track over a set of features
#'
#' Constructor for [AggregatedCoverage-class] objects. It imports a coverage
#' track and a set of features, discards the features that cannot be scored,
#' computes the per-position mean coverage (+/- 95% CI) and stores everything
#' in an `AggregatedCoverage` object.
#'
#' @param bw_file Path to a single coverage track file (e.g. a `.bw` file).
#' @param features_file Path to a single features file (e.g. a `.bed` or
#'   `.narrowPeak` file).
#' @param width Integer. The width (in bp) to which each feature is resized.
#'
#' @return An [AggregatedCoverage-class] object, with three assays (`mean`,
#'   `upCI` and `lowCI`).
#'
#' @importFrom SummarizedExperiment SummarizedExperiment
#' @importFrom methods new
#' @export
#'
#' @examples
#' bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
#' bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
#' AggregatedCoverage(bw_file, bed_file, width = 2000)
AggregatedCoverage <- function(bw_file, features_file, width) {
    width <- as.integer(width)

    ## Import, filter and aggregate the coverage (functions from Day 1 & 2)
    l <- importFiles(bw_file, features_file, width = width) |>
        filterGRanges()
    df <- computeCoverage(l)

    ## Assemble the SummarizedExperiment building blocks
    colData <- data.frame(file = bw_file)
    rowData <- data.frame(distance = df$distance)
    assays <- list(
        mean = matrix(df$mean, ncol = 1),
        upCI = matrix(df$ci_high, ncol = 1),
        lowCI = matrix(df$ci_low, ncol = 1)
    )
    se <- SummarizedExperiment::SummarizedExperiment(
        assays = assays,
        rowData = rowData,
        colData = colData
    )

    ## Promote the SummarizedExperiment to an AggregatedCoverage
    ac <- methods::new("AggregatedCoverage", se)
    ac@features <- l$features
    ac@width <- width
    ac
}

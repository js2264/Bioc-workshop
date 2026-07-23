#' AggregatedCoverage S4 class
#'
#' An `AggregatedCoverage` object stores the aggregated coverage of a genomic
#' track over a set of genomic features. It is a direct extension of the
#' [SummarizedExperiment::SummarizedExperiment] class, with two additional
#' slots.
#'
#' @slot features A [GenomicRanges::GRanges] of the (resized) features over
#'   which the coverage was aggregated.
#' @slot width Integer. The width (in bp) at which each feature was resized.
#'
#' @return An `AggregatedCoverage` object. It contains a `rowData` (the
#'   distance to the center of the features), a `colData` (the sample(s)) and
#'   three assays: `mean`, `upCI` and `lowCI`.
#'
#' @name AggregatedCoverage-class
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @importFrom methods setClass
#' @exportClass AggregatedCoverage
methods::setClass(
    "AggregatedCoverage",
    contains = "SummarizedExperiment",
    slots = list(
        features = "GRanges",
        width = "integer"
    )
)

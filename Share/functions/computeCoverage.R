#' Compute the mean coverage profile over a set of features
#'
#' Extracts the coverage track values over each (fixed-width) feature, orients
#' features located on the minus strand so that all profiles run 5' -> 3', and
#' computes the per-position mean coverage together with a 95% confidence
#' interval.
#'
#' @param l A `list` as returned by [importFiles()] (and ideally filtered with
#'   [filterGRanges()]), with a `coverage` ([S4Vectors::RleList]) and a
#'   `features` ([GenomicRanges::GRanges]) element.
#'
#' @return A `data.frame` with one row per position and the following columns:
#'   * `distance`: distance (in bp) to the center of the features, from
#'     `-width/2` to `width/2 - 1`.
#'   * `mean`: mean coverage across all features at that position.
#'   * `ci_low`, `ci_high`: bounds of the 95% confidence interval.
#'
#' @importFrom GenomicRanges width strand
#' @importFrom stats sd qnorm
#' @export
#'
#' @examples
#' bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
#' bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
#' l <- importFiles(bw_file, bed_file, width = 2000) |> filterGRanges()
#' head(computeCoverage(l))
computeCoverage <- function(l) {
    coverage <- l$coverage
    features <- l$features
    width <- unique(GenomicRanges::width(features))
    stopifnot("All features must share the same width" = length(width) == 1)

    ## Extract the coverage over each feature (an RleList, one Rle per feature)
    ## and reshape it into a `features x positions` numeric matrix
    cov_by_feature <- coverage[features]
    mat <- matrix(
        as.numeric(unlist(cov_by_feature)),
        ncol = width, byrow = TRUE
    )

    ## Flip minus-strand features so every profile runs 5' -> 3'
    is_minus <- as.logical(GenomicRanges::strand(features) == "-")
    if (any(is_minus)) {
        mat[is_minus, ] <- mat[is_minus, rev(seq_len(width)), drop = FALSE]
    }

    ## Per-position mean and 95% confidence interval
    n <- nrow(mat)
    means <- colMeans(mat, na.rm = TRUE)
    sds <- apply(mat, 2, stats::sd, na.rm = TRUE)
    ci <- stats::qnorm(0.975) * sds / sqrt(n)

    data.frame(
        distance = seq(-width / 2, width / 2 - 1, by = 1),
        mean = means,
        ci_low = means - ci,
        ci_high = means + ci
    )
}

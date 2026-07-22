#' Plot an aggregated coverage profile
#'
#' Plots the mean coverage profile (with its confidence interval ribbon)
#' computed by [computeCoverage()], as a function of the distance to the
#' center of the features.
#'
#' @param df A `data.frame` as returned by [computeCoverage()], with columns
#'   `distance`, `mean`, `ci_low` and `ci_high`.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @importFrom ggplot2 ggplot aes geom_ribbon geom_line labs theme_bw
#' @export
#'
#' @examples
#' bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
#' bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
#' importFiles(bw_file, bed_file, width = 2000) |>
#'     filterGRanges() |>
#'     computeCoverage() |>
#'     plotCoverage()
plotCoverage <- function(df) {
    ggplot2::ggplot(df, ggplot2::aes(x = distance, y = mean)) +
        ggplot2::geom_ribbon(
            ggplot2::aes(ymin = ci_low, ymax = ci_high),
            fill = "steelblue", alpha = 0.2
        ) +
        ggplot2::geom_line(color = "steelblue") +
        ggplot2::labs(
            x = "Distance to center (bp)",
            y = "Mean coverage"
        ) +
        ggplot2::theme_bw()
}

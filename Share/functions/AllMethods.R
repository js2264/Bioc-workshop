#' Plot an AggregatedCoverage object
#'
#' `plot` method for [AggregatedCoverage-class] objects. It plots the
#' aggregated coverage profile stored in the object, one line (+/- confidence
#' interval ribbon) per sample (column).
#'
#' @param x An [AggregatedCoverage-class] object.
#' @param ... Ignored.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @importFrom SummarizedExperiment assay colData rowData
#' @importFrom ggplot2 ggplot aes geom_line geom_ribbon labs theme_bw
#' @importFrom methods setMethod
#' @export
methods::setMethod("plot", "AggregatedCoverage", function(x, ...) {
    df <- lapply(seq_len(ncol(x)), function(K) {
        data.frame(
            file = SummarizedExperiment::colData(x)$file[K],
            K = K,
            distance = SummarizedExperiment::rowData(x)$distance,
            mean = SummarizedExperiment::assay(x, "mean")[, K],
            upCI = SummarizedExperiment::assay(x, "upCI")[, K],
            lowCI = SummarizedExperiment::assay(x, "lowCI")[, K]
        )
    }) |> dplyr::bind_rows()
    ggplot2::ggplot(df, mapping = ggplot2::aes(
        x = distance, y = mean, ymin = lowCI, ymax = upCI,
        col = basename(file), fill = basename(file)
    )) +
        ggplot2::geom_line() +
        ggplot2::geom_ribbon(col = NA, alpha = 0.2) +
        ggplot2::labs(x = "Distance to center (bp)", y = "Mean coverage") +
        ggplot2::theme_bw()
})

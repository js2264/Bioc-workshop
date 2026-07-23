## Example test file for Day 3.
##
## Copy it (adapting the paths / expectations to your own package) to
## `tests/testthat/test-computeCoverage.R` after running
## `usethis::use_testthat()`.

test_that("importFiles() returns a coverage track and resized features", {
    bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
    bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
    l <- importFiles(bw_file, bed_file, width = 2000)

    expect_type(l, "list")
    expect_named(l, c("coverage", "features"))
    expect_s4_class(l$coverage, "RleList")
    expect_s4_class(l$features, "GRanges")
    ## Every feature has been resized to the requested width
    expect_true(all(GenomicRanges::width(l$features) == 2000))
})

test_that("filterGRanges() only keeps in-bounds features", {
    bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
    bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
    imported <- importFiles(bw_file, bed_file, width = 2000)
    filtered <- filterGRanges(imported)

    ## Filtering can only remove features, never add any
    expect_true(length(filtered$features) <= length(imported$features))
    ## No remaining feature extends beyond its chromosome start
    expect_true(all(GenomicRanges::start(filtered$features) >= 1))
})

test_that("computeCoverage() returns a well-formed data.frame", {
    bw_file <- system.file("extdata", "Scc1-vs-input.bw", package = "JacquesTestPackage")
    bed_file <- system.file("extdata", "Scc1-peaks.narrowPeak", package = "JacquesTestPackage")
    width <- 2000
    df <- importFiles(bw_file, bed_file, width = width) |>
        filterGRanges() |>
        computeCoverage()

    ## One row per position, four expected columns
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), width)
    expect_named(df, c("distance", "mean", "ci_low", "ci_high"))
    ## The distance axis is centered on 0
    expect_equal(df$distance[1], -width / 2)
    ## The confidence interval always brackets the mean
    expect_true(all(df$ci_low <= df$mean))
    expect_true(all(df$mean <= df$ci_high))
})

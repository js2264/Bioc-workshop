# `Share/` — reference materials for the workshop exercises

This folder holds the **reference code** for the package built across the
exercises (Days 1 to 5). It is kept under version control "for the record",
so that the reference implementation and the exercise sheets stay in sync.

## Contents

```
Share/
├── data/                      # Reference data for the exercises
│   ├── Scc1-peaks.narrowPeak  #   example features
│   └── Scc1-vs-input.bw       #   example track
├── functions/                 # Reference implementation of the package
│   ├── importFiles.R          #   Day 1 & 2 : import a track + features
│   ├── filterGRanges.R        #   Day 1 & 2 : drop un-scorable features
│   ├── computeCoverage.R      #   Day 1 & 2 : aggregate into a mean profile
│   ├── plotCoverage.R         #   Day 2     : plot the profile
│   ├── AllClasses.R           #   Day 4     : the AggregatedCoverage S4 class
│   ├── AggregatedCoverage.R   #   Day 4     : its constructor
│   └── AllMethods.R           #   Day 4     : the plot() method
├── scripts/
│   └── make-extdata.R         #   Day 3     : example inst/scripts/ file
├── tests/
│   └── test-computeCoverage.R #   Day 3     : example testthat file
└── README.md
```

## The four core functions

Together, the four functions chain into a single pipeline:

```r
importFiles(bw_file, features_file, width) |>
    filterGRanges() |>
    computeCoverage() |>
    plotCoverage()
```

They are prototyped interactively in **Day 1**, turned into a documented
package in **Day 2**, given data / examples / tests in **Day 3**, wrapped into
the `AggregatedCoverage` S4 class in **Day 4**, and applied to real
Bioconductor resources in **Day 5**.

## Using these functions

If at any point you are stuck, you can source the reference functions directly:

```r
for (f in list.files("Share/functions", pattern = "\\.R$", full.names = TRUE)) {
    source(f)
}
```

Note that the `system.file(..., package = "JacquesTestPackage")` calls in the
`@examples` assume the toy data has been added to your own package's
`inst/extdata/` folder (see Day 3).


# prcbench <img src="man/figures/logo.png" align="right" alt="" width="100" />

[![R-CMD-check](https://github.com/evalclass/prcbench/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/evalclass/prcbench/actions/workflows/R-CMD-check.yaml)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/evalclass/prcbench?branch=main&svg=true)](https://ci.appveyor.com/project/takayasaito/prcbench/)
[![codecov.io](https://codecov.io/github/evalclass/prcbench/coverage.svg?branch=main)](https://codecov.io/github/evalclass/prcbench?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/evalclass/prcbench/badge)](https://www.codefactor.io/repository/github/evalclass/prcbench/)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version-ago/prcbench)](https://cran.r-project.org/package=prcbench)
[![CRAN_Logs_Badge](https://cranlogs.r-pkg.org/badges/grand-total/prcbench)](https://cran.r-project.org/package=prcbench)

The aim of the `prcbench` package is to provide a testing workbench for
evaluating precision-recall curves under various conditions. It contains
integrated interfaces for the following five tools. It also contains
predefined test data sets.

| Tool          | Platform | Links                                                                                                |
|---------------|----------|------------------------------------------------------------------------------------------------------|
| precrec       | R        | [Web site](https://evalclass.github.io/precrec/), [CRAN](https://cran.r-project.org/package=precrec) |
| ROCR          | R        | [Web site](https://ipa-tys.github.io/ROCR/), [CRAN](https://cran.r-project.org/package=ROCR)         |
| PRROC         | R        | [CRAN](https://cran.r-project.org/package=PRROC)                                                     |
| AUCCalculator | Java     | [Web site](http://mark.goadrich.com/programs/AUC/)                                                   |
| PerfMeas      | R        | [CRAN](https://cran.r-project.org/package=PerfMeas)                                                  |

| Tool          | Language | Link                                                                                                      |
|:--------------|:---------|:----------------------------------------------------------------------------------------------------------|
| precrec       | R        | [Tool web site](https://evalclass.github.io/precrec/), [CRAN](https://cran.r-project.org/package=precrec) |
| ROCR          | R        | [Tool web site](https://ipa-tys.github.io/ROCR/), [CRAN](https://cran.r-project.org/package=ROCR)         |
| PRROC         | R        | [CRAN](https://cran.r-project.org/package=PRROC)                                                          |
| AUCCalculator | Java     | [Tool web site](http://mark.goadrich.com/programs/AUC/)                                                   |
| PerfMeas      | R        | [CRAN](https://cran.r-project.org/package=PerfMeas)                                                       |

**Disclaimer**: `prcbench` was originally develop to help our
[precrec](https://CRAN.R-project.org/package=precrec) library in order
to provide fast and accurate calculations of precision-recall curves
with extra functionality.

## Accuracy evaluation of precision-recall curves

`prcbench` uses pre-defined test sets to help evaluate the accuracy of
precision-recall curves.

1.  `create_toolset`: creates objects of different tools for testing (5
    different tools)
2.  `create_testset`: selects pre-defined data sets (c1, c2, and c3)
3.  `run_evalcurve`: evaluates the selected tools on the simulation data
4.  `autoplot`: shows the results with `ggplot2` and `patchwork`

``` r
## Load library
library(prcbench)

## Plot base points and the result of 5 tools on pre-defined test sets (c1, c2, and c3)
toolset <- create_toolset(c("precrec", "ROCR", "AUCCalculator", "PerfMeas", "PRROC"))
testset <- create_testset("curve", c("c1", "c2", "c3"))
scores1 <- run_evalcurve(testset, toolset)
autoplot(scores1, ncol = 3, nrow = 2)
```

![](README_files/figure-gfm/fig1-1.png)<!-- -->

## Running-time evaluation of precision-recall curves

`prcbench` helps create simulation data to measure computational times
of creating precision-recall curves.

1.  `create_toolset`: creates objects of different tools for testing
2.  `create_testset`: creates simulation data
3.  `run_benchmark`: evaluates the selected tools on the simulation data

``` r
## Load library
library(prcbench)

## Run benchmark for auc5 (5 tools) on b10 (balanced 5 positives and 5 negatives)
toolset <- create_toolset(set_names = "auc5")
testset <- create_testset("bench", "b10")
res <- run_benchmark(testset, toolset)

print(res)
```

| testset | toolset | toolname      |  min |   lq | mean | median |   uq |   max | neval |
|:--------|:--------|:--------------|-----:|-----:|-----:|-------:|-----:|------:|------:|
| b10     | auc5    | AUCCalculator | 2.89 | 3.01 | 3.19 |   3.03 | 3.44 |  3.56 |     5 |
| b10     | auc5    | PerfMeas      | 0.11 | 0.11 | 0.15 |   0.12 | 0.14 |  0.27 |     5 |
| b10     | auc5    | precrec       | 5.50 | 6.02 | 7.06 |   6.05 | 6.47 | 11.26 |     5 |
| b10     | auc5    | PRROC         | 0.22 | 0.23 | 0.28 |   0.23 | 0.25 |  0.45 |     5 |
| b10     | auc5    | ROCR          | 2.45 | 2.46 | 2.82 |   2.61 | 2.95 |  3.62 |     5 |

## Documentation

-   [Introduction to
    prcbench](https://evalclass.github.io/prcbench/articles/introduction.html)
    – a package vignette that contains the descriptions of the functions
    with several useful examples. View the vignette with
    `vignette("introduction", package = "prcbench")` in R.

-   [Help pages](https://evalclass.github.io/prcbench/reference/) – all
    the functions including the S3 generics have their own help pages
    with plenty of examples. View the main help page with
    `help(package = "prcbench")` in R.

## Installation

### CRAN

``` r
install.packages("prcbench")
```

### Dependencies

`AUCCalculator` requires a Java runtime environment (\>= 6) if
`AUCCalculator` needs to be evaluated.

### GitHub

You can install a development version of `prcbench` from [our GitHub
repository](https://github.com/evalclass/prcbench).

``` r
devtools::install_github("evalclass/prcbench")
```

1.  Make sure you have a working development environment.

    -   **Windows**: Install Rtools (available on the CRAN website).

    -   **Mac**: Install Xcode from the Mac App Store.

    -   **Linux**: Install a compiler and various development libraries
        (details vary across different flavors of Linux).

2.  Install `devtools` from CRAN with `install.packages("devtools")`.

3.  Install `prcbench` from the GitHub repository with
    `devtools::install_github("evalclass/prcbench")`.

## Troubleshooting

### microbenchmark

[microbenchmark](https://cran.r-project.org/package=microbenchmark) does
not work on some OSs. `prcbench` uses `system.time` when
`microbenchmark` is not available.

### rJava

-   Some OSs require en extra configuration step after rJava
    installation.

<!-- -->

    sudo R CMD javareconf

-   JDKs

1.  [Oracle JDK](https://www.oracle.com/java/)
2.  [OpenJDK](https://openjdk.org/)

-   JDKs for macOS

1.  [AdoptOpenJDK](https://adoptopenjdk.net/)
2.  [AdoptOpenJDK with homebrew](https://formulae.brew.sh/cask/temurin)

-   JRI support on macOS Big Sur – see this [Stack Overflow
    thread](https://stackoverflow.com/questions/65278552/cannot-install-rjava-on-big-sur).

``` r
install.packages("rJava", configure.args="--disable-jri")
```

## Citation

*Precrec: fast and accurate precision-recall and ROC curve calculations
in R*

Takaya Saito; Marc Rehmsmeier

Bioinformatics 2017; 33 (1): 145-147.

doi:
[10.1093/bioinformatics/btw570](https://doi.org/10.1093/bioinformatics/btw570)

## External links

-   [Classifier evaluation with imbalanced
    datasets](https://classeval.wordpress.com/) – our web site that
    contains several pages with useful tips for performance evaluation
    on binary classifiers.

-   [The Precision-Recall Plot Is More Informative than the ROC Plot
    When Evaluating Binary Classifiers on Imbalanced
    Datasets](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0118432)
    – our paper that summarized potential pitfalls of ROC plots with
    imbalanced datasets and advantages of using precision-recall plots
    instead.

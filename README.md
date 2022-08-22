
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

| Tool          | Link                                                                                                      |
|---------------|-----------------------------------------------------------------------------------------------------------|
| ROCR          | [Tool web site](https://ipa-tys.github.io/ROCR/), [CRAN](https://cran.r-project.org/package=ROCR)         |
| AUCCalculator | [Tool web site](http://mark.goadrich.com/programs/AUC/)                                                   |
| PerfMeas      | [CRAN](https://cran.r-project.org/package=PerfMeas)                                                       |
| PRROC         | [CRAN](https://cran.r-project.org/package=PRROC)                                                          |
| precrec       | [Tool web site](https://evalclass.github.io/precrec/), [CRAN](https://cran.r-project.org/package=precrec) |

## Documentation

-   [Introduction to
    prcbench](https://evalclass.github.io/prcbench/articles/introduction.html)
    – a package vignette that contains the descriptions of the functions
    with several useful examples. View the vignette with
    `vignette("introduction", package = "prcbench")` in R. The HTML
    version is also available on the [GitHub
    Pages](https://evalclass.github.io/prcbench/articles/introduction.html).

-   [Help pages](https://evalclass.github.io/prcbench/reference/) – all
    the functions including the S3 generics have their own help pages
    with plenty of examples. View the main help page with
    `help(package = "prcbench")` in R. The HTML version is also
    available on the [GitHub
    Pages](https://evalclass.github.io/prcbench/reference/).

## Dependencies

### Java

`AUCCalculator` requires a Java runtime (\>= 6).

## Installation

-   Install the release version of `prcbench` from CRAN with
    `install.packages("prcbench")`.

-   Alternatively, you can install a development version of `prcbench`
    from [our GitHub repository](https://github.com/evalclass/prcbench).
    To install it:

    1.  Make sure you have a working development environment.

        -   **Windows**: Install Rtools (available on the CRAN website).
        -   **Mac**: Install Xcode from the Mac App Store.
        -   **Linux**: Install a compiler and various development
            libraries (details vary across different flavors of Linux).

    2.  Install `devtools` from CRAN with
        `install.packages("devtools")`.

    3.  Install `prcbench` from the GitHub repository with
        `devtools::install_github("evalclass/prcbench")`.

## Troubleshooting

### microbenchmark

[microbenchmark](https://cran.r-project.org/package=microbenchmark) does
not work on some OSs. `prcbench` uses `system.time` when
`microbenchmark` is not available.

### rJava

-   Some OSs require further configuration for rJava.

<!-- -->

    sudo R CMD javareconf

-   JDKs for macOS Big Sur.

1.  [AdoptOpenJDK](https://adoptopenjdk.net/)
2.  [AdoptOpenJDK with
    homebrew](https://github.com/AdoptOpenJDK/homebrew-openjdk/)
3.  [Oracle JDK](https://www.oracle.com/java/)

-   JRI support on macOS Big Sur – see this [Stack Overflow
    thread](https://stackoverflow.com/questions/65278552/cannot-install-rjava-on-big-sur).

``` r
install.packages("rJava", configure.args="--disable-jri")
```

## Examples

Following two examples show the basic usage of `prcbench` functions.

### Benchmarking

The `run_benchmark` function outputs the result of
[microbenchmark](https://cran.r-project.org/package=microbenchmark) for
specified tools.

``` r
## Load library
library(prcbench)

## Run microbenchmark for auc5 (five tools) on b10 (balanced 5 Ps and 5 Ns)
testset <- create_testset("bench", "b10")
toolset <- create_toolset(set_names = "auc5")
res <- run_benchmark(testset, toolset)

## Use knitr::kable to show the result in a table format
knitr::kable(res$tab, digits = 2)
```

| testset | toolset | toolname      |  min |   lq |  mean | median |    uq |    max | neval |
|:--------|:--------|:--------------|-----:|-----:|------:|-------:|------:|-------:|------:|
| b10     | auc5    | AUCCalculator | 2.78 | 4.04 | 15.51 |   4.75 |  4.75 |  61.22 |     5 |
| b10     | auc5    | PerfMeas      | 0.08 | 0.09 | 98.83 |   0.09 |  0.12 | 493.76 |     5 |
| b10     | auc5    | precrec       | 5.10 | 5.15 | 27.96 |   5.79 |  6.21 | 117.54 |     5 |
| b10     | auc5    | PRROC         | 0.29 | 0.30 |  3.30 |   0.33 |  0.39 |  15.18 |     5 |
| b10     | auc5    | ROCR          | 1.73 | 1.78 | 13.37 |   2.02 | 15.31 |  46.04 |     5 |

### Evaluation of precision-recall curves

The `run_evalcurve` function evaluates precision-recall curves with
predefined test datasets. The `autoplot` shows a plot with the result of
the `run_evalcurve` function.

``` r
## ggplot2 is necessary to use autoplot
library(ggplot2)

## Plot base points and the result of precrec on c1, c2, and c3 test sets
testset <- create_testset("curve", c("c1", "c2", "c3"))
toolset <- create_toolset("precrec")
scores1 <- run_evalcurve(testset, toolset)
autoplot(scores1)
```

![](https://raw.githubusercontent.com/evalclass/prcbench/main/README_files/figure-gfm/unnamed-chunk-4-1.png)

``` r
## Plot the results of PerfMeas and PRROC on c1, c2, and c3 test sets
toolset <- create_toolset(c("PerfMeas", "PRROC"))
scores2 <- run_evalcurve(testset, toolset)
autoplot(scores2, base_plot = FALSE)
```

![](https://raw.githubusercontent.com/evalclass/prcbench/main/README_files/figure-gfm/unnamed-chunk-5-1.png)

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

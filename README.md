<!-- README.md is generated from README.Rmd. Please edit that file -->
prcbench
========

The aim of `prcbench` is to provide a testing workbench for evaluating Precision-Recall curves under various conditions. It contains integrated interfaces for the following five different tools as well as predefined test data sets.

| Tool          | Link                                                     |
|---------------|----------------------------------------------------------|
| ROCR          | [CRAN](https://cran.r-project.org/web/packages/ROCR)     |
| AUCCalculator | [Web site](http://mark.goadrich.com/programs/AUC)        |
| PerfMeas      | [CRAN](https://cran.r-project.org/web/packages/PerfMeas) |
| PRROC         | [CRAN](https://cran.r-project.org/web/packages/PRROC)    |
| precrec       | [CRAN](https://cran.r-project.org/web/packages/precrec)  |

Installation
------------

Only a development version of `prcbench` is currently available at [our GitHub repository](https://github.com/takayasaito/prcbench).

To install it:

1.  Make sure you have a working development environment.
    -   **Windows**: Install [Rtools](http://cran.r-project.org/bin/windows/Rtools/).
    -   **Mac**: Install Xcode from the Mac App Store.
    -   **Linux**: Install a compiler and various development libraries (details vary across different flavors of Linux).

2.  Install required Bioconductor packages for `PerfMeas`.

        ## try http:// if https:// URLs are not supported
        source("https://bioconductor.org/biocLite.R")
        biocLite("limma")
        biocLite("graph")
        biocLite("RBGL")

3.  Install `devtools` from CRAN with `install.packages("devtools")`.

4.  Install `prcbench` from the GitHub repository with `devtools::install_github("/takayasaito/prcbench")`

Documentation
-------------

A package vignette - Introduction to prcbench - contains the descriptions of the functions with several useful examples. View the vignette with `vignette("introduction", package = "prcbench")`.

In addition, all the main functions have their own help pages with examples.

Examples
--------

Following two examples show the basic usage of `prcbench` functions.

### Benchmarking

The `run_benchmark` function outputs the result of [microbenchmark](https://cran.r-project.org/web/packages/microbenchmark) for specified tools.

``` r
## Load library
library(prcbench)

## Run microbenchmark for aut5 on b100
testset <- create_testset("bench", "b100")
toolset <- create_toolset(set_names = "auc5")
res <- run_benchmark(testset, toolset)

## Use knitr::kable to show the result in a table format
knitr::kable(res$tab)
```

| testset | toolset | toolname      |        min|         lq|       mean|      median|          uq|        max|  neval|
|:--------|:--------|:--------------|----------:|----------:|----------:|-----------:|-----------:|----------:|------:|
| b100    | auc5    | ROCR          |   21.92791|   22.39528|   94.96592|   22.761756|   29.241013|   378.5037|      5|
| b100    | auc5    | AUCCalculator |  707.05526|  721.76639|  748.69201|  759.132118|  776.940386|   778.5659|      5|
| b100    | auc5    | PerfMeas      |    0.52550|    0.53291|  564.44183|    0.539179|    0.571666|  2820.0399|      5|
| b100    | auc5    | PRROC         |  129.81143|  132.95986|  148.03759|  145.426505|  150.475173|   181.5150|      5|
| b100    | auc5    | precrec       |   38.44352|   38.61907|   58.55680|   39.178193|   39.341200|   137.2020|      5|

### Evaluation of Precision-Recall curves

The `run_evalcurve` function evaluates Precision-Recall curves with predefined test datasets. The `autoplot` shows a plot with the result of the `run_evalcurve` function.

``` r
## ggplot2 is nesessary to use autoplot
library(ggplot2)

## Plot base points and the result of precrec on c1, c2, and c3 test sets
testset <- create_testset("curve", c("c1", "c2", "c3"))
toolset <- create_toolset("precrec")
scores1 <- run_evalcurve(testset, toolset)
autoplot(scores1)
```

![](README_files/figure-markdown_github/unnamed-chunk-2-1.png)

``` r
## Plot the results of PerfMeas and PRROC on c1, c2, and c3 test sets
toolset <- create_toolset(c("PerfMeas", "PRROC"))
scores2 <- run_evalcurve(testset, toolset)
autoplot(scores2, base_plot = FALSE)
```

![](README_files/figure-markdown_github/unnamed-chunk-2-2.png)

<!-- README.md is generated from README.Rmd. Please edit that file -->
prcbench
========

The aim of `prcbench` is to provide a testig workbench for evaluating Precision-Recall curves under various conditions. It contains integrated interfaces for the following five different tools as well as pre-defined test data sets.

| Tool          | Web site                                                 |
|---------------|----------------------------------------------------------|
| ROCR          | [CRAN](https://cran.r-project.org/web/packages/ROCR)     |
| AUCCalculator | [Web site](http://mark.goadrich.com/programs/AUC/)       |
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

Examples
--------

Following two examples show the basic usage of `prcbench` functions.

### Benchmarking

The `run_benchmark` function outputs the result of [microbenchmark](https://cran.r-project.org/web/packages/microbenchmark) for specified tools.

``` r
## Load library
library(prcbench)

## Run microbenchmark for 4 different tools and the 'b100' dataset.
## 'b100' is a random sample set that contains 50 positives and 50 negatives.
res1 <- run_benchmark("b100", c("ROCR", "AUCCalculator", "PerfMeas", "PRROC", "precrec"))

## Use knitr::kable to show the result in a table format
knitr::kable(res1)
```

|         min|          lq|       mean|      median|          uq|        max|  neval| tool          | sampset | toolset       |
|-----------:|-----------:|----------:|-----------:|-----------:|----------:|------:|:--------------|:--------|:--------------|
|    5.682536|    5.714155|   16.83950|    6.079957|    8.117084|   58.60377|      5| ROCR          | b100    | ROCR          |
|  167.297053|  167.902669|  189.71560|  177.664496|  182.517524|  253.19625|      5| AUCCalculator | b100    | AUCCalculator |
|    0.121374|    0.125866|  111.36412|    0.141964|    0.178831|  556.25255|      5| PerfMeas      | b100    | PerfMeas      |
|  390.523416|  439.006490|  435.11773|  443.367923|  447.827618|  454.86322|      5| PRROC         | b100    | PRROC         |
|    6.900436|    7.080545|   11.46156|    8.161800|   11.572931|   23.59210|      5| precrec       | b100    | precrec       |

### Evaluation of Precison-Recall curve accuracy

The `eval_curves` function evaluates Precision-Recall curves with pre-defined test datasets. The `autoplot` shows a plot with the result of the `eval_curves` function.

``` r
## ggplot2 is nesessary to use autoplot
library(ggplot2)

## Evaluate Precision-Recall curves with 3 pre-defined test sets
eres1 <- eval_curves(c("r1", "r2", "r3"), "precrec")
autoplot(eres1)

eres2 <- eval_curves(c("r1", "r2", "r3"), c("PerfMeas", "PRROC"))
autoplot(eres2, base_plot = FALSE)
```

![](README_files/figure-markdown_github/unnamed-chunk-2-1.png) ![](README_files/figure-markdown_github/unnamed-chunk-2-2.png)

<!-- README.md is generated from README.Rmd. Please edit that file -->
prcbench
========

The aim of `prcbench` is to provide a testig workbench for evaluating Precision-Recall curves under various conditions. It contains integrated interfaces for the following five different tools as well as pre-defined test data sets.

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

|         min|          lq|       mean|      median|          uq|         max|  neval| tool          | sampset | toolset       |
|-----------:|-----------:|----------:|-----------:|-----------:|-----------:|------:|:--------------|:--------|:--------------|
|    4.531912|    5.179967|   19.57988|    6.681025|    7.456586|    74.04990|      5| ROCR          | b100    | ROCR          |
|  166.322768|  170.132468|  903.38135|  172.779018|  180.570106|  3827.10241|      5| AUCCalculator | b100    | AUCCalculator |
|    0.120191|    0.122307|  112.09616|    0.126824|    0.138595|   559.97287|      5| PerfMeas      | b100    | PerfMeas      |
|  376.183791|  424.207631|  422.39150|  427.342781|  438.812847|   445.41046|      5| PRROC         | b100    | PRROC         |
|    7.073711|    7.118452|   11.06713|    7.227970|   10.500266|    23.41525|      5| precrec       | b100    | precrec       |

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

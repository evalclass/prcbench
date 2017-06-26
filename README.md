
prcbench
========

[![Travis](https://img.shields.io/travis/takayasaito/prcbench.svg?maxAge=2592000)](https://travis-ci.org/takayasaito/prcbench) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/takayasaito/prcbench?branch=master&svg=true)](https://ci.appveyor.com/project/takayasaito/prcbench) [![codecov.io](https://codecov.io/github/takayasaito/prcbench/coverage.svg?branch=master)](https://codecov.io/github/takayasaito/prcbench?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/prcbench)](https://cran.r-project.org/package=prcbench)

The aim of the `prcbench` package is to provide a testing workbench for evaluating precision-recall curves under various conditions. It contains integrated interfaces for the following five tools. It also contains predefined test data sets.

| Tool          | Link                                                                                                      |
|---------------|-----------------------------------------------------------------------------------------------------------|
| ROCR          | [Tool web site](http://rocr.bioinf.mpi-sb.mpg.de), [CRAN](https://cran.r-project.org/package=ROCR)        |
| AUCCalculator | [Tool web site](http://mark.goadrich.com/programs/AUC)                                                    |
| PerfMeas      | [CRAN](https://cran.r-project.org/package=PerfMeas)                                                       |
| PRROC         | [CRAN](https://cran.r-project.org/package=PRROC)                                                          |
| precrec       | [Tool web site](http://takayasaito.github.io/precrec), [CRAN](https://cran.r-project.org/package=precrec) |

Dependencies
------------

### Java

`AUCCalculator` requires a Java runtime (&gt;= 6).

### Bioconductor libraries

`PerfMeas` requires Bioconductor libraries. To automatically install the dependencies, add a Bioconductor repository to the repository list as:

``` r
## Include a Bioconductor repository
setRepositories(ind = 1:2)
```

Installation
------------

-   Install the release version of `prcbench` from CRAN with `install.packages("prcbench")`.

-   Alternatively, you can install a development version of `prcbench` from [our GitHub repository](https://github.com/takayasaito/prcbench). To install it:

    1.  Make sure you have a working development environment.
        -   **Windows**: Install Rtools (available on the CRAN website).
        -   **Mac**: Install Xcode from the Mac App Store.
        -   **Linux**: Install a compiler and various development libraries (details vary across different flavors of Linux).
    2.  Install `devtools` from CRAN with `install.packages("devtools")`.

    3.  Install `prcbench` from the GitHub repository with `devtools::install_github("takayasaito/prcbench")`.

Potential installation issues
-----------------------------

### Bioconductor libraries

You can manually install the dependencies from Bioconductor if `install.packages` fails to access the Bioconductor repository.

``` r
## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
biocLite("limma")
biocLite("graph")
biocLite("RBGL")
```

### rJava

Some OSs require further configuration for rJava.

Use:

``` r
Sys.setenv(JAVA_HOME = "<path to JRE>")
```

or

    #!/bin/bash

    export JAVA_HOME = "<path to JRE>"
    R CMD javareconf

### microbenchmark

[microbenchmark](https://cran.r-project.org/package=microbenchmark) does not work on some OSs. `prcbench` uses `system.time` when `microbenchmark` is not available.

Documentation
-------------

-   [Introduction to prcbench](http://takayasaito.github.io/prcbench/articles/introduction.html) - a package vignette that contains the descriptions of the functions with several useful examples. View the vignette with `vignette("introduction", package = "prcbench")` in R. The HTML version is also available on the [GitPages](http://takayasaito.github.io/prcbench/articles/introduction.html).

-   [Help pages](http://takayasaito.github.io/prcbench/reference) - all the functions including the S3 generics have their own help pages with plenty of examples. View the main help page with `help(package = "prcbench")` in R. The HTML version is also available on the [GitPages](http://takayasaito.github.io/prcbench/reference).

Examples
--------

Following two examples show the basic usage of `prcbench` functions.

### Benchmarking

The `run_benchmark` function outputs the result of [microbenchmark](https://cran.r-project.org/package=microbenchmark) for specified tools.

``` r
## Load library
library(prcbench)

## Run microbenchmark for aut5 on b10
testset <- create_testset("bench", "b10")
toolset <- create_toolset(set_names = "auc5")
res <- run_benchmark(testset, toolset)

## Use knitr::kable to show the result in a table format
knitr::kable(res$tab, digits = 2)
```

| testset | toolset | toolname      |   min|    lq|    mean|  median|      uq|     max|  neval|
|:--------|:--------|:--------------|-----:|-----:|-------:|-------:|-------:|-------:|------:|
| b10     | auc5    | ROCR          |  2.59|  2.81|   80.21|    2.91|  168.70|  224.05|      5|
| b10     | auc5    | AUCCalculator |  5.02|  5.07|   21.70|    5.13|   35.56|   57.71|      5|
| b10     | auc5    | PerfMeas      |  0.12|  0.13|  154.44|    0.19|   29.47|  742.31|      5|
| b10     | auc5    | PRROC         |  0.27|  0.27|   49.32|    0.30|   48.54|  197.23|      5|
| b10     | auc5    | precrec       |  7.67|  7.71|  180.34|    7.90|  216.46|  661.93|      5|

### Evaluation of precision-recall curves

The `run_evalcurve` function evaluates precision-recall curves with predefined test datasets. The `autoplot` shows a plot with the result of the `run_evalcurve` function.

``` r
## ggplot2 is necessary to use autoplot
library(ggplot2)

## Plot base points and the result of precrec on c1, c2, and c3 test sets
testset <- create_testset("curve", c("c1", "c2", "c3"))
toolset <- create_toolset("precrec")
scores1 <- run_evalcurve(testset, toolset)
autoplot(scores1)
```

![](https://rawgit.com/takayasaito/prcbench/master/README_files/figure-markdown_github/unnamed-chunk-5-1.png)

``` r
## Plot the results of PerfMeas and PRROC on c1, c2, and c3 test sets
toolset <- create_toolset(c("PerfMeas", "PRROC"))
scores2 <- run_evalcurve(testset, toolset)
autoplot(scores2, base_plot = FALSE)
```

![](https://rawgit.com/takayasaito/prcbench/master/README_files/figure-markdown_github/unnamed-chunk-6-1.png)

Citation
--------

*Precrec: fast and accurate precision-recall and ROC curve calculations in R*

Takaya Saito; Marc Rehmsmeier

Bioinformatics 2017; 33 (1): 145-147.

doi: [10.1093/bioinformatics/btw570](https://doi.org/10.1093/bioinformatics/btw570)

External links
--------------

-   [Classifier evaluation with imbalanced datasets](https://classeval.wordpress.com/) - our web site that contains several pages with useful tips for performance evaluation on binary classifiers.

-   [The Precision-Recall Plot Is More Informative than the ROC Plot When Evaluating Binary Classifiers on Imbalanced Datasets](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0118432) - our paper that summarized potential pitfalls of ROC plots with imbalanced datasets and advantages of using precision-recall plots instead.

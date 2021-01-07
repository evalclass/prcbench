# precrec 0.9.1

* Update Travis configurations for rJava

# precrec 0.9

* Improve code quality using the results from lintr and CodeFactor.io

# precrec 0.8.2

* Avoid data.frame() factor conversion in unit tests

# precrec 0.8

* Fix hard-coded JAR file path issue

# precrec 0.7.3

* Update curve evaluation for PRROC version 1.2

# precrec 0.6.2

* Create github pages with pkgdown

# precrec 0.5.2

* Update README

* Update wrapper functions so that precrec works when PerfMeas is not available

# prcbench 0.5

* Change predefined C3 data

* Update AppVeyor config for rJava

# prcbench 0.4

* Enhance create_usrtool
    * x and y values can be specified as precalculated precision and recall
    
* Add a new test set
    * C4

* Add test categories to curve evaluation test result

* Improve graph options
    
# prcbench 0.3

* Improve the testing environment
    * unit tests
    * codecov
    
* Change Java version
    * 1.7 -> 1.6
       
# prcbench 0.2

* Fix microbenchmark
    * Change from 'Imports' to 'Suggests'
    * Use system time when microbenchmark is unavailable
    
* Improve several documents
    * help files (.Rd)
    * package vignette
    * README  
    
# prcbench 0.1

* The first release version of `prcbench`

* The package offers four main functions
    * Common tool interface for multiple tools
    * Common test data interface for benchmarking and curve evaluation
    * Benchmarking of tools that generate Precision-Recall curves
    * Evaluation of Precision-Recall curves
    
* The package contains predefined interfaces of the following five tool
    * ROCR
    * AUCCalculator
    * PerfMeas
    * PRROC
    * precrec    

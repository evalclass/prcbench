# prcbench 0.3

* Improve the testing enviroment
    * unit tests
    * codecov
    
* Change Java version
    * 1.7 -> 1.6
       
# prcbench 0.2

* Fix microbenchmark
    * Change from 'Imports' to 'Suggests'
    * Use sytem time when microbenchmark is unavailable
    
* Improve several documents
    * help files (.Rd)
    * package vignette
    * README  
    
# prcbench 0.1

* The first release version of `prcbench`

* The package offers four main functions
    * Common tool interface for multiple tools
    * Common test data interface for benchmarking and curve evaluation
    * Benchmarcking of tools that generate Precision-Recall curves
    * Evaluation of Precision-Recall curves
    
* The package contains predefined interfaces of the following five tool
    * ROCR
    * AUCCalculator
    * PerfMeas
    * PRROC
    * precrec    

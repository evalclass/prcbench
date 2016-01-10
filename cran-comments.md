## Version 0.2.0
Version 0.1 failed with CRAN checks on Solaris. Avoiding microbenchmark was suggested
by Prof. Brian Ripley so that we updated our package accordingly. 
    
In this version I have:

* Changed several functions and the corresponding unit tests 
so that the package uses system.time when microbenchmark is not installed. 

* Updated several documents.

* Updated the version.

## Test environments
* local OS X Yosemite, R 3.2.3
* local CentOS 6.7, R 3.2.3
* local Windows 10, R 3.2.3
* win-builder (devel and release)
* ubuntu (on travis-ci), R 3.2.3

## R CMD check results
* There was one **NOTE** from win-builder (both devel and release) tests.

    >checking CRAN incoming feasibility ... NOTE
    >
    >Maintainer: 'Takaya Saito <takaya.saito@outlook.com>'
    >
    >Days since last update: 2

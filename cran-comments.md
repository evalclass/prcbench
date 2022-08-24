## Version 1.1.1
This is a submission for updating the already published package - prcbench.

In this version I have:

* Ported precision-recall calculation part from obsolete PerfMeas package to internal RCpp,

* Updated document files to HTML5 format,

* Fix the warning issue occured upon the previous CRAN submission (V1.1.0), 

* and Updated the version.
    * 1.0.2 -> 1.1.1
    
## Warning on Debain upon CRAN submission

I used R-hub to test the package on Debian environment, but I couldn't reproduce the warning. The code also looks OK to me, but I still have modified the part that potentially caused the warning.

  - Flavor: r-devel-linux-x86_64-debian-gcc
  - Check: whether package can be installed, Result: WARNING
     Found the following significant warnings:
     perfmeas.cpp:41:27: warning: array subscript [-2147483648, -1] is outside array bounds of 'double [2147483647]' [-Warray-bounds]
   
## Test environments

-   local macOS Big Sur, R 4.2.1

-   R-hub, Debian Linux, R-devel, GCC (debian-gcc-devel)

-   win-builder, R Under development (unstable) (2022-08-22 r82736 ucrt)

-   GitHub Actions

    -   macOS-latest (release)
    -   windows-latest (release)
    -   ubuntu-latest (devel)
    -   ubuntu-latest (release)
    -   ubuntu-latest (oldrel-1)

-   AppVeyor

    - R Under development (unstable) (2022-08-22 r82736 ucrt)
    - R version 4.2.1 (2022-06-23 ucrt)


## R CMD check results
* There were no ERRORs or WARNINGs.

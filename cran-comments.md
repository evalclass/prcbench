## Version 0.5.1
This is a submission for updating the already published package - prcbench.

In this version I have:

* Updated README.md.

* Updated the PerfMeas wrapper function so that prcbench works even when the PerfMeas package is not available.

* Updated the version.
    * 0.5.0 -> 0.5.1
    
## Test environments
* local OS X Yosemite, R 3.3.1
* local CentOS 6.7, R 3.3.1
* local Windows 10, R 3.3.1
* win-builder, Under development (unstable)
* Ubuntu 12.04.5 LTS (on travis-ci), R 3.3.1
* Windows Server 2012 R2 x64 (on AppVeyor), R 3.3.1 Patched

## R CMD check results
* There were no ERRORs or WARNINGs.

* Two **NOTEs** from the CRAN incoming feasibility test on **win-builder**.

    Found the following (possibly) invalid URLs:  
      URL: https://cran.r-project.org/web/packages/prcbench/precrec.pdf  
      URL: https://cran.r-project.org/web/packages/prcbench/vignettes/introduction.html
      
      **These URLs are not the direct links for the package.**
      
    Examples with CPU or elapsed time > 10s user system elapsed
    
      **Some examples of this package are meant to be like this.**
      
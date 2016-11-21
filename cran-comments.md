## Version 0.6.1
This is a submission for updating the already published package - prcbench.

In this version I have:

* Added GitPages

* Updated the version.
    * 0.5.2 -> 0.6.1
    
## Test environments
* local OS X Yosemite, R 3.3.2
* local CentOS 6.7, R 3.3.2
* local Windows 10, R 3.3.2
* win-builder, Under development (unstable)
* Ubuntu 12.04.5 LTS (on travis-ci), R 3.3.1
* Windows Server 2012 R2 x64 (on AppVeyor), R 3.3.2 Patched

## R CMD check results
* There were no ERRORs or WARNINGs.

* One **NOTE** from the CRAN incoming feasibility test on **win-builder**.
      
    * Found the following (possibly) invalid URLs:  
        URL: https://doi.org/10.1093/bioinformatics/btw570  
          From: README.md  
          Status: 400  
          Message: Bad Request

    * Found the following (possibly) invalid DOIs:  
        DOI: 10.1093/bioinformatics/btw570  
          From: inst/CITATION  
          Status: Bad Request  
          Message: 400
       
    **ROC is spelt correctly. Both URL and DOI are correct.**

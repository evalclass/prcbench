## Version 1.1.15
This is a submission for updating the already published package - prcbench.

The version published on CRAN is 1.1.10. Versions 1.1.11, 1.1.12, 1.1.13, and
1.1.14 were prepared but never submitted, so this submission covers the changes
of all five versions.

In this version I have:

* Added sklearn as a wrapped tool, calculated by a standalone Python module
  that is bundled in `inst/python` and derived from the scikit-learn source
  code, so scikit-learn itself is not required,

* Added yardstick as a wrapped tool,

* Restructured the predefined tool sets. The def7, auc7, and crv7 sets contain
  all seven tools, every predefined set now contains sklearn, and the smaller
  sets drop PerfMeas, then AUCCalculator, then PRROC,

* Fixed the help page of `create_testset`, which described the naming
  convention of benchmark test sets the wrong way round,

* Improved the readme and the introduction vignette,

* Regenerated the help pages with roxygen2 8.1.0,

* and Updated the version.
    * 1.1.10 -> 1.1.15

The bundled Python module is BSD-3-Clause licensed. `inst/COPYRIGHTS` holds
the licence text together with the provenance of the derived code, and the
copyright holders are credited in `Authors@R`.

The sklearn tool needs `reticulate`, a working Python installation, and
`numpy`. All three are optional, and `reticulate` is only in `Suggests`. The
tool is a member of every predefined tool set, so it is constructed during the
examples and the tests, but it never requires Python to do so. When
`reticulate`, Python, or `numpy` is unavailable, the tool returns a flat dummy
curve instead of raising an error, in the same way as the AUCCalculator tool
does without `rJava`. The tests that check the calculated values are skipped
when Python is unavailable.


## Test environments

-   local Ubuntu 24.04.5 LTS, R 4.6.1

<!-- TODO before submitting: add the results of these to the section below. -->

-   local MacBook Pro Ventura 13.7.6, R 4.5.0

-   win-builder, R Under development (unstable)

-   GitHub Actions

    -   macOS-latest (release)
    -   windows-latest (release)
    -   ubuntu-latest (devel)
    -   ubuntu-latest (release)
    -   ubuntu-latest (oldrel-1)


## R CMD check results

On local Ubuntu 24.04.5 LTS with R 4.6.1:

* There were no ERRORs or WARNINGs.

* There was 1 NOTE about the non-portable compilation flag
  '-mno-omit-leaf-frame-pointer'. The flag comes from the CFLAGS of the
  Debian/Ubuntu build of R used locally, not from the package.

<!-- TODO before submitting: add the results of the remaining environments. -->

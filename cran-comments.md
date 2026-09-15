## Version 1.1.13
This is a submission for updating the already published package - prcbench.

The version published on CRAN is 1.1.10. Versions 1.1.11 and 1.1.12 were
prepared but never submitted, so this submission covers the changes of all
three versions.

In this version I have:

* Added sklearn as a wrapped tool, calculated by a standalone Python module
  that is bundled in `inst/python` and derived from the scikit-learn source
  code, so scikit-learn itself is not required,

* Added yardstick as a wrapped tool, together with the def6, auc6, and crv6
  tool sets,

* Improved the readme and the introduction vignette,

* Regenerated the help pages with roxygen2 8.1.0,

* and Updated the version.
    * 1.1.10 -> 1.1.13

The bundled Python module is BSD-3-Clause licensed. `inst/COPYRIGHTS` holds
the licence text together with the provenance of the derived code, and the
copyright holders are credited in `Authors@R`.

The sklearn tool needs `reticulate`, a working Python installation, and
`numpy`. All three are optional. `reticulate` is only in `Suggests`, the tool
is not a member of any predefined tool set, and the examples and tests that
need Python are skipped when it is unavailable.


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

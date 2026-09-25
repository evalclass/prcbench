## Version 1.1.15

An update of the published package `prcbench` (1.1.10 -> 1.1.15). The versions
in between were prepared but not submitted, so this release carries five sets
of changes: `yardstick` and `scikit-learn` as two new wrapped tools, predefined
tool sets restructured around all seven tools, a corrected help page for
`create_testset`, and an improved readme and vignette. It adds one dependency,
`yardstick`, and one suggested package, `reticulate`. `NEWS.md` has the full
list.

The `scikit-learn` tool calls a small Python module bundled in `inst/python`,
derived from scikit-learn and licensed under BSD-3-Clause. `inst/COPYRIGHTS`
holds the licence and the provenance, and the copyright holders are credited
in `Authors@R`. The tool needs `reticulate`, Python, and `numpy`, all optional.
Without them it returns a flat dummy curve instead of raising an error, and
the tests that check its values are skipped.

## Test environments

- local Ubuntu 24.04, R release
- win-builder, R devel
- GitHub Actions
    - macOS-latest (release)
    - windows-latest (release)
    - ubuntu-latest (devel, release, oldrel-1)

## R CMD check results

0 errors | 0 warnings | 0 notes

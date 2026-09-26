## Version 1.1.16

A resubmission of 1.1.15, which did not pass the incoming checks. The Debian
pre-test reported one NOTE for the examples of `Toolsklearn`: 5.6s of CPU time
against 1.2s elapsed, which is over both the 5s limit and the limit on the
ratio of CPU time to elapsed time. The Windows pre-test was OK.

Creating that tool initialises Python and imports `numpy`, and the BLAS library
behind `numpy` starts a thread pool sized to the number of cores, which spends
CPU time that the import itself does not. The pool is now capped to two threads
while the import runs, so the CPU time no longer grows with the number of cores
of the machine. Measured with `R CMD check --timings`, the example now takes
1.4s of CPU time against 1.3s elapsed. Thread counts that the user has already
chosen, such as `OMP_NUM_THREADS`, are respected.

Apart from that fix the contents are those of 1.1.15. This is an update of the
published package `prcbench` (1.1.10 -> 1.1.16). The versions in between were
prepared but not submitted, so this release carries several sets of changes:
`yardstick` and `scikit-learn` as two new wrapped tools, predefined tool sets
restructured around all seven tools, a corrected help page for
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

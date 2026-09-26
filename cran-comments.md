## Version 1.1.16

A resubmission of 1.1.15. The Debian pre-test reported one NOTE for the
examples of `Toolsklearn`, which took 5.6s of CPU time against 1.2s elapsed.
Creating that tool imports `numpy`, whose BLAS library started a thread pool
sized to the number of cores. The pool is now capped to two threads while the
import runs, and the example takes 1.4s of CPU time against 1.3s elapsed.

The rest is the update of the published 1.1.10: `yardstick` and `scikit-learn`
as two new wrapped tools, restructured tool sets, and an improved readme and
vignette. `NEWS.md` has the full list.

The `scikit-learn` tool calls a small Python module bundled in `inst/python`,
derived from scikit-learn and licensed under BSD-3-Clause. `inst/COPYRIGHTS`
holds the licence, and the copyright holders are credited in `Authors@R`. The
tool needs `reticulate`, Python, and `numpy`, all optional, and returns a flat
dummy curve without them.

## Test environments

- local Ubuntu 24.04, R release
- win-builder, R devel
- GitHub Actions
    - macOS-latest (release)
    - windows-latest (release)
    - ubuntu-latest (devel, release, oldrel-1)

## R CMD check results

0 errors | 0 warnings | 0 notes

use_vdiff <- FALSE
check_ggplot_fig <- function(ptitle, p) {
  if (testthat:::on_ci() || !use_vdiff) {
    testthat::expect_true(is(p, "ggplot"))
  } else {
    suppressWarnings(vdiffr::expect_doppelganger(ptitle, p))
  }
}

# Skip unless the scikit-learn tool can actually run, which needs reticulate,
# a discoverable Python, numpy and the bundled standalone module.
skip_if_no_sklearn_py <- function() {
  testthat::skip_if_not_installed("reticulate")
  if (!prcbench:::.check_sklearn_available()) {
    testthat::skip("Python, numpy or the bundled sklearn module is not available")
  }
}

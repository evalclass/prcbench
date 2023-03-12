use_vdiff <- FALSE
check_ggplot_fig <- function(ptitle, p) {
  if (testthat:::on_ci() || !use_vdiff) {
    testthat::expect_true(is(p, "ggplot"))
  } else {
    suppressWarnings(vdiffr::expect_doppelganger(ptitle, p))
  }
}

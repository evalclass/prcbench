
check_ggplot_fig <- function(ptitle, p) {
  if (testthat:::on_ci()) {
    testthat::expect_true(is(p, "ggplot"))
  } else {
    suppressWarnings(vdiffr::expect_doppelganger(ptitle, p))
  }
}

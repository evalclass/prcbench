#' @importFrom ggplot2 grid

context("Plot: autoplot")
# Test autoplot.evalcurve
#

check_libs1 <- function() {
  if (requireNamespace("ggplot2", quietly = TRUE) &&
      requireNamespace("patchwork", quietly = TRUE) &&
      requireNamespace("vdiffr", quietly = TRUE)) {
    TRUE
  } else {
    FALSE
  }
}

check_libs2 <- function() {
  if (requireNamespace("ggplot2", quietly = TRUE) &&
      requireNamespace("grid", quietly = TRUE) &&
      requireNamespace("gridExtra", quietly = TRUE) &&
      requireNamespace("vdiffr", quietly = TRUE)) {
    TRUE
  } else {
    FALSE
  }
}


test_that("autoplot.evalcurve with pathwork", {
  if (!check_libs1()) {
    skip("Libraries cannot be loaded")
  }

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv1 <- run_evalcurve(testset, toolset)

  suppressWarnings(vdiffr::expect_doppelganger("evalcurve1",
                                               autoplot(evalcrv1)))

  toolset <- create_toolset(c("ROCR", "precrec"))
  testset <- create_testset("curve", "c2")
  evalcrv2 <- run_evalcurve(testset, toolset)

  suppressWarnings(vdiffr::expect_doppelganger("evalcurve2",
                                               autoplot(evalcrv2)))
})

test_that("autoplot.evalcurve with grid", {
  if (!check_libs2()) {
    skip("Libraries cannot be loaded")
  }

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv1 <- run_evalcurve(testset, toolset)

  expect_silent(suppressWarnings(autoplot(evalcrv1, multiplot_lib="grid",
                                          ret_grob = TRUE)))

  toolset <- create_toolset(c("ROCR", "precrec"))
  testset <- create_testset("curve", "c2")
  evalcrv2 <- run_evalcurve(testset, toolset)

  expect_silent(suppressWarnings(autoplot(evalcrv2, multiplot_lib="grid",
                                          ret_grob = TRUE)))
})

test_that("autoplot.evalcurve ret_grob", {
  if (!check_libs2()) {
    skip("Libraries cannot be loaded")
  }

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv <- run_evalcurve(testset, toolset)

  pp <- suppressWarnings(autoplot(evalcrv, multiplot_lib="grid",
                                  ret_grob = TRUE))
  expect_true(is(pp, "grob"))
  vdiffr::expect_doppelganger("evalcurve_grob",
                              suppressWarnings(grid::grid.draw(pp)))

  expect_error(suppressWarnings(autoplot(evalcrv, multiplot_lib="grid",
                                         ret_grob = 1)),
               "ret_grob is not a flag")
})

test_that("autoplot.evalcurve base_plot", {
  if (!check_libs2()) {
    skip("Libraries cannot be loaded")
  }

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv <- run_evalcurve(testset, toolset)

  pp1 <- suppressWarnings(autoplot(evalcrv, multiplot_lib="grid",
                                   ret_grob = TRUE, base_plot = TRUE))
  expect_equal(length(pp1$grobs), 6)

  pp2 <- suppressWarnings(autoplot(evalcrv, multiplot_lib="grid",
                                   ret_grob = TRUE, base_plot = FALSE))
  expect_equal(length(pp2$grobs), 5)

  expect_error(suppressWarnings(autoplot(evalcrv, multiplot_lib="grid",
                                         ret_grob = TRUE, base_plot = 1)),
               "base_plot is not a flag")
})

test_that("autoplot.evalcurve ncol & nrow", {

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv <- run_evalcurve(testset, toolset)

  expect_error(suppressWarnings(autoplot(evalcrv, ncol = 1)),
               "Both ncol and nrow must be set")

  expect_error(suppressWarnings(autoplot(evalcrv, nrow = 1)),
               "Both ncol and nrow must be set")

  expect_error(suppressWarnings(autoplot(evalcrv, ncol = 1, nrow = 0)),
               "nrow not greater than 0")

  expect_error(suppressWarnings(autoplot(evalcrv, ncol = 0, nrow = 1)),
               "ncol not greater than 0")
})

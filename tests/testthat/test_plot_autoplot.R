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

  toolset1 <- create_toolset(set_names = "crv5")
  testset1 <- create_testset("curve", "c2")
  ecurves1 <- run_evalcurve(testset1, toolset1)
  check_ggplot_fig("ecurves1", autoplot(ecurves1))

  toolset2 <- create_toolset(c("ROCR", "precrec"))
  testset2 <- create_testset("curve", "c2")
  ecurves2 <- run_evalcurve(testset2, toolset2)
  check_ggplot_fig("ecurves2", autoplot(ecurves2))

  toolset3 <- create_toolset(c(
    "precrec", "ROCR",
    "PerfMeas", "PRROC"
  ))
  testset3 <- create_testset("curve", c("c1", "c2", "c3"))
  ecurves3 <- run_evalcurve(testset3, toolset3)
  check_ggplot_fig("ecurves3", autoplot(ecurves3, ncol = 3, nrow = 2))

  toolset4 <- create_toolset(c(
    "precrec", "ROCR", "AUCCalculator",
    "PerfMeas", "PRROC"
  ))
  testset4 <- create_testset("curve", c("c1", "c2", "c3"))
  ecurves4 <- run_evalcurve(testset4, toolset4)
  check_ggplot_fig("ecurves4", autoplot(ecurves4, ncol = 3, nrow = 2))

  toolset5 <- create_toolset(c(
    "precrec", "ROCR", "AUCCalculator",
    "PerfMeas", "PRROC"
  ))
  testset5 <- create_testset("curve", c("c1", "c2", "c3"))
  ecurves5 <- run_evalcurve(testset5, toolset5)
  check_ggplot_fig("ecurves5", autoplot(ecurves5, use_category = TRUE))
})

test_that("autoplot.evalcurve with grid", {
  if (!check_libs2()) {
    skip("Libraries cannot be loaded")
  }

  toolset1 <- create_toolset(set_names = "crv5")
  testset1 <- create_testset("curve", "c2")
  ecurves1 <- run_evalcurve(testset1, toolset1)

  expect_silent(suppressWarnings(autoplot(ecurves1,
    multiplot_lib = "grid",
    ret_grob = TRUE
  )))

  toolset2 <- create_toolset(c("ROCR", "precrec"))
  testset2 <- create_testset("curve", "c2")
  ecurves2 <- run_evalcurve(testset2, toolset2)

  expect_silent(suppressWarnings(autoplot(ecurves2,
    multiplot_lib = "grid",
    ret_grob = TRUE
  )))

  toolset3 <- create_toolset(c(
    "precrec", "ROCR", "AUCCalculator",
    "PerfMeas", "PRROC"
  ))
  testset3 <- create_testset("curve", c("c1", "c2", "c3"))
  ecurves3 <- run_evalcurve(testset3, toolset3)
  expect_silent(suppressWarnings(autoplot(ecurves3,
    multiplot_lib = "grid",
    ret_grob = TRUE, ncol = 3, nrow = 2
  )))
})

test_that("autoplot.evalcurve ret_grob", {
  if (!check_libs2()) {
    skip("Libraries cannot be loaded")
  }
  pdf(NULL)
  on.exit(dev.off())

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv <- run_evalcurve(testset, toolset)

  pp <- suppressWarnings(autoplot(evalcrv,
    multiplot_lib = "grid",
    ret_grob = TRUE
  ))
  expect_true(is(pp, "grob"))
  expect_silent(suppressWarnings(grid::grid.draw(pp)))

  expect_error(
    suppressWarnings(autoplot(evalcrv,
      multiplot_lib = "grid",
      ret_grob = 1
    )),
    "ret_grob is not a flag"
  )
})

test_that("autoplot.evalcurve base_plot", {
  if (!check_libs2()) {
    skip("Libraries cannot be loaded")
  }

  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv <- run_evalcurve(testset, toolset)

  pp1 <- suppressWarnings(autoplot(evalcrv,
    multiplot_lib = "grid",
    ret_grob = TRUE, base_plot = TRUE
  ))
  expect_equal(length(pp1$grobs), 6)

  pp2 <- suppressWarnings(autoplot(evalcrv,
    multiplot_lib = "grid",
    ret_grob = TRUE, base_plot = FALSE
  ))
  expect_equal(length(pp2$grobs), 5)

  expect_error(
    suppressWarnings(autoplot(evalcrv,
      multiplot_lib = "grid",
      ret_grob = TRUE, base_plot = 1
    )),
    "base_plot is not a flag"
  )
})

test_that("autoplot.evalcurve ncol & nrow", {
  toolset <- create_toolset(set_names = "crv5")
  testset <- create_testset("curve", "c2")
  evalcrv <- run_evalcurve(testset, toolset)

  expect_error(
    suppressWarnings(autoplot(evalcrv, ncol = 1)),
    "Both ncol and nrow must be set"
  )

  expect_error(
    suppressWarnings(autoplot(evalcrv, nrow = 1)),
    "Both ncol and nrow must be set"
  )

  expect_error(
    suppressWarnings(autoplot(evalcrv, ncol = 1, nrow = 0)),
    "nrow not greater than 0"
  )

  expect_error(
    suppressWarnings(autoplot(evalcrv, ncol = 0, nrow = 1)),
    "ncol not greater than 0"
  )
})

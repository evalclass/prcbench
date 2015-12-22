library(prcbench)
library(ggplot2)
library(grid)

context("Plot: autoplot")
# Test autoplot.evalcurve
#

test_that("autoplot.evalcurve", {
  pdf(NULL)
  on.exit(dev.off())

  evalcrv1 <- eval_curves()
  expect_that(suppressWarnings(autoplot(evalcrv1)), not(throws_error()))

  evalcrv2 <- eval_curves(tool_names = c("ROCR", "precrec"))
  expect_that(suppressWarnings(autoplot(evalcrv2)), not(throws_error()))
})

test_that("autoplot.evalcurve ret_grob", {
  pdf(NULL)
  on.exit(dev.off())

  evalcrv <- eval_curves()

  pp <- suppressWarnings(autoplot(evalcrv, ret_grob = TRUE))
  expect_true(all(class(pp) == c("gtable", "grob", "gDesc")))
  expect_that(suppressWarnings(grid.draw(pp)), not(throws_error()))
})

test_that("autoplot.evalcurve base_plot", {
  pdf(NULL)
  on.exit(dev.off())

  evalcrv <- eval_curves()

  pp1 <- suppressWarnings(autoplot(evalcrv, base_plot = TRUE, ret_grob = TRUE))
  expect_equal(length(pp1$grobs), 6)

  pp2 <- suppressWarnings(autoplot(evalcrv, base_plot = FALSE, ret_grob = TRUE))
  expect_equal(length(pp2$grobs), 5)

})


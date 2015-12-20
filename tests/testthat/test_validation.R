library(prcbenchmark)

context("Validation")
# Test .eval_curves_singleset(testdat_name, toolset_name)
#      eval_curves
#

test_that(".eval_curves_singleset", {
  toolset <- create_tools("crv")
  toolnames <- names(toolset)

  test_tnames <- function(tnames) {
    res1 <- .eval_curves_singleset("r1", "crv")

    expect_equal(levels(res1$test), c("x_range", "y_range", "fpoint", "int_pts",
                                      "epoint"))
    expect_equal(length(setdiff(levels(res1$tool), toolnames)), 0)
    expect_equal(length(unique(res1$test)) * length(unique(res1$tool)),
                 nrow(res1))
    expect_true(all(res1$success <= res1$total))
    expect_true(all(res1$total >= 1))
  }

  for (t in c("r1", "r2", "r3")) {
    test_tnames(t)
  }

})

test_that("eval_curves", {
  res1 <- eval_curves("r1", "crv")
  expect_true(all(res1$scores$testdata == "r1"))
  expect_true(all(res1$scores$toolset == "crv"))

  res2 <- eval_curves(c("r1", "r2"), "crv")
  expect_true(any(res2$scores$testdata == "r1"))
  expect_true(any(res2$scores$testdata == "r2"))
  expect_true(all(res2$scores$toolset == "crv"))
})

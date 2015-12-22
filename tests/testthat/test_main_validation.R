library(prcbench)

context("Main: Validation")
# Test .eval_curves_singleset(testdat_name, toolset_name)
#      eval_curves
#

test_that(".eval_curves_singleset", {
  toolset <- create_tools("crv5")
  toolnames <- names(toolset)

  test_tnames <- function(tnames) {
    res1 <- .eval_curves_singleset("r1", "crv5")

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
  res1 <- eval_curves()
  expect_equal(is(res1), "evalcurve")
  expect_equal(length(res1), 3)
  expect_equal(names(res1), c("points", "curves", "scores"))
})

test_that("eval_curves points", {
  res1 <- eval_curves("r1", "crv5")
  expect_true(all(res1$points$x >= 0 && res1$points$x <= 1))
  expect_true(all(res1$points$y >= 0 && res1$points$y <= 1))
  expect_true(all(res1$points$testdata == "r1"))

  res2 <- eval_curves(c("r1", "r2"), "crv5")
  expect_true(all(res2$points$x >= 0 && res2$points$x <= 1))
  expect_true(all(res2$points$y >= 0 && res2$points$y <= 1))
  expect_true(any(res2$points$testdata == "r1"))
  expect_true(any(res2$points$testdata == "r2"))

  res3 <- eval_curves(c("r1", "r2"), c("ROCR", "precrec"))
  expect_true(all(res3$points$x >= 0 && res3$points$x <= 1))
  expect_true(all(res3$points$y >= 0 && res3$points$y <= 1))
  expect_true(any(res3$points$testdata == "r1"))
  expect_true(any(res3$points$testdata == "r2"))
})

test_that("eval_curves curves", {
  res1 <- eval_curves("r1", "crv5")
  expect_true(all(res1$curves$testdata == "r1"))
  expect_true(any(res1$curves$toolname == "ROCR"))
  expect_true(any(res1$curves$toolname == "AUCCalculator"))
  expect_true(any(res1$curves$toolname == "PerfMeas"))
  expect_true(any(res1$curves$toolname == "PRROC"))
  expect_true(any(res1$curves$toolname == "precrec"))

  res2 <- eval_curves(c("r1", "r2"), "crv5")
  expect_true(any(res2$curves$testdata == "r1"))
  expect_true(any(res2$curves$testdata == "r2"))
  expect_true(any(res2$curves$toolname == "ROCR"))
  expect_true(any(res2$curves$toolname == "AUCCalculator"))
  expect_true(any(res2$curves$toolname == "PerfMeas"))
  expect_true(any(res2$curves$toolname == "PRROC"))
  expect_true(any(res2$curves$toolname == "precrec"))

  res3 <- eval_curves(c("r1", "r2"), c("ROCR", "precrec"))
  expect_true(any(res3$curves$testdata == "r1"))
  expect_true(any(res3$curves$testdata == "r2"))
  expect_true(any(res3$curves$toolname == "ROCR"))
  expect_true(all(res3$curves$toolname != "AUCCalculator"))
  expect_true(all(res3$curves$toolname != "PerfMeas"))
  expect_true(all(res3$curves$toolname != "PRROC"))
  expect_true(any(res3$curves$toolname == "precrec"))
})

test_that("eval_curves scores", {
  res1 <- eval_curves("r1", "crv5")
  expect_true(all(res1$scores$testdata == "r1"))
  expect_true(all(res1$scores$toolset == "crv5"))
  expect_true(any(res1$scores$toolname == "ROCR"))
  expect_true(any(res1$scores$toolname == "AUCCalculator"))
  expect_true(any(res1$scores$toolname == "PerfMeas"))
  expect_true(any(res1$scores$toolname == "PRROC"))
  expect_true(any(res1$scores$toolname == "precrec"))

  res2 <- eval_curves(c("r1", "r2"), "crv5")
  expect_true(any(res2$scores$testdata == "r1"))
  expect_true(any(res2$scores$testdata == "r2"))
  expect_true(all(res2$scores$toolset == "crv5"))
  expect_true(any(res2$scores$toolname == "ROCR"))
  expect_true(any(res2$scores$toolname == "AUCCalculator"))
  expect_true(any(res2$scores$toolname == "PerfMeas"))
  expect_true(any(res2$scores$toolname == "PRROC"))
  expect_true(any(res2$scores$toolname == "precrec"))

  res3 <- eval_curves(c("r1", "r2"), c("ROCR", "precrec"))
  expect_true(any(res3$scores$testdata == "r1"))
  expect_true(any(res3$scores$testdata == "r2"))
  expect_true(any(res3$scores$toolset == "ROCR"))
  expect_true(any(res3$scores$toolset == "precrec"))
  expect_true(any(res3$scores$toolname == "ROCR"))
  expect_true(all(res3$scores$toolname != "AUCCalculator"))
  expect_true(all(res3$scores$toolname != "PerfMeas"))
  expect_true(all(res3$scores$toolname != "PRROC"))
  expect_true(any(res3$scores$toolname == "precrec"))
})

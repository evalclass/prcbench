library(prcbench)

context("Main: Validation")
# Test .eval_curves_singleset(testdat_name, toolset_name)
#      eval_curves
#

test_that(".eval_curves_singleset", {
  tools <- create_tools("crv5")
  toolnames <- names(tools[[1]])

  test_tnames <- function(tname) {
    testdata <- create_testdata(tname)
    res1 <- .eval_curves_singleset(testdata[[1]], tools[[1]], tname)

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
  tools <- create_tools("crv5")
  tdat <- create_testdata("r1")

  res1 <- eval_curves(tdat, tools)
  expect_equal(is(res1), "evalcurve")
  expect_equal(length(res1), 3)
  expect_equal(names(res1), c("points", "curves", "scores"))
})

test_that("eval_curves points", {
  tools <- create_tools("crv5")
  tdat <- create_testdata("r1")
  res1 <- eval_curves(tdat, tools)

  expect_true(all(res1$points$x >= 0 && res1$points$x <= 1))
  expect_true(all(res1$points$y >= 0 && res1$points$y <= 1))
  expect_true(all(res1$points$testdata == "r1"))

  tools <- create_tools("crv5")
  tdat <- create_testdata(c("r1", "r2"))
  res2 <- eval_curves(tdat, tools)

  expect_true(all(res2$points$x >= 0 && res2$points$x <= 1))
  expect_true(all(res2$points$y >= 0 && res2$points$y <= 1))
  expect_true(any(res2$points$testdata == "r1"))
  expect_true(any(res2$points$testdata == "r2"))

  tools <- create_tools(c("ROCR", "precrec"))
  tdat <- create_testdata(c("r1", "r2"))
  res3 <- eval_curves(tdat, tools)

  expect_true(all(res3$points$x >= 0 && res3$points$x <= 1))
  expect_true(all(res3$points$y >= 0 && res3$points$y <= 1))
  expect_true(any(res3$points$testdata == "r1"))
  expect_true(any(res3$points$testdata == "r2"))
})

test_that("eval_curves curves", {
  tools <- create_tools("crv5")
  tdat <- create_testdata("r1")
  res1 <- eval_curves(tdat, tools)

  expect_true(all(res1$curves$testdata == "r1"))
  expect_true(any(res1$curves$toolname == "ROCR"))
  expect_true(any(res1$curves$toolname == "AUCCalculator"))
  expect_true(any(res1$curves$toolname == "PerfMeas"))
  expect_true(any(res1$curves$toolname == "PRROC"))
  expect_true(any(res1$curves$toolname == "precrec"))

  tools <- create_tools("crv5")
  tdat <- create_testdata(c("r1", "r2"))
  res2 <- eval_curves(tdat, tools)

  expect_true(any(res2$curves$testdata == "r1"))
  expect_true(any(res2$curves$testdata == "r2"))
  expect_true(any(res2$curves$toolname == "ROCR"))
  expect_true(any(res2$curves$toolname == "AUCCalculator"))
  expect_true(any(res2$curves$toolname == "PerfMeas"))
  expect_true(any(res2$curves$toolname == "PRROC"))
  expect_true(any(res2$curves$toolname == "precrec"))

#   tools <- create_tools(c("ROCR", "precrec"))
#   tdat <- create_testdata(c("r1", "r2"))
#   res3 <- eval_curves(tdat, tools)
#
#   expect_true(any(res3$curves$testdata == "r1"))
#   expect_true(any(res3$curves$testdata == "r2"))
#   expect_true(any(res3$curves$toolname == "ROCR"))
#   expect_true(all(res3$curves$toolname != "AUCCalculator"))
#   expect_true(all(res3$curves$toolname != "PerfMeas"))
#   expect_true(all(res3$curves$toolname != "PRROC"))
#   expect_true(any(res3$curves$toolname == "precrec"))
})

test_that("eval_curves scores", {
  tools <- create_tools("crv5")
  tdat <- create_testdata("r1")
  res1 <- eval_curves(tdat, tools)

  expect_true(all(res1$scores$testdata == "r1"))
  expect_true(all(res1$scores$toolset == "crv5"))
  expect_true(any(res1$scores$toolname == "ROCR"))
  expect_true(any(res1$scores$toolname == "AUCCalculator"))
  expect_true(any(res1$scores$toolname == "PerfMeas"))
  expect_true(any(res1$scores$toolname == "PRROC"))
  expect_true(any(res1$scores$toolname == "precrec"))

  tools <- create_tools("crv5")
  tdat <- create_testdata(c("r1", "r2"))
  res2 <- eval_curves(tdat, tools)

  expect_true(any(res2$scores$testdata == "r1"))
  expect_true(any(res2$scores$testdata == "r2"))
  expect_true(all(res2$scores$toolset == "crv5"))
  expect_true(any(res2$scores$toolname == "ROCR"))
  expect_true(any(res2$scores$toolname == "AUCCalculator"))
  expect_true(any(res2$scores$toolname == "PerfMeas"))
  expect_true(any(res2$scores$toolname == "PRROC"))
  expect_true(any(res2$scores$toolname == "precrec"))

#   tools <- create_tools(c("ROCR", "precrec"))
#   tdat <- create_testdata(c("r1", "r2"))
#   res3 <- eval_curves(tdat, tools)
#
#   expect_true(any(res3$scores$testdata == "r1"))
#   expect_true(any(res3$scores$testdata == "r2"))
#   expect_true(any(res3$scores$toolset == "ROCR"))
#   expect_true(any(res3$scores$toolset == "precrec"))
#   expect_true(any(res3$scores$toolname == "ROCR"))
#   expect_true(all(res3$scores$toolname != "AUCCalculator"))
#   expect_true(all(res3$scores$toolname != "PerfMeas"))
#   expect_true(all(res3$scores$toolname != "PRROC"))
#   expect_true(any(res3$scores$toolname == "precrec"))
})

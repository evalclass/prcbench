context("Main: Curve evaluation")
# Test eval_curves
#

test_that("eval_curves", {
  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", "p1")

  res1 <- eval_curves(tdat, tools)
  expect_equal(is(res1), "evalcurve")
  expect_equal(length(res1), 4)
  expect_equal(names(res1), c("testscores", "testsum", "basepoints",
                              "predictions"))
})

test_that("eval_curves testscores", {
  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", "p1")
  res1 <- eval_curves(tdat, tools)

  expect_equal(names(res1$testscores), c("testdata", "toolset", "toolname",
                                         "testitem", "success", "total"))
  expect_true(all(res1$testscores$testdata == "p1"))
  expect_true(all(res1$testscores$toolset == "crv5"))
  expect_true(any(res1$testscores$toolname == "ROCR"))
  expect_true(any(res1$testscores$toolname == "AUCCalculator"))
  expect_true(any(res1$testscores$toolname == "PerfMeas"))
  expect_true(any(res1$testscores$toolname == "PRROC"))
  expect_true(any(res1$testscores$toolname == "precrec"))

  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res2 <- eval_curves(tdat, tools)

  expect_equal(names(res2$testscores), c("testdata", "toolset", "toolname",
                                         "testitem", "success", "total"))
  expect_true(any(res2$testscores$testdata == "p1"))
  expect_true(any(res2$testscores$testdata == "p2"))
  expect_true(all(res2$testscores$toolset == "crv5"))
  expect_true(any(res2$testscores$toolname == "ROCR"))
  expect_true(any(res2$testscores$toolname == "AUCCalculator"))
  expect_true(any(res2$testscores$toolname == "PerfMeas"))
  expect_true(any(res2$testscores$toolname == "PRROC"))
  expect_true(any(res2$testscores$toolname == "precrec"))

  tools <- create_tools(c("ROCR", "precrec"))
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res3 <- eval_curves(tdat, tools)

  expect_equal(names(res3$testscores), c("testdata", "toolset", "toolname",
                                         "testitem", "success", "total"))
  expect_true(any(res3$testscores$testdata == "p1"))
  expect_true(any(res3$testscores$testdata == "p2"))
  expect_true(any(res3$testscores$toolset == "ROCR"))
  expect_true(any(res3$testscores$toolset == "precrec"))
  expect_true(any(res3$testscores$toolname == "ROCR"))
  expect_true(all(res3$testscores$toolname != "AUCCalculator"))
  expect_true(all(res3$testscores$toolname != "PerfMeas"))
  expect_true(all(res3$testscores$toolname != "PRROC"))
  expect_true(any(res3$testscores$toolname == "precrec"))
})

test_that("eval_curves testsum", {
  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", "p1")
  res1 <- eval_curves(tdat, tools)

  expect_equal(names(res1$testsum), c("testdata", "toolset", "toolname",
                                      "success", "total", "label", "lbl_pos_x",
                                      "lbl_pos_y"))
  expect_true(all(res1$testsum$testdata == "p1"))
  expect_true(all(res1$testsum$toolset == "crv5"))
  expect_true(any(res1$testsum$toolname == "ROCR"))
  expect_true(any(res1$testsum$toolname == "AUCCalculator"))
  expect_true(any(res1$testsum$toolname == "PerfMeas"))
  expect_true(any(res1$testsum$toolname == "PRROC"))
  expect_true(any(res1$testsum$toolname == "precrec"))

  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res2 <- eval_curves(tdat, tools)

  expect_equal(names(res2$testsum), c("testdata", "toolset", "toolname",
                                      "success", "total", "label", "lbl_pos_x",
                                      "lbl_pos_y"))
  expect_true(any(res2$testsum$testdata == "p1"))
  expect_true(any(res2$testsum$testdata == "p2"))
  expect_true(all(res2$testsum$toolset == "crv5"))
  expect_true(any(res2$testsum$toolname == "ROCR"))
  expect_true(any(res2$testsum$toolname == "AUCCalculator"))
  expect_true(any(res2$testsum$toolname == "PerfMeas"))
  expect_true(any(res2$testsum$toolname == "PRROC"))
  expect_true(any(res2$testsum$toolname == "precrec"))

  tools <- create_tools(c("ROCR", "precrec"))
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res3 <- eval_curves(tdat, tools)

  expect_equal(names(res3$testsum), c("testdata", "toolset", "toolname",
                                      "success", "total", "label", "lbl_pos_x",
                                      "lbl_pos_y"))
  expect_true(any(res3$testsum$testdata == "p1"))
  expect_true(any(res3$testsum$testdata == "p2"))
  expect_true(any(res3$testsum$toolset == "ROCR"))
  expect_true(any(res3$testsum$toolset == "precrec"))
  expect_true(any(res3$testsum$toolname == "ROCR"))
  expect_true(all(res3$testsum$toolname != "AUCCalculator"))
  expect_true(all(res3$testsum$toolname != "PerfMeas"))
  expect_true(all(res3$testsum$toolname != "PRROC"))
  expect_true(any(res3$testsum$toolname == "precrec"))
})

test_that("eval_curves basepoints", {
  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", "p1")
  res1 <- eval_curves(tdat, tools)

  expect_equal(names(res1$basepoints), c("testdata", "x", "y"))
  expect_true(all(res1$basepoints$x >= 0 && res1$basepoints$x <= 1))
  expect_true(all(res1$basepoints$y >= 0 && res1$basepoints$y <= 1))
  expect_true(all(res1$basepoints$testdata == "p1"))

  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res2 <- eval_curves(tdat, tools)

  expect_equal(names(res2$basepoints), c("testdata", "x", "y"))
  expect_true(all(res2$basepoints$x >= 0 && res2$basepoints$x <= 1))
  expect_true(all(res2$basepoints$y >= 0 && res2$basepoints$y <= 1))
  expect_true(any(res2$basepoints$testdata == "p1"))
  expect_true(any(res2$basepoints$testdata == "p2"))

  tools <- create_tools(c("ROCR", "precrec"))
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res3 <- eval_curves(tdat, tools)

  expect_equal(names(res3$basepoints), c("testdata", "x", "y"))
  expect_true(all(res3$basepoints$x >= 0 && res3$basepoints$x <= 1))
  expect_true(all(res3$basepoints$y >= 0 && res3$basepoints$y <= 1))
  expect_true(any(res3$basepoints$testdata == "p1"))
  expect_true(any(res3$basepoints$testdata == "p2"))
})

test_that("eval_curves predictions", {
  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", "p1")
  res1 <- eval_curves(tdat, tools)

  expect_equal(names(res1$predictions), c("testdata", "toolset", "toolname",
                                          "x", "y"))
  expect_true(all(res1$predictions$testdata == "p1"))
  expect_true(all(res1$predictions$toolset == "crv5"))
  expect_true(any(res1$predictions$toolname == "ROCR"))
  expect_true(any(res1$predictions$toolname == "AUCCalculator"))
  expect_true(any(res1$predictions$toolname == "PerfMeas"))
  expect_true(any(res1$predictions$toolname == "PRROC"))
  expect_true(any(res1$predictions$toolname == "precrec"))

  tools <- create_tools(set_names = "crv5")
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res2 <- eval_curves(tdat, tools)

  expect_equal(names(res2$predictions), c("testdata", "toolset", "toolname",
                                          "x", "y"))
  expect_true(any(res2$predictions$testdata == "p1"))
  expect_true(any(res2$predictions$testdata == "p2"))
  expect_true(all(res2$predictions$toolset == "crv5"))
  expect_true(any(res2$predictions$toolname == "ROCR"))
  expect_true(any(res2$predictions$toolname == "AUCCalculator"))
  expect_true(any(res2$predictions$toolname == "PerfMeas"))
  expect_true(any(res2$predictions$toolname == "PRROC"))
  expect_true(any(res2$predictions$toolname == "precrec"))

  tools <- create_tools(c("ROCR", "precrec"))
  tdat <- create_testdata("precalc", c("p1", "p2"))
  res3 <- eval_curves(tdat, tools)

  expect_equal(names(res2$predictions), c("testdata", "toolset", "toolname",
                                          "x", "y"))
  expect_true(any(res3$predictions$testdata == "p1"))
  expect_true(any(res3$predictions$testdata == "p2"))
  expect_true(any(res3$predictions$toolset == "ROCR"))
  expect_true(any(res3$predictions$toolset == "precrec"))
  expect_true(any(res3$predictions$toolname == "ROCR"))
  expect_true(all(res3$predictions$toolname != "AUCCalculator"))
  expect_true(all(res3$predictions$toolname != "PerfMeas"))
  expect_true(all(res3$predictions$toolname != "PRROC"))
  expect_true(any(res3$predictions$toolname == "precrec"))
})

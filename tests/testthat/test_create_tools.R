library(prcbenchmark)

context("Tool: Create wrapper objects")
# Test create_tools
#

test_that("create_tools", {
  tools1 <- create_tools()
  expect_equal(length(tools1), 5)

  tool1 <- create_tools("ROCR")
  expect_true(is(tool1[[1]], "ToolROCR"))

  tool2 <- create_tools("AUCCalculator")
  expect_true(is(tool2[[1]], "ToolAUCCalculator"))

  tool3 <- create_tools("PerfMeas")
  expect_true(is(tool3[[1]], "ToolPerfMeas"))

  tool4 <- create_tools("PRROC")
  expect_true(is(tool4[[1]], "ToolPRROC"))

  tool5 <- create_tools("precrec")
  expect_true(is(tool5[[1]], "Toolprecrec"))
})







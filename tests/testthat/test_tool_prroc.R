library(prcbenchmark)

context("Tool: PRROC")
# Test tool_generator(name)
#      ToolPRROC
#

test_that("tool_generator - R6ClassGenerator", {
  tool_class <- tool_generator("PRROC")

  expect_true(is(tool_class, "R6ClassGenerator"))
  expect_equal(attr(tool_class, "name"), "ToolPRROC_generator")

  expect_true(is.function(tool_class$public_methods$set_curve))
  expect_true(is.function(tool_class$public_methods$set_minStepSize))

  expect_equal(grep(".prroc_wrapper",
                    body(tool_class$private_methods$f_wrapper))[[1]], 2)
})

test_that("tool_generator - R6", {
  tool_obj <- tool_generator("PRROC")$new()

  expect_true(is(tool_obj, "ToolPRROC"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["set_curve"]]))
  expect_true(is.function(tool_obj[["set_minStepSize"]]))
})

test_that("ToolPRROC - R6ClassGenerator", {
  expect_true(is(ToolPRROC, "R6ClassGenerator"))
  expect_equal(attr(ToolPRROC, "name"), "ToolPRROC_generator")

  expect_true(is.function(ToolPRROC$public_methods$set_curve))
  expect_true(is.function(ToolPRROC$public_methods$set_minStepSize))

  expect_equal(grep(".prroc_wrapper",
                    body(ToolPRROC$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolPRROC - R6", {
  tool_obj <- ToolPRROC$new()

  expect_true(is(tool_obj, "ToolPRROC"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["set_curve"]]))
  expect_true(is.function(tool_obj[["set_minStepSize"]]))
})

test_that("ToolPRROC$new(curve)", {
  tool_obj1 <- ToolPRROC$new()
  expect_equal(environment(tool_obj1$clone)$private$curve, TRUE)

  tool_obj2 <- ToolPRROC$new(curve = FALSE)
  expect_equal(environment(tool_obj2$clone)$private$curve, FALSE)
})

test_that("ToolPRROC$new(minStepSize)", {
  tool_obj1 <- ToolPRROC$new()
  expect_equal(environment(tool_obj1$clone)$private$minStepSize, 0.01)

  tool_obj2 <- ToolPRROC$new(minStepSize = 0.05)
  expect_equal(environment(tool_obj2$clone)$private$minStepSize, 0.05)
})

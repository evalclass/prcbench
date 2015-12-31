context("Tool: PRROC")
# Test ToolPRROC
#      create_tools
#

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
  expect_true(is(tool_obj, "ToolIFBase"))
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

test_that("create_tools: calc_auc", {
  tool_obj1 <- create_tools("PRROC")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_calc_auc, TRUE)

  tool_obj2 <- create_tools("PRROC", calc_auc = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_tools: store_res", {
  tool_obj1 <- create_tools("PRROC")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_store_res, TRUE)

  tool_obj2 <- create_tools("PRROC", store_res = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_store_res, FALSE)
})

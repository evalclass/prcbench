context("Tool: ROCR")
# Test ToolROCR
#      create_toolset
#

test_that("ToolROCR - R6ClassGenerator", {
  expect_true(is(ToolROCR, "R6ClassGenerator"))
  expect_equal(attr(ToolROCR, "name"), "ToolROCR_generator")

  expect_equal(grep("ROCR", body(ToolROCR$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolROCR - R6", {
  tool_obj <- ToolROCR$new()

  expect_true(is(tool_obj, "ToolROCR"))
  expect_true(is(tool_obj, "ToolIFBase"))
  expect_true(is(tool_obj, "R6"))
})

test_that("create_toolset: calc_auc", {
  tool_obj1 <- create_toolset("ROCR")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_calc_auc, TRUE)

  tool_obj2 <- create_toolset("ROCR", calc_auc = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_toolset: store_res", {
  tool_obj1 <- create_toolset("ROCR")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_store_res, TRUE)

  tool_obj2 <- create_toolset("ROCR", store_res = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_store_res, FALSE)
})

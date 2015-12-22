library(prcbench)

context("Tool: ROCR")
# Test .create_tool_cls(name)
#      ToolROCR
#

test_that(".create_tool_cls - R6", {
  tool_obj <- .create_tool_cls("ROCR")[[1]]

  expect_true(is(tool_obj, "ToolROCR"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))
})

test_that("ToolROCR - R6ClassGenerator", {
  expect_true(is(ToolROCR, "R6ClassGenerator"))
  expect_equal(attr(ToolROCR, "name"), "ToolROCR_generator")

  expect_equal(grep("ROCR", body(ToolROCR$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolROCR - R6", {
  tool_obj <- ToolROCR$new()

  expect_true(is(tool_obj, "ToolROCR"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))
})

library(prcbenchmark)

context("Tool: ROCR")
# Test tool_generator(name)
#      ToolROCR
#

test_that("tool_generator - R6ClassGenerator", {
  tool_class <- tool_generator("ROCR")

  expect_true(is(tool_class, "R6ClassGenerator"))
  expect_equal(attr(tool_class, "name"), "ToolROCR_generator")

  expect_equal(grep("ROCR", body(tool_class$private_methods$f_wrapper))[[1]], 2)
})

test_that("tool_generator - R6", {
  tool_obj <- tool_generator("ROCR")$new()

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

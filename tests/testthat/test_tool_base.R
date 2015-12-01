library(prcbenchmark)

context("Tool: Base")
# Test .tool_base_generator()
#      ToolBase
#

test_that(".tool_base_generator - R6ClassGenerator", {
  tool_class <- .tool_base_generator()

  expect_true(is(tool_class, "R6ClassGenerator"))
  expect_equal(attr(tool_class, "name"), "ToolBase_generator")

  expect_true(is.function(tool_class$public_methods$call))
  expect_true(is.function(tool_class$public_methods$get_result))
  expect_true(is.function(tool_class$public_methods$get_x))
  expect_true(is.function(tool_class$public_methods$get_y))
  expect_true(is.function(tool_class$public_methods$get_auc))
})

test_that(".tool_base_generator - R6", {
  tool_obj <- .tool_base_generator()$new()

  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["call"]]))
  expect_true(is.function(tool_obj[["get_result"]]))
  expect_true(is.function(tool_obj[["get_x"]]))
  expect_true(is.function(tool_obj[["get_y"]]))
  expect_true(is.function(tool_obj[["get_auc"]]))
})

test_that("ToolBase - R6ClassGenerator", {
  expect_true(is(ToolBase, "R6ClassGenerator"))
  expect_equal(attr(ToolBase, "name"), "ToolBase_generator")

  expect_true(is.function(ToolBase$public_methods$call))
  expect_true(is.function(ToolBase$public_methods$get_result))
  expect_true(is.function(ToolBase$public_methods$get_x))
  expect_true(is.function(ToolBase$public_methods$get_y))
  expect_true(is.function(ToolBase$public_methods$get_auc))
})

test_that("ToolBase - R6", {
  tool_obj <- ToolBase$new()

  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["call"]]))
  expect_true(is.function(tool_obj[["get_result"]]))
  expect_true(is.function(tool_obj[["get_x"]]))
  expect_true(is.function(tool_obj[["get_y"]]))
  expect_true(is.function(tool_obj[["get_auc"]]))
})

test_that("ToolBase$get_x", {
  tool_obj <- ToolBase$new()

  expect_true(is.na(tool_obj$get_x()))
})

test_that("ToolBase$get_y", {
  tool_obj <- ToolBase$new()

  expect_true(is.na(tool_obj$get_y()))
})

test_that("ToolBase$get_auc", {
  tool_obj <- ToolBase$new()

  expect_true(is.na(tool_obj$get_auc()))
})

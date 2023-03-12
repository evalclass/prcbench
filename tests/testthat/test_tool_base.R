context("Tool: IFBase")
# Test ToolIFBase
#

test_that("ToolIFBase - R6ClassGenerator", {
  expect_true(is(ToolIFBase, "R6ClassGenerator"))
  expect_equal(attr(ToolIFBase, "name"), "ToolIFBase_generator")

  expect_true(is.function(ToolIFBase$public_methods$call))
  expect_true(is.function(ToolIFBase$public_methods$get_toolname))
  expect_true(is.function(ToolIFBase$public_methods$get_setname))
  expect_true(is.function(ToolIFBase$public_methods$set_setname))
  expect_true(is.function(ToolIFBase$public_methods$get_result))
  expect_true(is.function(ToolIFBase$public_methods$get_x))
  expect_true(is.function(ToolIFBase$public_methods$get_y))
  expect_true(is.function(ToolIFBase$public_methods$get_auc))
  expect_true(is.function(ToolIFBase$public_methods$print))
})

test_that("ToolIFBase - R6", {
  tool_obj <- ToolIFBase$new()

  expect_true(is(tool_obj, "ToolIFBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["call"]]))
  expect_true(is.function(tool_obj[["get_toolname"]]))
  expect_true(is.function(tool_obj[["get_setname"]]))
  expect_true(is.function(tool_obj[["set_setname"]]))
  expect_true(is.function(tool_obj[["get_result"]]))
  expect_true(is.function(tool_obj[["get_x"]]))
  expect_true(is.function(tool_obj[["get_y"]]))
  expect_true(is.function(tool_obj[["get_auc"]]))
  expect_true(is.function(tool_obj[["print"]]))
})

test_that("ToolIFBase$get_result", {
  tool_obj <- ToolIFBase$new()

  expect_equal(tool_obj$get_result(), list(x = NA, y = NA, auc = NA))
})

test_that("ToolIFBase$get_x", {
  tool_obj <- ToolIFBase$new()

  expect_true(is.na(tool_obj$get_x()))
})

test_that("ToolIFBase$get_y", {
  tool_obj <- ToolIFBase$new()

  expect_true(is.na(tool_obj$get_y()))
})

test_that("ToolIFBase$get_auc", {
  tool_obj <- ToolIFBase$new()

  expect_true(is.na(tool_obj$get_auc()))
})

test_that("ToolIFBase$get_toolname", {
  tool_obj <- ToolIFBase$new()

  expect_true(is.na(tool_obj$get_toolname()))

  oclone <- tool_obj$clone
  unlockBinding("oclone", environment())
  environment(oclone)$private$toolname <- "ABC"
  lockBinding("oclone", environment())

  expect_equal(tool_obj$get_toolname(), "ABC")
})

test_that("ToolIFBase$get_setname & set_setname", {
  tool_obj <- ToolIFBase$new()

  expect_true(is.na(tool_obj$get_setname()))

  tool_obj$set_setname("AAA")

  expect_equal(environment(tool_obj$clone)$private$setname, "AAA")
  expect_equal(tool_obj$get_setname(), "AAA")
})

test_that("ToolIFBase$get_toolname & set_toolname", {
  tool_obj <- ToolIFBase$new()

  expect_true(is.na(tool_obj$get_toolname()))

  tool_obj$set_toolname("AAA")

  expect_equal(environment(tool_obj$clone)$private$toolname, "AAA")
  expect_equal(tool_obj$get_toolname(), "AAA")
})

test_that("ToolIFBase$print", {
  tool_obj <- ToolIFBase$new()

  expect_output(print(tool_obj), "Tool interface")
})

test_that("ToolIFBase$call", {
  .test_f_wrapper <- function(testset = "x", calc_auc = FALSE, store_res = TRUE) {
    list(x = 0, y = 0, auc = 1)
  }
  testx <- R6::R6Class(
    "x",
    inherit = ToolIFBase,
    private = list(toolname = "testx", f_wrapper = .test_f_wrapper)
  )
  tool_obj <- testx$new(store_res = FALSE)

  expect_silent(tool_obj$call("x", TRUE, FALSE))
  expect_equal(tool_obj$get_auc(), 1)


  expect_silent(tool_obj$call("x", TRUE, TRUE))
  expect_equal(tool_obj$get_result(), list(x = 0, y = 0, auc = 1))
})

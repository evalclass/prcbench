library(prcbench)

context("Tool: AUCCalculator")
# Test .create_tool_cls(name)
#      ToolAUCCalculator
#

test_that(".create_tool_cls - R6", {
  tool_obj <- .create_tool_cls("AUCCalculator")[[1]]

  expect_true(is(tool_obj, "ToolAUCCalculator"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["set_java_call"]]))
})

test_that("ToolAUCCalculator - R6ClassGenerator", {
  expect_true(is(ToolAUCCalculator, "R6ClassGenerator"))
  expect_equal(attr(ToolAUCCalculator, "name"), "ToolAUCCalculator_generator")

  expect_true(is.function(ToolAUCCalculator$public_methods$set_java_call))

  expect_equal(grep(".auccalc_wrapper",
                    body(ToolAUCCalculator$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolAUCCalculator - R6", {
  tool_obj <- ToolAUCCalculator$new()

  expect_true(is(tool_obj, "ToolAUCCalculator"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))

  expect_true(is.function(tool_obj[["set_java_call"]]))
})

test_that("ToolAUCCalculator$new(type)", {
  tool_obj1 <- ToolAUCCalculator$new()
  expect_equal(environment(tool_obj1$clone)$private$type, "syscall")

  tool_obj2 <- ToolAUCCalculator$new(type = "rjava")
  expect_equal(environment(tool_obj2$clone)$private$type, "rjava")
})

test_that("ToolAUCCalculator$new(fpath)", {
  tool_obj1 <- ToolAUCCalculator$new()
  expect_true(is.null(environment(tool_obj1$clone)$private$fpath))

  fpath <- system.file("java", "auc.jar", package = "prcbench")
  tool_obj2 <- ToolAUCCalculator$new(fpath = fpath)
  expect_equal(environment(tool_obj2$clone)$private$fpath, fpath)
})

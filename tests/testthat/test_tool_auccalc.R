library(prcbenchmark)

context("Tool: AUCCalculator")
# Test tool_generator(name)
#      ToolAUCCalculator
#

test_that("tool_generator - R6ClassGenerator", {
  tool_class <- tool_generator("AUCCalculator")

  expect_true(is(tool_class, "R6ClassGenerator"))
  expect_equal(attr(tool_class, "name"), "ToolAUCCalculator_generator")

  expect_true(is.function(tool_class$public_methods$set_java_call))

  expect_equal(grep(".auccalc_wrapper",
                    body(tool_class$private_methods$f_wrapper))[[1]], 2)
})

test_that("tool_generator - R6", {
  tool_obj <- tool_generator("AUCCalculator")$new()

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

  fpath <- system.file("java", "auc.jar", package = "prcbenchmark")
  tool_obj2 <- ToolAUCCalculator$new(fpath = fpath)
  expect_equal(environment(tool_obj2$clone)$private$fpath, fpath)
})

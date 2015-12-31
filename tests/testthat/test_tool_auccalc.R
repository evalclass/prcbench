context("Tool: AUCCalculator")
# Test ToolAUCCalculator
#      create_tools
#

test_that("ToolAUCCalculator - R6ClassGenerator", {
  expect_true(is(ToolAUCCalculator, "R6ClassGenerator"))
  expect_equal(attr(ToolAUCCalculator, "name"), "ToolAUCCalculator_generator")

  expect_true(is.function(ToolAUCCalculator$public_methods$set_java_call))
})

test_that("ToolAUCCalculator - R6", {
  tool_obj <- ToolAUCCalculator$new()

  expect_true(is(tool_obj, "ToolAUCCalculator"))
  expect_true(is(tool_obj, "ToolIFBase"))
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
  expect_true(is.na(environment(tool_obj1$clone)$private$fpath))

  fpath <- system.file("java", "auc2.jar", package = "prcbench")
  tool_obj2 <- ToolAUCCalculator$new(fpath = fpath)
  expect_equal(environment(tool_obj2$clone)$private$fpath, fpath)
})

test_that("create_tools: calc_auc", {
  tool_obj1 <- create_tools("AUCCalculator")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_calc_auc, TRUE)

  tool_obj2 <- create_tools("AUCCalculator", calc_auc = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_tools: store_res", {
  tool_obj1 <- create_tools("AUCCalculator")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_store_res, TRUE)

  tool_obj2 <- create_tools("AUCCalculator", store_res = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_store_res, FALSE)
})

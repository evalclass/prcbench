context("Tool: AUCCalculator")
# Test ToolAUCCalculator
#      create_toolset
#

test_that("ToolAUCCalculator - R6ClassGenerator", {
  expect_true(is(ToolAUCCalculator, "R6ClassGenerator"))
  expect_equal(attr(ToolAUCCalculator, "name"), "ToolAUCCalculator_generator")

  expect_true(is.function(ToolAUCCalculator$public_methods$set_java_call))
})

test_that("ToolAUCCalculator - R6", {
  toolset <- ToolAUCCalculator$new()

  expect_true(is(toolset, "ToolAUCCalculator"))
  expect_true(is(toolset, "ToolIFBase"))
  expect_true(is(toolset, "R6"))

  expect_true(is.function(toolset[["set_java_call"]]))
})

test_that("ToolAUCCalculator$new(type)", {
  toolset1 <- ToolAUCCalculator$new()
  expect_equal(environment(toolset1$clone)$private$type, "syscall")

  toolset2 <- ToolAUCCalculator$new(type = "rjava")
  expect_equal(environment(toolset2$clone)$private$type, "rjava")
})

test_that("ToolAUCCalculator$new(fpath)", {
  toolset1 <- ToolAUCCalculator$new()
  expect_true(is.na(environment(toolset1$clone)$private$fpath))

  fpath <- system.file("java", "auc2.jar", package = "prcbench")
  toolset2 <- ToolAUCCalculator$new(fpath = fpath)
  expect_equal(environment(toolset2$clone)$private$fpath, fpath)
})

test_that("create_toolset", {
  toolset1 <- create_toolset("AUC")[[1]]
  expect_true(is(toolset1, "ToolAUCCalculator"))
  expect_equal(toolset1$get_toolname(), "AUCCalculator")

  toolset2 <- create_toolset("auc")[[1]]
  expect_true(is(toolset2, "ToolAUCCalculator"))
  expect_equal(toolset2$get_toolname(), "AUCCalculator")
})

test_that("create_toolset: calc_auc", {
  toolset1 <- create_toolset("AUCCalculator")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_calc_auc, TRUE)

  toolset2 <- create_toolset("AUCCalculator", calc_auc = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_toolset: store_res", {
  toolset1 <- create_toolset("AUCCalculator")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_store_res, TRUE)

  toolset2 <- create_toolset("AUCCalculator", store_res = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_store_res, FALSE)
})

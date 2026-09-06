context("Tool: yardstick")
# Test Toolyardstick
#      create_toolset
#

test_that("Toolyardstick - R6ClassGenerator", {
  expect_true(is(Toolyardstick, "R6ClassGenerator"))
  expect_equal(attr(Toolyardstick, "name"), "Toolyardstick_generator")

  expect_equal(grep(
    "yardstick",
    body(Toolyardstick$private_methods$f_wrapper)
  )[[1]], 2)
})

test_that("Toolyardstick - R6", {
  toolset <- Toolyardstick$new()

  expect_true(is(toolset, "Toolyardstick"))
  expect_true(is(toolset, "ToolIFBase"))
  expect_true(is(toolset, "R6"))
})

test_that("Toolyardstick print", {
  toolset <- Toolyardstick$new()
  expect_output(print(toolset), "Tool interface")
  expect_output(print(toolset), "yardstick")
})

test_that("create_toolset", {
  toolset1 <- create_toolset("YARD")[[1]]
  expect_true(is(toolset1, "Toolyardstick"))
  expect_equal(toolset1$get_toolname(), "yardstick")

  toolset2 <- create_toolset("yard")[[1]]
  expect_true(is(toolset2, "Toolyardstick"))
  expect_equal(toolset2$get_toolname(), "yardstick")
})

test_that("create_toolset: calc_auc", {
  toolset1 <- create_toolset("yardstick")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_calc_auc, TRUE)

  toolset2 <- create_toolset("yardstick", calc_auc = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_toolset: store_res", {
  toolset1 <- create_toolset("yardstick")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_store_res, TRUE)

  toolset2 <- create_toolset("yardstick", store_res = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_store_res, FALSE)
})

test_that(".yardstick_wrapper", {
  testset <- create_testset("curve", "c1")[[1]]
  res <- .yardstick_wrapper(testset)

  expect_equal(res$x, c(0.0, 0.5, 1.0, 1.0))
  expect_equal(res$y, c(1.0, 1.0, 0.6666667, 0.5), tolerance = .001)
  expect_true(is.na(res$auc))

  res2 <- .yardstick_wrapper(testset, store_res = FALSE)
  expect_true(is.null(res2))

  res3 <- .yardstick_wrapper(testset, calc_auc = TRUE)
  expect_equal(res3$x, c(0.0, 0.5, 1.0, 1.0))
  expect_equal(res3$y, c(1.0, 1.0, 0.6666667, 0.5), tolerance = .001)
  expect_equal(res3$auc, 0.9166667, tolerance = .001)
})

test_that(".yardstick_wrapper: positive label is the event level", {
  testset <- create_testset("curve", "c2")[[1]]
  res <- .yardstick_wrapper(testset, calc_auc = TRUE)

  # A flipped event level would place the AUC well below 0.5
  expect_true(res$auc > 0.5)
  expect_equal(res$x[[1]], 0.0)
  expect_equal(res$x[[length(res$x)]], 1.0)
})

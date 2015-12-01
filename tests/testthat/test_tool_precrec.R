library(prcbenchmark)

context("Tool: precrec")
# Test tool_generator(name)
#      Toolprecrec
#

test_that("tool_generator - R6ClassGenerator", {
  tool_class <- tool_generator("precrec")

  expect_true(is(tool_class, "R6ClassGenerator"))
  expect_equal(attr(tool_class, "name"), "Toolprecrec_generator")

  expect_equal(grep("precrec",
                    body(tool_class$private_methods$f_wrapper))[[1]], 2)
})

test_that("tool_generator - R6", {
  tool_obj <- tool_generator("precrec")$new()

  expect_true(is(tool_obj, "Toolprecrec"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))
})

test_that("Toolprecrec - R6ClassGenerator", {
  expect_true(is(Toolprecrec, "R6ClassGenerator"))
  expect_equal(attr(Toolprecrec, "name"), "Toolprecrec_generator")

  expect_equal(grep("precrec",
                    body(Toolprecrec$private_methods$f_wrapper))[[1]], 2)
})

test_that("Toolprecrec - R6", {
  tool_obj <- Toolprecrec$new()

  expect_true(is(tool_obj, "Toolprecrec"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))
})

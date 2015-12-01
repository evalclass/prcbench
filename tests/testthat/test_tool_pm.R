library(prcbenchmark)

context("Tool: PerfMeas")
# Test tool_generator(name)
#      ToolPerfMeas
#

test_that("tool_generator - R6ClassGenerator", {
  tool_class <- tool_generator("PerfMeas")

  expect_true(is(tool_class, "R6ClassGenerator"))
  expect_equal(attr(tool_class, "name"), "ToolPerfMeas_generator")

  expect_equal(grep("PerfMeas",
                    body(tool_class$private_methods$f_wrapper))[[1]], 2)
})

test_that("tool_generator - R6", {
  tool_obj <- tool_generator("PerfMeas")$new()

  expect_true(is(tool_obj, "ToolPerfMeas"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))
})

test_that("ToolPerfMeas - R6ClassGenerator", {
  expect_true(is(ToolPerfMeas, "R6ClassGenerator"))
  expect_equal(attr(ToolPerfMeas, "name"), "ToolPerfMeas_generator")

  expect_equal(grep("PerfMeas",
                    body(ToolPerfMeas$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolPerfMeas - R6", {
  tool_obj <- ToolPerfMeas$new()

  expect_true(is(tool_obj, "ToolPerfMeas"))
  expect_true(is(tool_obj, "ToolBase"))
  expect_true(is(tool_obj, "R6"))
})

library(prcbenchmark)

context("Tool: PerfMeas")
# Test .create_tool_cls(name)
#      ToolPerfMeas
#

test_that(".create_tool_cls - R6", {
  tool_obj <- .create_tool_cls("PerfMeas")[[1]]

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

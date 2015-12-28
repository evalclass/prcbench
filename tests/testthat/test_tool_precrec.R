library(prcbench)

context("Tool: precrec")
# Test .create_tool_cls(name)
#      Toolprecrec
#

test_that(".create_tool_cls - R6", {
  tool_obj <- .create_tool_cls("precrec")[[1]]

  expect_true(is(tool_obj, "Toolprecrec"))
  expect_true(is(tool_obj, "ToolIFBase"))
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
  expect_true(is(tool_obj, "ToolIFBase"))
  expect_true(is(tool_obj, "R6"))
})

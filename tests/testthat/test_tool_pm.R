context("Tool: PerfMeas")
# Test ToolPerfMeas
#      create_tools
#

test_that("ToolPerfMeas - R6ClassGenerator", {
  expect_true(is(ToolPerfMeas, "R6ClassGenerator"))
  expect_equal(attr(ToolPerfMeas, "name"), "ToolPerfMeas_generator")

  expect_equal(grep("PerfMeas",
                    body(ToolPerfMeas$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolPerfMeas - R6", {
  tool_obj <- ToolPerfMeas$new()

  expect_true(is(tool_obj, "ToolPerfMeas"))
  expect_true(is(tool_obj, "ToolIFBase"))
  expect_true(is(tool_obj, "R6"))
})

test_that("create_tools: calc_auc", {
  tool_obj1 <- create_tools("PerfMeas")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_calc_auc, TRUE)

  tool_obj2 <- create_tools("PerfMeas", calc_auc = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_tools: store_res", {
  tool_obj1 <- create_tools("PerfMeas")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_store_res, TRUE)

  tool_obj2 <- create_tools("PerfMeas", store_res = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_store_res, FALSE)
})

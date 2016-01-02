context("Tool: precrec")
# Test Toolprecrec
#      create_toolset
#

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

test_that("create_toolset: calc_auc", {
  tool_obj1 <- create_toolset("precrec")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_calc_auc, TRUE)

  tool_obj2 <- create_toolset("precrec", calc_auc = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_toolset: store_res", {
  tool_obj1 <- create_toolset("precrec")[[1]]
  expect_equal(environment(tool_obj1$clone)$private$def_store_res, TRUE)

  tool_obj2 <- create_toolset("precrec", store_res = FALSE)[[1]]
  expect_equal(environment(tool_obj2$clone)$private$def_store_res, FALSE)
})

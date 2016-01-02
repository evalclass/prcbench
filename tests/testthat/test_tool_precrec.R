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
  toolset <- Toolprecrec$new()

  expect_true(is(toolset, "Toolprecrec"))
  expect_true(is(toolset, "ToolIFBase"))
  expect_true(is(toolset, "R6"))
})

test_that("create_toolset: calc_auc", {
  toolset1 <- create_toolset("precrec")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_calc_auc, TRUE)

  toolset2 <- create_toolset("precrec", calc_auc = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_toolset: store_res", {
  toolset1 <- create_toolset("precrec")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_store_res, TRUE)

  toolset2 <- create_toolset("precrec", store_res = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_store_res, FALSE)
})

context("Tool: User-defined tool")
# Test create_example_func
#      create_usrtool
#

test_that("create_example_func", {

  func <- create_example_func()
  expect_true(is.function(func))
  expect_equal(names(formals(func)), "testset")

})

test_that("create_usrtool - R6", {
  func <- create_example_func()
  tool1 <- create_usrtool("xyz", func)[[1]]

  expect_true(is(tool1, "Toolxyz"))
  expect_true(is(tool1, "ToolIFBase"))
  expect_true(is(tool1, "R6"))
})

test_that("create_usrtool: calc_auc", {
  func <- create_example_func()
  tool1 <- create_usrtool("xyz", func)[[1]]
  expect_equal(environment(tool1$clone)$private$def_calc_auc, TRUE)

  tool2 <- create_usrtool("xyz", func, calc_auc = FALSE)[[1]]
  expect_equal(environment(tool2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_usrtool: store_res", {
  func <- create_example_func()
  tool1 <- create_usrtool("xyz", func)[[1]]
  expect_equal(environment(tool1$clone)$private$def_store_res, TRUE)

  tool2 <- create_usrtool("xyz", func, store_res = FALSE)[[1]]
  expect_equal(environment(tool2$clone)$private$def_store_res, FALSE)
})

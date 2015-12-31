context("Data: Precalculated testset")
# Test create_testdata
#

test_that("create_testdata: p1", {
  tdat <- create_testdata("precalc", "p1")[[1]]

  expect_true(is(tdat, "TestDataEC"))
  expect_true(is(tdat, "TestDataPB"))
  expect_true(is(tdat, "R6"))

  expect_equal(tdat$get_dsname(), "p1")

  bp_x <- c(0, 0.25, 0.5, 0.75, 1, 1)
  bp_y <- c(1, 1, 1, 0.75, 0.6666666667, 0.5)
  expect_equal(tdat$get_basepoints_x(), bp_x)
  expect_equal(tdat$get_basepoints_y(), bp_y)

  expect_equal(tdat$get_textpos_x(), 0.85)
  expect_equal(tdat$get_textpos_y(), 0.9)
})

test_that("create_testdata: p2", {
  tdat <- create_testdata("precalc", "p2")[[1]]

  expect_true(is(tdat, "TestDataEC"))
  expect_true(is(tdat, "TestDataPB"))
  expect_true(is(tdat, "R6"))

  expect_equal(tdat$get_dsname(), "p2")

  bp_x <- c(0, 0.25, 0.5, 0.5, 0.75, 1)
  bp_y <- c(0.5, 0.5, 0.5, 0.3333333333, 0.4285714286, 0.5)
  expect_equal(tdat$get_basepoints_x(), bp_x)
  expect_equal(tdat$get_basepoints_y(), bp_y)

  expect_equal(tdat$get_textpos_x(), 0.2)
  expect_equal(tdat$get_textpos_y(), 0.65)
})

test_that("create_testdata: p3", {
  tdat <- create_testdata("precalc", "p3")[[1]]

  expect_true(is(tdat, "TestDataEC"))
  expect_true(is(tdat, "TestDataPB"))
  expect_true(is(tdat, "R6"))

  expect_equal(tdat$get_dsname(), "p3")

  bp_x <- c(0, 0, 0, 0.25, 0.5, 0.75, 1)
  bp_y <- c(0, 0, 0, 0.2, 0.3333333333, 0.4285714286, 0.5)
  expect_equal(tdat$get_basepoints_x(), bp_x)
  expect_equal(tdat$get_basepoints_y(), bp_y)

  expect_equal(tdat$get_textpos_x(), 0.8)
  expect_equal(tdat$get_textpos_y(), 0.2)
})

test_that("create_testdata: p1, p2, p3", {
  tdat <- create_testdata("precalc", c("p1", "p2", "p3"))

  expect_equal(tdat[[1]]$get_dsname(), "p1")
  expect_equal(tdat[[2]]$get_dsname(), "p2")
  expect_equal(tdat[[3]]$get_dsname(), "p3")
})

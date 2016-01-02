context("Data: Testset for curve evaluation")
# Test create_testset
#

test_that("create_testset: p1", {
  testset <- create_testset("curve", "p1")[[1]]

  expect_true(is(testset, "TestDataEC"))
  expect_true(is(testset, "TestDataPB"))
  expect_true(is(testset, "R6"))

  expect_equal(testset$get_dsname(), "p1")

  bp_x <- c(0, 0.25, 0.5, 0.75, 1, 1)
  bp_y <- c(1, 1, 1, 0.75, 0.6666666667, 0.5)
  expect_equal(testset$get_basepoints_x(), bp_x)
  expect_equal(testset$get_basepoints_y(), bp_y)

  expect_equal(testset$get_textpos_x(), 0.85)
  expect_equal(testset$get_textpos_y(), 0.9)
})

test_that("create_testset: p2", {
  testset <- create_testset("curve", "p2")[[1]]

  expect_true(is(testset, "TestDataEC"))
  expect_true(is(testset, "TestDataPB"))
  expect_true(is(testset, "R6"))

  expect_equal(testset$get_dsname(), "p2")

  bp_x <- c(0, 0.25, 0.5, 0.5, 0.75, 1)
  bp_y <- c(0.5, 0.5, 0.5, 0.3333333333, 0.4285714286, 0.5)
  expect_equal(testset$get_basepoints_x(), bp_x)
  expect_equal(testset$get_basepoints_y(), bp_y)

  expect_equal(testset$get_textpos_x(), 0.2)
  expect_equal(testset$get_textpos_y(), 0.65)
})

test_that("create_testset: p3", {
  testset <- create_testset("curve", "p3")[[1]]

  expect_true(is(testset, "TestDataEC"))
  expect_true(is(testset, "TestDataPB"))
  expect_true(is(testset, "R6"))

  expect_equal(testset$get_dsname(), "p3")

  bp_x <- c(0, 0, 0, 0.25, 0.5, 0.75, 1)
  bp_y <- c(0, 0, 0, 0.2, 0.3333333333, 0.4285714286, 0.5)
  expect_equal(testset$get_basepoints_x(), bp_x)
  expect_equal(testset$get_basepoints_y(), bp_y)

  expect_equal(testset$get_textpos_x(), 0.8)
  expect_equal(testset$get_textpos_y(), 0.2)
})

test_that("create_testset: p1, p2, p3", {
  testset <- create_testset("curve", c("p1", "p2", "p3"))

  expect_equal(testset[[1]]$get_dsname(), "p1")
  expect_equal(testset[[2]]$get_dsname(), "p2")
  expect_equal(testset[[3]]$get_dsname(), "p3")
})

context("Data: Single dataset")
# Test create_testset
#

test_that("create_testset: single - scores and labels", {
  testset <- create_testset("single", scores = c(0.1, 0.2),
                            labels = c(1, 0))[[1]]

  expect_true(is(testset, "TestDataPB"))
  expect_true(is(testset, "R6"))

  expect_equal(testset$get_scores(), c(0.1, 0.2))
  expect_equal(testset$get_labels(), c(1, 0))
})

test_that("create_testset: single - dsname", {
  testset1 <- create_testset("single", scores = c(0.1, 0.2),
                             labels = c(1, 0))[[1]]
  expect_true(is.na(testset1$get_dsname()))

  testset2 <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                             dsname = "m1")[[1]]
  expect_equal(testset2$get_dsname(), "m1")
})

test_that("create_testset: single base points", {
  testset <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                            base_x = c(0.13, 0.2), base_y = c(0.5, 0.6))[[1]]

  expect_true(is(testset, "TestDataEC"))
  expect_true(is(testset, "TestDataPB"))
  expect_true(is(testset, "R6"))

  expect_equal(testset$get_scores(), c(0.1, 0.2))
  expect_equal(testset$get_labels(), c(1, 0))
  expect_equal(testset$get_basepoints_x(), c(0.13, 0.2))
  expect_equal(testset$get_basepoints_y(), c(0.5, 0.6))
})

test_that("create_testset: single base points", {
  testset1 <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                             text_x = 0.75, text_y = 0.85)[[1]]

  expect_true(!is(testset1, "TestDataEC"))
  expect_true(is(testset1, "TestDataPB"))
  expect_true(is(testset1, "R6"))

  testset2 <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                             base_x = c(0.13, 0.2), base_y = c(0.5, 0.6),
                             text_x = 0.75, text_y = 0.85)[[1]]

  expect_true(is(testset2, "TestDataEC"))
  expect_true(is(testset2, "TestDataPB"))
  expect_true(is(testset2, "R6"))

  expect_equal(testset2$get_scores(), c(0.1, 0.2))
  expect_equal(testset2$get_labels(), c(1, 0))
  expect_equal(testset2$get_basepoints_x(), c(0.13, 0.2))
  expect_equal(testset2$get_basepoints_y(), c(0.5, 0.6))
  expect_equal(testset2$get_textpos_x(), 0.75)
  expect_equal(testset2$get_textpos_y(), 0.85)
})

context("Data: Single dataset")
# Test create_testset
#

test_that("create_testset: single - scores and labels", {
  tdat <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0))[[1]]

  expect_true(is(tdat, "TestDataPB"))
  expect_true(is(tdat, "R6"))

  expect_equal(tdat$get_scores(), c(0.1, 0.2))
  expect_equal(tdat$get_labels(), c(1, 0))
})

test_that("create_testset: single - dsname", {
  tdat1 <- create_testset("single", scores = c(0.1, 0.2),
                           labels = c(1, 0))[[1]]
  expect_true(is.na(tdat1$get_dsname()))

  tdat2 <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                          dsname = "m1")[[1]]
  expect_equal(tdat2$get_dsname(), "m1")
})

test_that("create_testset: single base points", {
  tdat <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                         base_x = c(0.13, 0.2), base_y = c(0.5, 0.6))[[1]]

  expect_true(is(tdat, "TestDataEC"))
  expect_true(is(tdat, "TestDataPB"))
  expect_true(is(tdat, "R6"))

  expect_equal(tdat$get_scores(), c(0.1, 0.2))
  expect_equal(tdat$get_labels(), c(1, 0))
  expect_equal(tdat$get_basepoints_x(), c(0.13, 0.2))
  expect_equal(tdat$get_basepoints_y(), c(0.5, 0.6))
})

test_that("create_testset: single base points", {
  tdat1 <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                          text_x = 0.75, text_y = 0.85)[[1]]

  expect_true(!is(tdat1, "TestDataEC"))
  expect_true(is(tdat1, "TestDataPB"))
  expect_true(is(tdat1, "R6"))

  tdat2 <- create_testset("single", scores = c(0.1, 0.2), labels = c(1, 0),
                          base_x = c(0.13, 0.2), base_y = c(0.5, 0.6),
                          text_x = 0.75, text_y = 0.85)[[1]]

  expect_true(is(tdat2, "TestDataEC"))
  expect_true(is(tdat2, "TestDataPB"))
  expect_true(is(tdat2, "R6"))

  expect_equal(tdat2$get_scores(), c(0.1, 0.2))
  expect_equal(tdat2$get_labels(), c(1, 0))
  expect_equal(tdat2$get_basepoints_x(), c(0.13, 0.2))
  expect_equal(tdat2$get_basepoints_y(), c(0.5, 0.6))
  expect_equal(tdat2$get_textpos_x(), 0.75)
  expect_equal(tdat2$get_textpos_y(), 0.85)
})

context("Data: TestData")
# Test TestDataPB
#      TestDataEC
#

test_that("TestDataPB - R6ClassGenerator", {
  expect_true(is(TestDataPB, "R6ClassGenerator"))
  expect_equal(attr(TestDataPB, "name"), "TestDataPB_generator")

  expect_true(is.function(TestDataPB$public_methods$get_dsname))
  expect_true(is.function(TestDataPB$public_methods$get_scores))
  expect_true(is.function(TestDataPB$public_methods$get_labels))
  expect_true(is.function(TestDataPB$public_methods$get_fg))
  expect_true(is.function(TestDataPB$public_methods$get_bg))
  expect_true(is.function(TestDataPB$public_methods$get_fname))
  expect_true(is.function(TestDataPB$public_methods$del_file))
})

test_that("TestDataPB - R6", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3), c(0, 1, 1))

  expect_true(is(data_obj, "TestDataPB"))
  expect_true(is(data_obj, "R6"))

  expect_true(is.function(data_obj[["get_dsname"]]))
  expect_true(is.function(data_obj[["get_scores"]]))
  expect_true(is.function(data_obj[["get_labels"]]))
  expect_true(is.function(data_obj[["get_fg"]]))
  expect_true(is.function(data_obj[["get_bg"]]))
  expect_true(is.function(data_obj[["get_fname"]]))
  expect_true(is.function(data_obj[["del_file"]]))
})

test_that("TestDataPB - get_datname", {
  data_obj1 <- TestDataPB$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_true(is.na(data_obj1$get_dsname()))

  data_obj2 <- TestDataPB$new(c(0.1, 0.2, 0.3), c(0, 1, 1), "m1")
  expect_equal(data_obj2$get_dsname(), "m1")
})

test_that("TestDataPB - get_scores", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_equal(data_obj$get_scores(), c(0.1, 0.2, 0.3))
})

test_that("TestDataPB - get_labels", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_equal(data_obj$get_labels(), c(0, 1, 1))
})

test_that("TestDataPB - get_fg", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  expect_equal(data_obj$get_fg(), c(0.2, 0.3))
})

test_that("TestDataPB - get_bg", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  expect_equal(data_obj$get_bg(), c(0.1, 0.4))
})

test_that("TestDataPB - get_fname", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  expect_true(file.exists(data_obj$get_fname()))
})

test_that("TestDataPB - del_file", {
  data_obj <- TestDataPB$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  fname <- data_obj$get_fname()

  data_obj$del_file()

  expect_true(!file.exists(fname))
  expect_true(is.na(data_obj$get_fname()))
})

test_that("TestDataEC - R6ClassGenerator", {
  expect_true(is(TestDataEC, "R6ClassGenerator"))
  expect_equal(attr(TestDataEC, "name"), "TestDataEC_generator")

  expect_true(is.function(TestDataEC$public_methods$set_basepoints_x))
  expect_true(is.function(TestDataEC$public_methods$set_basepoints_y))
  expect_true(is.function(TestDataEC$public_methods$get_basepoints_x))
  expect_true(is.function(TestDataEC$public_methods$get_basepoints_y))
  expect_true(is.function(TestDataEC$public_methods$set_textpos_x))
  expect_true(is.function(TestDataEC$public_methods$set_textpos_y))
  expect_true(is.function(TestDataEC$public_methods$get_textpos_x))
  expect_true(is.function(TestDataEC$public_methods$get_textpos_y))
})

test_that("TestDataEC - R6", {
  data_obj <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1))

  expect_true(is(data_obj, "TestDataEC"))
  expect_true(is(data_obj, "TestDataPB"))
  expect_true(is(data_obj, "R6"))

  expect_true(is.function(data_obj[["set_basepoints_x"]]))
  expect_true(is.function(data_obj[["set_basepoints_y"]]))
  expect_true(is.function(data_obj[["get_basepoints_x"]]))
  expect_true(is.function(data_obj[["get_basepoints_y"]]))
  expect_true(is.function(data_obj[["set_textpos_x"]]))
  expect_true(is.function(data_obj[["set_textpos_y"]]))
  expect_true(is.function(data_obj[["get_textpos_x"]]))
  expect_true(is.function(data_obj[["get_textpos_y"]]))
})

test_that("TestDataEC - get_datname", {
  data_obj1 <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_true(is.na(data_obj1$get_dsname()))

  data_obj2 <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1), "m1")
  expect_equal(data_obj2$get_dsname(), "m1")
})

test_that("TestDataEC - get_scores", {
  data_obj <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_equal(data_obj$get_scores(), c(0.1, 0.2, 0.3))
})

test_that("TestDataEC - basepoints", {
  data_obj <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  data_obj$set_basepoints_x(c(0, 0.5, 1))
  data_obj$set_basepoints_y(c(0, 0.4, 1))

  expect_equal(data_obj$get_basepoints_x(), c(0, 0.5, 1))
  expect_equal(data_obj$get_basepoints_y(), c(0, 0.4, 1))
})

test_that("TestDataEC - textpos", {
  data_obj <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  data_obj$set_textpos_x(c(0.3, 0.4))
  data_obj$set_textpos_y(c(0.8, 0.9))

  expect_equal(data_obj$get_textpos_x(), c(0.3, 0.4))
  expect_equal(data_obj$get_textpos_y(), c(0.8, 0.9))
})

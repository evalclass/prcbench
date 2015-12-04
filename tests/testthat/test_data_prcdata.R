library(prcbenchmark)

context("Data: PRCData")
# Test prcdata_generator
#      PRCData
#

test_that("prcdata_generator - R6ClassGenerator", {
  prcdata_cls <- prcdata_generator()

  expect_true(is(prcdata_cls, "R6ClassGenerator"))
  expect_equal(attr(prcdata_cls, "name"), "PRCData_generator")

  expect_true(is.function(prcdata_cls$public_methods$get_datname))
  expect_true(is.function(prcdata_cls$public_methods$get_scores))
  expect_true(is.function(prcdata_cls$public_methods$get_labels))
  expect_true(is.function(prcdata_cls$public_methods$get_fg))
  expect_true(is.function(prcdata_cls$public_methods$get_bg))
  expect_true(is.function(prcdata_cls$public_methods$get_fname))
  expect_true(is.function(prcdata_cls$public_methods$del_file))
})

test_that("prcdata_generator - R6", {
  prcdata_obj <- prcdata_generator()$new(c(0.1, 0.2, 0.3), c(0, 1, 1))

  expect_true(is(prcdata_obj, "PRCData"))
  expect_true(is(prcdata_obj, "R6"))

  expect_true(is.function(prcdata_obj[["get_datname"]]))
  expect_true(is.function(prcdata_obj[["get_scores"]]))
  expect_true(is.function(prcdata_obj[["get_labels"]]))
  expect_true(is.function(prcdata_obj[["get_fg"]]))
  expect_true(is.function(prcdata_obj[["get_bg"]]))
  expect_true(is.function(prcdata_obj[["get_fname"]]))
  expect_true(is.function(prcdata_obj[["del_file"]]))
})

test_that("PRCData - R6ClassGenerator", {
  expect_true(is(PRCData, "R6ClassGenerator"))
  expect_equal(attr(PRCData, "name"), "PRCData_generator")

  expect_true(is.function(PRCData$public_methods$get_datname))
  expect_true(is.function(PRCData$public_methods$get_scores))
  expect_true(is.function(PRCData$public_methods$get_labels))
  expect_true(is.function(PRCData$public_methods$get_fg))
  expect_true(is.function(PRCData$public_methods$get_bg))
  expect_true(is.function(PRCData$public_methods$get_fname))
  expect_true(is.function(PRCData$public_methods$del_file))
})

test_that("PRCData - R6", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3), c(0, 1, 1))

  expect_true(is(prcdata_obj, "PRCData"))
  expect_true(is(prcdata_obj, "R6"))

  expect_true(is.function(prcdata_obj[["get_datname"]]))
  expect_true(is.function(prcdata_obj[["get_scores"]]))
  expect_true(is.function(prcdata_obj[["get_labels"]]))
  expect_true(is.function(prcdata_obj[["get_fg"]]))
  expect_true(is.function(prcdata_obj[["get_bg"]]))
  expect_true(is.function(prcdata_obj[["get_fname"]]))
  expect_true(is.function(prcdata_obj[["del_file"]]))
})

test_that("PRCData - get_datname", {
  prcdata_obj1 <- PRCData$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_true(is.na(prcdata_obj1$get_datname()))

  prcdata_obj2 <- PRCData$new(c(0.1, 0.2, 0.3), c(0, 1, 1), "m1")
  expect_equal(prcdata_obj2$get_datname(), "m1")
})

test_that("PRCData - get_scores", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_equal(prcdata_obj$get_scores(), c(0.1, 0.2, 0.3))
})

test_that("PRCData - get_labels", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3), c(0, 1, 1))
  expect_equal(prcdata_obj$get_labels(), c(0, 1, 1))
})

test_that("PRCData - get_fg", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  expect_equal(prcdata_obj$get_fg(), c(0.2, 0.3))
})

test_that("PRCData - get_bg", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  expect_equal(prcdata_obj$get_bg(), c(0.1, 0.4))
})

test_that("PRCData - get_fname", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  expect_true(file.exists(prcdata_obj$get_fname()))
})

test_that("PRCData - del_file", {
  prcdata_obj <- PRCData$new(c(0.1, 0.2, 0.3, 0.4), c(0, 1, 1, 0))
  fname <- prcdata_obj$get_fname()

  prcdata_obj$del_file()

  expect_true(!file.exists(fname))
  expect_true(is.na(prcdata_obj$get_fname()))
})


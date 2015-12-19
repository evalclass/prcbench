library(prcbenchmark)

context("Data: Sample datasets")
# Test create_sample
#      .create_rnd_sample(np, pfunc, nn, nfunc)
#

test_that("create_sample: b100", {
  samp <- create_sample("b100")
  scores <- samp$get_scores()
  expect_equal(length(scores), 100)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 50)
  expect_equal(length(labels[labels != 1]), 50)
})

test_that("create_sample: b10k", {
  samp <- create_sample("b10k")
  scores <- samp$get_scores()
  expect_equal(length(scores), 10000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 5000)
  expect_equal(length(labels[labels != 1]), 5000)
})

test_that("create_sample: b100k", {
  samp <- create_sample("b100k")
  scores <- samp$get_scores()
  expect_equal(length(scores), 100000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 50000)
  expect_equal(length(labels[labels != 1]), 50000)
})

test_that("create_sample: ib100", {
  samp <- create_sample("ib100")
  scores <- samp$get_scores()
  expect_equal(length(scores), 100)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 25)
  expect_equal(length(labels[labels != 1]), 75)
})

test_that("create_sample: ib10k", {
  samp <- create_sample("ib10k")
  scores <- samp$get_scores()
  expect_equal(length(scores), 10000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 2500)
  expect_equal(length(labels[labels != 1]), 7500)
})

test_that("create_sample: ib100k", {
  samp <- create_sample("ib100k")
  scores <- samp$get_scores()
  expect_equal(length(scores), 100000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 25000)
  expect_equal(length(labels[labels != 1]), 75000)
})

test_that(".create_rnd_sample", {
  samp1 <- .create_rnd_sample()

  expect_true(is(samp1, "PRCData"))
  expect_true(is(samp1, "R6"))

  scores <- samp1$get_scores()
  expect_equal(length(scores), 20)

  labels <- samp1$get_labels()
  expect_equal(length(labels[labels == 1]), 10)
  expect_equal(length(labels[labels != 1]), 10)
})

test_that(".create_rnd_sample: np and nn", {
  samp1 <- .create_rnd_sample(np = 100, nn = 1000)

  scores <- samp1$get_scores()
  expect_equal(length(scores), 1100)

  labels <- samp1$get_labels()
  expect_equal(length(labels[labels == 1]), 100)
  expect_equal(length(labels[labels != 1]), 1000)
})

test_that(".create_rnd_sample: pfunc and ", {
  rfunc1 <- function(n) {
    runif(n, 2, 3)
  }
  samp1 <- .create_rnd_sample(pfunc = rfunc1, nfunc = rfunc1)
  scores1 <- samp1$get_scores()
  expect_true(all(scores1 >= 2))
  expect_true(all(scores1 <= 3))

  rfunc2 <- function(n) {
    runif(n, 20, 30)
  }
  samp2 <- .create_rnd_sample(pfunc = rfunc2, nfunc = rfunc2)
  scores2 <- samp2$get_scores()
  expect_true(all(scores2 >= 20))
  expect_true(all(scores2 <= 30))

  samp3 <- .create_rnd_sample(pfunc = rfunc1, nfunc = rfunc2)
  scores3 <- samp3$get_scores()
  labels3 <- samp3$get_labels()
  scores3p <- scores3[labels3 == 1]
  scores3n <- scores3[labels3 != 1]

  expect_true(all(scores3p >= 2))
  expect_true(all(scores3p <= 3))
  expect_true(all(scores3n >= 20))
  expect_true(all(scores3n <= 30))
})

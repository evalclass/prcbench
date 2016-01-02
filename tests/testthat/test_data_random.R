context("Data: Random samples")
# Test create_testset
#      .create_rsample(sname, np, pfunc, nn, nfunc)
#

test_that("create_testset: b100", {
  samp <- create_testset("random", "b100")[[1]]
  scores <- samp$get_scores()
  expect_equal(length(scores), 100)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 50)
  expect_equal(length(labels[labels != 1]), 50)
})

test_that("create_testset: b10k", {
  samp <- create_testset("random", "b10k")[[1]]
  scores <- samp$get_scores()
  expect_equal(length(scores), 10000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 5000)
  expect_equal(length(labels[labels != 1]), 5000)
})

test_that("create_testset: b1m", {
  samp <- create_testset("random", "b1m")[[1]]
  scores <- samp$get_scores()
  expect_equal(length(scores), 1000000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 500000)
  expect_equal(length(labels[labels != 1]), 500000)
})

test_that("create_testset: i100", {
  samp <- create_testset("random", "i100")[[1]]
  scores <- samp$get_scores()
  expect_equal(length(scores), 100)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 25)
  expect_equal(length(labels[labels != 1]), 75)
})

test_that("create_testset: i10k", {
  samp <- create_testset("random", "i10k")[[1]]
  scores <- samp$get_scores()
  expect_equal(length(scores), 10000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 2500)
  expect_equal(length(labels[labels != 1]), 7500)
})

test_that("create_testset: i1m", {
  samp <- create_testset("random", "i1m")[[1]]
  scores <- samp$get_scores()
  expect_equal(length(scores), 1000000)

  labels <- samp$get_labels()
  expect_equal(length(labels[labels == 1]), 250000)
  expect_equal(length(labels[labels != 1]), 750000)
})

test_that(".create_rsample", {
  samp1 <- .create_rsample()

  expect_true(is(samp1, "TestDataPB"))
  expect_true(is(samp1, "R6"))

  scores <- samp1$get_scores()
  expect_equal(length(scores), 20)

  labels <- samp1$get_labels()
  expect_equal(length(labels[labels == 1]), 10)
  expect_equal(length(labels[labels != 1]), 10)
})

test_that(".create_rsample: np and nn", {
  samp1 <- .create_rsample(np = 100, nn = 1000)

  scores <- samp1$get_scores()
  expect_equal(length(scores), 1100)

  labels <- samp1$get_labels()
  expect_equal(length(labels[labels == 1]), 100)
  expect_equal(length(labels[labels != 1]), 1000)
})

test_that(".create_rsample: pfunc and nfunc", {
  rfunc1 <- function(n) {
    runif(n, 2, 3)
  }
  samp1 <- .create_rsample(pfunc = rfunc1, nfunc = rfunc1)
  scores1 <- samp1$get_scores()
  expect_true(all(scores1 >= 2))
  expect_true(all(scores1 <= 3))

  rfunc2 <- function(n) {
    runif(n, 20, 30)
  }
  samp2 <- .create_rsample(pfunc = rfunc2, nfunc = rfunc2)
  scores2 <- samp2$get_scores()
  expect_true(all(scores2 >= 20))
  expect_true(all(scores2 <= 30))

  samp3 <- .create_rsample(pfunc = rfunc1, nfunc = rfunc2)
  scores3 <- samp3$get_scores()
  labels3 <- samp3$get_labels()
  scores3p <- scores3[labels3 == 1]
  scores3n <- scores3[labels3 != 1]

  expect_true(all(scores3p >= 2))
  expect_true(all(scores3p <= 3))
  expect_true(all(scores3n >= 20))
  expect_true(all(scores3n <= 30))
})

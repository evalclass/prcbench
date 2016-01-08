library(microbenchmark)

context("Main: Benchmark")
# Test run_benchmark
#

test_that("run_benchmark", {
  testset <- create_testset("bench", c("b10", "i10"))
  toolset <- create_toolset(set_names = c("crv5", "auc5"))
  res1 <- run_benchmark(testset, toolset, times = 2)[["tab"]]

  num_tools <- 5
  num_toolsets <- 2
  num_datasets <- 2
  expect_equal(nrow(res1), num_tools * num_toolsets * num_datasets)
  expect_equal(length(unique(res1$toolname)), num_tools)
  expect_equal(length(unique(res1$testset)), num_datasets)
  expect_equal(length(unique(res1$toolset)), num_toolsets)
  expect_true(all(res1$neval == 2))
})

test_that("run_benchmark: testset", {
  testset <- create_testset("bench", c("b10", "i10"))
  toolset <- create_toolset(set_names = c("crv5", "auc5"))

  expect_that(run_benchmark(testset, toolset), not(throws_error()))

  expect_error(run_benchmark(1, toolset), "testset is not a list")
  expect_error(run_benchmark("1", toolset), "testset is not a list")
  expect_error(run_benchmark(list(), toolset), "not greater than 0")
  expect_error(run_benchmark(toolset, toolset), "Invalid testset")
})

test_that("run_benchmark: toolset", {
  testset <- create_testset("bench", c("b10", "i10"))
  toolset <- create_toolset(set_names = c("crv5", "auc5"))

  expect_that(run_benchmark(testset, toolset), not(throws_error()))

  expect_error(run_benchmark(testset, 1), "toolset is not a list")
  expect_error(run_benchmark(testset, "1"), "toolset is not a list")
  expect_error(run_benchmark(testset, list()), "not greater than 0")
  expect_error(run_benchmark(testset, testset), "Invalid toolset")
})

test_that("run_benchmark: times", {
  testset <- create_testset("bench", "b10")
  toolset <- create_toolset(set_names = "def5")

  res <- run_benchmark(testset, toolset, times = 1)[["tab"]]
  expect_true(all(res$neval == 1))

  expect_error(run_benchmark(testset, toolset, times = 0),
               "times not greater than 0")
  expect_error(run_benchmark(testset, toolset, times = "1"),
               "times is not a number")
})

test_that("run_benchmark: unit", {
  testset <- create_testset("bench", "b10")
  toolset <- create_toolset(set_names = "def5")

  expect_that(run_benchmark(testset, toolset, unit = "ns"), not(throws_error()))
  expect_that(run_benchmark(testset, toolset, unit = "us"), not(throws_error()))
  expect_that(run_benchmark(testset, toolset, unit = "ms"), not(throws_error()))
  expect_that(run_benchmark(testset, toolset, unit = "s"), not(throws_error()))
  expect_that(run_benchmark(testset, toolset, unit = "eps"),
              not(throws_error()))
  expect_that(run_benchmark(testset, toolset, unit = "relative"),
              not(throws_error()))

  expect_error(run_benchmark(testset, toolset, unit = "ss"),
               "is not TRUE")
  expect_error(run_benchmark(testset, toolset, unit = 1),
               "unit is not a string")
})
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

test_that("run_benchmark: times", {
  testset <- create_testset("bench", "b10")
  toolset <- create_toolset(set_names = "def5")

  res <- run_benchmark(testset, toolset, times = 1)[["tab"]]

  expect_true(all(res$neval == 1))
})
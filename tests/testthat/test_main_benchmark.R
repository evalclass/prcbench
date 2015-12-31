library(microbenchmark)

context("Main: Benchmark")
# Test run_benchmark
#

test_that("run_benchmark", {
  tdat <- create_testdata("random", c("b10", "i10"))
  tools <- create_tools(set_names = c("crv5", "auc5"))
  res1 <- run_benchmark(tdat, tools, times = 2)

  num_tools <- 5
  num_toolsets <- 2
  num_datasets <- 2
  expect_equal(nrow(res1), num_tools * num_toolsets * num_datasets)
  expect_equal(length(unique(res1$toolname)), num_tools)
  expect_equal(length(unique(res1$dsname)), num_datasets)
  expect_equal(length(unique(res1$toolset)), num_toolsets)
  expect_true(all(res1$neval == 2))
})

test_that("run_benchmark: times", {
  tdat <- create_testdata("random", "b10")
  tools <- create_tools(set_names = "both5")

  res <- run_benchmark(tdat, tools, times = 1)

  expect_true(all(res$neval == 1))
})
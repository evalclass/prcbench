library(prcbenchmark)

context("Benchmark")
# Test run_benchmark(sdat, tool_funcs, times, unit)
#      benchmark_sets
#

test_that("benchmark_sets", {
  sampsets <- c("b100", "ib100")
  toolsets <- c("crv", "auc", "both")
  res1 <- benchmark_sets(sampsets, toolsets)

  num_tools <- 5
  expect_equal(nrow(res1), num_tools * length(sampsets) * length(toolsets))
  expect_equal(length(unique(res1$tool)), num_tools)
  expect_equal(length(unique(res1$sampset)), length(sampsets))
  expect_equal(length(unique(res1$toolset)), length(toolsets))
  expect_true(all(res1$neval == 5))

  res2 <- benchmark_sets(sampsets, toolsets, times = 1)
  expect_true(all(res2$neval == 1))
})


test_that("run_benchmark", {
  samp1 <- .create_rnd_sample()
  toolset1 <- create_tools("crv")
  res1 <- run_benchmark(samp1, toolset1)

  expect_equal(names(toolset1), res1$tool)
  expect_true(all(toolset1$neval == 5))
})

test_that("run_benchmark: times", {
  samp1 <- .create_rnd_sample()
  toolset1 <- create_tools("crv")
  res1 <- run_benchmark(samp1, toolset1, times = 1)

  expect_true(all(toolset1$neval == 1))
})

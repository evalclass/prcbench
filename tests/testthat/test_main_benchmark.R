library(prcbench)

context("Main: Benchmark")
# Test .benchmark_wrapper(testdata, tool_funcs, times, unit)
#      run_benchmark
#

test_that("run_benchmark", {
  tdat <- create_samplesets(c("b100", "ib100"))
  tools <- create_tools(c("crv5", "auc5", "both5"))
  res1 <- run_benchmark(tdat, tools, times = 2)

  num_tools <- 5
  expect_equal(nrow(res1), num_tools * length(tdat) * length(tools))
  expect_equal(length(unique(res1$tool)), num_tools)
  expect_equal(length(unique(res1$sampset)), length(tdat))
  expect_equal(length(unique(res1$toolset)), length(tools))
  expect_true(all(res1$neval == 2))

  res2 <- run_benchmark(tdat, tools, times = 1)
  expect_true(all(res2$neval == 1))
})


test_that(".benchmark_wrapper", {
  samp1 <- .create_rnd_sample()
  toolset1 <- create_tools("crv5")
  res1 <- .benchmark_wrapper(samp1, toolset1[[1]], times = 2)

  expect_equal(names(toolset1[[1]]), res1$tool)
  expect_true(all(toolset1$neval == 2))
})

test_that(".benchmark_wrapper: times", {
  samp1 <- .create_rnd_sample()
  toolset1 <- create_tools("crv5")
  res1 <- .benchmark_wrapper(samp1, toolset1[[1]], times = 1)

  expect_true(all(toolset1$neval == 1))
})

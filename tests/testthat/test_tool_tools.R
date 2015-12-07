library(prcbenchmark)

context("Tool: Create wrapper objects")
# Test create_toolset
#      .rename_tool_names
#      create_tools
#

test_that("create_toolset: set1", {
  toolset1 <- create_toolset("set1")
  expect_equal(length(toolset1), 5)
  for (i in 1:5) {
    expect_equal(class(toolset1[[i]]), "function")
    expect_true(formals(toolset1[[i]])$retval)
    expect_true(!formals(toolset1[[i]])$auc)
  }

  expect_equal(is(environment(toolset1[[1]])$obj), "ToolROCR")
  expect_equal(is(environment(toolset1[[2]])$obj), "ToolAUCCalculator")
  expect_equal(is(environment(toolset1[[3]])$obj), "ToolPerfMeas")
  expect_equal(is(environment(toolset1[[4]])$obj), "ToolPRROC")
  expect_equal(is(environment(toolset1[[5]])$obj), "Toolprecrec")

})

test_that("create_toolset: set2", {
  toolset2 <- create_toolset("set2")
  expect_equal(length(toolset2), 5)
  for (i in 1:5) {
    expect_equal(class(toolset2[[i]]), "function")
    expect_true(!formals(toolset2[[i]])$retval)
    expect_true(formals(toolset2[[i]])$auc)
  }

  expect_equal(is(environment(toolset2[[1]])$obj), "ToolROCR")
  expect_equal(is(environment(toolset2[[2]])$obj), "ToolAUCCalculator")
  expect_equal(is(environment(toolset2[[3]])$obj), "ToolPerfMeas")
  expect_equal(is(environment(toolset2[[4]])$obj), "ToolPRROC")
  expect_equal(is(environment(toolset2[[5]])$obj), "Toolprecrec")

  expect_true(!environment(environment(toolset2[[4]])$obj$clone)$private$curve)
})

test_that("create_toolset: set3", {
  toolset3 <- create_toolset("set3")
  expect_equal(length(toolset3), 5)
  for (i in 1:5) {
    expect_equal(class(toolset3[[i]]), "function")
    expect_true(formals(toolset3[[i]])$retval)
    expect_true(formals(toolset3[[i]])$auc)
  }

  expect_equal(is(environment(toolset3[[1]])$obj), "ToolROCR")
  expect_equal(is(environment(toolset3[[2]])$obj), "ToolAUCCalculator")
  expect_equal(is(environment(toolset3[[3]])$obj), "ToolPerfMeas")
  expect_equal(is(environment(toolset3[[4]])$obj), "ToolPRROC")
  expect_equal(is(environment(toolset3[[5]])$obj), "Toolprecrec")

})

test_that(".rename_tool_names", {
  renamed1 <- .rename_tool_names(c("1", "2", "3", "4"))
  expect_equal(renamed1, c("1", "2", "3", "4"))

  renamed2 <- .rename_tool_names(c("1", "2", "1", "4"))
  expect_equal(renamed2, c("1", "2", "1.2", "4"))

  renamed3 <- .rename_tool_names(c("1", "2", "1", "1"))
  expect_equal(renamed3, c("1", "2", "1.2", "1.3"))

  renamed4 <- .rename_tool_names(c("1", "2", "1", "2"))
  expect_equal(renamed4, c("1", "2", "1.2", "2.2"))
})

test_that("create_tools", {
  tools1 <- create_tools()
  expect_equal(length(tools1), 5)

  tool1 <- create_tools("ROCR")
  expect_true(is(tool1[[1]], "ToolROCR"))

  tool2 <- create_tools("AUCCalculator")
  expect_true(is(tool2[[1]], "ToolAUCCalculator"))

  tool3 <- create_tools("PerfMeas")
  expect_true(is(tool3[[1]], "ToolPerfMeas"))

  tool4 <- create_tools("PRROC")
  expect_true(is(tool4[[1]], "ToolPRROC"))

  tool5 <- create_tools("precrec")
  expect_true(is(tool5[[1]], "Toolprecrec"))
})

test_that("Duplicated names", {
  tool1 <- create_tools(c("ROCR", "PRROC", "PerfMeas", "precrec"))
  expect_equal(names(tool1), c("ROCR", "PRROC", "PerfMeas", "precrec"))

  tool2 <- create_tools(c("ROCR", "PRROC", "ROCR", "precrec"))
  expect_equal(names(tool2), c("ROCR", "PRROC", "ROCR.2", "precrec"))

  tool3 <- create_tools(c("ROCR", "PRROC", "ROCR", "PRROC"))
  expect_equal(names(tool3), c("ROCR", "PRROC", "ROCR.2", "PRROC.2"))

  tool4 <- create_tools(c("ROCR", "PRROC", "ROCR", "ROCR"))
  expect_equal(names(tool4), c("ROCR", "PRROC", "ROCR.2", "ROCR.3"))

})

test_that("Extra param - AUCCalculator$new(type)", {
  tool1 <- create_tools("AUCCalculator")
  expect_equal(environment(tool1[[1]]$clone)$private$type, "syscall")

  tool2 <- create_tools("AUCCalculator", list(list(type = "rjava")))
  expect_equal(environment(tool2[[1]]$clone)$private$type, "rjava")

  tool3 <- create_tools(c("AUCCalculator", "AUCCalculator"),
                        list(list(), list(type = "rjava")))
  expect_equal(environment(tool3[[1]]$clone)$private$type, "syscall")
  expect_equal(environment(tool3[[2]]$clone)$private$type, "rjava")
  expect_equal(names(tool3), c("AUCCalculator", "AUCCalculator.2"))

})

test_that("Extra param - AUCCalculator$new(fpath)", {
  tool1 <- create_tools("AUCCalculator")
  expect_true(is.null(environment(tool1[[1]]$clone)$private$fpath))

  fpath <- system.file("java", "auc.jar", package = "prcbenchmark")
  tool2 <- create_tools("AUCCalculator", list(list(fpath = fpath)))
  expect_equal(environment(tool2[[1]]$clone)$private$fpath, fpath)

  tool3 <- create_tools(c("AUCCalculator", "AUCCalculator"),
                        list(list(), list(fpath = fpath)))
  expect_true(is.null(environment(tool3[[1]]$clone)$private$fpath))
  expect_equal(environment(tool3[[2]]$clone)$private$fpath, fpath)
  expect_equal(names(tool3), c("AUCCalculator", "AUCCalculator.2"))
})

test_that("Extra param - PRROC$new(curve)", {
  tool1 <- create_tools("PRROC")
  expect_equal(environment(tool1[[1]]$clone)$private$curve, TRUE)

  tool2 <- create_tools("PRROC", list(list(curve = FALSE)))
  expect_equal(environment(tool2[[1]]$clone)$private$curve, FALSE)

  tool3 <- create_tools(c("PRROC", "PRROC"),
                        list(list(), list(curve = FALSE)))
  expect_equal(environment(tool3[[1]]$clone)$private$curve, TRUE)
  expect_equal(environment(tool3[[2]]$clone)$private$curve, FALSE)
  expect_equal(names(tool3), c("PRROC", "PRROC.2"))

})

test_that("Extra param - PRROC$new(minStepSize)", {
  tool1 <- create_tools("PRROC")
  expect_equal(environment(tool1[[1]]$clone)$private$minStepSize, 0.01)

  tool2 <- create_tools("PRROC", list(list(minStepSize = 0.05)))
  expect_equal(environment(tool2[[1]]$clone)$private$minStepSize, 0.05)

  tool3 <- create_tools(c("PRROC", "PRROC"),
                        list(list(), list(minStepSize = 0.05)))
  expect_equal(environment(tool3[[1]]$clone)$private$minStepSize, 0.01)
  expect_equal(environment(tool3[[2]]$clone)$private$minStepSize, 0.05)
  expect_equal(names(tool3), c("PRROC", "PRROC.2"))

})


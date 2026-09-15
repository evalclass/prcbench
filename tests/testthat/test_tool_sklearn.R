context("Tool: sklearn")
# Test Toolsklearn
#      create_toolset
#

test_that("Toolsklearn - R6ClassGenerator", {
  expect_true(is(Toolsklearn, "R6ClassGenerator"))
  expect_equal(attr(Toolsklearn, "name"), "Toolsklearn_generator")

  expect_true(is.function(Toolsklearn$public_methods$set_drop_intermediate))
  expect_true(is.function(Toolsklearn$public_methods$set_aucType))

  expect_equal(grep(
    ".sklearn_wrapper",
    body(Toolsklearn$private_methods$f_wrapper)
  )[[1]], 2)
})

test_that("Toolsklearn - R6", {
  toolset <- Toolsklearn$new()

  expect_true(is(toolset, "Toolsklearn"))
  expect_true(is(toolset, "ToolIFBase"))
  expect_equal(toolset$get_toolname(), "sklearn")
})

test_that("Toolsklearn - default parameters", {
  toolset <- Toolsklearn$new()

  expect_equal(toolset$.__enclos_env__$private$drop_intermediate, FALSE)
  expect_equal(toolset$.__enclos_env__$private$aucType, 1)
})

test_that("Toolsklearn - set parameters", {
  toolset <- Toolsklearn$new(drop_intermediate = TRUE, aucType = 2)

  expect_equal(toolset$.__enclos_env__$private$drop_intermediate, TRUE)
  expect_equal(toolset$.__enclos_env__$private$aucType, 2)

  toolset$set_drop_intermediate(FALSE)
  toolset$set_aucType(1)

  expect_equal(toolset$.__enclos_env__$private$drop_intermediate, FALSE)
  expect_equal(toolset$.__enclos_env__$private$aucType, 1)
})

test_that("create_toolset - sklearn", {
  toolset <- create_toolset("sklearn")

  expect_equal(length(toolset), 1)
  expect_true(is(toolset[[1]], "Toolsklearn"))
  expect_equal(toolset[[1]]$get_toolname(), "sklearn")
})

test_that("create_toolset - sklearn is not in the predefined sets", {
  snames <- c(
    "def6", "auc6", "crv6", "def5", "auc5", "crv5", "def4", "auc4", "crv4"
  )
  for (sname in snames) {
    toolset <- create_toolset(set_names = sname)
    tnames <- sapply(toolset, function(x) x$get_toolname())
    expect_false("sklearn" %in% tnames)
  }
})

test_that("Toolsklearn - curve values", {
  skip_if_no_sklearn_py()

  testset <- create_testset("curve", "c1")
  toolset <- create_toolset("sklearn")
  toolset[[1]]$call(testset[[1]])

  x <- toolset[[1]]$get_x()
  y <- toolset[[1]]$get_y()

  # scikit-learn appends a synthetic (recall = 0, precision = 1) point and
  # returns recall in decreasing order; the wrapper reverses it so that the
  # curve starts at the lowest recall as the other tools do.
  expect_equal(x[1], 0)
  expect_equal(y[1], 1)
  expect_equal(x[length(x)], 1)
  expect_true(all(diff(x) >= 0))
  expect_true(all(x >= 0 & x <= 1))
  expect_true(all(y >= 0 & y <= 1))
})

# create_testset("bench", ...) samples scores at random, so the tests below use
# a fixed dataset to stay deterministic.
.sklearn_testdata <- function() {
  scores <- c(0.9, 0.85, 0.8, 0.7, 0.6, 0.55, 0.4, 0.3, 0.2, 0.1)
  labels <- c(1, 0, 1, 1, 0, 1, 0, 1, 0, 0)
  create_usrdata("bench", scores = scores, labels = labels, tsname = "skl")
}

test_that("Toolsklearn - AUC types", {
  skip_if_no_sklearn_py()

  testset <- .sklearn_testdata()

  tool1 <- Toolsklearn$new(aucType = 1, calc_auc = TRUE)
  tool1$call(testset[[1]])
  auc1 <- tool1$get_auc()

  tool2 <- Toolsklearn$new(aucType = 2, calc_auc = TRUE)
  tool2$call(testset[[1]])
  auc2 <- tool2$get_auc()

  expect_true(is.numeric(auc1))
  expect_true(is.numeric(auc2))
  expect_true(auc1 >= 0 && auc1 <= 1)
  expect_true(auc2 >= 0 && auc2 <= 1)

  # Average precision and the trapezoidal rule disagree on the same curve
  expect_false(isTRUE(all.equal(auc1, auc2)))

  # aucType = 2 is the trapezoidal area of the returned curve
  expect_equal(
    auc2,
    sum(diff(tool2$get_x()) *
      (utils::head(tool2$get_y(), -1) + utils::tail(tool2$get_y(), -1)) / 2)
  )
})

test_that("Toolsklearn - store_res and calc_auc", {
  skip_if_no_sklearn_py()

  testset <- .sklearn_testdata()

  tool <- Toolsklearn$new(calc_auc = FALSE, store_res = TRUE)
  tool$call(testset[[1]])
  expect_true(is.na(tool$get_auc()))
  expect_true(length(tool$get_x()) > 0)

  # As with every other tool, the wrapper returns NULL when store_res is
  # FALSE, so the AUC score is not retrieved even when calc_auc is TRUE.
  tool2 <- Toolsklearn$new(calc_auc = TRUE, store_res = FALSE)
  tool2$call(testset[[1]])
  expect_true(is.na(tool2$get_auc()))
})

test_that("Toolsklearn - drop_intermediate reduces the number of points", {
  skip_if_no_sklearn_py()

  testset <- .sklearn_testdata()

  tool1 <- Toolsklearn$new(drop_intermediate = FALSE)
  tool1$call(testset[[1]])

  tool2 <- Toolsklearn$new(drop_intermediate = TRUE)
  tool2$call(testset[[1]])

  expect_true(length(tool2$get_x()) <= length(tool1$get_x()))
})

test_that("Toolsklearn - run_evalcurve", {
  skip_if_no_sklearn_py()

  res <- run_evalcurve(
    create_testset("curve", "c1"),
    create_toolset("sklearn")
  )

  expect_true(is(res, "evalcurve"))
  expect_true("sklearn" %in% res[["testsum"]][["toolname"]])
  expect_true("sklearn" %in% res[["testscores"]][["toolname"]])
})

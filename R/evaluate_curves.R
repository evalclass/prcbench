#' Evaluate a Precision-Recall curves with a specified test set
#'
#' The \code{eval_curves_singleset} function validate a Precision-Recall curve
#'    with for a specified test dataset.
#'
#' @param testdata_names A character vector to specify the names of test data
#'     sets.
#'
#' @param tool_names A character vector to specify the names of tool sets for
#'     \code{\link{create_tools}}.
#'
#' @return A data frame with validation results.
#'
#' @examples
#' ## Check Precision-Recall cuvers of a tool set "crv" on a test dataset "r1"
#' res1 <- eval_curves("r1", "crv")
#'
#' @export
eval_curves <- function(testdata_names = c("r1", "r2", "r3"),
                        tool_names = "crv") {

  new_testdata_names <- rep(testdata_names, length(tool_names))
  new_tool_names <- rep(tool_names, each = length(testdata_names))

  vfunc <- function(i) {
    vres <- .eval_curves_singleset(new_testdata_names[i], new_tool_names[i])
    vres$testdata <- new_testdata_names[i]
    vres$toolset <- new_tool_names[i]
    vres
  }
  eval_res <- do.call(rbind, lapply(seq_along(new_testdata_names), vfunc))

  sum_res <- .summarize_eval_result(eval_res, new_testdata_names, tool_names)

  # === Create an S3 object ===
  s3obj <- structure(sum_res, class = "evalcurve")
}

#
# Validate a Precsion-Recall curve
#
.eval_curves_singleset <- function(testdat_name = "r1", tool_name = "crv") {
  testdat <- .get_testdat(testdat_name)
  sdata <- PRCData$new(testdat$scores, testdat$labels)

  tools <- create_tools(tool_name)
  res <- lapply(tools, function(t) {t(sdata)})

  test_res <- list()
  test_res[["x_range"]] <- do.call(rbind, lapply(res, .eval_x_range))
  test_res[["y_range"]] <- do.call(rbind, lapply(res, .eval_y_range))

  tres <- lapply(res, function(x) {.eval_fpoint(testdat, x)})
  test_res[["fpoint"]] <- do.call(rbind, tres)

  tres <- lapply(res, function(x) {.eval_int_pts(testdat, x)})
  test_res[["int_pts"]] <- do.call(rbind, tres)

  tres <- lapply(res, function(x) {.eval_epoint(testdat, x)})
  test_res[["epoint"]] <- do.call(rbind, tres)

  sfunc <- function(vname) {
    tnames <- rownames(test_res[[vname]])
    rownames(test_res[[vname]]) <- NULL
    df <- as.data.frame(test_res[[vname]])
    df <- cbind(data.frame(test = vname, tool = tnames),
                as.data.frame(test_res[[vname]]))
  }
  do.call(rbind, lapply(names(test_res), sfunc))
}

#
# Get a predefinded test dataset
#
.get_testdat <- function(testdat_name) {
  if (testdat_name == "r1") {
    prcbenchmark::M1DATA
  } else if (testdat_name == "r2") {
    prcbenchmark::M2DATA
  } else if (testdat_name == "r3") {
    prcbenchmark::M3DATA
  } else {
    stop("Ivalid dataset name")
  }
}

#
# Check the x value range of a Precision-Recall curve
#
.eval_x_range <- function(res) {
  score <- 0

  # Test 1
  if (all(res$get_x() >= 0, na.rm = T)) {
    score <- score + 1
  }

  # Test 2
  if (all(res$get_x() <= 1, na.rm = T)) {
    score <- score + 1
  }

  scores <- c(score, 2)
  names(scores) <-  c("success", "total")
  scores
}

#
# Check the y value range of a Precision-Recall curve
#
.eval_y_range <- function(res) {
  score <- 0

  # Test 1
  if (all(res$get_y() >= 0, na.rm = T)) {
    score <- score + 1
  }

  # Test 2
  if (all(res$get_y() <= 1, na.rm = T)) {
    score <- score + 1
  }

  scores <- c(score, 2)
  names(scores) <-  c("success", "total")
  scores
}

#
# Check intermediate points of a Precisoin-Recall curve
#
.eval_int_pts <- function(testdat, res, tolerance = 1e-4) {
  score <- 0

  efunc <- function(i) {
    xidx <- abs(res$get_x() - testdat$bp_x[i]) < tolerance
    ys <- res$get_y()[xidx]

    if (any(abs(ys - testdat$bp_y[i]) < tolerance, na.rm = T)) {
      return(1)
    } else {
      return(0)
    }
  }

  evalsss <- lapply(2:(length(testdat$bp_x) - 1), efunc)
  score <- do.call(sum, evalsss)
  scores <- c(score, length(testdat$bp_x) - 2)
  names(scores) <-  c("success", "total")
  scores
}

#
# Check the first point of a Precisoin-Recall curve
#
.eval_fpoint <- function(testdat, res, tolerance = 1e-4) {
  if (!is.na(res$get_x()[1]) && !is.na(res$get_y()[1])
        && (abs(res$get_x()[1] - testdat$bp_x[1]) < tolerance)
        && (abs(res$get_y()[1] - testdat$bp_y[1]) < tolerance)) {
    score <- 1
  } else {
    score <- 0
  }

  scores <- c(score, 1)
  names(scores) <-  c("success", "total")
  scores
}

#
# Check the end point of a Precisoin-Recall curve
#
.eval_epoint <- function(testdat, res, tolerance = 1e-4) {
  epos1 <- length(res$get_x())
  epos2 <- length(testdat$bp_x)

  if (!is.na(res$get_x()[epos1]) && !is.na(res$get_y()[epos1])
      && (abs(res$get_x()[epos1] - testdat$bp_x[epos2]) < tolerance)
      && (abs(res$get_y()[epos1] - testdat$bp_y[epos2]) < tolerance)) {
    score <- 1
  } else {
    score <- 0
  }

  scores <- c(score, 1)
  names(scores) <-  c("success", "total")
  scores
}

#
# Summarize evaluation results
#
.summarize_eval_result <- function(eval_res, testdata_names, tool_names) {

  testdata <- lapply(testdata_names, .get_testdat)
  names(testdata) <- testdata_names
  tools <- create_tools(tool_names)

  points <- .create_points(testdata, testdata_names)
  curves <- .create_curves(tools, testdata, testdata_names)
  scores <- .summarize_scores(eval_res, testdata, testdata_names)

  list(points = points, curves = curves, scores = scores)
}

#
# Get points from test datasets
#
.create_points <- function(testdata, testdata_names) {
  pfunc <- function(i) {
    ds <- data.frame(x = testdata[[i]]$bp_x, y = testdata[[i]]$bp_y)
    ds$testdata <- testdata_names[i]
    ds
  }
  pointsets <- do.call(rbind, lapply(seq_along(testdata), pfunc))
  pointsets$testdata <- factor(pointsets$testdata)
  pointsets
}

#
# Create curves by specified tools for test datasets
#
.create_curves <- function(tools, testdata, testdata_names) {
  cfunc <- function(i) {
    prcdata <- PRCData$new(testdata[[i]]$scores, testdata[[i]]$labels,
                           testdata_names[i])
    tres <- lapply(tools, function(t) t(prcdata))
    sfunc <- function(tname) {
      tdf <- data.frame(x = tres[[tname]]$get_x(), y = tres[[tname]]$get_y())
      tdf$modname <- tname
      tdf
    }
    df <- do.call(rbind, lapply(names(tools), sfunc))
    df$testdata <- testdata_names[i]
    df
  }
  curves <- do.call(rbind, lapply(seq_along(testdata), cfunc))
  curves$modname <- factor(curves$modname)
  curves$testdata <- factor(curves$testdata)
  curves
}

#
# Summrize curve evaluation results
#
.summarize_scores <- function(eval_res, testdata, testdata_names) {
  scores <- aggregate(eval_res[,c('success', 'total')],
                      by = list(eval_res$tool, eval_res$testdata,
                                eval_res$toolset),
                      FUN = sum, na.rm = TRUE)
  colnames(scores)[1:3] <- c("tool", "testdata", "toolset")
  scores$label <- factor(paste0(scores$success, "/", scores$total))
  scores$x <- 0
  scores$y <- 0
  for (tname in testdata_names) {
    scores[scores$testdata == tname, "x"] <- testdata[[tname]]$tp_x
    scores[scores$testdata == tname, "y"] <- testdata[[tname]]$tp_y
  }

  scores
}

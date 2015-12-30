#' Create a set of random samples
#'
#' The \code{create_sample} function takes a name of predefined sample set
#'   and genarates a list of wrapper functions for tool calculations.
#'
#' @param samp_name A single string to specify the name of a predefined tool
#'   set. Following six sets are currently available.
#'
#'   \describe{
#'     \item{"b100"}{A balanced data set with 50 positives and 50
#'         negatives.}
#'     \item{"b10k"}{A balanced data set with 5000 positives and 5000
#'         negatives.}
#'     \item{"b100k"}{A balanced data set with 50 000 positives and 50 000
#'         negatives}
#'     \item{"ib100"}{An imbalanced data set with 25 positives and 75
#'         negatives.}
#'     \item{"ib10k"}{A imbalanced data set with 2500 positives and 7500
#'         negatives.}
#'     \item{"ib100k"}{A imbalanced data set with 25 000 positives and 75 000
#'         negatives}
#'   }
#'
#' @param np An integer to specify the number of positves.
#'
#' @param pfunc A function to generate randome positive scores. It should accept
#'     \code{n} as an argument for the number of observations.
#'
#' @param nn An integer to specify the number of negatives.
#'
#' @param nfunc A function to generate randome negative scores. It should accept
#'     \code{n} as an argument for the number of observations.
#'
#' @seealso \code{\link{PRCData}}
#'
#' @examples
#' ## Create a balanced data set with 50 positives and 50 negatives
#' samp1 <- create_sample("b100")
#'
#' ## Create a balanced data set with 50 0000 positives and 50 000 negatives
#' samp2 <- create_sample("b100k")
#'
#' ## Create an imbalanced data set with 25 positives and 75 negatives
#' samp3 <- create_sample("ib100")
#'
#' ## Generate a sample dataset with 1000 positives and 10000 negatives
#' samp4 <- create_sample(np = 1000, nn = 10000)
#'
#' ## Generate a sample dataset by normal distribution random generator
#' pfunc <- function(n) {rnorm(n)}
#' samp5 <- create_sample(pfunc = pfunc)
#'
#' @export
create_testdata <- function(datatype, sampnames = NULL, scores = NULL,
                            labels = NULL, dsname = NA, base_x = NULL,
                            base_y = NULL, text_x = NULL, text_y = NULL) {

  if (!is.na(pmatch(datatype, "single"))) {
    sampnames <- "single"
    if (!is.null(base_x) && !is.null(base_y)) {
      ds <- TestDataEC$new(scores, labels, dsname)
      ds$set_basepoints_x(base_x)
      ds$set_basepoints_y(base_y)
      if (!is.null(text_x)) {
        ds$set_textpos_x(text_x)
      }
      if (!is.null(text_y)) {
        ds$set_textpos_y(text_y)
      }
      dsets <- list(ds)
    } else {
      dsets <- list(TestDataPB$new(scores, labels, dsname))
    }
  } else if (!is.na(pmatch(datatype, "random"))) {
    dsets <- lapply(sampnames, function(sname) {.create_rsample(sname)})
  } else if (!is.na(pmatch(datatype, "precal"))) {
    dsets <- lapply(sampnames, function(sname) {.create_precalc(sname)})
  }

  names(dsets) <- sampnames
  dsets
}

#
# Create a random sample dataset
#
.create_rsample <- function(sname = NULL, np = 10, pfunc = NULL, nn = 10,
                            nfunc = NULL) {

  # Calculate np and nn when sename is specified
  if (!is.null(sname)) {
    tot <- as.numeric(gsub("[i|b|k|m]", "", tolower(sname)))
    if (grepl("k$", tolower(sname))) {
      tot <- tot * 1000
    } else if (grepl("m$", tolower(sname))) {
      tot <- tot * 1000 * 1000
    }

    if (grepl("^i", tolower(sname))) {
      posratio <- 0.25
    } else if (grepl("^b", tolower(sname))) {
      posratio <- 0.5
    } else {
      posratio <- runif(1)
    }

    np <- round(tot * posratio)
    nn <- tot - np
  }

  # Sample positive scores
  if (is.null(pfunc)) {
    pfunc = function(n) stats::rbeta(n, shape1 = 1, shape2 = 1)
  }

  # Sample negative scores
  if (is.null(nfunc)) {
    nfunc = function(n) stats::rbeta(n, shape1 = 1, shape2 = 4)
  }

  # Create scores and labels
  scores <- c(pfunc(np), nfunc(nn))
  labels <- c(rep(1, np), rep(0, nn))

  # Create a TestDataPB object
  TestDataPB$new(scores, labels, as.character(sname))
}

#
# Get a test dataset with precalculated values
#
.create_precalc <- function(sname) {
  if (tolower(sname) == "p1") {
    pdata <- prcbench::P1DATA
  } else if (tolower(sname) == "p2") {
    pdata <- prcbench::P2DATA
  } else if (tolower(sname) == "p3") {
    pdata <- prcbench::P3DATA
  } else {
    stop("Ivalid dataset name")
  }

  # Create a TestDataEC object
  ds <- TestDataEC$new(pdata$scores, pdata$labels, sname)
  ds$set_basepoints_x(pdata$bp_x)
  ds$set_basepoints_y(pdata$bp_y)
  ds$set_textpos_x(pdata$tp_x)
  ds$set_textpos_y(pdata$tp_y)

  ds
}

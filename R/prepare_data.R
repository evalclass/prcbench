#' Create a set of random samples
#'
#' The \code{create_sampleset} function takes a name of predefined sample set
#'   and genarates a list of wrapper functions for tool calculations.
#'
#' @param set_name A single string to specify the name of a predefined tool set.
#'   Following six sets are currently available.
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
#' @seealso \code{\link{PRCData}} and \code{\link{create_rnd_sample}}.
#'
#' @examples
#' ## Create a balanced data set with 50 positives and 50 negatives
#' samp1 <- create_sampleset("b100")
#'
#' ## Create a balanced data set with 50 0000 positives and 50 000 negatives
#' samp2 <- create_sampleset("b100k")
#'
#' ## Create an imbalanced data set with 25 positives and 75 negatives
#' samp3 <- create_sampleset("ib100")
#'
#' @export
create_sampleset <- function(set_name) {
  if (set_name == "b100") {
    create_rnd_sample(np = 50, nn = 50)
  } else if (set_name == "b1k") {
    create_rnd_sample(np = 500, nn = 500)
  } else if (set_name == "b10k") {
    create_rnd_sample(np = 5000, nn = 5000)
  } else if (set_name == "b100k") {
    create_rnd_sample(np = 50000, nn = 50000)
  } else if (set_name == "ib100") {
    create_rnd_sample(np = 25, nn = 75)
  } else if (set_name == "ib1k") {
    create_rnd_sample(np = 250, nn = 750)
  } else if (set_name == "ib10k") {
    create_rnd_sample(np = 2500, nn = 7500)
  } else if (set_name == "ib100k") {
    create_rnd_sample(np = 25000, nn = 75000)
  } else {
    stop("Invalid set name")
  }
}

#' Create random samples
#'
#' The \code{create_rnd_sample} function creates a random sample.
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
#' @return PRCData \code{R6} object.
#'
#' @seealso \code{\link{PRCData}} and \code{\link{create_sampleset}}.
#'
#' @examples
#' ## Generate a sample dataset
#' samp1 <- create_rnd_sample()
#'
#' ## Generate a sample dataset with 1000 positives and 10000 negatives
#' samp2 <- create_rnd_sample(np = 1000, nn = 10000)
#'
#' ## Generate a sample dataset by normal distribution random generator
#' pfunc <- function(n) {rnorm(n)}
#' samp3 <- create_rnd_sample(pfunc = pfunc)
#'
#' @export
create_rnd_sample <- function(np = 10, pfunc = NULL, nn = 10, nfunc = NULL) {

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

  # Create a PRCData object
  PRCData$new(scores, labels)
}

#
# Validate scores and labels
#
.validate_prcdata <- function(scores, labels) {
  # Check scores
  .validate_scores(scores)

  # Check labels
  .validate_labels(labels)

  # Check length of scores and labels
  if (length(labels) != length(scores)) {
    stop("scores and labels must be the same lengths", call. = FALSE)
  }
}

#
# Validate scores
#
.validate_scores <- function(scores) {
  assertthat::assert_that(is.atomic(scores),
                          is.vector(scores),
                          is.numeric(scores),
                          length(scores) > 0L)
}

#
# Validate labels
#
.validate_labels <- function(labels) {
  assertthat::assert_that(is.atomic(labels),
                          (is.vector(labels) || is.factor(labels)),
                          length(labels) > 0L,
                          length(unique(labels)) == 2L)
}

#
# Get positive and negative labels
#
.get_uniq_labels <- function(labels) {
  ulables <- unique(labels)
  pos_label <- max(ulables)
  neg_label <- min(ulables)

  c(neg_label, pos_label)
}

#
# Create an input file
#
.write_auccalc_input_file <- function(scores, labels) {
  # Create a combined line
  dlines <- paste(scores, labels, sep = "\t", collapse = "\n")

  # Get a temp file name
  fname <- tempfile("prcdata_", fileext = c(".txt"))

  # Write data (use writeLines to avoid '\n' in the last line)
  file_con <- file(fname)
  writeLines(dlines, file_con, sep = "")
  close(file_con)

  # Return the file name
  fname
}

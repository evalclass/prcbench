#' TestDataB
#'
#' @description
#' \code{R6} class of test data set for performance evaluation tools.
#'
#' @details
#' \code{TestDataB} is a class that contains scores and label for performance
#'   evaluation tools. It provides necessary methods for benchmarking.
#'
#' @seealso \code{\link{create_testset}} for creating a list of test datasets.
#'   \code{\link{TestDataC}} is derived from this class for curve evaluation.
#'
#' @examples
#' ## Initialize with scores, labels, and a dataset name
#' testset <- TestDataB$new(c(0.1, 0.2, 0.3), c(0, 1, 1), "m1")
#' testset
#'
#' @docType class
#' @format An \code{R6} class object.
#' @export
TestDataB <- R6::R6Class(
  "TestDataB",
  public = list(
    #' @description
    #' Default class initialization method.
    #' @param scores A vector of scores.
    #' @param labels A vector of labels.
    #' @param tsname A dataset name.
    initialize = function(scores = NULL,
                          labels = NULL,
                          tsname = NA) {
      # Validate arguments
      .validate_prcdata(scores, labels)

      # Get unique lables
      ulabs <- .get_uniq_labels(labels)

      # Set private fields
      private$tsname <- tsname
      private$scores <- scores
      private$labels <- labels
      private$fg <- scores[labels == ulabs[2]]
      private$bg <- scores[labels == ulabs[1]]
      private$fname <- .write_auccalc_input_file(scores, labels)

      # Finalizer
      reg.finalizer(self, function(e) {
        self$del_file()
      }, onexit = TRUE)
    },

    #' @description
    #' Get the dataset name.
    get_tsname = function() {
      private$tsname
    },

    #' @description
    #' Get a vector of scores.
    get_scores = function() {
      private$scores
    },

    #' @description
    #' Get a vector of labels.
    get_labels = function() {
      private$labels
    },

    #' @description
    #' Get a vector of positive scores.
    get_fg = function() {
      private$fg
    },

    #' @description
    #' Get a vector of negative scores.
    get_bg = function() {
      private$bg
    },

    #' @description
    #' Get a file name that contains scores and labels.
    get_fname = function() {
      private$fname
    },

    #' @description
    #' Delete the file with scores and labels.
    del_file = function() {
      if (!is.na(private$fname) && file.exists(private$fname)) {
        tryCatch(
          file.remove(private$fname),
          warning = function(w) {
            print(w)
          },
          error = function(e) {
            print(e)
          }
        )
      }
      private$fname <- NA
    },

    #' @description
    #' Pretty print of the test dataset.
    #' @param ... Not used.
    print = function(...) {
      cat("\n")
      cat("    === Test dataset for prcbench functions ===\n")
      cat("\n")

      cat("    Testset name:    ", private$tsname, "\n")
      cat("    # of positives:  ", length(private$fg), "\n")
      cat("    # of negatives:  ", length(private$bg), "\n")
      cat("    Scores:          ", min(private$scores), "(min)", "\n")
      cat("                     ", mean(private$scores), "(mean)", "\n")
      cat("                     ", max(private$scores), "(max)", "\n")
      ulabs <- .get_uniq_labels(private$labels)
      cat("    Labels:          ", ulabs[1], "(neg),", ulabs[2], "(pos)\n")
      private$print_ext()
      cat("\n")
      invisible(self)
    }
  ),
  private = list(
    print_ext = function() {
      invisible(NULL)
    },
    tsname = NA,
    scores = NA,
    labels = NA,
    fg = NA,
    bg = NA,
    fname = NA
  )
)

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
  assertthat::assert_that(
    is.atomic(scores),
    is.vector(scores),
    is.numeric(scores),
    length(scores) > 0L
  )
}

#
# Validate labels
#
.validate_labels <- function(labels) {
  assertthat::assert_that(
    is.atomic(labels),
    (is.vector(labels) || is.factor(labels)),
    length(labels) > 0L,
    length(unique(labels)) == 2L
  )
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
  fname <- tempfile("prcdata_", fileext = ".txt")

  # Write data (use writeLines to avoid '\n' in the last line)
  file_con <- file(fname)
  writeLines(dlines, file_con, sep = "")
  close(file_con)

  # Return the file name
  fname
}

#' TestDataC
#'
#' @description
#' \code{R6} class of test dataset for Precision-Recall curve evaluation.
#'
#' @details
#' \code{TestDataC} is a class that contains scores and label for performance
#'   evaluation tools. It provides necessary methods for curve evaluation.
#'
#' @seealso \code{\link{create_testset}} for creating a list of test datasets.
#'   It is derived from \code{\link{TestDataB}}.
#'
#' @examples
#' ## Initialize with scores, labels, and a dataset name
#' testset <- TestDataC$new(c(0.1, 0.2), c(1, 0), "c4")
#' testset
#'
#' ## Set base points
#' testset$set_basepoints_x(c(0.13, 0.2))
#' testset$set_basepoints_y(c(0.5, 0.6))
#' testset
#'
#' @docType class
#' @format An \code{R6} class object.
#' @export
TestDataC <- R6::R6Class(
  "TestDataC",
  inherit = TestDataB,
  public = list(
    #' @description
    #' Set pre-calculated recall values for curve evaluation.
    #' @param x A recall value.
    set_basepoints_x = function(x) {
      private$bx_x <- x
    },

    #' @description
    #' Set pre-calculated precision values for curve evaluation.
    #' @param y A precision value.
    set_basepoints_y = function(y) {
      private$bx_y <- y
    },

    #' @description
    #' Get pre-calculated recall values for curve evaluation.
    get_basepoints_x = function() {
      private$bx_x
    },

    #' @description
    #' Get pre-calculated precision values for curve evaluation.
    get_basepoints_y = function() {
      private$bx_y
    },

    #' @description
    #' Set the position \code{x} for displaying the test result in a plot.
    #' @param x Position x of the test result.
    set_textpos_x = function(x) {
      private$tp_x <- x
    },

    #' @description
    #' Set the \code{y} position for displaying the test result in a plot.
    #' @param y Position y of the test result.
    set_textpos_y = function(y) {
      private$tp_y <- y
    },

    #' @description
    #' Set the \code{x} position for displaying the test result in a plot.
    #' @param x Position x of the test result.
    set_textpos_x2 = function(x) {
      private$tp_x2 <- x
    },

    #' @description
    #' Set the \code{y} position for displaying the test result in a plot.
    #' @param y Position y of the test result.
    set_textpos_y2 = function(y) {
      private$tp_y2 <- y
    },

    #' @description
    #' Get the position \code{x} for displaying the test result in a plot.
    get_textpos_x = function() {
      private$tp_x
    },

    #' @description
    #' Get the position \code{y} for displaying the test result in a plot.
    get_textpos_y = function() {
      private$tp_y
    },

    #' @description
    #' Get the \code{x} position for displaying the test result in a plot.
    get_textpos_x2 = function() {
      private$tp_x2
    },

    #' @description
    #' Get the \code{y} position for displaying the test result in a plot.
    get_textpos_y2 = function() {
      private$tp_y2
    }
  ),
  private = list(
    print_ext = function() {
      cat("    Pre-calculated:  ")
      if (!is.null(private$bx_x) && !is.null(private$bx_y)) {
        cat(" Yes\n")
      } else {
        cat(" No\n")
      }
      cat("    # of base points:", length(private$bx_x), "\n")
      cat(
        "    Text position:   ",
        paste0("(", private$tp_x, ", ", private$tp_y, ")\n")
      )
      cat(
        "    Text position2:  ",
        paste0("(", private$tp_x2, ", ", private$tp_y2, ")\n")
      )
    },
    bx_x = NA,
    bx_y = NA,
    tp_x = 0.75,
    tp_y = 0.25,
    tp_x2 = 0.75,
    tp_y2 = 0.25
  )
)

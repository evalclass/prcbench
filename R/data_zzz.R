#' General test dataset class for performance evaluation tools
#'
#' \code{TestDataPB} is a class that contans scores and labels as input data for
#'   performance evaluation tools.
#'
#' @section Methods:
#' \itemize{
#'  \item \code{get_datname()}: Get a string of the dataset name.
#'  \item \code{get_scores()}: Get a vector of predicted scores.
#'  \item \code{get_labels()}: Get a vector of observed labels.
#'  \item \code{get_fg()}: Get a vector of positive scores.
#'  \item \code{get_bg()}: Get a vector of negative scores.
#'  \item \code{get_fname()}: Get a file name that contains scores and labels.
#'  \item \code{del_file()}: Get a file name that contains scores and labels.
#' }
#'
#' @examples
#' ## An object needs to be instantiated from the class
#' ## before calling any methods
#' prcdata <- PRCData$new(c(0.1, 0.2, 0.3), c(0, 1, 1), "m1")
#'
#' @docType class
#' @format An R6 class object.
#' @export
TestDataPB <- R6::R6Class("TestDataPB",
  public = list(
   initialize = function(scores = NULL, labels = NULL, dsname = NA) {

     # Validate arguments
     .validate_prcdata(scores, labels)

     # Get unique lables
     ulabs <- .get_uniq_labels(labels)

     # Set private fields
     private$dsname <- dsname
     private$scores <- scores
     private$labels <- labels
     private$fg <- scores[labels == ulabs[2]]
     private$bg <- scores[labels == ulabs[1]]
     private$fname <- .write_auccalc_input_file(scores, labels)

     # Finalizer
     reg.finalizer(self, function(e) {self$del_file()}, onexit = TRUE)
   },
   get_dsname = function() {private$dsname},
   get_scores = function() {private$scores},
   get_labels = function() {private$labels},
   get_fg = function() {private$fg},
   get_bg = function() {private$bg},
   get_fname = function() {private$fname},
   del_file = function() {
     if (!is.na(private$fname) && file.exists(private$fname)) {
       file.remove(private$fname)
     }
     private$fname <- NA
   },
   print = function(...) {
     cat("\n")
     cat("    === Test dataset for prcbench functions ===\n")
     cat("\n")

     cat("    Dataset name:    ", private$dsname, "\n")
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
    print_ext = function() {invisible(NULL)},
    dsname = NA,
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

#' General test dataset class for performance evaluation tools
#'
#' \code{TestDataEC} is a class that contans scores and labels as input data for
#'   performance evaluation tools.
#'
#' @section Methods:
#' \itemize{
#'  \item \code{get_datname()}: Get a string of the dataset name.
#'  \item \code{get_scores()}: Get a vector of predicted scores.
#'  \item \code{get_labels()}: Get a vector of observed labels.
#'  \item \code{get_fg()}: Get a vector of positive scores.
#'  \item \code{get_bg()}: Get a vector of negative scores.
#'  \item \code{get_fname()}: Get a file name that contains scores and labels.
#'  \item \code{del_file()}: Get a file name that contains scores and labels.
#' }
#'
#' @examples
#' ## An object needs to be instantiated from the class
#' ## before calling any methods
#' prcdata <- TestDataEC$new(c(0.1, 0.2, 0.3), c(0, 1, 1), "m1")
#'
#' @docType class
#' @format An R6 class object.
#' @export
TestDataEC <- R6::R6Class(
  "TestDataEC", inherit = TestDataPB,
  public = list(
    set_basepoints_x = function(x) {
      private$bx_x <- x
    },
    set_basepoints_y = function(y) {
      private$bx_y <- y
    },
    get_basepoints_x = function() {private$bx_x},
    get_basepoints_y = function() {private$bx_y},
    set_textpos_x = function(x) {
      private$tp_x <- x
    },
    set_textpos_y = function(y) {
      private$tp_y <- y
    },
    get_textpos_x = function() {private$tp_x},
    get_textpos_y = function() {private$tp_y}
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
      cat("    Text position:   ",
          paste0("(", private$tp_x, ", ", private$tp_y, ")\n"))
    },
    bx_x = NA,
    bx_y = NA,
    tp_x = 0.75,
    tp_y = 0.25
  )
)

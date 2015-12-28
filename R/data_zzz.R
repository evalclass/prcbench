#' Input dataset class for performance evaluation tools
#'
#' \code{PRCData} is a class that contans scores and labels as input data for
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
PRCData <- R6::R6Class("PRCData",
  public = list(
   initialize = function(scores = NULL, labels = NULL, datname = NA) {

     # Validate arguments
     .validate_prcdata(scores, labels)

     # Get unique lables
     ulabs <- .get_uniq_labels(labels)

     # Set private fields
     private$datname <- datname
     private$scores <- scores
     private$labels <- labels
     private$fg <- scores[labels == ulabs[2]]
     private$bg <- scores[labels == ulabs[1]]
     private$fname <- .write_auccalc_input_file(scores, labels)

     # Finalizer
     reg.finalizer(self, function(e) {self$del_file()}, onexit = TRUE)
   },
   get_datname = function() {private$datname},
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
     cat("    === PRCData object: Test dataset for prcbench functions ===\n")
     cat("\n")

     cat("    Dataset name:  ", self$get_datname(), "\n")
     cat("    # of positives:", length(self$get_fg()), "\n")
     cat("    # of negatives:", length(self$get_bg()), "\n")
     cat("    Scores:        ", min(self$get_scores()), "(min)", "\n")
     cat("                   ", mean(self$get_scores()), "(mean)", "\n")
     cat("                   ", max(self$get_scores()), "(max)", "\n")
     cat("    Labels:        ", unique(self$get_labels()), "\n")
     cat("\n")
     invisible(self)
   }
  ),
  private = list(
   datname = NA,
   scores = NA,
   labels = NA,
   fg = NA,
   bg = NA,
   fname = NA
  )
)

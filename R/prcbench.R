#' prcbench: A package to provide a testing workbench for Precision-Recall
#' curves
#'
#' The prcbench package provides four categories of important functions:
#' tool wrappers, data preparation, curve evaluation, and benchmarking.
#'
#' @section Tool wrappers:
#' \code{\link{create_tools}}.
#'
#' @section Data preparation:
#' \code{\link{create_tools}}.
#'
#' @section Curve evaluation:
#' \code{\link{create_tools}}
#'
#' @section Benchmarking:
#' \code{\link{create_tools}}.
#'
#' @docType package
#' @name prcbench
#'
#' @importFrom R6 R6Class
#' @importFrom ggplot2 autoplot
#'
NULL

#' P1: Pre-calculated Precision-Recall curve
#'
#' A list contains scores, labels, and precalculated recall and precision
#' values as x and y.
#'
#' @format A list with 5 items.
#' \describe{
#'   \item{scores}{input scores}
#'   \item{labels}{input labels}
#'   \item{bp_x}{precalculated recall values for curve evaulation}
#'   \item{bp_y}{precalculated precision values for curve evaluation}
#'   \item{tp_x}{x position for displaying the test result in a plot}
#'   \item{tp_y}{y position for displaying the test result in a plot}
#' }
#'
#' @docType data
#' @keywords datasets
#' @name P1DATA
#' @usage data(P1DATA)
NULL

#' P2: Pre-calculated Precision-Recall curve
#'
#' A list contains scores, labels, and precalculated recall and precision
#' values as x and y.
#'
#' @format See \code{\link{P1DATA}}.
#'
#' @docType data
#' @keywords datasets
#' @name P2DATA
#' @usage data(P2DATA)
NULL

#' P2: Pre-calculated Precision-Recall curve
#'
#' A list contains scores, labels, and precalculated recall and precision
#' values as x and y.
#'
#' @format See \code{\link{P1DATA}}.
#'
#' @docType data
#' @keywords datasets
#' @name P3DATA
#' @usage data(P3DATA)
NULL

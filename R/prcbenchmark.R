#' prcbenchmark: A package for benchmarking Precision-Recall curves
#'
#' The prcbenchmark package provides three categories of important functions:
#' tool wrappers, data preparation, and benchmarking.
#'
#' @section Tool wrappers:
#' \code{\link{create_tool}}.
#'
#' @section Data preparation:
#' \code{\link{create_tool}}.
#'
#' @section Benchmarking:
#' \code{\link{create_tool}}.
#'
#' @docType package
#' @name prcbenchmark
#'
#' @importFrom R6 R6Class
#'
NULL

#' M1: Manually calculated Precision-Recall curves
#'
#' A list contains scores and labels of input data, x and y values of
#' the Precision-Recall curve, and line types between two points.
#'
#' @format A list with 5 items.
#' \describe{
#'   \item{scores}{input scores}
#'   \item{labels}{input labels}
#'   \item{bp_x}{x values of the calculated curve}
#'   \item{bp_y}{y values of the calculated curve}
#'   \item{line_type}{line type between two points.
#'     \describe{
#'       \item{"v"}{vertical line}
#'       \item{"h"}{horizontal line}
#'       \item{"c"}{non-linear line}
#'       \item{"p"}{point}
#'     }
#'   }
#' }
#'
#' @docType data
#' @keywords datasets
#' @name M1DATA
#' @usage data(M1DATA)
NULL

#' M2: Manually calculated Precision-Recall curve
#'
#' A list contains scores and labels of input data, x and y values of
#' the Precision-Recall curve, and line types between two points.
#'
#' @format See \code{\link{M1DATA}}.
#'
#' @docType data
#' @keywords datasets
#' @name M2DATA
#' @usage data(M2DATA)
NULL

#' M3: Manually calculated Precision-Recall curve
#'
#' A list contains scores and labels of input data, x and y values of
#' the Precision-Recall curve, and line types between two points.
#'
#' @format See \code{\link{M1DATA}}.
#'
#' @docType data
#' @keywords datasets
#' @name M3DATA
#' @usage data(M3DATA)
NULL

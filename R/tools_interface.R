#' Create a set of tools
#'
#' The \code{create_tools} function takes a name of predefined tool set and
#'   genarates a list of wrapper functions for tool calculations.
#'
#' @param tool_names A character vector to specify the names of
#'   performance evaluatoin tools. The names for the following five tools can be
#'   currently used.
#'
#'   \itemize{
#'     \item ROCR
#'     \item AUCCalculator
#'     \item PerfMeas
#'     \item PRROC
#'     \item precrec
#'   }
#'
#'   Alternatively, a pre-defined set name can be specified. Following three
#'   sets are currently available.
#'
#'   \describe{
#'     \item{"crv"}{A set of tools optimized for curve calculations}
#'     \item{"auc"}{A set of tools optimized for AUC calculations}
#'     \item{"both"}{A set of tools optimized for both curve and AUC
#'                   calculations.}
#'   }
#'
#' @param init_params A list of lists that contain parameters used for
#'   tool object intialization. For instance, \code{list(list(p1 = 1))} makes
#'   the first tool (only one tool in this case) is initialized with a
#'   parameter as \code{toolclass$new(p1 = 1)}.
#'
#'   \tabular{lll}{
#'     \strong{Tool}
#'     \tab \strong{Parameters}
#'     \tab \strong{Notes} \cr
#'
#'     ROCR
#'         \tab NA \tab NA   \cr
#'     AUCCalculator
#'         \tab \code{type}, \code{fpath}
#'         \tab see \code{\link{ToolAUCCalculator}} \cr
#'     PerfMeas
#'         \tab NA \tab NA \cr
#'     PRROC
#'         \tab \code{curve}, \code{minStepSize}
#'         \tab see \code{\link{ToolPRROC}} \cr
#'     precrec
#'         \tab NA \tab NA
#'   }
#'
#' @param retval A Boolean value to specify whether the method returns the AUC
#'   score and x-y positions.
#'
#' @param auc A Boolean value to specify  whether the AUC score should be
#'   calculated.
#'
#' @return A list of functions that calls tool calculations.
#'
#' @seealso \code{\link{ToolROCR}}, \code{\link{ToolAUCCalculator}},
#'   \code{\link{ToolPerfMeas}}, \code{\link{ToolPRROC}},
#'   and \code{\link{Toolprecrec}} as classes of tool objects.
#'
#' @examples
#' ## Create a tool set for curve calculations
#' tool_funcs1 <- create_tools("crv")
#'
#' ## Create a tool set for AUC calculations
#' tool_funcs2 <- create_tools("auc")
#'
#' ## Create a tool set for both curve and AUC calculations
#' tool_funcs3 <- create_tools("both")
#'
#' @export
create_tools <- function(tool_names = NULL, init_params = NULL, retval = TRUE,
                         auc = TRUE) {
  set_name <- tool_names
  if (is.null(tool_names) || tool_names %in% c("crv", "auc", "both")) {
    tool_names <- c("ROCR", "AUCCalculator", "PerfMeas", "PRROC", "precrec")
  }
  if (is.null(init_params)) {
    init_params <- replicate(length(tool_names), list())
  }

  wrapper_func <- function(tool_names, init_params, retval, auc) {
    tool_set_func <- function(obj) {
      obj_call_func <- function(sdat, retval = retval, auc = auc) {
        obj$call(sdat, retval, auc)
      }
      formals(obj_call_func)$retval <- retval
      formals(obj_call_func)$auc <- auc
      obj_call_func
    }
    lapply(.create_tool_cls(tool_names, init_params), tool_set_func)
  }

  if (is.null(set_name) || length(set_name) > 1) {
    wrapper_func(tool_names, init_params, retval, auc)
  } else if (set_name == "crv") {
    wrapper_func(tool_names, init_params, TRUE, FALSE)
  } else if (set_name == "auc") {
    init_params[[4]] = list(curve = FALSE)
    wrapper_func(tool_names, init_params, FALSE, TRUE)
  } else if (set_name == "both") {
    wrapper_func(tool_names, init_params, TRUE, TRUE)
  } else {
    wrapper_func(tool_names, init_params, retval, auc)
  }
}

#
# Create tool class
#
.create_tool_cls <- function(tool_names = c("ROCR", "AUCCalculator", "PerfMeas",
                                            "PRROC", "precrec"),
                             init_params = replicate(length(tool_names),
                                                     list())) {

  tfunc <- function(i) {
    tool_cls <- eval(as.name(paste0("Tool", tool_names[i])))
    if (length(init_params[[i]]) == 0) {
      tool_obj <- tool_cls$new()
    } else {
      tool_obj <- do.call(tool_cls$new, init_params[[i]])
    }
  }
  tools <- lapply(seq_along(tool_names), tfunc)
  names(tools) <- .rename_tool_names(tool_names)

  tools
}

#
# Rename duplicated tool names
#
.rename_tool_names <- function(tool_names) {
  renamed <- list()
  for (idx in seq_along(tool_names)[duplicated(tool_names)]) {
    tname <- as.character(tool_names[idx])
    if (tname %in% names(renamed)) {
      renamed[[tname]] <- renamed[[tname]] + 1
    } else {
      renamed[[tname]] <- 2
    }
    tool_names[idx] <- paste0(tname, ".", renamed[[tname]])
  }
  tool_names
}

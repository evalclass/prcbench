#' Create a set of tools
#'
#' The \code{create_toolset} function takes a name of predefined tool set and
#'   genarates a list of wrapper functions for tool calculations.
#'
#' @param set_name A single string to specify the name of a predefined tool set.
#'   Following three sets are currently available.
#'
#'   \describe{
#'     \item{"crv"}{A set optimized for curve calculations}
#'     \item{"auc"}{A set optimized for AUC calculations}
#'     \item{"both"}{A set optimized for both curve and AUC calculations.}
#'   }
#'
#' @return A list of functions that calls tool calculations.
#'
#' @seealso \code{\link{create_tool}} for creating tool objects.
#'   \code{\link{ToolROCR}}, \code{\link{ToolAUCCalculator}},
#'   \code{\link{ToolPerfMeas}}, \code{\link{ToolPRROC}},
#'   and \code{\link{Toolprecrec}} as classes of tool objects.
#'
#' @examples
#' ## Create a tool set for curve calculations
#' tool_funcs1 <- create_toolset("crv")
#'
#' ## Create a tool set for AUC calculations
#' tool_funcs2 <- create_toolset("auc")
#'
#' ## Create a tool set for both curve and AUC calculations
#' tool_funcs3 <- create_toolset("both")
#'
#' @export
create_toolset <- function(set_name) {
  def_tool_names <- c("ROCR", "AUCCalculator", "PerfMeas", "PRROC", "precrec")
  def_init_params = replicate(length(def_tool_names), list())

  wrapper_func <- function(tool_names, init_params, retval, auc) {
    tool_set_func <- function(obj) {
      obj_call_func <- function(sdat, retval = retval, auc = auc) {
        obj$call(sdat, retval, auc)
      }
      formals(obj_call_func)$retval <- retval
      formals(obj_call_func)$auc <- auc
      obj_call_func
    }
    lapply(create_tool(tool_names, init_params), tool_set_func)
  }

  if (set_name == "crv") {
    wrapper_func(def_tool_names, def_init_params, TRUE, FALSE)
  } else if (set_name == "auc") {
    def_init_params[[4]] = list(curve = FALSE)
    wrapper_func(def_tool_names, def_init_params, FALSE, TRUE)
  } else if (set_name == "both") {
    wrapper_func(def_tool_names, def_init_params, TRUE, TRUE)
  } else {
    stop("Invalid set name")
  }
}

#' Create tool wrapper objects
#'
#' The \code{create_tool} function takes names of performance evaluation
#'   tool and generate wrapper objects.
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
#' @return A list of \code{R6} objects.
#'
#' @seealso \code{\link{ToolROCR}}, \code{\link{ToolAUCCalculator}},
#'   \code{\link{ToolPerfMeas}}, \code{\link{ToolPRROC}},
#'   and \code{\link{Toolprecrec}} can be genereted by this function.
#'
#' @examples
#' ## Generate all wraper objects
#' tools1 <- create_tool()
#'
#' ## Generate PRROC and precrec wraper objects
#' tools2 <- create_tool(c("PRROC", "precrec"))
#'
#' ## Specifiy an initialize parameter for the second tool entry
#' tools3 <- create_tool(c("PRROC", "PRROC"),
#'                       list(list(), list(curve = FALSE)))
#'
#' @export
create_tool <- function(tool_names = c("ROCR", "AUCCalculator", "PerfMeas",
                                        "PRROC", "precrec"),
                         init_params = replicate(length(tool_names), list())) {

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

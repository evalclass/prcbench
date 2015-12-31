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
#'     \item{"crv5"}{A set of 5 tools optimized for curve calculations}
#'     \item{"auc5"}{A set of 5 tools optimized for AUC calculations}
#'     \item{"both5"}{A set of 5 tools optimized for both curve and AUC
#'                   calculations.}
#'     \item{"crv4"}{A set of 4 tools optimized for curve calculations}
#'     \item{"auc4"}{A set of 4 tools optimized for AUC calculations}
#'     \item{"both4"}{A set of 4 tools optimized for both curve and AUC
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
#' tool_funcs1 <- create_tools("crv5")
#'
#' ## Create a tool set for AUC calculations
#' tool_funcs2 <- create_tools("auc5")
#'
#' ## Create a tool set for both curve and AUC calculations
#' tool_funcs3 <- create_tools("both5")
#'
#' @export
create_tools <- function(tool_names = NULL, set_names = NULL, calc_auc = TRUE,
                         store_res = TRUE) {

  init_data <- .prepare_init(tool_names, set_names, calc_auc, store_res)
  toolobjs <- .create_toolobjs(init_data)
  toolobjs
}

#
# Prepare init data for tool classes
#
.prepare_init <- function(tool_names, set_names, calc_auc, store_res) {
  # Initialize
  new_tool_names <- NULL
  new_set_names <- NULL
  new_init_params <- NULL

  # Set tool names
  if (!is.null(tool_names)) {
    new_tool_names <- tool_names
    new_set_names <- tool_names
    new_init_params <- replicate(length(tool_names),
                                 list(calc_auc = calc_auc,
                                      store_res = store_res), simplify = FALSE)
    for (i in seq_along(tool_names)) {
      new_init_params[[i]]$setname <- tool_names[i]
    }
  }

  # Set tool names from pre-defined sets
  if (!is.null(set_names)) {
    for (sname in set_names) {
      if (grepl("5$", sname)) {
        ntnames <- c("ROCR", "AUCCalculator", "PerfMeas", "PRROC", "precrec")
      } else if (grepl("4$", sname)) {
        ntnames <- c("ROCR", "AUCCalculator", "PerfMeas", "precrec")
      }
      nsname <- rep(sname, length(ntnames))

      if (grepl("^crv", sname)) {
        new_calc_auc <- FALSE
        new_store_res <- TRUE
      } else if (grepl("^auc", sname)) {
        new_calc_auc <- TRUE
        new_store_res <- FALSE
      } else if (grepl("^both", sname)) {
        new_calc_auc <- TRUE
        new_store_res <- TRUE
      }
      nparams <- replicate(length(ntnames), list(calc_auc = new_calc_auc,
                                                 store_res = new_store_res,
                                                 setname = sname),
                           simplify = FALSE)
      if (sname == "auc5") {
        nparams[[4]]$curve = FALSE
      }

      new_tool_names <- c(new_tool_names, ntnames)
      new_set_names <- c(new_set_names, nsname)
      new_init_params <- c(new_init_params, nparams)
    }
  }

  # Return updated names with parameters
  list(new_tool_names, new_set_names, new_init_params)
}

#
# Create tool objects
#
.create_toolobjs <- function(init_data) {
  tool_names <- init_data[[1]]
  set_names <- init_data[[2]]
  init_params <- init_data[[3]]

  tfunc <- function(i) {
    tool_cls <- eval(as.name(paste0("Tool", tool_names[i])))
    if (length(init_params[[i]]) == 0) {
      obj <- tool_cls$new()
    } else {
      obj <- do.call(tool_cls$new, init_params[[i]])
    }
  }
  toolobjs <- lapply(seq_along(tool_names), tfunc)
  names(toolobjs) <- .rename_tool_names(tool_names)

  toolobjs
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

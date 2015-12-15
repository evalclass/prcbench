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
#' @seealso \code{\link{create_tools}} for creating tool objects.
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
  if (set_name == "crv") {
    .create_toolset1_curve()
  } else if (set_name == "auc") {
    .create_toolset2_auc()
  } else if (set_name == "both") {
    .create_toolset3_both()
  } else {
    stop("Invalid set name")
  }
}

.create_toolset1_curve <- function() {
  tfunc <- function(obj) {
    function(sdat, retval = TRUE, auc = FALSE) {
      obj$call(sdat, retval, auc)
    }
  }
  lapply(create_tools(), tfunc)
}

.create_toolset2_auc <- function() {
  tool_names <- c("ROCR", "AUCCalculator", "PerfMeas", "PRROC", "precrec")
  init_params = replicate(length(tool_names), list())
  init_params[[4]] = list(curve = FALSE)

  tfunc <- function(obj) {
    function(sdat, retval = FALSE, auc = TRUE) {
      obj$call(sdat, retval, auc)
    }
  }
  lapply(create_tools(tool_names, init_params), tfunc)
}

.create_toolset3_both <- function() {
  tfunc <- function(obj) {
    function(sdat, retval = TRUE, auc = TRUE) {
      obj$call(sdat, retval, auc)
    }
  }
  lapply(create_tools(), tfunc)
}

#' Create tool wrapper objects
#'
#' The \code{create_tools} function takes names of performance evaluation
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
#'   \tabular{lllll}{
#'     \strong{Tool}
#'     \tab \tab \strong{Parameters}
#'     \tab \tab \strong{Notes} \cr
#'
#'     ROCR
#'         \tab \tab NA
#'         \tab \tab NA   \cr
#'     AUCCalculator
#'         \tab \tab \code{type}, \code{fpath}
#'         \tab \tab see \code{\link{ToolAUCCalculator}} \cr
#'     PerfMeas
#'         \tab \tab NA
#'         \tab \tab NA \cr
#'     PRROC
#'         \tab \tab \code{curve}, \code{minStepSize}
#'         \tab \tab see \code{\link{ToolPRROC}} \cr
#'     precrec
#'         \tab \tab NA
#'         \tab \tab NA
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
#' tools1 <- create_tools()
#'
#' ## Generate PRROC and precrec wraper objects
#' tools2 <- create_tools(c("PRROC", "precrec"))
#'
#' ## Specifiy an initialize parameter for the second tool entry
#' tools3 <- create_tools(c("PRROC", "PRROC"),
#'                        list(list(), list(curve = FALSE)))
#'
#' @export
create_tools <- function(tool_names = c("ROCR", "AUCCalculator", "PerfMeas",
                                        "PRROC", "precrec"),
                         init_params = replicate(length(tool_names), list())) {

  tfunc <- function(i) {
    tool_cls <- tool_generator(tool_names[i])
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

#' Wrapper class generator for performace evaluatoin tools
#'
#' The \code{tool_generator} function takes a name of a performance evaluation
#'   tool and makes an wrapper class for the tool. All generated classes share
#'   a common interface interited from the \code{\link{ToolBase}} class.
#'
#' @param name A string to specify the name of a performance evaluatoin tool.
#'   The funciton currently accepts the following five tools.
#'   \itemize{
#'     \item \href{https://rocr.bioinf.mpi-sb.mpg.de/}{ROCR}
#'     \item \href{http://mark.goadrich.com/programs/AUC/}{AUCCalculator}
#'     \item \href{https://cran.r-project.org/web/packages/PerfMeas/}{PerfMeas}
#'     \item \href{https://cran.r-project.org/web/packages/PRROC/}{PRROC}
#'     \item \href{https://cran.r-project.org/web/packages/precrec/}{precrec}
#'   }
#'
#' @return \code{R6} as a wrapper class of performace evaluatoin tools.
#'
#' \tabular{llll}{
#'   \strong{Tool name}
#'   \tab \tab \strong{Generated R6} \cr
#'
#'   ROCR \tab \tab \code{\link{ToolROCR}}   \cr
#'   AUCCalculator \tab \tab \code{\link{ToolAUCCalculator}} \cr
#'   PerfMeas \tab \tab \code{\link{ToolPerfMeas}}   \cr
#'   PRROC \tab \tab \code{\link{ToolPRROC}}   \cr
#'   precrec \tab \tab \code{\link{Toolprecrec}}
#' }
#'
#' @seealso \code{\link{ToolBase}} is used as the base class.
#'   \code{\link{ToolROCR}}, \code{\link{ToolAUCCalculator}},
#'   \code{\link{ToolPerfMeas}}, \code{\link{ToolPRROC}},
#'   and \code{\link{Toolprecrec}} can be genereted by this function.
#'
#' @examples
#' ## Generate a warpper class for ROCR
#' toolroc_cls <- tool_generator("ROCR")
#'
#' ## An object needs to be instantiated from the class
#' ## before calling any wrapper functions
#' toolroc <- toolroc_cls$new()
#'
#' @export
tool_generator <- function(name) {
  if (!requireNamespace("R6", quietly = TRUE)) {
    stop("R6 needed for this function to work. Please install it.",
         call. = FALSE)
  }

  baseclass <- .tool_base_generator()

  if (name == "ROCR") {
    toolclass <- .common_tool_generator(baseclass, "ROCR", .rocr_wrapper)
  } else if (name == "AUCCalculator") {
    toolclass <- .auccalc_tool_generator(baseclass)
  } else if (name == "PerfMeas") {
    toolclass <- .common_tool_generator(baseclass, "PerfMeas", .pm_wrapper)
  } else if (name == "PRROC") {
    toolclass <- .prroc_tool_generator(baseclass)
  } else if (name == "precrec") {
    toolclass <- .common_tool_generator(baseclass, "precrec", .precrec_wrapper)
  } else {
    stop("Invalid tool name")
  }

  toolclass
}

#
# Create base generator class
#
.tool_base_generator <- function() {
  baseclass <- R6::R6Class(
    "ToolBase",
    public = list(
      initialize = function(...) {
        arglist <- list(...)
        if (length(arglist) > 0) {
          stop("Invalid argument")
        }
      },
      call = function(sdat, retval = TRUE, auc = TRUE) {
        result <- private$f_wrapper(sdat, retval, auc)
        if (retval && !is.null(result)) {
          private$set_result(result)
        } else if (auc && !is.null(result$auc)) {
          private$set_auc(result$auc)
        }
        self
      },
      get_result = function() {private$result},
      get_x = function() {private$result[["x"]]},
      get_y = function() {private$result[["y"]]},
      get_auc = function() {private$result[["auc"]]}
    ),
    private = list(
      set_result = function(val) {private$result <- val},
      set_auc = function(val) {private$result[["auc"]] <- val},
      result = list(x = NA, y = NA, auc = NA),
      f_wrapper = function(sdat, retval, auc) {NULL}
    )
  )
  baseclass
}

#
# Create a tool wrapper class
#
.common_tool_generator <- function(baseclass, name, func) {
  toolclass <- R6::R6Class(
    paste0("Tool", name), inherit = baseclass,
    private = list(f_wrapper = func)
  )
  toolclass
}

#
# Create AUCCalculator wrapper class
#
.auccalc_tool_generator <- function(baseclass) {
  toolclass <- R6::R6Class(
    "ToolAUCCalculator", inherit = baseclass,
    public = list(
      initialize = function(...) {
        arglist <- list(...)
        argnum <- 0
        if (length(arglist) > 0) {
          if ("type" %in% names(arglist)){
            private$type <- arglist[["type"]]
            argnum <- argnum + 1
          }
          if ("fpath" %in% names(arglist)){
            private$fpath <- arglist[["fpath"]]
            argnum <- argnum + 1
          }
          if (length(arglist) != argnum) {
            stop("Invalid argument")
          }
        }
        self$set_java_call()
      },
      set_java_call = function(type = NULL, fpath = NULL) {
        if (is.null(type)) {
          type <- private$type
        }
        if (is.null(fpath)) {
          fpath <- private$fpath
        }
        if (type == "syscall") {
          private$java_call <- .create_syscall_auccalc(fpath)
        } else if (type == "rjava") {
          private$java_call <- .create_rjava_auccalc(fpath)
        }
      }
    ),
    private = list(
      type = "syscall",
      fpath = NULL,
      f_wrapper = function(sdat, retval, auc) {
        .auccalc_wrapper(sdat, retval, auc, private$java_call)
      },
      java_call = NULL
    )
  )
  toolclass
}

#
# Create PRROC wrapper class
#
.prroc_tool_generator <- function(baseclass) {
  toolclass <- R6::R6Class(
    "ToolPRROC", inherit = baseclass,
    public = list(
      initialize = function(...) {
        arglist <- list(...)
        argnum <- 0
        if (length(arglist) > 0) {
          if ("curve" %in% names(arglist)){
            private$curve <- arglist[["curve"]]
            argnum <- argnum + 1
          }
          if ("minStepSize" %in% names(arglist)){
            private$minStepSize <- arglist[["minStepSize"]]
            argnum <- argnum + 1
          }
          if (length(arglist) != argnum) {
            stop("Invalid argument")
          }
        }
      },
      set_curve = function(val) {private$curve <- val},
      set_minStepSize = function(val) {private$minStepSize <- val}
    ),
    private = list(
      f_wrapper = function(sdat, retval, auc) {
        .prroc_wrapper(sdat, retval, auc, private$curve, private$minStepSize)
      },
      curve = TRUE,
      minStepSize = 0.01
    )
  )
  toolclass
}

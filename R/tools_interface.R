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
#' @export
create_tools <- function(tool_names = c("ROCR", "AUCCalculator", "PerfMeas",
                                        "PRROC", "precrec")) {

  tfunc <- function(tool_name) {
    tool_generator(tool_name)$new()
  }
  tools <- lapply(tool_names, tfunc)
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
      set_java_call = function(type, fpath = NULL) {
        if (type == "syscall") {
          private$java_call <- .create_syscall_auccalc(fpath)
        } else if (type == "rjava") {
          private$java_call <- .create_rjava_auccalc(fpath)
        }
      }
    ),
    private = list(
      f_wrapper = function(sdat, retval, auc) {
        .auccalc_wrapper(sdat, retval, auc, private$java_call)
      },
      java_call = .create_syscall_auccalc()
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

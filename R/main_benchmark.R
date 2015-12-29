#' Run microbenchmark with specified sets of tools and sets of sample datasets
#'
#' The \code{run_benchmark} function runs
#'     \code{\link[microbenchmark]{microbenchmark}} for specified sets of tools
#'     and sets of sample datasets
#'
#' @param samp_names A character vector to specify the names of sample sets
#'     for \code{\link{create_sample}}.
#'
#' @param tool_names A character vector to specify the names of tool sets for
#'     \code{\link{create_tools}}.
#'
#' @param times The number of iteration used in
#'     \code{\link[microbenchmark]{microbenchmark}}.
#'
#' @param unit A single string to specify the unit used in
#'     \code{\link[microbenchmark]{summary.microbenchmark}}.
#'
#' @return A data frame with microbenchmark results.
#'
#' @seealso \code{\link[microbenchmark]{microbenchmark}} for benchmarking details.
#'    \code{\link{create_sample}} to generate sample datasets.
#'    \code{\link{create_tools}} to create sets of tools.
#'
#'
#' @examples
#' ## Generate a sample dataset
#' tdat <- create_samplesets(c("b100", "ib100"))
#' tools <- create_tools(c("crv5", "auc5", "both5"))
#' res1 <- run_benchmark(tdat, tools)
#'
#' @export
run_benchmark <- function(testdat, tools, times = 5, unit = "ms") {

  testdatasets <- rep(testdat, length(tools))
  toolsets <- rep(tools, each = length(testdat))

  bmfunc <- function(i) {
    bres <- .benchmark_wrapper(testdatasets[[i]],
                               toolsets[[i]],
                               times = times, unit = unit)
    bres$sampset <- names(testdatasets)[i]
    bres$toolset <- names(toolsets)[i]
    bres
  }

  res <- lapply(seq_along(testdatasets), bmfunc)
  df_res <- do.call(rbind, res)
  df_res
}

#
# Run microbenchmark with a specified set of tools and a sample dataset
#
.benchmark_wrapper <- function(testdata, tools, times = 5, unit = "ms") {
  if (!requireNamespace("microbenchmark", quietly = TRUE)) {
    stop("microbenchmark needed for this function to work. Please install it.",
         call. = FALSE)
  }

  bmfunc <- function(tfunc) {
    mres <- microbenchmark::microbenchmark(tfunc(testdata), times = times)
    summres <- summary(mres, unit = unit)
    summres$expr <- names(tfunc)
    summres
  }

  res <- lapply(tools, bmfunc)
  df_res <- do.call(rbind, res)
  df_res$tool <- rownames(df_res)
  rownames(df_res) <- NULL
  df_res
}

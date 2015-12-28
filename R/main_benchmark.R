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
#' res1 <- run_benchmark(c("b100", "ib100"), c("crv5", "auc5", "both5"))
#'
#' @export
run_benchmark <- function(samp_names = c("b100", "ib100", "b10k", "ib10k"),
                          tool_names = c("crv5", "auc5", "both5"),
                          times = 5, unit = "ms") {

  samps <- lapply(samp_names, create_sample)
  names(samps) <- samp_names
  tools <- lapply(tool_names, create_tools)
  names(tools) <- tool_names

  new_samp_names <- rep(samp_names, length(tool_names))
  new_tool_names <- rep(tool_names, each = length(samp_names))

  bmfunc <- function(i) {
    bres <- .benchmark_wrapper(samps[[new_samp_names[i]]],
                               tools[[new_tool_names[i]]],
                               times = times, unit = unit)
    bres$sampset <- new_samp_names[i]
    bres$toolset <- new_tool_names[i]
    bres
  }

  res <- lapply(seq_along(new_samp_names), bmfunc)
  df_res <- do.call(rbind, res)
  df_res
}

#
# Run microbenchmark with a specified set of tools and a sample dataset
#
.benchmark_wrapper <- function(sdat, tool_funcs, times = 5, unit = "ms") {
  if (!requireNamespace("microbenchmark", quietly = TRUE)) {
    stop("microbenchmark needed for this function to work. Please install it.",
         call. = FALSE)
  }

  bmfunc <- function(tfunc) {
    mres <- microbenchmark::microbenchmark(tfunc(sdat), times = times)
    summres <- summary(mres, unit = unit)
    summres$expr <- names(tfunc)
    summres
  }

  res <- lapply(tool_funcs, bmfunc)
  df_res <- do.call(rbind, res)
  df_res$tool <- rownames(df_res)
  rownames(df_res) <- NULL
  df_res
}

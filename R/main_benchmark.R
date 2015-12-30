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
#' tdat <- create_testdata("random", c("b10", "i10"))
#' tools <- create_tools(set_names = c("crv5", "auc5", "both5"))
#' res1 <- run_benchmark(tdat, tools)
#'
#' @export
run_benchmark <- function(testdat, tools, times = 5, unit = "ms") {
  if (!requireNamespace("microbenchmark", quietly = TRUE)) {
    stop("microbenchmark needed for this function to work. Please install it.",
         call. = FALSE)
  }

  new_testdat <- rep(testdat, length(tools))
  new_tools <- rep(tools, length(testdat))

  bmfunc <- function(i) {
    tool <- new_tools[[i]]
    testdata <- new_testdat[[i]]
    res <- microbenchmark::microbenchmark(tool$call(testdata), times = times)
    sdf <- summary(res, unit = unit)
    sdf$expr <- NULL
    ddf <- data.frame(dsname = testdata$get_dsname(),
                      toolset = tool$get_setname(),
                      toolname = tool$get_toolname())
    cbind(ddf, sdf)
  }
  res_df <- do.call(rbind, lapply(seq_along(new_testdat), bmfunc))
  sorted_df <- res_df[order(res_df$dsname, res_df$toolset, res_df$toolname), ]
  rownames(sorted_df) <- 1:nrow(sorted_df)
  sorted_df
}

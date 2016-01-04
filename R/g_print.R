#
# Print benchmark result
#
#' @export
print.benchmark <- function(x, digits = 2, ...) {
  print(x$tab, digits = digits)
}

#
# Print curve evaluation result
#
#' @export
print.evalcurve <- function(x, data_type = "summary", ...) {
  if (data_type == "summary") {
    newdf <- x$testsum[, c("testset", "toolset", "toolname", "label")]
    names(newdf) <- c("testset", "toolset", "toolname", "score")
    print(newdf)
  } else if (data_type == "all") {
    print(x$testscores)
  } else if (data_type == "basepoints") {
    print(x$basepoints)
  } else if (data_type == "predictions") {
    print(x$predictions)
  } else if (data_type == "rawsummary") {
    print(x$testsum)
  }
}

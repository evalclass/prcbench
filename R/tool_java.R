#
# AUCCalculator
#
.auccalc_wrapper <- function(testset, auc2, calc_auc = FALSE,
                             store_res = TRUE) {

  # Prepare data
  dpath <- testset$get_fname()

  # Calculate Precision-Recall curve
  res <- rJava::.jcall(auc2, "[F", "calcCurves", dpath)

  # Get AUC
  aucscore <- NA
  if (calc_auc) {
    aucscore <- res[2]
  }

  # Return x and y values if requested
  if (store_res) {
    x <- rJava::.jcall(auc2, "[F", "getX")
    y <- rJava::.jcall(auc2, "[F", "getY")
    rval <- list(x = x, y = y, auc = aucscore)
  } else {
    rval <- NULL
  }

  # Delete output files
  rJava::.jcall(auc2, "V", "delFiles")

  rval
}

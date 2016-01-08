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
  res <- tryCatch(
    rJava::.jcall(auc2, "S", "delFiles"),
    error = function(e) {
      print(e)
    }
  )

  if (res != "deleted") {
    del_auc_files(dpath)
  }

  rval
}

#
# Delete a file
#
del_auc_files <- function(fname) {
  fnames <- paste0(fname, c(".roc", ".pr", ".spr"))

  for (i in 1:length(fnames)) {
    if (file.exists(fnames[i])) {
      tryCatch(
        file.remove(fnames[i]),
        warning = function(w) {
          print(w)
        },
        error = function(e) {
          print(e)
        }
      )
    }
  }

}

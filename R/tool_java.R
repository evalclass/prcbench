#
# AUCCalculator
#
.auccalc_wrapper <- function(testset, auc2, calc_auc = FALSE,
                             store_res = TRUE, auctype = "java") {

  # Prepare data
  dpath <- testset$get_fname()

  # Calculate Precision-Recall curve
  res <- rJava::.jcall(auc2, "[D", "calcCurves", dpath)

  # Get AUC
  aucscore <- NA
  if (calc_auc) {
    if (auctype == "java") {
      aucscore <- res[2]
    } else if (auctype == "r") {
      x <- rJava::.jcall(auc2, "[D", "getX")
      y <- rJava::.jcall(auc2, "[D", "getY")
      x <- c(0, rJava::.jcall(auc2, "[D", "getX"))
      y <- c(rval$y[1], rval$y)

      aucscore <- 0
      for (i in 2:length(x)) {
        aucscore <- aucscore + 0.5 * (x[i] - x[i-1]) * (y[i] + y[i-1])
      }
    }
  }

  # Return x and y values if requested
  if (store_res) {
    x <- rJava::.jcall(auc2, "[D", "getX")
    y <- rJava::.jcall(auc2, "[D", "getY")
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
    .del_auc_files(dpath)
  }

  rJava::.jcall(auc2, "V", "clear")

  rval
}

#
# Delete a file
#
.del_auc_files <- function(fname) {
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

#
# Load java object
#
.load_java_obj <- function(obj_name, jarpath, curvetype) {
  rJava::.jinit()
  rJava::.jaddClassPath(jarpath)
  auc2 <- rJava::.jnew("auc2/AUCWrapper")
  rJava::.jcall(auc2, "V", "setCurveType", curvetype)

  auc2
}

#
# Get java object
#
.get_java_obj <- memoise::memoise(.load_java_obj)

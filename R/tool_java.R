#
# Create rJava interface to AUCCalculator
# (Use system2 version below if AUC is needed
#  since neither capture.output nor sink captures stdout with .jcall)
#
.create_rjava_auccalc <- function(fpath = NULL) {
  if (!requireNamespace("rJava", quietly = TRUE)) {
    stop("rJava needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (is.null(fpath) || is.na(fpath)) {
    fpath <- system.file("java", "auc.jar", package = "prcbench")
  }

  rJava::.jinit()
  rJava::.jaddClassPath(fpath)

  rjava_auccalc <- function(dpath) {
    rJava::.jcall("auc/AUCCalculator", "V", "main", c(dpath, "list"))
  }
}

#
# Create system call for AUCCalculator
#
.create_syscall_auccalc <- function(fpath = NULL) {
  if (is.null(fpath) || is.na(fpath)) {
    fpath <- system.file("java", "auc.jar", package = "prcbench")
  }

  jar_str <- paste("-jar", fpath)
  syscall_auccalc <- function(dpath) {
    arg_str <- paste(jar_str, dpath, "list")
    system2("java", arg_str, stdout = TRUE)
  }
}

#
# AUCCalculator
#
.auccalc_wrapper <- function(testset, calc_auc = FALSE, store_res = TRUE,
                             auccalc_call = NULL) {

  # Prepare data
  dpath <- testset$get_fname()

  # Calculate Precison-Recall curve
  if (is.null(auccalc_call)) {
    auccalc_call <- .create_syscall_auccalc()
  }
  res <- auccalc_call(dpath)

  # Get AUC
  aucscore <- NA
  if (calc_auc) {
    auc_line <- "Area Under the Curve for Precision - Recall is "
    auc_line_no <- grep(auc_line, res)
    if (length(auc_line_no) != 0) {
      aucscore <- as.numeric(sub(auc_line, "", res[auc_line_no]))
    }
  }

  # Get output file names
  prfname <- paste0(dpath, ".pr")
  rocfname <- paste0(dpath, ".roc")
  sprfname <- paste0(dpath, ".spr")

  # Return x and y values if requested
  if (store_res) {
    spr <- read.table(sprfname, sep = "\t", col.names = c("x", "y"))
    rval <- list(x = spr["x"], y = spr["y"], auc = aucscore)
  } else {
    rval <- NULL
  }

  # Delete output files
  delfunc <- function(fname) {
    if (file.exists(fname)) {
      file.remove(fname)
    }
  }
  for (fn in c(prfname, rocfname, sprfname)) {
    delfunc(fn)
  }

  rval
}

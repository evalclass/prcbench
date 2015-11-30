#
# Create rJava interface to AUCCalculator
# (Use system2 version below if AUC is needed
#  since neither capture.output nor sink captures stdout with .jcall)
#
create_rjava_auccalc <- function(fpath = NULL) {
  if (!requireNamespace("rJava", quietly = TRUE)) {
    stop("rJava needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (is.null(fpath)) {
    fpath <- system.file("extdata", "auc.jar", package = "prcbenchmark")
  }

  rJava::.jinit()
  rJava::.jaddClassPath(fpath)

  rjava_auccalc <- function(dpath) {
    rJava::.jcall("auc/AUCCalculator", "V", "main", c(dpath, "list"))
  }
}
def_rjava_auccalc <- create_rjava_auccalc()

#
# Create system call for AUCCalculator
#
create_syscall_auccalc <- function(fpath = NULL) {
  if (is.null(fpath)) {
    fpath <- system.file("extdata", "auc.jar", package = "prcbenchmark")
  }

  jar_str <- paste("-jar", fpath)
  syscall_auccalc <- function(dpath) {
    arg_str <- paste(jar_str, dpath, "list")
    system2("java", arg_str, stdout = TRUE)
  }
}
def_syscall_auccalc <- create_syscall_auccalc()

#
# AUCCalculator
#
auccalc_wrapper <- function(sdat, modname, retval = TRUE, auc = FALSE,
                            auccalc_call = def_syscall_auccalc) {

  # Prepare data
  dpath <- sdat$dpath

  # Calculate Precison-Recall curve
  res <- auccalc_call(dpath)

  # Get AUC
  aucscore <- NA
  if (auc) {
    auc_line <- "Area Under the Curve for Precision - Recall is "
    auc_line_no <- grep(auc_line, res)
    if (length(auc_line_no) != 0) {
      aucscore <- as.numeric(sub(auc_line, "", res[auc_line_no]))
    }
  }

  # Return x and y values if requested
  if (retval) {
    sprpath <- paste0(dpath, ".spr")
    spr <- read.table(sprpath, sep = "\t", col.names = c("x", "y"))
    data.frame(x = spr["x"], y = spr["y"], modname = rep(modname, length(x)))
  } else {
    NULL
  }
}

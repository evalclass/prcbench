# Input scores and labels
m1_s <- c(3, 2, 2, 1)
m1_l <- c(1, 0, 1, 0)

m2_s <- c(3, 3, 2, 1)
m2_l <- c(1, 0, 0, 1)

m3_s <- c(4, 3, 2, 1)
m3_l <- c(0, 0, 1, 1)

m4_s <- c(8, 7, 6, 5, 4, 3, 1, 1)
m4_l <- c(1, 1, 1, 0, 0, 0, 1, 0)

# Calculated base points
bp_m1_x <- c(0, 0.25, 0.5, 0.75, 1, 1)
bp_m1_y <- c(1, 1, 1, 0.75, 0.6666666667, 0.5)

bp_m2_x <- c(0, 0.25, 0.5, 0.5, 0.75, 1)
bp_m2_y <- c(0.5, 0.5, 0.5, 0.3333333333, 0.4285714286, 0.5)

bp_m3_x <- c(0, 0.25, 0.5, 0.75, 1)
bp_m3_y <- c(0, 0.2, 0.3333333333, 0.4285714286, 0.5)

bp_m4_x <- c(0, 0.25, 0.5, 0.75, 0.75, 0.75, 0.75, 0.875, 1)
bp_m4_y <- c(1, 1, 1, 1, 0.75, 0.6, 0.5, 0.5, 0.5)

# Text position
tp_m1_x <- 0.85
tp_m1_y <- 0.9
tp_m2_x <- 0.2
tp_m2_y <- 0.65
tp_m3_x <- 0.8
tp_m3_y <- 0.2
tp_m4_x <- 0.8
tp_m4_y <- 0.2

# Text position 2
tp_m1_x2 <- 0.9
tp_m1_y2 <- 0.9
tp_m2_x2 <- 0.2
tp_m2_y2 <- 0.75
tp_m3_x2 <- 0.8
tp_m3_y2 <- 0.2
tp_m4_x2 <- 0.8
tp_m4_y2 <- 0.2

# Create data
# C1
C1DATA <- list(
  scores = m1_s,
  labels = m1_l,
  bp_x = bp_m1_x,
  bp_y = bp_m1_y,
  tp_x = tp_m1_x,
  tp_y = tp_m1_y,
  tp_x2 = tp_m1_x2,
  tp_y2 = tp_m1_y2
)
devtools::use_data(C1DATA, overwrite = TRUE)

# C2
C2DATA <- list(
  scores = m2_s,
  labels = m2_l,
  bp_x = bp_m2_x,
  bp_y = bp_m2_y,
  tp_x = tp_m2_x,
  tp_y = tp_m2_y,
  tp_x2 = tp_m2_x2,
  tp_y2 = tp_m2_y2
)
devtools::use_data(C2DATA, overwrite = TRUE)

# C3
C3DATA <- list(
  scores = m3_s,
  labels = m3_l,
  bp_x = bp_m3_x,
  bp_y = bp_m3_y,
  tp_x = tp_m3_x,
  tp_y = tp_m3_y,
  tp_x2 = tp_m3_x2,
  tp_y2 = tp_m3_y2
)
devtools::use_data(C3DATA, overwrite = TRUE)

# C4
C4DATA <- list(
  scores = m4_s,
  labels = m4_l,
  bp_x = bp_m4_x,
  bp_y = bp_m4_y,
  tp_x = tp_m4_x,
  tp_y = tp_m4_y,
  tp_x2 = tp_m4_x2,
  tp_y2 = tp_m4_y2
)
devtools::use_data(C4DATA, overwrite = TRUE)

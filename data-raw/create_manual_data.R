
# Input scores and labels
m1_s <- c(3, 2, 2, 1)
m1_l <- c(1, 0, 1, 0)

m2_s <- c(3, 3, 2, 1)
m2_l <- c(1, 0, 0, 1)

m3_s <- c(4, 3, 2, 1)
m3_l <- c(0, 0, 1, 1)

# Calculated base points
bp_m1_x <- c(0, 0.25, 0.5, 0.75, 1, 1)
bp_m1_y <- c(1, 1, 1, 0.75, 0.6666666667, 0.5)

bp_m2_x <- c(0, 0.25, 0.5, 0.5, 0.75, 1)
bp_m2_y <- c(0.5, 0.5, 0.5, 0.3333333333, 0.4285714286, 0.5)

bp_m3_x <- c(0, 0, 0, 0.25, 0.5, 0.75, 1)
bp_m3_y <- c(0, 0, 0, 0.2, 0.3333333333, 0.4285714286, 0.5)

# Line types
lt_m1 <- c("h", "h", "c", "c", "v")
lt_m2 <- c("h", "h",  "v", "c", "c")
lt_m3 <- c("p", "p", "c", "c", "c", "c")

# Text position
tp_m1_x <- 0.85
tp_m1_y <- 0.9
tp_m2_x <- 0.2
tp_m2_y <- 0.65
tp_m3_x <- 0.8
tp_m3_y <- 0.2

# Create data
# M1
M1DATA <- list(
  scores = m1_s,
  labels = m1_l,
  bp_x = bp_m1_x,
  bp_y = bp_m1_y,
  line_type = lt_m1,
  tp_x = tp_m1_x,
  tp_y = tp_m1_y
)
devtools::use_data(M1DATA, overwrite = TRUE)

# M2
M2DATA <- list(
  scores = m2_s,
  labels = m2_l,
  bp_x = bp_m2_x,
  bp_y = bp_m2_y,
  line_type = lt_m2,
  tp_x = tp_m2_x,
  tp_y = tp_m2_y
)
devtools::use_data(M2DATA, overwrite = TRUE)

# M3
M3DATA <- list(
  scores = m3_s,
  labels = m3_l,
  bp_x = bp_m3_x,
  bp_y = bp_m3_y,
  line_type = lt_m3,
  tp_x = tp_m3_x,
  tp_y = tp_m3_y
)
devtools::use_data(M3DATA, overwrite = TRUE)
# =============================================================================
# Data preparation helpers
# Project: Bayesian Workplace Stress Analysis
# =============================================================================

source("R/data_dictionary.R")

expected_raw_files <- function() {
  c(
    "TP1_FINAL_public_V5.csv",
    "TP2_FINAL_public_V3.csv",
    "TP3_FINAL_public.csv",
    "TP4_FINAL_public_V3.csv",
    "haircortisoltp1and2.csv"
  )
}

check_raw_files <- function(raw_dir = "data/raw") {
  expected <- expected_raw_files()
  present <- list.files(raw_dir)
  missing <- setdiff(expected, present)

  if (length(missing) > 0) {
    stop(
      "Missing expected raw files:\n",
      paste(missing, collapse = "\n"),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

load_timepoint_data <- function(raw_dir = "data/raw") {
  check_raw_files(raw_dir)

  files <- c(
    tp1 = "TP1_FINAL_public_V5.csv",
    tp2 = "TP2_FINAL_public_V3.csv",
    tp3 = "TP3_FINAL_public.csv",
    tp4 = "TP4_FINAL_public_V3.csv"
  )

  lapply(names(files), function(tp) {
    dat <- read_raw_csv(file.path(raw_dir, files[[tp]]))
    dat$time_point <- tp
    dat
  }) |>
    stats::setNames(names(files))
}

summarise_timepoints <- function(timepoint_data) {
  data.frame(
    time_point = names(timepoint_data),
    rows = vapply(timepoint_data, nrow, integer(1)),
    columns = vapply(timepoint_data, ncol, integer(1)),
    stringsAsFactors = FALSE
  )
}

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

audit_study_ids <- function(timepoint_data, id_col = "StudyID") {
  do.call(rbind, lapply(names(timepoint_data), function(tp) {
    dat <- timepoint_data[[tp]]

    if (!id_col %in% names(dat)) {
      return(data.frame(
        time_point = tp,
        rows = nrow(dat),
        unique_ids = NA_integer_,
        missing_ids = NA_integer_,
        duplicated_ids = NA_integer_,
        stringsAsFactors = FALSE
      ))
    }

    ids <- as.character(dat[[id_col]])
    missing_ids <- is.na(ids) | ids == ""

    data.frame(
      time_point = tp,
      rows = nrow(dat),
      unique_ids = length(unique(ids[!missing_ids])),
      missing_ids = sum(missing_ids),
      duplicated_ids = sum(duplicated(ids[!missing_ids])),
      stringsAsFactors = FALSE
    )
  }))
}

build_id_overlap_matrix <- function(timepoint_data, id_col = "StudyID") {
  ids <- lapply(timepoint_data, function(dat) {
    if (!id_col %in% names(dat)) {
      return(character())
    }

    values <- as.character(dat[[id_col]])
    unique(values[!is.na(values) & values != ""])
  })

  overlap <- outer(
    names(ids),
    names(ids),
    Vectorize(function(a, b) length(intersect(ids[[a]], ids[[b]])))
  )

  dimnames(overlap) <- list(names(ids), names(ids))
  overlap
}

find_summary_columns <- function(timepoint_data) {
  patterns <- "sum|total|score|scale|mean|av$|avg"

  do.call(rbind, lapply(names(timepoint_data), function(tp) {
    dat <- timepoint_data[[tp]]
    cols <- grep(patterns, names(dat), ignore.case = TRUE, value = TRUE)

    if (length(cols) == 0) {
      return(data.frame())
    }

    data.frame(
      time_point = tp,
      column = cols,
      missing_rate = vapply(dat[cols], function(x) mean(is.na(x) | x == ""), numeric(1)),
      stringsAsFactors = FALSE
    )
  }))
}

profile_numeric_columns <- function(timepoint_data, columns_table) {
  do.call(rbind, lapply(seq_len(nrow(columns_table)), function(i) {
    tp <- columns_table$time_point[i]
    col <- columns_table$column[i]
    values <- suppressWarnings(as.numeric(timepoint_data[[tp]][[col]]))
    observed <- values[!is.na(values)]

    data.frame(
      time_point = tp,
      column = col,
      n_observed = length(observed),
      mean = if (length(observed) > 0) mean(observed) else NA_real_,
      sd = if (length(observed) > 1) stats::sd(observed) else NA_real_,
      min = if (length(observed) > 0) min(observed) else NA_real_,
      max = if (length(observed) > 0) max(observed) else NA_real_,
      stringsAsFactors = FALSE
    )
  }))
}

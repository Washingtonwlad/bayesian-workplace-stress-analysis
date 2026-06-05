# =============================================================================
# Data dictionary helpers
# Project: Bayesian Workplace Stress Analysis
# =============================================================================

raw_file_inventory <- function(raw_dir = "data/raw") {
  files <- list.files(raw_dir, full.names = TRUE, recursive = FALSE)

  data.frame(
    file = basename(files),
    extension = tools::file_ext(files),
    size_kb = round(file.info(files)$size / 1024, 1),
    stringsAsFactors = FALSE
  )
}

read_raw_csv <- function(path) {
  read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
}

csv_column_inventory <- function(raw_dir = "data/raw") {
  csv_files <- list.files(raw_dir, pattern = "\\.csv$", full.names = TRUE)

  do.call(rbind, lapply(csv_files, function(path) {
    dat <- read_raw_csv(path)
    data.frame(
      file = basename(path),
      rows = nrow(dat),
      columns = ncol(dat),
      column = names(dat),
      missing_rate = vapply(dat, function(x) mean(is.na(x) | x == ""), numeric(1)),
      stringsAsFactors = FALSE
    )
  }))
}

find_candidate_columns <- function(column_inventory, patterns) {
  pattern <- paste(patterns, collapse = "|")
  column_inventory[grepl(pattern, column_inventory$column, ignore.case = TRUE), ]
}

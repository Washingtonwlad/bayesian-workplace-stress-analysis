# =============================================================================
# Bayesian model helpers
# Project: Bayesian Workplace Stress Analysis
# =============================================================================

required_model_packages <- function() {
  c("brms", "posterior", "bayesplot", "loo")
}

check_model_packages <- function() {
  pkgs <- required_model_packages()
  data.frame(
    package = pkgs,
    installed = vapply(pkgs, requireNamespace, logical(1), quietly = TRUE),
    stringsAsFactors = FALSE
  )
}

#' Internal Project Constants and Path Configuration
#'
#' This file provides a centralized location for directory paths and project-wide
#' constants. Similar to a 'constants.py' in Python, this ensures consistency
#' and easier maintenance across the MCMC engine.
#'
#' @keywords internal
project_config <- list(
  # --- Input Templates ---
  template_dir = "inst/rmarkdown/templates",
  diagnostic_template = "diagnostics_appendix.Rmd",

  # --- Default Output Directories ---
  assets_dir = "assets/diagnostics",
  forecast_assets_dir = "assets/forecasting",
  reports_dir = "docs/reports",

  # --- Simulation Defaults ---
  default_sim_burn_in = 100,

  # --- MCMC Engine Defaults ---
  default_n_iter = 10000,
  default_burn_in = 1000,

  # --- Prior Hyperparameters ---
  prior_mu0 = 0, # Scalar to be repeated if necessary
  prior_Lambda0_diag = 100, # Large variance for uninformative prior
  prior_a0 = 2,
  prior_b0 = 1,

  # --- Ground Truth Benchmark (Phase 3 & 5) ---
  true_beta = c(10, 0.5, 0.2), # Intercept and phi coefficients
  true_sigma2 = 1, # Error variance (sigma squared)
  sim_n = 250, # Synthetic observations
  demo_n_iter = 2000, # Iterations for rapid verification
  demo_burn_in = 500, # Burn-in for rapid verification

  # --- Visualization Defaults ---
  plot_dpi = 300,
  plot_width = 8,
  plot_height = 6
)

#' Helper to resolve template paths across environments
#' @keywords internal
get_template_path <- function(template_name) {
  # 1. Check if installed package (system.file)
  tp <- system.file(file.path("rmarkdown/templates", template_name), package = "bayesian.mcmc.engine")

  # 2. Check local development path
  if (tp == "" || !file.exists(tp)) {
    local_tp <- file.path("inst/rmarkdown/templates", template_name)
    if (file.exists(local_tp)) {
      tp <- local_tp
    }
  }

  tp
}

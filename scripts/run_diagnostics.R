# Phase 5: MCMC Diagnostics and Results Validation
pkgload::load_all(".")

message("--- PHASE 5: MCMC DIAGNOSTICS ---\n")

# 1. Establish Ground Truth via Centralized Config
set.seed(42)
message("1. Simulating AR(2) process...")
y <- simulate_ar_process(
    n = project_config$sim_n,
    intercept = project_config$true_beta[1],
    phi = project_config$true_beta[2:3],
    sigma = sqrt(project_config$true_sigma2)
)

# 2. Fit Model via Gibbs Sampler
message("2. Fitting Bayesian AR(2) model (", project_config$demo_n_iter, " iterations)...")
fit <- run_gibbs_sampler(
    y = y,
    p = length(project_config$true_beta) - 1,
    n_iter = project_config$demo_n_iter,
    burn_in = project_config$demo_burn_in
)

# 3. Generate Diagnostics & Appendix
message("3. Generating Automated Diagnostic Appendix...")
generate_diagnostic_appendix(
    fit,
    true_params = list(beta = project_config$true_beta, sigma2 = project_config$true_sigma2),
    output_dir = project_config$assets_dir
)

message("\nDEMO COMPLETE.")
message("Assets Location: ", project_config$assets_dir, "/")
message("Report Location: ", project_config$reports_dir, "/diagnostics_result.pdf")

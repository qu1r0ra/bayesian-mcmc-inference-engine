# Demonstration Script for Phase 5 Diagnostics
pkgload::load_all(".")

message("--- PHASE 5: MCMC DIAGNOSTICS DEMONSTRATION ---\n")

# 1. Establish Ground Truth
set.seed(42)
true_beta <- c(10, 0.5, 0.2)
true_sigma2 <- 1

message("1. Simulating AR(2) process...")
y <- simulate_ar_process(
    n = 250,
    intercept = true_beta[1],
    phi = true_beta[2:3],
    sigma = sqrt(true_sigma2)
)

# 2. Fit Model via Gibbs Sampler
message("2. Fitting Bayesian AR(2) model (2000 iterations)...")
fit <- run_gibbs_sampler(
    y = y,
    p = 2,
    n_iter = 2000,
    burn_in = 500
)

# 3. Generate Diagnostics & Appendix
message("3. Generating Automated Diagnostic Appendix...")
generate_diagnostic_appendix(
    fit,
    true_params = list(beta = true_beta, sigma2 = true_sigma2),
    output_dir = "assets/figures/diagnostics/"
)

message("\nDEMO COMPLETE.")
message("Assets: assets/figures/diagnostics/")
message("Report: docs/reports/appendices/diagnostics_result.pdf")

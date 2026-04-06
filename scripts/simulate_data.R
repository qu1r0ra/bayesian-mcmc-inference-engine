# Phase 3: Ground Truth Data Simulation
pkgload::load_all(".")

message("--- PHASE 3: AR(p) DATA SIMULATION ---\n")

# 1. Establish Ground Truth via Centralized Config
set.seed(42)
message("1. Generating synthetic AR(2) series...")
y <- simulate_ar_process(
    n = project_config$sim_n,
    intercept = project_config$true_beta[1],
    phi = project_config$true_beta[2:3],
    sigma = sqrt(project_config$true_sigma2)
)

message("2. Time Series Summary:")
print(summary(y))

message("\nSimulation check COMPLETE.")

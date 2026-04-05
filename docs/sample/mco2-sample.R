#### Simulated Data Generation ####
# 1. Define dimensions
n <- 300
p <- 2

# 2. Set the TRUE parameters (Intercept, phi coefficients, sigma)
true_intercept <- 10
true_phi <- c(0.5, 0.2)
true_sigma <- 1
true_sigma2 <- true_sigma^2

# 3. Simulate AR(p) time series data
y_sim <- simulate_ar_process(
  n = n,
  intercept = true_intercept,
  phi = true_phi,
  sigma = true_sigma
)

#### MCMC Implementation in R ####
n_iter <- 5000
burn_in <- 1000

cat("Starting Gibbs sampler...\n")

fit <- run_gibbs_sampler(
  y = y_sim,
  p = p,
  n_iter = n_iter,
  burn_in = burn_in
)

cat("Gibbs sampler completed.\n")

# Discard Burn-in
posterior_beta <- fit$beta_samples
posterior_sigma2 <- fit$sigma2_samples

#### Diagnostics and Inference ####
results_table <- data.frame(
  Parameter = c("Intercept", "Phi1", "Phi2", "Sigma2"),
  True_Value = c(true_intercept, true_phi[1], true_phi[2], true_sigma2),
  Posterior_Mean = c(
    colMeans(posterior_beta)[1],
    colMeans(posterior_beta)[2],
    colMeans(posterior_beta)[3],
    mean(posterior_sigma2)
  )
)

results_table$True_Value <- round(results_table$True_Value, 3)
results_table$Posterior_Mean <- round(results_table$Posterior_Mean, 3)

print(results_table)
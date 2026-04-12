# Phase 6: Posterior Predictive Forecasting
pkgload::load_all(".")
library(ggplot2)

message("--- PHASE 6: CLOUD BILLING FORECASTING ---\n")

# 1. Regenerate Data and MCMC fit 
set.seed(project_config$default_seed)
message("1. Running Gibbs Sampler to generate posterior samples...")
y <- simulate_ar_process(
  n = project_config$sim_n,
  intercept = project_config$true_beta[1],
  phi = project_config$true_beta[2:3],
  sigma = sqrt(project_config$true_sigma2)
)

fit <- run_gibbs_sampler(
  y = y, 
  p = length(project_config$true_beta) - 1, 
  n_iter = project_config$demo_n_iter, 
  burn_in = project_config$demo_burn_in
)

# Combine beta and sigma2 samples into one matrix to feed into our function
samples_matrix <- cbind(fit$beta_samples, sigma2 = fit$sigma2_samples)

# 2. Generate Forecasts
message("2. Projecting the next 30 days of billing...")
pred_matrix <- forecast_ar_process(y = y, p = fit$p, samples = samples_matrix, h = 30)

# 3. Calculate Summary Statistics
forecast_summary <- data.frame(
  Day = 1:30,
  Mean = apply(pred_matrix, 2, mean),
  Lower_95 = apply(pred_matrix, 2, quantile, probs = 0.025),
  Upper_95 = apply(pred_matrix, 2, quantile, probs = 0.975)
)

# 4. Plot the Posterior Predictive Distribution
forecast_plot <- ggplot(forecast_summary, aes(x = Day)) +
  geom_ribbon(aes(ymin = Lower_95, ymax = Upper_95), fill = "steelblue", alpha = 0.3) +
  geom_line(aes(y = Mean), color = "blue", linewidth = 1) +
  labs(title = "30-Day AWS/GCP Billing Forecast via Bayesian AR(p)",
       subtitle = "Shaded region represents the 95% Credible Interval",
       x = "Days Ahead",
       y = "Projected Cost ($)") +
  theme_minimal()

print(forecast_plot)

# 5. Save the plot
out_path <- file.path(project_config$forecast_assets_dir, "30_day_projection.png")
if (!dir.exists(project_config$forecast_assets_dir)) dir.create(project_config$forecast_assets_dir, recursive = TRUE)

ggplot2::ggsave(out_path, forecast_plot, 
                width = project_config$plot_width, 
                height = project_config$plot_height, 
                dpi = project_config$plot_dpi)

message("SUCCESS: Forecasting complete. Plot saved to ", out_path)
#### Simulated Data Generation ####
# 1. Define dimensions
N <- 1000 # Number of emails
P <- 4    # Number of features (Intercept + 3 variables)

# 2. Set the TRUE beta coefficients (Intercept, "free", "urgent", "attachment")
true_beta <- c(-1.5, 2.0, 1.2, -0.8)

# 3. Simulate feature data
X <- cbind(1, matrix(rnorm(N * (P - 1)), nrow = N, ncol = P - 1))

# 4. Calculate true probabilities and generate binary labels (0 = Ham, 1 = Spam)
psi <- X %*% true_beta
p_true <- 1 / (1 + exp(-psi))
y <- rbinom(N, size = 1, prob = p_true)

#### MCMC Implementation in R ####
library(pgdraw)
library(MASS)
library(coda)

n_iter <- 5000
burn_in <- 1000

b_0 <- rep(0, P)                
B_0 <- diag(10, P)              
B_0_inv <- solve(B_0)           
kappa <- y - 0.5

beta_samples <- matrix(0, nrow = n_iter, ncol = P)
beta_current <- rep(0, P)       

cat("Starting MCMC...\n")
for (iter in 1:n_iter) {
  
  # Step 1: Sample latent variables omega_i | beta
  psi <- as.vector(X %*% beta_current)
  omega <- pgdraw(1, psi) 
  
  # Step 2: Sample beta | y, omega
  Omega_diag <- omega
  Xt_Omega_X <- t(X) %*% sweep(X, 1, Omega_diag, "*")
  V_omega <- chol2inv(chol(Xt_Omega_X + B_0_inv))
  m_omega <- V_omega %*% (t(X) %*% kappa + B_0_inv %*% b_0)
  
  beta_current <- mvrnorm(1, mu = m_omega, Sigma = V_omega)
  beta_samples[iter, ] <- beta_current
  
  # Step 3: Interim console output for monitoring
  if (iter %% 1000 == 0) cat("Completed iteration:", iter, "\n")
}

# Discard Burn-in
posterior_beta <- beta_samples[(burn_in + 1):n_iter, ]

#### Figure 1 ####
library(ggplot2)
library(tidyr)

# 1. Convert the raw samples matrix into a data frame
trace_df <- as.data.frame(beta_samples)
colnames(trace_df) <- c("Intercept", "Word_Free", "Word_Urgent", "Has_Attachment")

# Add a column for the iteration number
trace_df$Iteration <- 1:nrow(trace_df)

# 2. Reshape the data from "wide" to "long" format (required by ggplot2 for faceting)
trace_long <- pivot_longer(trace_df, 
                           cols = c("Intercept", "Word_Free", "Word_Urgent", "Has_Attachment"), 
                           names_to = "Parameter", 
                           values_to = "Sample_Value")

# 3. Create a reference data frame for your TRUE values
# This ensures the correct red line is drawn on the correct sub-plot
true_values_df <- data.frame(
  Parameter = c("Intercept", "Word_Free", "Word_Urgent", "Has_Attachment"),
  True_Value = c(-1.5, 2.0, 1.2, -0.8) # Matches the true_beta from Section 3
)

# 4. Generate the Plot
figure_1 <- ggplot(trace_long, aes(x = Iteration, y = Sample_Value)) +
  
  # A. Plot the actual MCMC chain (The "random walk")
  geom_line(color = "steelblue", alpha = 0.7) +
  
  # B. Overlay the true parameter value as a dashed red line
  geom_hline(data = true_values_df, aes(yintercept = True_Value), 
             color = "red", linetype = "dashed", linewidth = 1) +
  
  # C. Add a vertical dotted line to show where burn-in ends (Iteration 1000)
  geom_vline(xintercept = 1000, color = "black", linetype = "dotted", linewidth = 1) +
  
  # D. Split the plot into a 2x2 grid based on the Parameter name
  facet_wrap(~ Parameter, scales = "free_y") +
  
  # E. Add clean, academic labels
  labs(title = "Figure 1: MCMC Trace Plots for Spam Classification Weights",
       subtitle = "Dotted black line marks end of burn-in. Dashed red line is the true underlying parameter value.",
       x = "Algorithm Iteration",
       y = "Parameter Estimate") +
  
  # Use a clean, minimal theme perfect for PDF reports
  theme_minimal() +
  theme(strip.text = element_text(face = "bold", size = 10))

# Display the plot
print(figure_1)

#### Diagnostics and Inference ####
feature_names <- c("Intercept", "Word_Free", "Word_Urgent", "Has_Attachment")
colnames(posterior_beta) <- feature_names
mcmc_chain <- mcmc(posterior_beta)

# Parameter Recovery
library(bayesplot)
library(ggplot2)
summary_stats <- summary(mcmc_chain)$quantiles
results_table <- data.frame(
  True_Beta = true_beta,
  Posterior_Mean = colMeans(posterior_beta),
  Lower_95_CI = summary_stats[, 1],
  Upper_95_CI = summary_stats[, 5]
)
print(round(results_table, 3))

# Ensure required visualization packages are loaded
# install.packages(c("bayesplot", "ggplot2")) # Run if needed

#### Figure 2 ####
feature_names <- c("Intercept", "Spam Word: 'Free'", "Spam Word: 'Urgent'", "Has Attachment")
colnames(posterior_beta) <- feature_names

# --- 1. Set bayesplot Theme/Color Scheme ---
# 'blue' provides a clean, professional aesthetic for reports.
color_scheme_set("blue")

# --- 2. Generate the MCMC Areas Plot ---
# mcmc_areas() is the ideal function for visualizing density + uncertainty
figure_2 <- mcmc_areas(
  posterior_beta,         # Matrix of posterior samples (post burn-in)
  prob = 0.95,            # Visually shade the central 95% Credible Interval
  point_est = "mean",     # Mark the posterior mean with a vertical line
  pars = feature_names    # Explicitly plot our named features
) +
  
  # --- 3. Add Custom Styling and Professional Labels ---
  ggtitle("Figure 2: Posterior Distributions of Spam Classification Weights",
          subtitle = "Shaded areas represent 95% certainty (Credible Intervals). Vertical lines represent posterior means.") +
  labs(x = "Regression Coefficient Value (Beta Estimation)",
       y = "Feature Variable") +
  
  # Apply minimal theme and adjust font styling for PDF compilation
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 12),
        axis.title = element_text(size = 10),
        axis.text.y = element_text(face = "bold"))

# --- 4. Display and Save the Final Output ---
print(figure_2)

#### Posterior Predictive Checks ####
# 1. Define a new, unseen email (e.g., contains "Free" but no "Urgent" or Attachment)
x_new <- c(1, 2.5, 0, 0) # Intercept, Word_Free=2.5, Word_Urgent=0, Has_Attachment=0

# 2. Calculate the linear predictor (psi) for ALL 4000 posterior samples
psi_new <- posterior_beta %*% x_new 

# 3. Transform to probability scale using the logistic function
p_new_samples <- 1 / (1 + exp(-psi_new))

# 4. Calculate predictive metrics
p_mean <- mean(p_new_samples)
p_lower <- quantile(p_new_samples, 0.025)
p_upper <- quantile(p_new_samples, 0.975)

cat("Posterior Predictive Probability of Spam:\n")
cat("Mean Probability:", round(p_mean, 3), "\n")
cat("95% CI: [", round(p_lower, 3), ",", round(p_upper, 3), "]\n")

#### Output Table and Figure 3 ####
library(ggplot2)
library(knitr)

# --- 1. Generate the Table Output ---
# Create a data frame for the table
predictive_table <- data.frame(
  Metric = c("Mean Probability", "Lower 95% CI Bound", "Upper 95% CI Bound"),
  Value = c(round(p_mean, 3), round(p_lower, 3), round(p_upper, 3))
)

# Use knitr::kable to format it beautifully for a PDF/Markdown report
cat("\n--- Posterior Predictive Probability of Spam ---\n")
print(kable(predictive_table, align = "lc"))

# --- 2. Generate Figure 3 (The Histogram) ---
# Convert samples to a data frame for ggplot2
p_df <- data.frame(Probability = p_new_samples)

figure_3 <- ggplot(p_df, aes(x = Probability)) +
  # Draw the histogram bars
  geom_histogram(fill = "steelblue", color = "black", bins = 40, alpha = 0.7) +
  
  # Overlay the Mean as a dashed red line
  geom_vline(xintercept = p_mean, color = "red", linetype = "dashed", linewidth = 1.2) +
  
  # Overlay the 95% Credible Interval bounds as dotted black lines
  geom_vline(xintercept = p_lower, color = "black", linetype = "dotted", linewidth = 1) +
  geom_vline(xintercept = p_upper, color = "black", linetype = "dotted", linewidth = 1) +
  
  # Set the x-axis limits to highlight that these are probabilities (approaching 1.0)
  coord_cartesian(xlim = c(0.85, 1.0)) +
  
  # Add titles and labels corresponding to your report
  labs(title = "Figure 3: Posterior Predictive Distribution of Spam Probability",
       subtitle = "Dashed red line indicates the mean (0.975). Dotted black lines represent the 95% CI [0.932, 0.994].",
       x = "Calculated Probability of Being Spam",
       y = "Frequency (MCMC Samples)") +
  
  # Clean theme for academic/professional reporting
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 12),
        axis.title = element_text(size = 10))

# Display the plot
print(figure_3)
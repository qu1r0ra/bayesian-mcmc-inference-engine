#' Simulate AR(p) Time Series for Ground Truth
#'
#' Generates a synthetic time series following an AR(p) process with a constant term.
#'
#' @param n Total number of observations to generate.
#' @param intercept The constant term \(c\).
#' @param phi A numeric vector of autoregressive coefficients \(\phi_1, \dots, \phi_p\).
#' @param sigma The standard deviation of the error term \(\epsilon_t\).
#' @param burn_in Number of initial observations to discard to stabilize the series.
#' @return A numeric vector of length \(n\).
#' @export
simulate_ar_process <- function(n, intercept, phi, sigma, burn_in = project_config$default_sim_burn_in) {
  p <- length(phi)
  total_n <- n + burn_in
  y <- numeric(total_n)

  # Initialize the process using its theoretical stationary mean
  # This reduces the transient period needed to reach the steady state.
  y[1:p] <- rnorm(p, mean = intercept / (1 - sum(phi)), sd = sigma)

  # Iteratively generate observations following the AR(p) process equation:
  # y_t = c + phi1*y_{t-1} + ... + phip*y_{t-p} + epsilon_t
  for (t in (p + 1):total_n) {
    y[t] <- intercept + sum(phi * rev(y[(t - p):(t - 1)])) + rnorm(1, 0, sigma)
  }

  # Discard the initial transient 'burn-in' observations
  y[(burn_in + 1):total_n]
}

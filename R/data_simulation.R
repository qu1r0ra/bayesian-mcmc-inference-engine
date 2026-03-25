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
simulate_ar_process <- function(n, intercept, phi, sigma, burn_in = 100) {
  p <- length(phi)
  total_n <- n + burn_in
  y <- numeric(total_n)

  # Initialize with random noise
  y[1:p] <- rnorm(p, mean = intercept / (1 - sum(phi)), sd = sigma)

  for (t in (p + 1):total_n) {
    y[t] <- intercept + sum(phi * rev(y[(t - p):(t - 1)])) + rnorm(1, 0, sigma)
  }

  # Return only the post-burn-in series
  y[(burn_in + 1):total_n]
}

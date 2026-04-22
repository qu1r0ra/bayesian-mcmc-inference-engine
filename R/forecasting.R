#' Generate Posterior Predictive Forecast
#'
#' Forecasts the next \(h\) periods using the posterior samples.
#'
#' @param y Observed time series.
#' @param p Order of the AR process.
#' @param samples Posterior samples from the Gibbs sampler (matrix of betas and sigma2).
#' @param h Forecast horizon (e.g., 30 days).
#' @return A distribution of future series values.
#' @export
forecast_ar_process <- function(y, p, samples, h = 30) {
  n_samples <- nrow(samples)
  predictions <- matrix(0, nrow = n_samples, ncol = h)
  
  # Extract the most recent 'p' observations from the full time series
  last_y <- tail(y, p)
  
  for (i in 1:n_samples) {
    intercept <- samples[i, 1]
    phis <- samples[i, 2:(p + 1)]
    
    sigma <- sqrt(samples[i, ncol(samples)]) 
    
    current_history <- last_y
    
    for (t in 1:h) {
      # Calculate mean: c + phi_1*y_{t-1} + ... + phi_p*y_{t-p}
      mu <- intercept + sum(rev(current_history) * phis)
      
      # Sample from the predictive posterior Gaussian
      y_pred <- rnorm(1, mean = mu, sd = sigma)
      predictions[i, t] <- y_pred
      
      # Shift the history window forward by 1 day
      current_history <- c(current_history[-1], y_pred)
    }
  }
  
  return(predictions)
}

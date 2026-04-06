#' Prepare Autoregressive Design Matrix
#'
#' This function creates the lagged design matrix \(X\) for an AR(p) model.
#'
#' @param y A numeric vector of time series observations.
#' @param p The number of lags (autoregressive order).
#' @param intercept Logical; if TRUE, includes a column of ones for the constant term.
#' @return A matrix with \(n - p\) rows and \(p + (intercept)\) columns.
#' @export
create_design_matrix <- function(y, p, intercept = TRUE) {
  n <- length(y)
  if (n <= p) stop("Series length must be greater than number of lags.")

  # Create lagged columns
  x_cols <- lapply(1:p, function(i) y[(p - i + 1):(n - i)])
  x_mat <- do.call(cbind, x_cols)

  if (intercept) {
    x_mat <- cbind(1, x_mat)
  }

  x_mat
}

#' Create Response Vector for AR(p) Model
#'
#' This function extracts the response vector \(Y\) corresponding to the AR(p) regression form.
#'
#' @param y A numeric vector of time series observations.
#' @param p The number of lags (autoregressive order).
#' @return A numeric vector of length \(n - p\).
#' @export
create_response_vector <- function(y, p) {
  n <- length(y)

  if (n <= p) {
    stop("Series length must be greater than number of lags.")
  }

  # Response starts from y_{p+1} to y_n
  y[(p + 1):n]
}

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

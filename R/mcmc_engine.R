#' Bayesian MCMC AR(p) Gibbs Sampler
#'
#' Fits an AR(p) model using a Bayesian Gibbs sampling approach with conjugate priors.
#'
#' @param y Numeric vector of the observed time series.
#' @param p Integer; the order of the autoregressive process.
#' @param n_iter Total number of MCMC iterations.
#' @param burn_in Number of initial iterations to discard.
#' @param priors A list containing hyperparameters for the MVN and IG priors.
#' @return A list containing the posterior samples for \(\beta\) and \(\sigma^2\).
#' @export
run_gibbs_sampler <- function(y, p, n_iter = 10000, burn_in = 1000, priors = NULL) {
  if (!is.numeric(y)) {
    stop("y must be a numeric vector.")
  }

  if (length(y) <= p) {
    stop("Series length must be greater than number of lags.")
  }

  if (p < 1 || p != as.integer(p)) {
    stop("p must be a positive integer.")
  }

  if (n_iter <= burn_in) {
    stop("n_iter must be greater than burn_in.")
  }

  X <- create_design_matrix(y, p, intercept = TRUE)
  Y <- create_response_vector(y, p)

  n_obs <- length(Y)
  k <- ncol(X)

  if (is.null(priors)) {
    priors <- list(
      mu0 = rep(0, k),
      Lambda0 = diag(100, k),
      a0 = 2,
      b0 = 1
    )
  }

  mu0 <- priors$mu0
  Lambda0 <- priors$Lambda0
  a0 <- priors$a0
  b0 <- priors$b0

  if (length(mu0) != k) {
    stop("Length of mu0 must match the number of coefficients.")
  }

  if (!is.matrix(Lambda0) || !all(dim(Lambda0) == c(k, k))) {
    stop("Lambda0 must be a k x k matrix.")
  }

  if (a0 <= 0 || b0 <= 0) {
    stop("a0 and b0 must be positive.")
  }

  Lambda0_inv <- solve(Lambda0)
  XtX <- crossprod(X)
  XtY <- crossprod(X, Y)

  beta_samples <- matrix(NA_real_, nrow = n_iter, ncol = k)
  sigma2_samples <- numeric(n_iter)

  colnames(beta_samples) <- c("intercept", paste0("phi", seq_len(p)))

  beta_curr <- rep(0, k)
  sigma2_curr <- var(Y)

  for (iter in seq_len(n_iter)) {
    Lambda_n <- solve(Lambda0_inv + (1 / sigma2_curr) * XtX)
    mu_n <- Lambda_n %*% (Lambda0_inv %*% mu0 + (1 / sigma2_curr) * XtY)

    z <- rnorm(k)
    chol_Lambda_n <- chol(Lambda_n)
    beta_curr <- as.vector(mu_n + t(chol_Lambda_n) %*% z)

    resid <- Y - X %*% beta_curr
    a_n <- a0 + n_obs / 2
    b_n <- b0 + 0.5 * drop(crossprod(resid))

    sigma2_curr <- rinvgamma(1, shape = a_n, scale = b_n)

    beta_samples[iter, ] <- beta_curr
    sigma2_samples[iter] <- sigma2_curr
  }

  keep_idx <- (burn_in + 1):n_iter

  list(
    beta_samples = beta_samples[keep_idx, , drop = FALSE],
    sigma2_samples = sigma2_samples[keep_idx],
    full_beta_samples = beta_samples,
    full_sigma2_samples = sigma2_samples,
    X = X,
    Y = Y,
    p = p,
    n_iter = n_iter,
    burn_in = burn_in,
    priors = priors
  )
}

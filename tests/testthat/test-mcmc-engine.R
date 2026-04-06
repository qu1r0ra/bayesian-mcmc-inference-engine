test_that("create_response_vector returns correct response vector", {
  y <- 1:10
  p <- 2
  Y <- create_response_vector(y, p)

  expect_equal(length(Y), 8)
  expect_equal(Y[1], 3)
  expect_equal(Y[8], 10)
})

test_that("rinvgamma returns positive samples", {
  x <- rinvgamma(100, shape = 2, scale = 1)

  expect_equal(length(x), 100)
  expect_true(all(x > 0))
})

test_that("run_gibbs_sampler returns valid posterior samples", {
  set.seed(123)

  y <- simulate_ar_process(
    n = 100,
    intercept = 10,
    phi = c(0.5, 0.2),
    sigma = 1
  )

  fit <- run_gibbs_sampler(
    y = y,
    p = 2,
    n_iter = 500,
    burn_in = 100
  )

  expect_true(is.list(fit))
  expect_equal(nrow(fit$beta_samples), 400)
  expect_equal(ncol(fit$beta_samples), 3)
  expect_equal(length(fit$sigma2_samples), 400)
  expect_true(all(is.finite(fit$beta_samples)))
  expect_true(all(is.finite(fit$sigma2_samples)))
  expect_true(all(fit$sigma2_samples > 0))
})

test_that("run_gibbs_sampler approximately recovers true parameters", {
  set.seed(123)

  true_intercept <- 10
  true_phi <- c(0.5, 0.2)
  true_sigma <- 1

  y <- simulate_ar_process(
    n = 400,
    intercept = true_intercept,
    phi = true_phi,
    sigma = true_sigma
  )

  fit <- run_gibbs_sampler(
    y = y,
    p = 2,
    n_iter = 3000,
    burn_in = 1000
  )

  beta_mean <- colMeans(fit$beta_samples)
  sigma2_mean <- mean(fit$sigma2_samples)

  expect_true(abs(beta_mean[1] - true_intercept) < 3.0)
  expect_true(abs(beta_mean[2] - true_phi[1]) < 0.2)
  expect_true(abs(beta_mean[3] - true_phi[2]) < 0.2)
  expect_true(abs(sigma2_mean - true_sigma^2) < 0.5)
})

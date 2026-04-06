test_that("summarize_mcmc_results returns structured data frame", {
  set.seed(42)
  # Mock samples
  beta_samples <- matrix(rnorm(300), ncol = 3, dimnames = list(NULL, c("intercept", "phi1", "phi2")))
  sigma2_samples <- rgamma(100, 2, 1)

  all_samples <- cbind(beta_samples, sigma2_samples)
  colnames(all_samples)[4] <- "sigma2"

  summary_res <- summarize_mcmc_results(all_samples)

  expect_s3_class(summary_res, "data.frame")
  expect_equal(nrow(summary_res), 4)
  expect_true(all(c("Parameter", "Mean", "ESS") %in% colnames(summary_res)))
  expect_true(all(is.numeric(summary_res$Mean)))
  expect_true(all(summary_res$ESS > 0))
})

test_that("diagnostic plots return ggplot objects", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("bayesplot")

  set.seed(42)
  samples <- rnorm(100)

  p_trace <- plot_mcmc_trace(samples, "param1", true_value = 0)
  p_dens <- plot_posterior_density(samples, "param1", true_value = 0)
  p_acf <- plot_mcmc_acf(samples, "param1")
  p_rank <- plot_mcmc_rank(samples, "param1")

  expect_s3_class(p_trace, "ggplot")
  expect_s3_class(p_dens, "ggplot")
  expect_s3_class(p_acf, "ggplot")
  expect_s3_class(p_rank, "ggplot")
})

test_that("generate_diagnostic_appendix runs without error", {
  # Mock fit object
  fit <- list(
    beta_samples = matrix(rnorm(60), ncol = 2, dimnames = list(NULL, c("intercept", "phi1"))),
    sigma2_samples = rgamma(30, 2, 1)
  )

  # Run in a temp directory to avoid cluttering local assets during tests
  temp_assets <- file.path(tempdir(), "test_assets")

  # Mock the PDF rendering check by locally overriding the condition if necessary
  # or just let it skip the PDF if rmarkdown is not available in the test env.
  expect_no_error({
    generate_diagnostic_appendix(fit, output_dir = temp_assets)
  })

  # Check if PNGs were created
  expect_true(file.exists(file.path(temp_assets, "intercept_trace.png")))
  expect_true(file.exists(file.path(temp_assets, "phi1_trace.png")))
  expect_true(file.exists(file.path(temp_assets, "sigma2_trace.png")))
})

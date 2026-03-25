test_that("create_design_matrix handles basic inputs", {
  y <- 1:10
  p <- 2
  X <- create_design_matrix(y, p, intercept = TRUE)

  expect_equal(nrow(X), 8)
  expect_equal(ncol(X), 3)
  expect_equal(X[1, 1], 1) # Intercept
})

test_that("simulate_ar_process produces correct series length", {
  n <- 50
  phi <- c(0.5, 0.2)
  y_sim <- simulate_ar_process(n, intercept = 10, phi = phi, sigma = 1)

  expect_length(y_sim, n)
})

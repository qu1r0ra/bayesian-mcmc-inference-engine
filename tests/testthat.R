# Entry point for R CMD check to run the test suite
library(testthat)
library(bayesian.mcmc.engine)

test_check("bayesian.mcmc.engine")

# Project Implementation Checklist (DAT004M) <!-- omit from toc -->

- [x] Phase 1: Problem Definition & Selection (Topic 10: Cloud Billing)
- [x] Phase 2: Mathematical Formulation (AR(p) + Gibbs Sampler)
- [x] Phase 3: MCMC Logic & Implementation (The Engine)
- [x] Phase 4: Ground Truth Simulation & Verification (The Ground Truth)
- [ ] Phase 5: Diagnostics & Results
- [ ] Phase 6: Forecasting & Uncertainty Quantification
- [ ] Phase 7: Final Documentation & Report

## Phase 1: Problem Definition & Selection

- [x] **Select Computational Problem**
  - [x] Topic 10: Autoregressive AR(p) Time Series selected.
- [x] **Define ML/Statistical Challenge**
  - [x] Explain AWS/GCP daily billing temporal dependencies.
- [x] **Justify Bayesian Approach**
  - [x] Contrast with frequentist point estimates.
  - [x] Explain value of uncertainty quantification in production risk-management.

## Phase 2: Mathematical Formulation

- [x] **Define the Generative Model**
  - [x] Specify the AR(p) process equations.
  - [x] Define the constant term (intercept).
- [x] **Specify Prior Distributions**
  - [x] Justify Multivariate Normal for coefficients.
  - [x] Justify Inverse-Gamma for error variance.
- [x] **Derive Full Conditional Distributions**
  - [x] Posterior of coefficients given variance.
  - [x] Posterior of variance given coefficients.

## Phase 3: MCMC Logic & Implementation

- [x] **Initialize the Gibbs Sampler**
  - [x] Set up iterative loop and parameter storage.
- [x] **Update Matrix Algebra**
  - [x] Create design matrix (X) with p-lags.
  - [x] Implement vectorsized calculations.
- [x] **Manage MCMC Transitions**
  - [x] Draw from conditional posteriors every iteration.
  - [x] Implement proper burn-in period.

## Phase 4: Ground Truth Simulation & Verification

- [x] **Generate Synthetic AR(p) Series**
  - [x] Set "true" parameters (c, phi, sigma).
  - [x] Simulate series using the process equation.
- [x] **Parameter Recovery Check**
  - [x] Feed synthetic series to the MCMC engine.
  - [x] Verify posterior means match "true" values.

## Phase 5: Diagnostics & Results

- [ ] **Verify Chain Convergence**
  - [ ] Generate trace plots for all parameters.
  - [ ] Check mixing and stationarity.
- [ ] **Quantify Posterior Evidence**
  - [ ] Calculate Effective Sample Size (ESS).
  - [ ] Generate kernel density plots of posteriors.

## Phase 6: Forecasting & Uncertainty Quantification

- [ ] **Simulate Predictive Future**
  - [ ] Iteratively generate next 30 days of billing.
- [ ] **Quantify Range of Outcomes**
  - [ ] Calculate 95% credible intervals for predictions.
  - [ ] Generate probabilistic "fan plots" for forecasting.

## Phase 7: Final Documentation & Report

- [ ] **Compose Technical Report**
  - [ ] Compile LaTeX source into final PDF.
- [ ] **Final Packaging**
  - [ ] Ensure README, NAMESPACE, and documentation are synchronized.

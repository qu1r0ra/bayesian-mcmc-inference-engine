# Bayesian MCMC Inference Engine - Project Checklist

## Phase 1: Problem Definition & Selection

- [ ] **Select Computational Problem**
  - [x] Topic 10: Autoregressive AR(p) Time Series selected.
- [ ] **Define ML/Statistical Challenge**
  - [ ] Explain AWS/GCP daily billing temporal dependencies.
- [ ] **Justify Bayesian Approach**
  - [ ] Contrast with frequentist point estimates.
  - [ ] Explain value of uncertainty quantification in production risk-management.

## Phase 2: Mathematical Formulation

- [ ] **Rigorous Model definition**
  - [ ] Define AR(p) process with intercept.
- [ ] **Explicit Likelihood Function**
  - [ ] Derive the joint likelihood for the time series.
- [ ] **Prior Specification & Justification**
  - [ ] Define MVN prior for coefficients ($\beta$).
  - [ ] Define Inverse-Gamma prior for error variance ($\sigma^2$).
- [ ] **Analytical Derivations**
  - [ ] Derive full conditional distribution for $\beta$.
  - [ ] Derive full conditional distribution for $\sigma^2$.
- [ ] **Technical Discussion**
  - [ ] Explain Gibbs Sampling mechanics for the chosen model.

## Phase 3: Ground Truth Simulation

- [ ] **Develop Simulation Script**
  - [ ] Create `R/simulate_data.R`.
- [ ] **Pre-define Ground Truth Parameters**
  - [ ] Set known "True" values for $\phi_i$ and $\sigma$.
- [ ] **Algorithmic Debugging Tool**
  - [ ] Ensure the sampler can recover these specific known values.

## Phase 4: MCMC Engine Implementation

- [ ] **Implement Pure R Sampler**
  - [ ] Build iterative Gibbs loop from scratch.
- [ ] **Console Feedback**
  - [ ] Implement `txtProgressBar` or equivalent.
- [ ] **Avoid External Black-Boxes**
  - [ ] Ensure no reliance on Stan/JAGS for core implementation.

## Phase 5: Chain Mixing & Diagnostics

- [ ] **Verification of Stationarity**
  - [ ] Identify and discard burn-in period.
- [ ] **Visual Proofs**
  - [ ] Generate publication-quality trace plots.
  - [ ] Generate posterior density plots with 95% Credible Intervals.
- [ ] **Quantitative Efficiency**
  - [ ] Calculate Effective Sample Size (ESS) for all parameters.

## Phase 6: Inference & Risk-Aware Prediction

- [ ] **Posterior Predictive Distribution**
  - [ ] Feed new synthetic data points.
  - [ ] Calculate full distribution of future costs.
- [ ] **Forecasting Logic**
  - [ ] Forecast next 30 days with expanding 95% CIs.
- [ ] **Final Analysis**
  - [ ] Explain how a production system uses these uncertainty metrics for defensive decisions.

## Final Submission

- [ ] **Technical Report (.pdf)**
  - [ ] Structured exactly according to 6 phases.
  - [ ] Clean math formatting (LaTeX).
- [ ] **Annotated Code Reproducibility**
  - [ ] All .R scripts documented and runnable.

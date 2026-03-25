# bayesian-mcmc-inference-engine <!-- omit from toc -->

<!-- ![title](./assets/readme/title.png) -->

<!-- Refer to https://shields.io/badges for usage -->

![Year, Term, Course](https://img.shields.io/badge/AY2526--T2-DAT004M-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white)

A Bayesian inference pipeline with a custom Markov Chain Monte Carlo (MCMC) engine using autoregressive (AR) time series forecasting for cloud compute billing prediction. Created for DAT004M (Probability and Statistics).

## Table of Contents <!-- omit from toc -->

- [1. Introduction](#1-introduction)
- [2. Project Structure](#2-project-structure)
- [3. Running the Project](#3-running-the-project)
  - [3.1. Prerequisites](#31-prerequisites)
  - [3.2. CLI Entry Points](#32-cli-entry-points)
  - [3.3. Reproducing the Results](#33-reproducing-the-results)
- [4. References](#4-references)

## 1. Introduction

This project implements a comprehensive **Bayesian Inference Engine** from scratch in R. It focuses on modeling and forecasting the temporal dependencies in **AWS/GCP Cloud Compute Billing** data using an Autoregressive AR($p$) process.

Unlike traditional frequentist methods that provide simple point-estimate forecasts, this engine leverages **Markov Chain Monte Carlo (MCMC)** sampling—specifically a **Gibbs Sampler**—to recover the full posterior distribution of model parameters. This allows for rigorous **Uncertainty Quantification**, providing decision-makers with 95% credible intervals to make risk-aware predictions about future infrastructure costs.

## 2. Project Structure

A high-level overview of the repository organization:

```text
.
├── DESCRIPTION             # R Package manifest and dependencies
├── Makefile                # Unified task runner (Check, Test, Simulate)
├── NAMESPACE               # (Generated) Package exports and imports
├── R/                      # Core MCMC Engine modules
│   ├── data_simulation.R   # Ground truth AR(p) generation (Phase 3)
│   ├── diagnostics.R       # Chain mixing and ESS calculations (Phase 5)
│   ├── forecasting.R       # Posterior predictive forecasting (Phase 6)
│   ├── mcmc_engine.R       # Core Gibbs sampling logic (Phase 4)
│   └── utils.R             # Matrix prep and time-series lags
├── docs/                   # Full project documentation
│   ├── architecture.md     # Technical design and logic overview
│   ├── math/               # LaTeX-based mathematical derivations
│   ├── reports/            # Placeholder for final PDF submission
│   ├── sample/             # Benchmark samples and output expectations
│   └── specs/              # Course requirements and phase tracking
├── man/                    # (Generated) Help documentation (.Rd files)
├── misc/                   # Internal context and reference materials
│   ├── context/            # AI Agent persistent memory
│   └── materials/          # Lecture slides and reference papers
└── tests/                  # Unit testing suite (testthat)
```

For a detailed look at the internal design, statistical methodology, and mathematical derivations, see [architecture.md](docs/architecture.md) and [math_derivation.md](docs/math/math_derivation.md).

## 3. Running the Project

### 3.1. Prerequisites

To run the engine and development tools, you will need:

1. **R:** Version `4.1.0` or later is recommended.
2. **GNU Make:** (Optional) Highly recommended for automating tasks (installation, tests, and lints).

### 3.2. CLI Entry Points

This project provides unified `make` entry points for common tasks:

- **`make simulate`**: Runs the Phase 3 ground-truth data simulation to verify the sampler.
- **`make test`**: Executes the unit test suite in `tests/testthat/`.
- **`make doc`**: Rebuilds the package documentation and `NAMESPACE` via `roxygen2`.
- **`make lint`**: Performs static code analysis to ensure style consistency.
- **`make check`**: Runs the full local CI lifecycle (doc, format, lint, and test).

### 3.3. Reproducing the Results

1. Clone this repository:

   ```bash
   git clone https://github.com/qu1r0ra/bayesian-mcmc-inference-engine
   ```

2. Navigate to the project root and install dependencies:

   ```bash
   cd bayesian-mcmc-inference-engine
   make install
   ```

3. Run the ground-truth simulation and engine verification:

   ```bash
   make simulate
   ```

## 4. References

[1] Gelman, A., Carlin, J. B., Stern, H. S., Dunson, D. B., Vehtari, A., & Rubin, D. B. (2013). _Bayesian Data Analysis_. CRC Press.

[2] Robert, C. P., & Casella, G. (2010). _Monte Carlo Statistical Methods_. Springer Science & Business Media.

[3] Box, G. E., Jenkins, G. M., Reinsel, G. C., & Ljung, G. M. (2015). _Time Series Analysis: Forecasting and Control_. John Wiley & Sons.

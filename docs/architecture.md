# Project Architecture

This document describes the architectural design and directory structure of the `bayesian-mcmc-inference-engine` project. It serves as a guide for understanding the core components of the Bayesian AR($p$) time-series forecasting engine.

## Directory Structure Overview

```text
.
├── .github/                # CI/CD Workflows (GitHub Actions)
├── .vscode/                # Editor-specific configurations
├── assets/                 # MCMC diagnostic and forecast PNG assets
│   ├── diagnostics/        # Automated MCMC diagnostic PNGs (Phase 5)
│   └── forecasting/        # Future billing projections (Phase 6)
├── docs/                   # Project documentation
│   ├── architecture.md     # Technical design (this document)
│   ├── design/             # Math derivations and blueprints (Phase 2 & 5)
│   ├── reports/            # Output directory for final PDF reports
│   ├── sample/             # Reference materials and benchmark samples
│   └── specs/              # Course requirements and task tracking
├── inst/                   # Package assets for installation
│   └── rmarkdown/
│       └── templates/      # Automated PDF report templates (Phase 5)
├── man/                    # Generated help documentation (.Rd files)
├── misc/                   # Miscellaneous context and internal notes
│   ├── context/            # AI Agent persistent memory (metacontext.md)
│   ├── materials/          # Reference lecture slides and papers
│   └── personal/           # Developer notes and private checklists
├── R/                      # Core MCMC Engine modules
│   ├── config.R            # Project-wide constants and path manager
│   ├── data_simulation.R   # Ground truth AR(p) generation (Phase 3)
│   ├── diagnostics.R       # Chain mixing, ESS, and PDF automation (Phase 5)
│   ├── forecasting.R       # Posterior predictive forecasting (Phase 6)
│   ├── mcmc_engine.R       # Core Gibbs sampling loop (Phase 4)
│   └── utils.R             # Matrix prep and time-series lags
├── scripts/                # Execution entry points
│   └── demo_diagnostics.R  # End-to-end simulation and validation script
├── tests/                  # Unit testing suite (testthat)
│   ├── testthat/           # Component-specific test files
│   └── testthat.R          # Test entry point for the engine
├── .lintr                  # Static analysis and style configuration
├── .Rbuildignore           # Package build exclusion rules
├── DESCRIPTION             # R Package manifest and dependencies
├── LICENSE                 # MIT License details
├── Makefile                # Unified task runner (simulate, diagnostics, check)
├── NAMESPACE               # Generated package exports
└── NEWS.md                 # Project version history and changelog
```

## Core Design Principles

### 1. Fully Bayesian Uncertainty Quantification

Unlike frequentist methods that provide point estimates, this engine recovers the full posterior distribution of model parameters.

- **Credible Intervals:** We provide 95% Credible Intervals for all coefficients, offering a direct probabilistic interpretation of parameter uncertainty.
- **Risk-Aware Forecasting:** Predictions are delivered as distributions, allowing decision-makers to quantify the risk of extreme billing fluctuations.

### 2. Exact Gibbs Sampling (Conjugate Priors)

To ensure high-performance sampling without the tuning overhead of Metropolis-Hastings, the project leverages **Semi-Conjugate Priors**.

- **Vectorized Math:** The design matrix $X$ and posterior updates are implemented using optimized matrix algebra in R.
- **Analytical Accuracy:** We use closed-form full conditional distributions, ensuring the sampler reaches the stationary distribution efficiently.

### 3. Decoupled Engine Components

The engine is strictly modularized to support "Phase-based" development:

- **`mcmc_engine.R`**: The core iterative logic, decoupled from data source or plotting (Phase 4).
- **`data_simulation.R`**: Verification tool to establish a known ground truth (Phase 3).
- **`diagnostics.R`**: Visualization and convergence testing (Trace plots, density, ESS).

### 4. Unified R Package API

The project follows standard R package conventions. We use **`roxygen2`** for documentation management.

- Internal functions are documented alongside code.
- `make doc` synchronizes the `NAMESPACE` and user documentation.

## Statistical Methodology

The engine implements a Bayesian Autoregressive AR($p$) framework.

### 1. The Generative Model

For a time series $y_t$, the process is modeled as:
$$y_t = c + \sum_{i=1}^p \phi_i y_{t-i} + \epsilon_t, \quad \epsilon_t \sim N(0, \sigma^2)$$

Where $\beta = [c, \phi_1, \dots, \phi_p]^\top$ represents the regression weights (intercept and lags).

### 2. The Gibbs Sampler

The engine alternates between drawing from two conditional posteriors:

- **Coefficient Update:** $\beta | \sigma^2, Y \sim MVN(\mu_n, \Lambda_n)$
- **Variance Update:** $\sigma^2 | \beta, Y \sim IG(a_n, b_n)$

### 3. Posterior Predictive Check (PPC)

To validate the model's predictive power, we generate replications $\tilde{y}$ from the posterior distribution. This allows us to "simulate" the next 30 days of billing data based on the learned temporal dependencies.

## Tools & Dependencies

- **stats / graphics**: Core R statistical and plotting engines.
- **mvtnorm**: High-performance multivariate normal draws.
- **testthat**: Unit testing framework for mathematical consistency.
- **roxygen2**: Documentation and namespace management.
- **styler / lintr**: Code quality and standards enforcement.

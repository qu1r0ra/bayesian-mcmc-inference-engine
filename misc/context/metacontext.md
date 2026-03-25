# Metacontext

This document captures high-level insights, architectural decisions, and documented bottlenecks encountered during the development of this project. It serves as a persistent memory to avoid re-treading documented dead-ends and to understand the "why" behind specific design choices. It also stores project-specific preferences and style constraints to ensure consistency across the codebase.

## Project Preferences

- **Stylistic Constraints:** Avoid the use of emojis in any part of the project (code, documentation, or commit messages) to maintain a professional, academic tone.
- **Formatting:** Encourage the use of **Markdown** formatting and $\LaTeX$ mathematical notation for all technical variables and equations to ensure high readability and publication-quality documentation.

Our group chose **10. Autoregressive AR(p) Time Series Forecasting** from the topic list.

## Architectural Decisions

### Model Design

- **Structure:** AR($p$) model with a constant term (intercept).
- **Reasoning:** Daily cloud billing typically has a base cost (uptime/baseline services) that is not zero-centered. AR($p$) allows for capturing weekly ($p=7$) seasonality.
- **Constraints:** **Stationarity** will not be strictly enforced within the sampler to maintain speed and simplicity, but will be monitored as a diagnostic post-sampling.

### MCMC Strategy

- **Approach:** Pure **Gibbs Sampler** (Exact).
- **Priors:** Conjugate priors are used to allow for closed-form full conditionals.
  - **Coefficients ($\beta$):** Multivariate Normal (MVN) prior.
  - **Error Variance ($\sigma^2$):** Inverse-Gamma (IG) prior.
- **Implementation:** Pure R implementation for transparency and adherence to project "from-scratch" requirements. Optimization via `Rcpp` is deprioritized in favor of code clarity.

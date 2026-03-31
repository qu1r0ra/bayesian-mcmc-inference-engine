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

## External Library Context (context7)

To ensure accurate documentation retrieval for this Bayesian MCMC project, use the following `libraryId`s for `context7` queries:

| Library        | libraryId              | Purpose                                            |
| :------------- | :--------------------- | :------------------------------------------------- |
| **R Language** | `/wch/r-source`        | Base R, statistical functions, and S3/S4 methods   |
| **Tidyverse**  | `/tidyverse/tidyverse` | General data science workflow (includes `ggplot2`) |
| **ggplot2**    | `/tidyverse/ggplot2`   | Advanced plotting and visualization                |
| **testthat**   | `/r-lib/testthat`      | Unit testing and package validation                |

> [!TIP]
> For Bayesian-specific packages like `mvtnorm`, `invgamma`, `bayesplot`, or `coda`, you can attempt to resolve their IDs using the `resolve-library-id` tool if a direct query fails.

## Workflow & Documentation Decisions

### Phase Swap (MCMC vs. Simulation)

- **Phase 3 (MCMC Logic & Implementation)** and **Phase 4 (Simulation & Verification)** were swapped in the master plan.
- Building the engine logic first allows for mathematical unit testing against known distribution properties before generating the specific synthetic datasets.

### Reporting & Typography

- **Class:** **arXiv** one-column template (based on `arxiv.sty` and `article` class).
- **Typography:** The report structure is grouped into high-level **Methodology** and **Results and Discussion** chapters to improve narrative flow.
- Reduced the `\vskip` in `arxiv.sty` to provide a tighter, more modern academic appearance.

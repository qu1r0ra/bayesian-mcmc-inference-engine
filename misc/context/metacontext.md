# Metacontext

This document captures high-level insights, architectural decisions, and documented bottlenecks encountered during the development of this project. It serves as a persistent memory to avoid re-treading documented dead-ends and to understand the "why" behind specific design choices. It also stores project-specific preferences and style constraints to ensure consistency across the codebase.

## Project Preferences

- **Stylistic Constraints:** Avoid the use of emojis in any part of the project (code, documentation, or commit messages) to maintain a professional, academic tone.
- **Directory Protection:** **NEVER** modify or overwrite files in the `docs/sample/` directory. These are frozen as references provided by the instructor for compliance verification.
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
- **Library Permissions:** Based on the official `docs/sample/mco2-sample.R`, it is **confirmed** that specialized libraries (e.g., `MASS`, `coda`, `bayesplot`, `pgdraw`) are permitted for sampling individual components and diagnostics, provided the high-level MCMC loop itself is manually implemented.
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

### Implementation Milestones

- [x] **Phase 3 (Ground Truth Simulation & Verification):** Developed a ground-truth AR($p$) simulator and verified the data-generating process (GGP).
- [x] **Phase 4 (MCMC Logic & Implementation):** Successfully implemented the Gibbs sampler in `R/mcmc_engine.R` and verified parameter recovery via automated unit tests in `tests/testthat/test-mcmc-engine.R`.
- [x] **Phase 5 (Diagnostics & Results):** Successfully implemented the `bayesplot`/`ggplot2` diagnostic suite, automated high-resolution asset generation, and created the **Diagnostic Appendix PDF** via RMarkdown. All project constants and paths are now centralized in **`R/config.R`**. Renamed architectural logic directory to **`docs/design/`** for better context.
- **Status:** Phase 5 is 100% complete. The engine is robustly verified with 33 passing unit tests, zero lints, and a sequential execution pipeline via `make results`.
- **Phase 6 (Forecasting):** Initializing.

### Development Workflow

- **Phase Sequence:** Ground Truth Simulation (Phase 3) is established first to provide a "Gold Standard" for the Inference Engine (Phase 4).
- **Reasoning:** This allows us to verify that the MCMC engine correctly recovers known parameters, ensuring mathematical validity before applying the model to real-world billing data.

### Reporting & Typography

- **Class:** **arXiv** one-column template (based on `arxiv.sty` and `article` class).
- **Typography:** The report structure is grouped into high-level **Methodology** and **Results and Discussion** chapters to improve narrative flow.
- Reduced the `\vskip` in `arxiv.sty` to provide a tighter, more modern academic appearance.

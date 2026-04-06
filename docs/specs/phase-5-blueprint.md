# Phase 5: Diagnostics & Results Blueprint

This document specifies the technical implementation details for **Phase 5 (Diagnostics & Results)**. It establishes the library choice, visual design, and artifact generation strategy for the Bayesian AR($p$) inference engine.

## 1. Visual Design & Libraries

Following the project's goal for **Rich Aesthetics** and **Visual Excellence**, we will prioritize modern, publication-quality plotting libraries:

- **Primary Visuals:** `bayesplot` (high-level Bayesian visualization).
- **Foundation Styling:** `ggplot2` (custom themes and layouts).
- **Core Engine:** `coda` (for MCMC diagnostic calculation).

> [!NOTE]
> All plots should use the `ggplot2::theme_minimal()` or `bayesplot::theme_default()` with high resolution (300 DPI) for PDF generation.

## 2. Visualization Requirements

The following plots MUST be generated for each parameter ($\beta$ and $\sigma^2$):

| Plot Type        | Metric          | Description                                                               |
| :--------------- | :-------------- | :------------------------------------------------------------------------ |
| **Trace Plot**   | Mixing          | Shows the sampling path over the logic to verify stationarity and mixing. |
| **Density/Area** | Posterior       | Displays the distribution shape and 95% credible intervals.               |
| **ACF Plot**     | Autocorrelation | Quantifies the dependency between successive MCMC samples.                |
| **Rank Plot**    | Convergence     | Categorical visualization of histogram ranks to complement trace plots.   |

## 3. Quantitative Diagnostics

For every parameter trace, the system must calculate and output:

- **Mean / Median:** Point estimates of the recovered parameters.
- **Standard Deviation:** Quantification of posterior uncertainty.
- **95% HPD Intervals:** Highest Posterior Density intervals (or 2.5% and 97.5% quantiles).
- **ESS (Effective Sample Size):** The number of independent draws equivalent to the MCMC chain.
- **R-hat ($\hat{R}$):** To be added if multiple chains are implemented in the future.

## 4. Artifact Generation Strategy

Phase 5 will produce artifacts in two primary formats:

### A. Console Summary (Real-Time)

A clean, formatted table printed to the terminal once the sampling and diagnostics are complete:

```text
Parameter    Mean     SD      2.5%    97.5%    ESS
intercept    1.02     0.05    0.92    1.12     4500
phi1         0.51     0.02    0.47    0.55     5200
sigma2       1.01     0.08    0.86    1.18     3900
```

### B. PDF Report Appendix (Automated)

An automated script will generate a standalone **Diagnostic Appendix** PDF:

- **Location:** `docs/reports/appendices/diagnostics_result.pdf`
- **Individual Assets:** Standalone PNGs stored in `assets/figures/diagnostics/` for use in `main.tex`.

## 5. Directory Structure Preparation

Ensure the following paths are created:

- `assets/figures/diagnostics/`
- `docs/reports/appendices/`

## 6. Development Workflow

1. **Refactor `R/diagnostics.R`**: Replace Phase 5 placeholders with `bayesplot` and `ggplot2` logic.
2. **Verify via CLI**: Ensure `make check` and `make simulate` produce the results mentioned above.
3. **LaTeX Integration**: Update `docs/reports/main.tex` to include the figures as an appendix.

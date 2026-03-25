# Phase 2: Mathematical Derivations

This document outlines the theoretical framework for our AR($p$) Bayesian Inference Engine, following the **Gibbs Sampling** strategy.

## 1. The Model Specification: AR($p$)

$$y_t = c + \phi_1 y_{t-1} + \dots + \phi_p y_{t-p} + \epsilon_t, \quad \epsilon_t \sim N(0, \sigma^2)$$

Let $\beta = [c, \phi_1, \dots, \phi_p]^\top$. In matrix form:
$$Y = X\beta + \epsilon$$

Where:
s

- $Y$ is the $(n-p) \times 1$ vector of observations from $t = p+1$ to $n$.
- $X$ is the $(n-p) \times (p+1)$ design matrix containing the intercept and $p$ lagged values of $y$.
- $\epsilon \sim N(0, \sigma^2 I)$.

## 2. The Priors (Conjugate)

To allow for an exact Gibbs sampler, we assign the following semi-conjugate priors:

- **Coefficients:** $\beta \sim MVN(\mu_0, \Lambda_0)$
- **Error Variance:** $\sigma^2 \sim IG(a_0, b_0)$

## 3. The Full Conditional Distributions

For the Gibbs sampler, we alternate between drawing from $p(\beta | \sigma^2, Y)$ and $p(\sigma^2 | \beta, Y)$.

### 3.1. Full Conditional for $\beta$ (Posterior for coefficients)

Assuming $\sigma^2$ is known:
$$\beta | \sigma^2, Y \sim MVN(\mu_n, \Lambda_n)$$
Where:

- $\Lambda_n = (\Lambda_0^{-1} + \frac{1}{\sigma^2} X^\top X)^{-1}$
- $\mu_n = \Lambda_n (\Lambda_0^{-1}\mu_0 + \frac{1}{\sigma^2} X^\top Y)$

### 3.2. Full Conditional for $\sigma^2$ (Posterior for variance)

Assuming $\beta$ is known:
$$\sigma^2 | \beta, Y \sim IG(a_n, b_n)$$
Where:

- $a_n = a_0 + \frac{n-p}{2}$
- $b_n = b_0 + \frac{1}{2} (Y - X\beta)^\top (Y - X\beta)$

## 4. Sampling Loop Recap

1. Initialize $\beta^{(0)}$ and $(\sigma^2)^{(0)}$.
2. For $i$ from 1 to $N_{sim}$:
   a. Draw $\beta^{(i)} \sim MVN(\mu_n, \Lambda_n | (\sigma^2)^{(i-1)})$
   b. Draw $(\sigma^2)^{(i)} \sim IG(a_n, b_n | \beta^{(i)})$
3. Discard burn-in samples and proceed with diagnostics.

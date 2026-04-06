# Phase 2: Mathematical Derivations

This document outlines the theoretical framework for our AR($p$) Bayesian Inference Engine, following the **Gibbs Sampling** strategy.

## 1. The Model Specification: AR($p$)

$$y_t = c + \phi_1 y_{t-1} + \dots + \phi_p y_{t-p} + \epsilon_t, \quad \epsilon_t \sim N(0, \sigma^2)$$
Here, $c$ is the constant term (intercept), $\phi_1, \dots, \phi_p$ are the autoregressive coefficients, and $\sigma^2$ is the error variance.

Let $\beta = [c, \phi_1, \dots, \phi_p]^\top$. In matrix form:
$$Y = X\beta + \epsilon$$

Equivalently, $Y \mid \beta, \sigma^2 \sim N(X\beta, \sigma^2 I)$.

Where:

- $Y$ is the $(n-p) \times 1$ vector of observations from $t = p+1$ to $n$.
- $X$ is the $(n-p) \times (p+1)$ design matrix containing the intercept and $p$ lagged values of $y$.
- $\epsilon \sim N(0, \sigma^2 I)$.

## 2. The Priors (Conjugate)

To allow for an exact Gibbs sampler, we assign the following semi-conjugate priors:

- **Coefficients:** $\beta \sim MVN(\mu_0, \Lambda_0)$
- **Error Variance:** $\sigma^2 \sim IG(a_0, b_0)$

The multivariate normal prior for $\beta$ is appropriate because the coefficient vector is continuous and the normal family combines conveniently with the Gaussian likelihood, yielding a closed-form posterior conditional for the Gibbs sampler.

This allows the model to express uncertainty over the coefficient values rather than fixing them to a single estimate.

The inverse-gamma prior for $\sigma^2$ is appropriate because the variance parameter must be strictly positive, and the inverse-gamma family is conjugate to the Gaussian likelihood, yielding a closed-form posterior conditional for variance updates.

This ensures that uncertainty in the variability of the data is also modeled.

## 3. The Full Conditional Distributions

These full conditional distributions are obtained by combining the Gaussian likelihood with the conjugate priors defined above. Due to conjugacy, both conditional distributions take closed-form expressions, which enables efficient Gibbs sampling without the need for numerical approximation methods.

This allows us to repeatedly sample from known distributions, making the Gibbs sampler efficient.

For the Gibbs sampler, we alternate between drawing from $p(\beta | \sigma^2, Y)$ and $p(\sigma^2 | \beta, Y)$.

### 3.1. Full Conditional for $\beta$ (Posterior for coefficients)

This conditional posterior is derived by combining the Gaussian likelihood with the multivariate normal prior on $\beta$. The resulting posterior remains multivariate normal due to conjugacy.

Assuming $\sigma^2$ is known:
$$\beta | \sigma^2, Y \sim MVN(\mu_n, \Lambda_n)$$
Where:

- $\Lambda_n = (\Lambda_0^{-1} + \frac{1}{\sigma^2} X^\top X)^{-1}$
- $\mu_n = \Lambda_n (\Lambda_0^{-1}\mu_0 + \frac{1}{\sigma^2} X^\top Y)$

This means that at each iteration, we update our belief about the coefficients based on both prior knowledge and the observed data.

### 3.2. Full Conditional for $\sigma^2$ (Posterior for variance)

This conditional posterior is derived by combining the Gaussian likelihood with the inverse-gamma prior on $\sigma^2$. The resulting posterior remains inverse-gamma due to conjugacy.

Assuming $\beta$ is known:
$$\sigma^2 | \beta, Y \sim IG(a_n, b_n)$$
Where:

- $a_n = a_0 + \frac{n-p}{2}$
- $b_n = b_0 + \frac{1}{2} (Y - X\beta)^\top (Y - X\beta)$

This reflects how the variance is updated based on how well the model fits the observed data.

## 4. Sampling Loop Recap

1. Initialize $\beta^{(0)}$ and $(\sigma^2)^{(0)}$.
2. For $i$ from 1 to $N_{sim}$:
   a. Draw $\beta^{(i)} \sim MVN(\mu_n, \Lambda_n | (\sigma^2)^{(i-1)})$
   b. Draw $(\sigma^2)^{(i)} \sim IG(a_n, b_n | \beta^{(i)})$
3. Discard burn-in samples and proceed with diagnostics.

The remaining samples represent draws from the posterior distribution and are used for inference and prediction.
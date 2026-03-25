# [MAJOR COURSE OUTPUT 2] BAYESIAN STATISTICS W/ MARKOV CHAIN MONTE CARLO (MCMC) MODEL FITTING DEMONSTRATION

This project requires you to design and develop a comprehensive Bayesian inference pipeline from scratch in R. Demonstrating a fully Bayesian uncertainty quantification, you will bridge statistical theory with algorithmic execution to solve a computational problem. **You must select one of the approved computational domains listed below** and construct a custom Markov Chain Monte Carlo (MCMC) engine to estimate the posterior distribution of your model parameters.

1. **The first phase involves selecting a specific computational problem from the approved list below.** You must clearly define the machine learning or statistical challenge and discuss why traditional frequentist methods (which provide only point estimates) fall short in this domain. Justify why a Bayesian approach, specifically the ability to quantify algorithmic uncertainty and handle latent structures, is critical for production systems in this context of the problem you have chosen to work on.
2. **Provide a rigorous mathematical formulation of your statistical (Bayesian) model.** Explicitly define your likelihood function and specify appropriate prior distributions for all parameters (justifying your choice of conjugate, weakly informative, or custom priors). Be able to provide as well the mathematical derivations of the full conditional distributions required for your specific MCMC strategy. If your model requires advanced techniques (such as Pólya-Gamma/Albert-Chib data augmentation, collapsed integration, or Metropolis-Hastings acceptance ratios), provide a high-level technical discussion of these mechanics in your report.
3. Establish a verifiable ground truth. **Develop an R script to simulate a synthetic, multidimensional dataset where the true data-generating parameters are pre-defined and known.** This simulated environment should act as an algorithmic debugging tool to ensure that your MCMC sampler can successfully recover the true underlying statistical structure.
4. **Implement the MCMC sampling algorithm entirely from scratch in `R` (or `Rcpp` for optimization).** You may use black-box probabilistic programming languages (such as Stan or JAGS) for this requirement. Implement a console output mechanism to track iteration progress and computational overhead, ideally in real-time or even in summary (i.e., live trace plots).
5. Provide quantitative and visual proof that your algorithm has reached a stationary distribution. After discarding an appropriate burn-in period, **compute summary statistics and generate publication-quality trace plots to visually confirm stationary chain mixing. Generate posterior density plots with shaded 95% Credible Intervals**, plotting them against your simulated ground truth to demonstrate successful parameter recovery. You must also calculate the Effective Sample Size (ESS) to quantify your sampler's algorithmic efficiency.
6. Demonstrate how your model performs inference on unseen data. **Feed new, synthetic data points into your model and calculate the posterior predictive distribution.** Instead of yielding a single point prediction, your engine must output the full distribution of calculated probabilities or continuous predictions. Compute the mean and 95% credible intervals for this prediction, and write a concluding analysis explaining how an automated system would utilize this specific uncertainty metric to make defensive, risk-aware decisions in a production environment.

As part of your submission, **please prepare a technical documentation report (in `.pdf` format) structured exactly according to these six phases.** Detailed documentation should clearly delineate the mathematical derivations and provide annotated explanations for the diagnostic visualizations. Submit this alongside `.R` scripts.

Example, for Reference of Bayesian project demonstration _(Bayesian Spam Classification via Polya-Gamma Data Augmentation)_:

- [(MCO 2 Sample) Bayesian Spam Classification via Polya-Gamma Data Augmentation.pdf](../sample/mco2-sample.pdf)
- [(MCO 2 Sample) Bayesian Spam Classification via Polya-Gamma Data Augmentation.R](../sample/mco2-sample.R)

## List of Topics

### 1. Bayesian Probit Regression via Albert-Chib Data Augmentation

- Domain: Malware Detection (Binary Classification)

- Description: Implement binary classification using a Probit link function. Because the Probit model is non-conjugate, must use the Albert-Chib data augmentation trick, introducing a truncated normal latent variable for each observation to render the conditional distributions Gaussian, allowing for an exact Gibbs sampler.

### 2. Robust Linear Regression with Student- Errors

- Domain: IoT Sensor Calibration / Outlier Rejection

- Description: Standard frequentist regression fails drastically in the presence of sensor anomalies. Model linear regression using a heavy-tailed Student- likelihood. To sample this in R, must represent the Student- distribution as an infinite mixture of scaled Gaussians, introducing a latent variance parameter for each data point to be sampled via Gibbs.

### 3. Feature Selection using Spike-and-Slab Priors

- Domain: High-Dimensional Genomics or Text Analysis

- Description: When the number of features approaches the number of observations, standard regression overfits. Implement a Bayesian linear regression model using a "Spike-and-Slab" prior. The MCMC loop requires sampling a latent Bernoulli inclusion variable for every feature to determine if it belongs to the "spike" (zero effect) or the "slab" (active feature), effectively performing algorithmic dimensionality reduction.

### 4. Gaussian Mixture Models (GMM) for Unsupervised Anomaly Detection

- Domain: Network Traffic Intrusion Detection

- Description: Instead of -means, build a fully Bayesian GMM to cluster multidimensional server logs. The Gibbs sampler requires assigning conjugate Normal-Inverse-Wishart priors and alternating between sampling discrete cluster assignments (Categorical distribution) and updating the continuous cluster means and covariance matrices.

### 5. Latent Dirichlet Allocation (LDA) via Collapsed Gibbs Sampling

- Domain: Natural Language Processing (Topic Modeling)

- Description: Model a small synthetic corpus of text documents to uncover hidden semantic structures. Rather than a standard Gibbs sampler, derive and implement a collapsed Gibbs sampler in R, which analytically integrates out the continuous Dirichlet parameters to drastically speed up the sampling of the discrete word-topic assignments.

### 6. Matrix Factorization for Collaborative Filtering

- Domain: Recommender Systems (e.g., Netflix/Amazon ratings)

- Description: Predict missing entries in a sparse user-item rating matrix. The project involves Bayesian Probabilistic Matrix Factorization, requiring an alternating Gibbs sampler that iteratively updates the posterior distributions of user latent feature vectors and item latent feature vectors.

### 7. Bayesian Poisson Regression with Metropolis-Hastings

- Domain: Cloud Server Load Forecasting

- Description: Predicting count data (e.g., HTTP requests per minute). Because the Poisson likelihood is not conjugate to a Gaussian prior on the regression weights, an exact Gibbs sampler is impossible. Write a custom Random-Walk Metropolis-Hastings (RWMH) algorithm within their R loop, manually tuning the proposal variance to achieve an optimal acceptance rate (around ~40%).

### 8. Hidden Markov Models (HMM) for Keystroke Dynamics

- Domain: Behavioral Biometrics / User Authentication

- Description: Model sequential typing speed data to detect unauthorized users. Implement a Bayesian HMM, using a Forward-Backward Gibbs sampling routine (Message Passing algorithm) to infer the discrete hidden states (e.g., "typing password" vs. "thinking") and the continuous Gaussian emission parameters.

### 9. Hierarchical Beta-Binomial Models for A/B/n Testing

- Domain: Web Analytics and Conversion Rate Optimization

- Description: Evaluate multiple website designs simultaneously. Instead of independent priors, build a hierarchical model where all conversion rates share a common hyperprior. The MCMC sampler will demonstrate "shrinkage," where low-traffic website variations borrow statistical strength from high-traffic variations.

### 10. Autoregressive AR() Time Series Forecasting

- Domain: AWS/GCP Cloud Compute Billing Predictions

- Description: Model the temporal dependency of daily server costs. Implement an MCMC sampler to estimate the autoregressive coefficients and the error variance of an AR model. The posterior predictive checks will involve forecasting the next 30 days of billing with expanding 95% credible intervals.

### 11. Bayesian Accelerated Failure Time (AFT) Models

- Domain: Hard Drive / Hardware Reliability (Survival Analysis)

- Description: Predict the "time-to-failure" of data center components. Using a Weibull likelihood, write an MCMC algorithm that handles right-censored data (drives that are currently functioning but will fail eventually), requiring them to sample latent failure times for the censored observations during the Gibbs loop.

### 12. Naive Bayes with Dirichlet-Multinomial Smoothing

- Domain: Phishing Website URL Classification

- Description: A fully Bayesian treatment of the classic Naive Bayes classifier. Instead of using arbitrary Laplace smoothing for unseen words, use MCMC to sample the conditional probability distributions from a Dirichlet posterior, providing rigorous uncertainty metrics for edge-case URLs.

### 13. Contextual Thompson Sampling via Bayesian Linear Regression

- Domain: Reinforcement Learning / Ad Routing

- Description: Simulate an online environment where traffic is dynamically routed to different algorithms. The project requires running a Bayesian linear regression MCMC update for each "arm" to calculate the posterior distribution of expected reward, and using those posterior samples to route the next batch of synthetic users.

### 14. Stochastic Volatility Modeling

- Domain: Quantitative Finance / Algorithmic Trading

- Description: Model the variance of financial returns not as a constant, but as a latent Autoregressive AR(1) process. This requires a complex "Metropolis-within-Gibbs" architecture in R to sample the sequence of hidden volatility states alongside the static model parameters.

### 15. Bayesian Image Denoising using Markov Random Fields (MRF)

- Domain: Computer Vision

- Description: Reconstruct a corrupted binary image (e.g., optical character recognition). Model the image as an Ising model (a type of MRF) where neighboring pixels influence each other. The Gibbs sampler will iterate over the grid, updating the probability of each pixel being black or white based on its neighbors and the noisy observation.

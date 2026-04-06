#' Generate Publication-Quality Trace Plots
#'
#' @param samples A numeric vector or matrix of MCMC samples.
#' @param param_name Name of the parameter for labeling the plot.
#' @param true_value Optional numeric value of the ground truth for recovery overlay.
#' @return A ggplot object.
#' @export
plot_mcmc_trace <- function(samples, param_name, true_value = NULL) {
  if (is.null(dim(samples))) {
    samples <- as.matrix(samples)
    colnames(samples) <- param_name
  }

  p <- bayesplot::mcmc_trace(samples, pars = param_name) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = paste("MCMC Trace Plot:", param_name),
      subtitle = "Visual check for chain mixing and stationarity."
    )

  if (!is.null(true_value)) {
    p <- p + ggplot2::geom_hline(yintercept = true_value, color = "red", linetype = "dashed", linewidth = 1)
  }

  p
}

#' Generate Posterior Density Plots with 95% Shaded Intervals
#'
#' @param samples A numeric vector or matrix of MCMC samples.
#' @param param_name Name of the parameter for labeling the plot.
#' @param true_value Optional numeric value of the ground truth for recovery overlay.
#' @return A ggplot object.
#' @export
plot_posterior_density <- function(samples, param_name, true_value = NULL) {
  if (is.null(dim(samples))) {
    samples <- as.matrix(samples)
    colnames(samples) <- param_name
  }

  p <- bayesplot::mcmc_areas(samples, pars = param_name, prob = 0.95) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = paste("Posterior Density:", param_name),
      subtitle = "Shaded area represents the 95% Credible Interval."
    )

  if (!is.null(true_value)) {
    p <- p + ggplot2::geom_vline(xintercept = true_value, color = "red", linetype = "dashed", linewidth = 1)
  }

  p
}

#' Generate Autocorrelograms (ACF) for MCMC Chains
#'
#' @param samples A numeric vector or matrix of MCMC samples.
#' @param param_name Name of the parameter for labeling the plot.
#' @return A ggplot object.
#' @export
plot_mcmc_acf <- function(samples, param_name) {
  if (is.null(dim(samples))) {
    samples <- as.matrix(samples)
    colnames(samples) <- param_name
  }

  bayesplot::mcmc_acf(samples, pars = param_name) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = paste("Autocorrelation (ACF):", param_name),
      subtitle = "Assessment of sampling independence."
    )
}

#' Generate Rank Histograms to Verify Convergence
#'
#' @param samples A numeric vector or matrix of MCMC samples.
#' @param param_name Name of the parameter for labeling the plot.
#' @return A ggplot object.
#' @export
plot_mcmc_rank <- function(samples, param_name) {
  if (is.null(dim(samples))) {
    samples <- as.matrix(samples)
    colnames(samples) <- param_name
  }

  bayesplot::mcmc_rank_hist(samples, pars = param_name) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = paste("Rank Histogram:", param_name),
      subtitle = "Uniformity check for proper posterior exploration."
    )
}

#' Calculate MCMC Summary Statistics and Effective Sample Size
#'
#' @param samples A numeric matrix or data frame of MCMC samples.
#' @return A data frame containing Mean, SD, Quatiles, and ESS.
#' @export
summarize_mcmc_results <- function(samples) {
  if (is.null(colnames(samples))) {
    colnames(samples) <- paste0("param", seq_len(ncol(samples)))
  }

  stats_list <- lapply(seq_len(ncol(samples)), function(j) {
    s <- samples[, j]
    n_eff <- coda::effectiveSize(coda::as.mcmc(s))
    quant <- quantile(s, probs = c(0.025, 0.5, 0.975))

    data.frame(
      Parameter = colnames(samples)[j],
      Mean = mean(s),
      SD = sd(s),
      `2.5%` = quant[1],
      Median = quant[2],
      `97.5%` = quant[3],
      ESS = as.numeric(n_eff),
      check.names = FALSE
    )
  })

  do.call(rbind, stats_list)
}

#' Generate Diagnostic Assets for Appendix
#'
#' This function automates the generation of diagnostics for all parameters in a fit object.
#'
#' @param fit A list containing the MCMC results (beta_samples, sigma2_samples).
#' @param true_params Optional list with 'beta' and 'sigma2' for ground truth overlays.
#' @param output_dir Path to save the PNG assets. Defaults to project_config$assets_dir.
#' @export
generate_diagnostic_appendix <- function(fit, true_params = NULL, output_dir = project_config$assets_dir) {
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

  # Prepare sample matrices
  beta_samples <- fit$beta_samples
  sigma2_samples <- as.matrix(fit$sigma2_samples)
  colnames(sigma2_samples) <- "sigma2"

  params <- c(colnames(beta_samples), "sigma2")
  all_samples <- cbind(beta_samples, sigma2_samples)

  for (p_name in params) {
    # Determine true value if provided
    tv <- NULL
    if (!is.null(true_params)) {
      if (p_name == "sigma2") {
        tv <- true_params$sigma2
      } else if (p_name == "intercept") {
        tv <- true_params$beta[1]
      } else if (grepl("^phi", p_name)) {
        idx <- as.numeric(gsub("phi", "", p_name))
        tv <- true_params$beta[idx + 1]
      }
    }

    # Generate and Save Plots
    p_trace <- plot_mcmc_trace(all_samples, p_name, tv)
    p_dens <- plot_posterior_density(all_samples, p_name, tv)
    p_acf <- plot_mcmc_acf(all_samples, p_name)
    p_rank <- plot_mcmc_rank(all_samples, p_name)

    # Use centralized resolution/DPI settings
    ggplot2::ggsave(file.path(output_dir, paste0(p_name, "_trace.png")), p_trace,
      width = project_config$plot_width, height = project_config$plot_height / 2, dpi = project_config$plot_dpi
    )
    ggplot2::ggsave(file.path(output_dir, paste0(p_name, "_density.png")), p_dens,
      width = project_config$plot_width, height = project_config$plot_height / 2, dpi = project_config$plot_dpi
    )
    ggplot2::ggsave(file.path(output_dir, paste0(p_name, "_acf.png")), p_acf,
      width = project_config$plot_width, height = project_config$plot_height / 2, dpi = project_config$plot_dpi
    )
    ggplot2::ggsave(file.path(output_dir, paste0(p_name, "_rank.png")), p_rank,
      width = project_config$plot_width, height = project_config$plot_height / 2, dpi = project_config$plot_dpi
    )
  }

  # 2. Print Summary Table to Console
  summary_stats <- summarize_mcmc_results(all_samples)
  message("\n--- MCMC DIAGNOSTIC SUMMARY ---\n")
  print(summary_stats, row.names = FALSE)
  message("\n-------------------------------\n")

  # 3. Handle PDF Appendix Generation via RMarkdown
  plot_list <- list()
  for (p_name in params) {
    # Determine true value if provided
    tv <- NULL
    if (!is.null(true_params)) {
      if (p_name == "sigma2") {
        tv <- true_params$sigma2
      } else if (p_name == "intercept") {
        tv <- true_params$beta[1]
      } else if (grepl("^phi", p_name)) {
        idx <- as.numeric(gsub("phi", "", p_name))
        tv <- true_params$beta[idx + 1]
      }
    }

    plot_list[[p_name]] <- list(
      trace = plot_mcmc_trace(all_samples, p_name, tv),
      density = plot_posterior_density(all_samples, p_name, tv),
      acf = plot_mcmc_acf(all_samples, p_name),
      rank = plot_mcmc_rank(all_samples, p_name)
    )
  }

  # Resolve template path via centralized helper
  template_path <- get_template_path(project_config$diagnostic_template)

  if (requireNamespace("rmarkdown", quietly = TRUE) &&
    rmarkdown::pandoc_available() &&
    template_path != "") {
    # Resolve report path via centralized config
    pdf_out <- file.path(project_config$reports_dir, "diagnostics_result.pdf")
    if (!dir.exists(dirname(pdf_out))) dir.create(dirname(pdf_out), recursive = TRUE)

    # Render with local environment variables
    params_summary <- summary_stats
    rmarkdown::render(
      input = template_path,
      output_file = basename(pdf_out),
      output_dir = dirname(pdf_out),
      envir = environment(),
      quiet = TRUE
    )
    message("SUCCESS: Diagnostic Appendix PDF generated at ", pdf_out)
  } else {
    message("PDF rendering skipped: rmarkdown or template not available.")
  }

  invisible(summary_stats)
}

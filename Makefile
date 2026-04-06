.PHONY: install format lint test doc check simulate diagnostics forecast report results clean

# Default target: Run everything
all: check results

# Results Pipeline (Phase 3 -> 5 -> 6 -> 7)
results: simulate diagnostics forecast report

# Install necessary R dependencies from DESCRIPTION file
install:
	Rscript -e "if (!requireNamespace('remotes', quietly = TRUE)) install.packages('remotes')"
	Rscript -e "remotes::install_deps(dependencies = TRUE, repos = 'https://cloud.r-project.org')"

# Format R code using the styler package
format:
	Rscript -e "styler::style_dir('R')"

# Lint R code to ensure style consistency
lint:
	Rscript -e "lintr::lint_dir()"

# Run unit tests via testthat
test:
	Rscript -e "testthat::test_local()"

# Generate package documentation (man/ files) and NAMESPACE via Roxygen2
doc:
	Rscript -e "roxygen2::roxygenize()"

# Full check of formatting, linting, tests, and documentation
check: format lint test doc

# Run the ground truth data simulation (Phase 3)
simulate:
	Rscript scripts/simulate_data.R

# Generate Phase 5 diagnostics and results summary
diagnostics:
	Rscript scripts/run_diagnostics.R

# Generate Phase 6 posterior predictive forecasts
forecast:
	Rscript scripts/generate_forecasts.R

# Generate Phase 7 final submission report
report:
	Rscript scripts/final_report.R

# Reset project output (remove all generated plots and reports)
clean:
	rm -rf assets/diagnostics/*.png
	rm -rf assets/forecasting/*.png
	rm -rf docs/reports/*.pdf

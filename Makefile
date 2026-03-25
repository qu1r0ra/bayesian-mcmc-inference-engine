.PHONY: install format lint test doc check simulate

# Default target: Run a full project check
all: check

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
	Rscript R/data_simulation.R

# Phase 7: Final Documentation and Report Generation
pkgload::load_all(".")

message("--- PHASE 7: FINAL REPORT COMPILATION ---\n")

# 1. Gather Math Derivations (Phase 2)
# 2. Gather Benchmark Results & Ground Truth (Phase 3 & 5)
# 3. Gather Forecast fan plots (Phase 6)
message("Gathering and verifying all project assets...")

expected_assets <- c(
  "assets/diagnostics/phi1_trace.png",
  "assets/diagnostics/phi2_trace.png",
  "assets/forecasting/30_day_projection.png",
  "docs/reports/main.tex",
  "docs/reports/references.bib"
)

missing_assets <- expected_assets[!file.exists(expected_assets)]

if (length(missing_assets) > 0) {
  stop("Missing assets! Please run diagnostics and forecasting scripts first:\n", paste(missing_assets, collapse="\n"))
} else {
  message("All required mathematical, diagnostic, and forecast assets are gathered.")
}

# Final Packaging: Synchronize Documentation & NAMESPACE (From todo.md)
message("\nSynchronizing Package Documentation (NAMESPACE & Rd files)...")
if (requireNamespace("roxygen2", quietly = TRUE)) {
  roxygen2::roxygenise()
  message("Documentation successfully synchronized.")
} else {
  message("WARNING: roxygen2 not found. Run install.packages('roxygen2') to sync.")
}

# 4. Compile final LaTeX-based PDF Report
message("\nCompiling final LaTeX-based PDF Report locally...")

if (requireNamespace("tinytex", quietly = TRUE)) {
  tryCatch({
    # Compiling from root so graphicspath correctly finds the assets/ folder
    tinytex::latexmk("docs/reports/main.tex", engine = "pdflatex", clean = TRUE)
    message("\nSUCCESS: PDF compiled successfully! Look for 'main.pdf' in the docs/reports/ directory.")
  }, error = function(e) {
    message("\nWARNING: Local PDF compilation failed. A local LaTeX distribution might be missing from your system.")
    message("Error details: ", e$message)
    message("Since you already compiled the PDF in Prism, you are still safe to submit!")
  })
} else {
  message("\nWARNING: 'tinytex' package not found. Skipping local PDF compilation.")
}

message("\n--- PROJECT SYNTHESIS COMPLETE ---")
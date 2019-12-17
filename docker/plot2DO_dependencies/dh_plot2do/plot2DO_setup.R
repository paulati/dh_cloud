# Libraries that are required:
# CRAN: 
#   c("colorRamps", "doParallel", "foreach", "ggplot2", "gridExtra", "optparse", "pracma", "reshape2", "yaml")
# Bioconductor: 
#   c("AnnotationHub", "biomaRt", "GenomicFeatures", "GenomicRanges", "GenomeInfoDb", "IRanges", "Rsamtools", "rtracklayer")
# R core libraries (do not need installation): 
#   c("grid", "parallel", "tools")


noError = TRUE

# Install CRAN packages
cat("Checking and installing missing CRAN packages:\n")
cranLibraries <- c("colorRamps", "doParallel", "foreach", "ggplot2", "gridExtra", "optparse", "pracma", "reshape2", "yaml", "RCurl", "aws.s3")
foo <- sapply(cranLibraries, function(x) {
  if (requireNamespace(x, quietly = FALSE)){
    result <- "was already available."
  } else {
    install.packages(x, repos="http://cloud.r-project.org")
    success <- requireNamespace(x, quietly = FALSE)
    if(success) {
      result <- "was successfully installed."
    } else {
      result <- "error: not available and cannot install!"
      noError = FALSE
    }
  }
  cat("  >", paste(x, result, sep = "....."))
  cat("\n")
})

# Install Bioconductor packages
cat("\n")
if (!requireNamespace("BiocManager", quietly = FALSE)){
  install.packages("BiocManager")
}

cat("\n")
cat("Checking and installing missing Bioconductor packages (and update dependencies!):\n")

bioconductorLibraries <- c("AnnotationHub", "biomaRt",
                           "GenomeInfoDb", "IRanges", "GenomicRanges", "Rsamtools",
                           "GenomicFeatures", "rtracklayer")

if (!requireNamespace("BiocManager", quietly = FALSE)){
  install.packages("BiocManager")
}
foo <- sapply(bioconductorLibraries, function(x) {
  if (requireNamespace(x, quietly = FALSE)){
    result <- "was already available."
  } else {
    BiocManager::install(x, ask = FALSE)
    success <- requireNamespace(x, quietly = FALSE)
    if(success) {
      result <- "was successfully installed."
    } else {
      result <- "error: not available and cannot install!"
      noError = FALSE
    }
  }
  cat("  >", paste(x, result, sep = "....."))
  cat("\n")
})


cat("\nDone!")
if (noError) {
  cat(" All the required packages are available now.\n")
} else {
  cat(" Error(s) found! See above.\n")
}

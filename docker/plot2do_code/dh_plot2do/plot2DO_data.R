#!/usr/bin/env Rscript

# Check the minimum R version: R>=3.5.0 (required for Bioconductor 3.7)
getRversion <- function() {
  rvs <- sub("R version ", "", R.version.string)
  pos <- gregexpr(" \\(", rvs)[[1]][1]
  rVersion <- substr(rvs, 1, pos-1)
  releaseDate <- substr(rvs, pos+2, nchar(rvs)-1)
  result <- list("version" = rVersion, "date" = releaseDate)
  return(result)
}

rvs <- getRversion()
rVersion <- rvs$version
releaseDate <- rvs$date
if (rVersion < "3.5") {
  stop(paste0("Your R version is ", rVersion,", which is a bit too old (release date: ", releaseDate, ").\nTo run plot2DO, please upgrade R to a version >= 3.5.0.\nYou can download the latest version of R from https://www.r-project.org/"))
}

suppressPackageStartupMessages({
  library(yaml)
})

# load app config values:

config <- yaml.load_file("config/config.yaml")

sourceBasePath <- config$application$paths$source
if(is.null(sourceBasePath)) {
  sourceBasePath <- file.path(getwd(), "source")
} 

readsBasePath <- config$application$paths$reads
if(is.null(readsBasePath)) {
  readsBasePath <- file.path(getwd(), "data")
}

outputBasePath <- config$application$paths$output
if(is.null(outputBasePath)) {
  outputBasePath <- file.path(getwd(), "tests")
}

annotationsBasePath <- config$application$paths$annotations
if(is.null(annotationsBasePath)) {
  #annotationsBasePath <- file.path(getwd(), "Annotations")
  annotationsBasePath <- getwd()
}

configBasePath <- config$application$paths$config
if(is.null(configBasePath)) {
  configBasePath <- file.path(getwd(), "config")
}

awsAccountKey <- config$application$aws$accountKey

awsAccountSecret <- config$application$aws$accountSecret

awsS3ReadsBucketName <- config$application$aws$s3$reads$bucketName
awsS3ReadsNameBase <- config$application$aws$s3$reads$baseName

awsS3CleanDataBucketName <- config$application$aws$s3$cleanData$bucketName
awsS3CleanDataNameBase <- config$application$aws$s3$cleanData$baseName

awsS3CoverageBucketName <- config$application$aws$s3$coverageData$bucketName
awsS3CoverageNameBase <- config$application$aws$s3$coverageData$baseName

awsS3PlotBucketName <- config$application$aws$s3$plotSite$bucketName
awsS3PlotNameBase <- config$application$aws$s3$plotSite$baseName

main <- file.path(sourceBasePath, "plot2DO_main_data_preparation.R")

source(main)

Main()


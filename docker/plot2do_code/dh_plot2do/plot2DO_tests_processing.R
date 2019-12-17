# load app config values:
library(yaml)
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



# end config

main <- file.path(sourceBasePath, "plot2DO_main_process.R")
source(main)


arguments_1 <- c("--file=yeast_50U_MNase_SRR3649301.5M_reads.bam", "--jobId=9")


start.time <- Sys.time()
command_line_args <- c(arguments_1)

##tengo que leer el id desde la notificacion (es la carpeta donde aparecio el archivo)

Main(command_line_args)

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
gc()


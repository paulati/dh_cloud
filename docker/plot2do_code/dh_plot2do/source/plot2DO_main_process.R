io <- file.path(sourceBasePath, "plot2DO_io.R")
data <- file.path(sourceBasePath, "plot2DO_data.R")
core <- file.path(sourceBasePath, "plot2DO_core.R")
aws <- file.path(sourceBasePath, "plot2DO_aws.R")
mainbase <- file.path(sourceBasePath, "plot2DO_main_base.R")
source(io)
source(data)
source(core)
source(aws)
source(mainbase)

DownloadDataFromS3 <- function(params) {
  
  jobId <- params$jobId
  
  account.key <- awsAccountKey
  account.secret <- awsAccountSecret
  
  remote.base.folder.path <- file.path(awsS3CleanDataNameBase, jobId)
  file.name <- paste0(params$sampleName, ".csv")
  object.name <- file.path(remote.base.folder.path, file.name)
  #local.base.folder.path <- dirname(dataFilePath)
  #local.file.name <- basename(dataFilePath)
  bucket.name <- awsS3CleanDataBucketName
  
  result <- read.csv.from.s3(account.key, account.secret, bucket.name, object.name)
  
  return(result)
  
}


UploadDataToS3 <- function(params, objectLocalFilePath) {
  
  jobId <- params$jobId
  
  account.key <- awsAccountKey
  account.secret <- awsAccountSecret
  bucket.name <- awsS3CoverageBucketName
  
  remote.base.folder.path <- file.path(awsS3CoverageNameBase, jobId)
  remote.file.name <- basename(objectLocalFilePath) # estoy perdiendo las carpetas

  local.file.path <- objectLocalFilePath
  
  upload.to.s3(account.key, account.secret,
                           bucket.name, remote.base.folder.path, 
                           remote.file.name, local.file.path)
    
  
}



CleanJobLocal <- function(jobId) {
  
  # borro el bam, que guarde local
  # borro los reads y la matriz de occupancy
}




Main <- function(command_line_args=NA)
{
  print("main process")
  
  opt <- LoadArguments(command_line_args)  
  
  params <- InitializeParams(opt)

  rm(opt) # deleted to be sure using initialized params
  
  DownloadBAMDataFromS3(params, awsS3CleanDataBucketName)
  
  if(params$inputFilePath == params$inputFilename) {
    # readsBasePath is initilized in plot2DO.R
    inputFilePath <- file.path(readsBasePath, params$inputFilename)
  }
  annotations <- LoadGenomeAnnotation_v2(inputFilePath, params$genome)
  
  referenceGRanges <- ConstructReferenceGRanges(params$referencePointsBed, annotations, params$reference, 
                            params$beforeRef, params$afterRef, params$genome, params$align)
  
  jobId <- params$jobId
  
  outputFolderPath <- CreateOutputFolders(jobId, params$plotType, params$referencePointsBed, params$reference, params$siteLabel)
  
  print(outputFolderPath)

  # read reads from s3 and convert to GRanges
  readsDF <- DownloadDataFromS3(params)
  reads <- ConvertDFToGranges(readsDF, params$genome, annotations)
  rm(readsDF)  

  result_data <- CalculatePlotData(params, reads, referenceGRanges)
  
  outputFilePath <- GetOutputMatrixFilePath(jobId, params$plotType, params$referencePointsBed, 
                                            params$reference, params$siteLabel, 
                                            params$lMin, params$lMax, params$sampleName)
  
  occMatrix <- result_data$occMatrix
  lMin <- result_data$lMin
  lMax <- result_data$lMax
  beforeRef <- result_data$beforeRef
  afterRef <- result_data$afterRef
  totalNoReads <- result_data$totalNoReads
  lengthHist <- result_data$lengthHist
  sampleName <- result_data$sampleName
  siteLabel <- result_data$siteLabel
  
  save(occMatrix, lMin, lMax, beforeRef, afterRef, totalNoReads, lengthHist, sampleName, siteLabel, file=outputFilePath)

  # upload results to S3 el contenido de outputFolderPath
  UploadDataToS3(params, outputFilePath)
  
  # clean all jobId
  
  
}

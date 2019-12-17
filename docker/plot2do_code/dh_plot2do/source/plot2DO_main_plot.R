io <- file.path(sourceBasePath, "plot2DO_io.R")
plots <- file.path(sourceBasePath, "plot2DO_plots.R")
aws <- file.path(sourceBasePath, "plot2DO_aws.R")
source(io)
source(plots)
source(aws)

DownloadDataFromS3 <- function(params) {
  
  account.key <- awsAccountKey
  account.secret <- awsAccountSecret
  
  remote.base.folder.path <- file.path(awsS3CoverageNameBase, params$jobId)
  
  rdataFilePath <- GetOutputMatrixFilePath(params$jobId, params$plotType, params$referencePointsBed, 
                                            params$reference, params$siteLabel, 
                                            params$lMin, params$lMax, params$sampleName)
  
  
  local.base.folder.path <- dirname(rdataFilePath)
  file.name <- basename(rdataFilePath)
  local.file.name <- file.name
  object.name <- file.path(remote.base.folder.path, file.name)
  #local.base.folder.path <- dirname(dataFilePath)
  #local.file.name <- basename(dataFilePath)
  bucket.name <- awsS3CoverageBucketName
  
  download.from.s3(account.key, account.secret,
                               remote.base.folder.path, file.name,
                               local.base.folder.path, 
                               local.file.name, bucket.name)
  
}


UploadPlotToS3 <- function(params, objectLocalFilePath) {
  
  jobId <- params$jobId
  
  account.key <- awsAccountKey
  account.secret <- awsAccountSecret
  bucket.name <- awsS3PlotBucketName
  
  remote.base.folder.path <- file.path(awsS3PlotNameBase, jobId)
  remote.file.name <- basename(objectLocalFilePath) # estoy perdiendo las carpetas
  
  local.file.path <- objectLocalFilePath
  
  upload.to.s3(account.key, account.secret,
               bucket.name, remote.base.folder.path, 
               remote.file.name, local.file.path)
  
  
}



CleanJobLocal <- function(jobId) {
  
  # borro el bam, que guarde local
  
}


Main <- function(command_line_args=NA)
{
  print("main plot")
  
  opt <- LoadArguments(command_line_args)  
  
  params <- InitializeParams(opt)

  rm(opt) # deleted to be sure using initialized params
  
  outputFolderPath <- CreateOutputFolders(params$jobId, params$plotType, params$referencePointsBed, params$reference, params$siteLabel)
  
  print(outputFolderPath)

  # leer rdata de s3 a local
  DownloadDataFromS3(params)
    
  plotFilePath <- PlotFigure(params)
    
  # check whether the unwanted file exists and remove it
  # somethingToRemove <- file.exists("Rplots.pdf")
  # if(somethingToRemove) {
  #     dummy <- file.remove("Rplots.pdf")  
  # }
  # 
  
  #subir pdf a s3
  UploadPlotToS3(params, plotFilePath)
    
  #clean de jobid (borrar rdata)
  CleanJobLocal(params$jobId)
}

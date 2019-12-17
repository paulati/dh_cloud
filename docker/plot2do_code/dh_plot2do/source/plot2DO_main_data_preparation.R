io <- file.path(sourceBasePath, "plot2DO_io.R")
data <- file.path(sourceBasePath, "plot2DO_data.R")
#core <- file.path(sourceBasePath, "plot2DO_core.R")
aws <- file.path(sourceBasePath, "plot2DO_aws.R")
mainbase <- file.path(sourceBasePath, "plot2DO_main_base.R")
source(io)
source(data)
#source(core)
source(aws)
source(mainbase)

UploadDataToS3 <- function(jobId, params, readsDF) {

  #seteada global al inicio:
  bucket.name <- awsS3CleanDataBucketName
  
  file.name <- paste0(params$sampleName, ".csv")
  #seteada global al inicio:
  object.name <- file.path(awsS3CleanDataNameBase, jobId, file.name)
  account.key <- awsAccountKey
  account.secret <- awsAccountSecret
  
  
  #guardo clean reads en S3 como csv (que voy a leer como Granges) en la carpeta del job id
  # esto crea la carpeta si no existe
  write.csv.to.s3(account.key, account.secret, readsDF, bucket.name, object.name)
  
  
}

CleanJobLocal <- function(jobId) {
  
  # borro el bam, que guarde local
  
}



Main <- function(command_line_args=NA)
{
  ###################
  # Generate job_id #
  ###################
  
  
  print("main")
  
  opt <- LoadArguments(command_line_args)  
  
  params <- InitializeParams(opt)

  rm(opt) # deleted to be sure using initialized params
  
  jobId <- params$jobId
  
  DownloadBAMDataFromS3(params, awsS3ReadsBucketName)
  
  # annotations <- LoadGenomeAnnotation(params$genome)
  if(params$inputFilePath == params$inputFilename) {
    # readsBasePath is initilized in plot2DO.R
    inputFilePath <- file.path(readsBasePath, params$inputFilename)
  }
  annotations <- LoadGenomeAnnotation_v2(inputFilePath, params$genome)
  
  rawReads <- LoadReads(inputFilePath, params$genome, annotations)
  
  # rawReads_df <- data.frame(rawReads, stringsAsFactors = FALSE)
  # file_name <- basename(params$inputFilePath)
  # base_path <- dirname(params$inputFilePath)
  # out_file_name <- sub(pattern = ".bam", replacement = ".bed", x = file_name)
  # out_file_path <- file.path(base_path, out_file_name)
  # write.table(rawReads_df, out_file_path, sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
  
  reads <- CleanReads(rawReads, annotations$chrLen, params$lMin, params$lMax)
  
  readsDF <- ConvertGRangesToDF(reads)
  
  UploadDataToS3(jobId, params, readsDF)

  CleanJobLocal(jobId)
  
}

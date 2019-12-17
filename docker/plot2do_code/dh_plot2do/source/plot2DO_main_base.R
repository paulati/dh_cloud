

DownloadBAMDataFromS3 <- function(params, awsS3BucketName) {
  
  jobId <- params$jobId
  
  #download bam:
  if(params$inputFilePath == params$inputFilename) {
    # readsBasePath is initilized in plot2DO.R
    dataFilePath <- file.path(readsBasePath, params$inputFilename)
  }
  # guardo desde s3 en dataFilePath
  account.key <- awsAccountKey
  account.secret <- awsAccountSecret
  remote.base.folder.path <- awsS3ReadsNameBase
  file.name <- params$inputFilename
  local.base.folder.path <- dirname(dataFilePath)
  local.file.name <- basename(dataFilePath)
  bucket.name <- awsS3BucketName
  
  download.from.s3(account.key, account.secret, 
                   remote.base.folder.path, file.name,
                   local.base.folder.path, 
                   local.file.name, bucket.name)
  
}

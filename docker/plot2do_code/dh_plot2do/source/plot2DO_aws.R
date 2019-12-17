library(aws.s3)

# https://cran.r-project.org/web/packages/aws.s3/readme/README.html
Sys.setenv("AWS_ACCESS_KEY_ID" = awsAccountKey,
           "AWS_SECRET_ACCESS_KEY" = awsAccountSecret,
           "AWS_DEFAULT_REGION" = "us-east-1")


download.from.s3 <- function(account.key, account.secret,
                             remote.base.folder.path, file.name,
                             local.base.folder.path, 
                             local.file.name, bucket.name)
{
  original.wd <- getwd()
  
  setwd(local.base.folder.path)
  
  local.file.path <- file.path(local.base.folder.path, local.file.name)
  
  object.name <- file.path(remote.base.folder.path, file.name)
  aws.s3::save_object(object = object.name,
                      #key = account.key,
                      #secret = account.secret,
                      bucket = bucket.name,
                      file = local.file.path)
  
  setwd(original.wd)
  # borra el gz:
  # gunzip(local.file.name.gz, local.file.name)
  
  # no estoy usando estas credenciales, solo las que estan seteadas globales
}

upload.to.s3 <- function(account.key, account.secret,
                        bucket.name, remote.base.folder.path, 
                        remote.file.name, local.file.path)
{
  #setwd(local.base.folder.path)
  
  object.name <- paste(remote.base.folder.path, remote.file.name, sep="/")
  aws.s3::put_object(object = object.name,
#                     multipart = TRUE, 
#                     key = account.key,
#                     secret = account.secret,
                      bucket = bucket.name,
                      file = local.file.path)
  # no estoy usando estas credenciales, solo las que estan seteadas globales 
}


write.csv.to.s3 <- function(account.key, account.secret,
                            data.frame, bucket.name, object.name) {
  s3write_using(data.frame, FUN = write.csv,
                bucket = bucket.name,
                object = object.name)
  
  # no estoy usando estas credenciales, solo las que estan seteadas globales
}

read.csv.from.s3 <- function(account.key, account.secret, bucket.name, object.name) {
  result <- s3read_using(FUN = read.csv,
                bucket = bucket.name,
                object = object.name)
  return(result)
  # no estoy usando estas credenciales, solo las que estan seteadas globales
}




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
# end config

main <- file.path(sourceBasePath, "plot2DO_main.R")
source(main)


arguments_1 <- c(paste0("--file=", file.path(readsBasePath, "yeast_SRR2045610.5M_reads.bam")))
#arguments_1 <- c("--file=yeast_SRR2045610.5M_reads.bam")
  #c("--sd=3", "--quietly")

##############################
## a todos los demas hay que completarle la ruta file.path(readsBasePath, .......)
## ejemplo: paste0("--file=", file.path(readsBasePath, "yeast_SRR2045610.5M_reads.bam"))
##############################

# arguments_2 <- c("--file=yeast_SRR2045610.bam", "--type=dyads", "--reference=Plus1", "--colorScaleMax=0.15")
# 
# arguments_31 <- c("--file=yeast_SRR2045610.bam", "--sites=Annotations/Yeast_tRNA_genes.bed",
#                   "--align=fivePrime", "--siteLabel=tRNA", "--simplifyPlot=on")
# 
# arguments_32 <- c("--file=yeast_SRR2045610.bam", "--sites=Annotations/Yeast_ARS_locations.bed", 
#                   "--align=center", "--siteLabel=ARS", "--simplifyPlot=on")
# 
# arguments_33 <- c("--file=yeast_SRR2045610.bam", "--sites=Annotations/Yeast_centromeres.bed", 
#                   "--align=threePrime", "--siteLabel=centromere", "--simplifyPlot=on")
# 
# # mas o menos
# arguments_41 <- c("--file=fly_SRR2038265.5M_reads.bam", "--genome=dm3",
#                   "--reference=TSS", "--simplifyPlot=on")
# 
# # ok
# arguments_42 <- c("--file=worm_SRR3289717.5M_reads.bam", "--genome=ce10",
#                   "--reference=TSS", "--simplifyPlot=on")
# 
# # mas o menos
# arguments_43 <- c("--file=mouse_SRR572708.5M_reads.bam", "--genome=mm10",
#                   "--reference=TSS", "--simplifyPlot=on")
# 
# # mas o menos
# arguments_44 <- c("--file=human_SRR1781839.5M_reads.bam", "--genome=hg19", 
#                   "--reference=TSS", "--simplifyPlot=on")
# 
# arguments_51 <- c("--file=yeast_50U_MNase_SRR3649301.5M_reads.bam", "--sites=Annotations/Yeast_tRNA_genes.bed",
#                   "--siteLabel=tRNA", "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_52 <- c("--file=yeast_100U_MNase_SRR3649296.5M_reads.bam", "--sites=Annotations/Yeast_tRNA_genes.bed",
#                   "--siteLabel=tRNA", "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_53 <- c("--file=yeast_200U_MNase_SRR3649297.5M_reads.bam", "--sites=Annotations/Yeast_tRNA_genes.bed",
#                   "--siteLabel=tRNA", "--upstream=100", "--downstream=100", "--squeezePlot=on")
#  
# arguments_54 <- c("--file=yeast_300U_MNase_SRR3649298.5M_reads.bam", "--sites=Annotations/Yeast_tRNA_genes.bed",
#                   "--siteLabel=tRNA", "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_55 <- c("--file=yeast_400U_MNase_SRR3649299.5M_reads.bam", "--sites=Annotations/Yeast_tRNA_genes.bed",
#                   "--siteLabel=tRNA", "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_56 <- c("--file=yeast_50U_MNase_SRR3649301.5M_reads.bam", "--reference=Plus1",
#                   "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_57 <- c("--file=yeast_100U_MNase_SRR3649296.5M_reads.bam", "--reference=Plus1",
#                   "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_58 <- c("--file=yeast_200U_MNase_SRR3649297.5M_reads.bam", "--reference=Plus1",
#                   "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_59 <- c("--file=yeast_300U_MNase_SRR3649298.5M_reads.bam", "--reference=Plus1",
#                   "--upstream=100", "--downstream=100", "--squeezePlot=on")
# 
# arguments_510 <- c("--file=yeast_400U_MNase_SRR3649299.5M_reads.bam", "--reference=Plus1",
#                    "--upstream=100", "--downstream=100", "--squeezePlot=on")

# TODO: agregar un test con hg38



start.time <- Sys.time()
command_line_args <- c(arguments_1)
Main(command_line_args)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
gc()

# start.time <- Sys.time()
# Main(arguments_2)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_31)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_32)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_33)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_41)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_42)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_43)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_44)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_51)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_52)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_53)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_54)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_55)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_56)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_57)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_58)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_59)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()
# 
# start.time <- Sys.time()
# Main(arguments_510)
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
# gc()

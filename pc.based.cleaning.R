## This script is used for check ancestry analyses on the plink .eigenvec file to remove individuals based on PC1/PC2 plot
install.packages("plinkQC")
library(plinkQC)

## Exclude ancestry
indir <- system.file("extdata", package="plinkQC")
name <- 'BorghesiGBS.merged'
refname <- '1KG'
prefixMergedDataset <- paste(name, ".", refname, sep="")

exclude_ancestry <-
  evaluate_check_ancestry(indir=indir, name=name,
                          prefixMergedDataset=prefixMergedDataset,
                          refSamplesFile=paste(indir, "/Genomes1000_ID2Pop.txt",
                                               sep=""),
                          refColorsFile=paste(indir, "/Genomes1000_PopColors.txt",
                                              sep=""),
                          interactive=TRUE)
exclude_ancestry

# datasets that failed ancestry
fail_ancestry <- evaluate_check_ancestry(indir=indir, name=name,
                                         refSamplesFile=paste(indir, "/Genomes1000_ID2Pop.txt",sep=""),
                                         refColorsFile=paste(indir, "/Genomes1000_PopColors.txt", sep=""),
                                         prefixMergedDataset=prefixMergedDataset, interactive=FALSE)
head(fail_ancestry)

# highlight samples
highlight_samples <- read.table(system.file("extdata", "keep_individuals",
                                            package="plinkQC"))
fail_ancestry <- check_ancestry(indir=indir, name=name,
                                refSamplesFile=paste(indir, "/Genomes1000_ID2Pop.txt",sep=""),
                                refColorsFile=paste(indir, "/Genomes1000_PopColors.txt", sep=""),
                                prefixMergedDataset="BorghesiGBS.merged.1KG", interactive=FALSE,
                                highlight_samples = highlight_samples[,2],
                                run.check_ancestry=FALSE,
                                highlight_type = c("text", "shape"))

## failed individuals
fail_individuals <- perIndividualQC(indir=indir, name=name,
                                    refSamplesFile=paste(indir, "/Genomes1000_ID2Pop.txt",
                                                         sep=""), 
                                    refColorsFile=paste(indir, "/Genomes1000_ID2Pop.txt",
                                                        sep=""),
                                    prefixMergedDataset="BorghesiGBS.merged.1KG",
                                    path2plink=path2plink, do.run_check_ancestry = FALSE,
                                    interactive=TRUE, verbose=TRUE)

## Overview Individuals
overview_individuals <- overviewPerIndividualQC(fail_individuals,
                                                interactive=TRUE)
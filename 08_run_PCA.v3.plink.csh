#!/bin/csh
## Takes in binary plink file set name 
## Expects $PED_ROOT.[bed/bim/fam]
## Requires R (v2.9)
## Usage: ./run_PCA.csh $PED_ROOT
## Run R command manually to get plots:
## R CMD BATCH '--args $PED_ROOT.hm3.merge.SNPqc.mds $PED_ROOT.hm3.merge.SNPqc' $PLOT 

#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 40G
#SBATCH --time 24:00:00
#SBATCH --output=convertf-borghesi.out
#SBATCH --error=convertf-borghesi.error
#SBATCH --job-name=convertf-borghesi


## Set variables 
set REF_DIR = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/post-imputation/1KG/20181203_biallelic_SNV
set PLINK = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/post-imputation/plink

#############################################################
#### Merge 1KG snps with Borghesi SNPs ####
#############################################################

awk '{print $2}' BorghesiGBS.merged.bim > BorghesiGBS.merged.snps

## Update extract and map the Borghesi snps and onto 1KG-GRCH38 snps 
$PLINK --bfile $REF_DIR/1KG_GRCH38.integrated_v1a.full --extract BorghesiGBS.merged.snps --make-bed --out 1KG_GRCH38.integrated_v1a.snpQC.TMP --noweb
$PLINK --bfile BorghesiGBS.merged --bmerge 1KG_GRCH38.integrated_v1a.snpQC.TMP.bed 1KG_GRCH38.integrated_v1a.snpQC.TMP.bim 1KG_GRCH38.integrated_v1a.snpQC.TMP.fam --make-bed --out BorghesiGBS.merged.1kg.merge.TMP --noweb --memory 40000 --threads 8

## the commands below are only used if you need to flip and correct for strandedness based on the .missnp report generated post merging. This is followed by merging of the dataset again
$PLINK --bfile BorghesiGBS.merged --flip BorghesiGBS.merged.1kg.merge.TMP.missnp --make-bed --out BorghesiGBS.merged.1kgSNPs.flip.TMP --noweb

mv BorghesiGBS.merged.1kgSNPs.flip.TMP.bed  BorghesiGBS.merged.1kgSNPs.TMP.bed
mv BorghesiGBS.merged.1kgSNPs.flip.TMP.bim  BorghesiGBS.merged.1kgSNPs.TMP.bim
mv BorghesiGBS.merged.1kgSNPs.flip.TMP.fam  BorghesiGBS.merged.1kgSNPs.TMP.fam

$PLINK --bfile BorghesiGBS.merged.1kgSNPs.TMP --bmerge 1KG_GRCH38.integrated_v1a.snpQC.TMP.bed 1KG_GRCH38.integrated_v1a.snpQC.TMP.bim 1KG_GRCH38.integrated_v1a.snpQC.TMP.fam --make-bed --out BorghesiGBS.merged.1kg.merge.TMP  --noweb
$PLINK --bfile BorghesiGBS.merged.1kg.merge.TMP --exclude BorghesiGBS.merged.1kg.merge.TMP.missnp --make-bed --out BorghesiGBS.merged.1kg.flip.TMP --noweb 

#mv $PED_ROOT.hm3SNPs.flip.TMP.bed $PED_ROOT.hm3SNPs.TMP.bed
#mv $PED_ROOT.hm3SNPs.flip.TMP.bim $PED_ROOT.hm3SNPs.TMP.bim
#mv $PED_ROOT.hm3SNPs.flip.TMP.fam $PED_ROOT.hm3SNPs.TMP.fam

$PLINK --bfile $PED_ROOT.hm3SNPs.TMP --bmerge hapmap3_r2_b36_all_pops.snpQC.TMP.bed hapmap3_r2_b36_all_pops.snpQC.TMP.bim hapmap3_r2_b36_all_pops.snpQC.TMP.fam --make-bed --out $PED_ROOT.hm3.merge.TMP  --noweb

## Some SNP QC and run PCA using PLINK. 
$PLINK --bfile BorghesiGBS.1kg.merge.TMP --geno 0.01 --maf 0.01 --recode --make-bed --out BorghesiGBS.1kg.merge.SNPqc  --noweb
$PLINK --bfile BorghesiGBS.1kg.merge.SNPqc --pca --out BorghesiGBS.1kg.plink.pca

#end
#!/bin/csh
## Takes in binary plink file set name 
## Expects $PED_ROOT.[bed/bim/fam] binary files

#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 24:00:00
#SBATCH --output=EUR.covars.logistic.col.out
#SBATCH --error=EUR.covars.logistic.col.error
#SBATCH --job-name=EUR.covars.logistic

## This script is run to perform association analysis between "Colonization" binary phenotype with Borghesi SNPs
## This analysis adjusts for multiple covariates and principle components
## PLINK2 glm determines the correct model (linear vs logistic regression) based on input data type (continuous vs binary)

## Set variables 
set PLINK2 = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/plink2

#############################################################
#### Run a PC adjusted GWAS using Plink2 Logis model ####
#############################################################

$PLINK2 --bfile /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/13_GWAS/EUR.BorghesiGBS.merged.upsex/EUR.BorghesiGBS.merged.upsex \
	   --glm hide-covar \
	   --pheno EUR.pheno.colonization --1 \
	   --pheno-name Ph_colonization \
	   --ci 0.95 \
	   --maf 0.05 \
	   --geno 0.1 \
	   --hwe 1e-6 \
	   --covar EUR.covars.pcs.txt \
	   --covar-name PC1 PC2 PC3 PC4 Klebsiella Primiparous ANA Clin_autoimm_noThyr Clin_inflam_dis \
	   --covar-variance-standardize PC1 PC2 PC3 PC4 \
	   --out EUR.BorghesiGBS.covar.r2

# Sort according to p-values
sort -k14 -g EUR.BorghesiGBS.covar.r2.Ph_colonization.glm.logistic.hybrid > EUR.BorghesiGBS.covar.r2.Ph_colonization.glm.logistic.hybrid.sorted

# Keep only GWAS significant SNPs
awk '$14<5.0e-08' EUR.BorghesiGBS.covar.r2.Ph_colonization.glm.logistic.hybrid.sorted > EUR.BorghesiGBS.covar.r2.Ph_colonization.glm.logistic.hybrid.sorted.signifcant

# Change X chromosome to 23
#awk '{ $1 = ($1 == "X" ? 23 : $1) } 1' ${FOLDER_RESULTS}/merged_CoLaus_UKB.CRP_log10.glm.linear > ${FOLDER_RESULTS}/merged_CoLaus_UKB.CRP_log10.glm.linear.23.txt

#end

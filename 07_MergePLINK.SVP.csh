#!/bin/csh

#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 20G
#SBATCH --time 01:00:00
#SBATCH --output=mergePLINK.out
#SBATCH --error=mergePLINK.error
#SBATCH --job-name=MergePLINK

#############################################################
#### Merge updated plink files ####
#############################################################

## Specify number of cpus-per-task given and memory (Mb) for plink ##
set MEM = 20000

## variables
## Merge ##
#set DATA = `(ls ./PLINK/*.CoPrAC1.rs.bim | awk -F "[./]" '{print $4"."$5"."$6}')`
  
##echo "X.$PROJECT.rs.bed ./PLINK/X.$PROJECT.rs.bim ./PLINK/X.$PROJECT.rs.fam" > ./PLINK/txt/$PROJECT.mergelist

##set k = 2
##while ($k <= 22)
##  echo "./PLINK/$k.$PROJECT.rs.bed ./PLINK/$k.$PROJECT.rs.bim ./PLINK/$k.$PROJECT.rs.fam" >> ./PLINK/txt/$PROJECT.mergelist
##@ k++
##end

./plink --bfile chr1.BorghesiGBS.rs \
  --merge-list mergelist.txt \
  --keep-allele-order \
  --memory $MEM \
  --make-bed \
  --out BorghesiGBS.merged

##end
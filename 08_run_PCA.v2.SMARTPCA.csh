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

set REF_DIR = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/post-imputation/1KG/20181203_biallelic_SNV
set PLINK = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/post-imputation/plink
set MT = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/post-imputation/merge_tables.pl
set CONVERTF = /work/backup/gr-fe/pipaliya/tools/EIG-6.1.4/bin/convertf
set SMARTPCA = /work/backup/gr-fe/pipaliya/tools/EIG-6.1.4/bin/smartpca

#############################################################
#### Merge 1KG snps with Borghesi SNPs ####
#############################################################

## Update extract and map the Borghesi snps and onto 1KG-GRCH38 snps 
$PLINK --bfile /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/post-imputation/1KG/20181203_biallelic_SNV/1KG_GRCH38.integrated_v1a.full --extract BorghesiGBS.merged.snps --make-bed --out 1KG_GRCH38.integrated_v1a.snpQC.TMP --noweb
$PLINK --bfile BorghesiGBS.merged --bmerge 1KG_GRCH38.integrated_v1a.snpQC.TMP.bed 1KG_GRCH38.integrated_v1a.snpQC.TMP.bim 1KG_GRCH38.integrated_v1a.snpQC.TMP.fam --make-bed --out BorghesiGBS.1kg.merge.TMP --noweb --memory 40000 --threads 8

## the commands below are only used if you need to flip and correct for strandedness based on the .missnp report generated post merging. This is followed by merging of the dataset again
#$PLINK --bfile BorghesiGBS.merged --flip BorghesiGBS.1kg.merge.TMP.missnp --make-bed --out BorghesiGBS.1kg.flip.TMP --noweb
#$PLINK --bfile $PED_ROOT --flip $PED_ROOT.hm3.merge.TMP.missnp --make-bed --out $PED_ROOT.hm3SNPs.flip.TMP --noweb

#mv $PED_ROOT.hm3SNPs.flip.TMP.bed $PED_ROOT.hm3SNPs.TMP.bed
#mv $PED_ROOT.hm3SNPs.flip.TMP.bim $PED_ROOT.hm3SNPs.TMP.bim
#mv $PED_ROOT.hm3SNPs.flip.TMP.fam $PED_ROOT.hm3SNPs.TMP.fam

#$PLINK --bfile $PED_ROOT.hm3SNPs.TMP --bmerge hapmap3_r2_b36_all_pops.snpQC.TMP.bed hapmap3_r2_b36_all_pops.snpQC.TMP.bim hapmap3_r2_b36_all_pops.snpQC.TMP.fam --make-bed --out $PED_ROOT.hm3.merge.TMP  --noweb
#$PLINK --bfile $PED_ROOT.hm3SNPs.TMP --exclude $PED_ROOT.hm3.merge.TMP.missnp --make-bed --out $PED_ROOT.hm3SNPs.flip.TMP --noweb 

#mv $PED_ROOT.hm3SNPs.flip.TMP.bed $PED_ROOT.hm3SNPs.TMP.bed
#mv $PED_ROOT.hm3SNPs.flip.TMP.bim $PED_ROOT.hm3SNPs.TMP.bim
#mv $PED_ROOT.hm3SNPs.flip.TMP.fam $PED_ROOT.hm3SNPs.TMP.fam

#$PLINK --bfile $PED_ROOT.hm3SNPs.TMP --bmerge hapmap3_r2_b36_all_pops.snpQC.TMP.bed hapmap3_r2_b36_all_pops.snpQC.TMP.bim hapmap3_r2_b36_all_pops.snpQC.TMP.fam --make-bed --out $PED_ROOT.hm3.merge.TMP  --noweb

## Some SNP QC and run PCA. Need to make .pedind file
$PLINK --bfile BorghesiGBS.1kg.merge.TMP --geno 0.01 --maf 0.01 --recode --out BorghesiGBS.1kg.merge.SNPqc  --noweb

echo "FID IID MID PID SEX" > foo.TMP
awk '{print $1,$2,$3,$4,$5}' BorghesiGBS.1kg.merge.SNPqc.ped >> foo.TMP

echo "IID POP" > bar.TMP
tail -n +2 1KG-sample-IDs.labels | awk '{print $1,$2}' >> bar.TMP

perl merge_tables.pl --file1 bar.TMP --file2 foo.TMP --index IID | tail -n +2 | awk '{ if ($6 == "NA") {print $1,$2,"0","0",$5,"Test"} else {print $1,$2,"0","0",$5,"Ref"}}' > BorghesiGBS.1kg.merge.SNPqc.pedind

set PATH="/work/backup/gr-fe/pipaliya/tools/EIG-6.1.4/bin:$PATH"

echo "genotypename:    BorghesiGBS.1kg.merge.SNPqc.ped" > BorghesiGBS.convertf.par
echo "snpname:         BorghesiGBS.1kg.merge.SNPqc.map" >> BorghesiGBS.convertf.par
echo "indivname:       BorghesiGBS.1kg.merge.SNPqc.pedind" >> BorghesiGBS.convertf.par
echo "outputformat:    EIGENSTRAT" >> BorghesiGBS.convertf.par
echo "genotypeoutname: BorghesiGBS.1kg.merge.SNPqc.geno" >> BorghesiGBS.convertf.par
echo "snpoutname:      BorghesiGBS.1kg.merge.SNPqc.snp" >> BorghesiGBS.convertf.par
echo "indivoutname:    BorghesiGBS.1kg.merge.SNPqc.ind" >> BorghesiGBS.convertf.par
echo "familynames:     NO" >> BorghesiGBS.convertf.par

$CONVERTF -p BorghesiGBS.convertf.par

echo "Ref"             > POPlist            
echo "genotypename:    BorghesiGBS.1kg.merge.SNPqc.geno" > BorghesiGBS.smartpca.par
echo "snpname:         BorghesiGBS.1kg.merge.SNPqc.snp" >> BorghesiGBS.smartpca.par
echo "indivname:       BorghesiGBS.1kg.merge.SNPqc.pedind" >> BorghesiGBS.smartpca.par
echo "evecoutname:     BorghesiGBS.1kg.merge.SNPqc.evec" >> BorghesiGBS.smartpca.par
echo "evaloutname:     BorghesiGBS.1kg.merge.SNPqc.eval" >> BorghesiGBS.smartpca.par
echo "altnormstyle:    NO" >> BorghesiGBS.smartpca.par
echo "numoutevec:      10" >> BorghesiGBS.smartpca.par
echo "numoutlieriter:  0"  >> BorghesiGBS.smartpca.par
echo "poplistname:     POPlist" >> BorghesiGBS.smartpca.par
​
$SMARTPCA -p BorghesiGBS.smartpca.par > BorghesiGBS.smartpca.log

echo "FID IID PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 Panel" > BorghesiGBS.1kg.merge.SNPqc.mds.tmp
grep -v eigvals BorghesiGBS.1kg.merge.SNPqc.evec | tr ":" " " | awk '{print $2,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' >> BorghesiGBS.1kg.merge.SNPqc.mds.tmp

$MT --file1 1KG-sample-IDs.labels --file2 BorghesiGBS.1kg.merge.SNPqc.mds.tmp --index IID | awk '{if ($14 == "NA") {print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,"Test"} else {print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$14}}' > BorghesiGBS.1kg.merge.SNPqc.mds

#R CMD BATCH '--args $PED_ROOT.hm3.merge.SNPqc.mds $PED_ROOT.hm3.merge.SNPqc' $PLOT 
Rscript $PLOT2 BorghesiGBS.1kg.merge.SNPqc.mds BorghesiGBS.1kg.merge.SNPqc
Rscript $PLOT1 BorghesiGBS.1kg.merge.SNPqc.mds BorghesiGBS.1kg.merge.SNPqc

rm *TMP*
#rm $PED_ROOT.hm3.merge.SNPqc.mds.tmp $PED_ROOT.snps $PED_ROOT.hm3.merge.SNPqc.hh $PED_ROOT.hm3.merge.SNPqc.ped $PED_ROOT.hm3.merge.SNPqc.map $PED_ROOT.hm3.merge.SNPqc.pedind $PED_ROOT.hm3.merge.SNPqc.snp $PED_ROOT.hm3.merge.SNPqc.ind $PED_ROOT.hm3.merge.SNPqc.geno $PED_ROOT*.par $PED_ROOT.hm3.merge.SNPqc.eval $PED_ROOT.hm3.merge.SNPqc.evec $PED_ROOT.hm3.merge.SNPqc.log $PED_ROOT.smartpca.log MDS_QCplotter.Rout 

#end
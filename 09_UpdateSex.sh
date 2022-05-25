#!/bin/bash

#BSUB -L /bin/bash
#BSUB -J updatesex
#BSUB -o %J_out.txt
#BSUB -e %J_err.txt
#BSUB -u christian.hammer@epfl.ch
#BSUB -N
#BSUB -R "rusage[mem=64000]" 
#BSUB -M 64000000

module add UHTS/Analysis/plink/1.90
plink --bfile plink/merged --update-sex /data/epfl/fellay/chammer/SHCS/genotyping/SHCS2016/SHCS.sexInfo --keep-allele-order --make-bed --out plink/final --memory 64000

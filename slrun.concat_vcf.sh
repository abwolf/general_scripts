#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=10G
#SBATCH --time 23:00:00
#SBATCH --qos=1day
#SBATCH --output=slrun.concat_vcf.%A_%a.o
source ~/.bashrc

date
echo **CONCAT VCF**
vcf-concat ./Tenn_nonAfr_*_n1_0.25_n2_0.0.mod.vcf.gz | bgzip -c > ./Tenn_nonAfr_ALL_n1_0.25_n2_0.0.mod.vcf.gz

echo **TABIX**
tabix -p vcf Tenn_nonAfr_ALL_n1_0.25_n2_0.0.mod.vcf.gz

echo FIN
date


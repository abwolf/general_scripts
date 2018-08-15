#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=4G
#SBATCH --time 2-0
#SBATCH --qos=1wk
#SBATCH --output=slrun.tar.%A_%a.o
source ~/.bashrc

date
echo Tar file
echo $1  "$1".tar.gz

tar -zcvf "$1".tar.gz $1

echo fin
date

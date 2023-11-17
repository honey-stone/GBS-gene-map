#!/bin/bash

#SBATCH --mem 10GB
#SBATCH -p common
#SBATCH -n 10
#SBATCH -N 1
#SBATCH -t 10:00:00

python3 gene_map.py
#python3 gene_map_N.py
python3 chr_split.py
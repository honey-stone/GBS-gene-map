#!/bin/bash

#SBATCH --mem 10GB
#SBATCH -p common
#SBATCH -n 10
#SBATCH -N 1
#SBATCH -t 1:00:00

work_dir=$(cat work_dir_path.txt)

map_dir=${work_dir}/gene_map/maps

for python in ${work_dir}/*_dir/*.py
	do
	python3 ${python}
done
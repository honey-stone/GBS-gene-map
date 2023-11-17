#!/bin/bash

#SBATCH --mem 10GB
#SBATCH -p common
#SBATCH -n 10
#SBATCH -N 1
#SBATCH -t 10:00:00

work_dir=$(cat work_dir_path.txt)
gene_map_dir=${work_dir}/gene_map

main_dir=${gene_map_dir}/vcf_preparing
zip_dir=${main_dir}/zip_vcf

mkdir -p ${main_dir}/merged
merged_dir=${main_dir}/merged

mkdir -p ${main_dir}/no_mis_GT
GT_dir=${main_dir}/no_mis_GT

mkdir -p ${main_dir}/new_names/
names_dir=${main_dir}/new_names/

cd ${zip_dir}

# Groups samples into one VCF. It takes a lot of time...
for list in *.txt
	do
	bcftools merge -l ${list} -o ${merged_dir}/${list}.vcf.gz
done

# Remove empty GT and
# change sample names according to the names.txt file
cd ${merged_dir}

for file in *.vcf.gz
	do
	bcftools view -e 'GT="mis"' ${file} -Oz -o ${GT_dir}/${file}
	bcftools reheader -s ${gene_map_dir}/'names.txt' ${GT_dir}/${file} -o ${names_dir}/${file}
done

# Extract columns to csv with sep=tab
cd ${names_dir}

for file in *.vcf.gz
	do
	bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' ${file} > ${main_dir}/${file}.csv
	cat ${gene_map_dir}/header.txt ${main_dir}/${file}.csv > ${main_dir}/${file}_header.csv
	mv ${main_dir}/${file}_header.csv ${main_dir}/${file}.csv
done

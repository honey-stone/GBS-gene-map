#!/bin/bash

#SBATCH --mem 10GB
#SBATCH -p common
#SBATCH -n 10
#SBATCH -N 1
#SBATCH -t 10:00:00

work_dir=$(cat work_dir_path.txt)

input_dir=${work_dir}/VCF
gene_map_dir=${work_dir}/gene_map
mkdir ${gene_map_dir}/quality_filter
mkdir ${gene_map_dir}/vcf_preparing

cd ${input_dir}

for file in *.vcf
	do
	mkdir ${gene_map_dir}/quality_filter/${file}
	output_dir=${gene_map_dir}/quality_filter/${file}
	bcftools stats ${file} > ${output_dir}/${file}.txt
	
	# Фильтрация по качеству картирования (MQ>10)
	bcftools view -i 'INFO/MQ>10' ${file} -Ov -o ${output_dir}/${file}_MQ.vcf
	cd ${output_dir}
	bcftools stats ${file}_MQ.vcf > ${file}_MQ.txt

	# Фильтрация по глубине прочтения каждого аллеля (AD>10)
	bcftools view -i 'FORMAT/AD > 10' ${file}_MQ.vcf -o ${file}_AD.vcf
	bcftools stats ${file}_AD.vcf > ${file}_AD.txt

	# Фильтрация по ALT/REF >= 0.5
	bcftools filter -e '(FORMAT/AD[0:1] / FORMAT/AD[0:0]) < 0.5' ${file}_AD.vcf > ${file}_ALT-REF.vcf
	bcftools stats ${file}_ALT-REF.vcf > ${file}_ALT-REF.txt

	# Архивирование и создание csi индекса
	bgzip -c ${file}_ALT-REF.vcf > ${gene_map_dir}/vcf_preparing/zip_vcf/${file}_ALT-REF.vcf.gz
	tabix -p vcf -C ${gene_map_dir}/vcf_preparing/zip_vcf/${file}_ALT-REF.vcf.gz

	cd ${input_dir}	

done

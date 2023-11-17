# gene-map
Construction of a genetic map for barley near-isogenic lines (NILs) showing which regions were inherited from the recipient variety and which - from the donor.

BEFORE RUNNING

1. Copy a gene_map directory in your working directory where VCF dir is located.
2. Type in work_dir_path.txt the path to your working directory without '/' at the end.
3. In a /gene_map, create a vcf_preparing/zip_vcf directory. Then, in /zip_vcf, create txt file(s) with VCF files which you want to merge. You should keep the following order: recipient, donor and NIL, each on a new line. Add to the end of each VCF '_ALT-REF.vcf.gz' 
	For example, you want to create a gene map for Aley_BA sample and you have Aley.vcf, BA.vcf and Aley_BA.vcf. Thus you need to create a txt with 
	Aley.vcf_ALT-REF.vcf.gz
	BA.vcf_ALT-REF.vcf.gz
	Aley_BA_ALT-REF.vcf.gz


ORDER OF RUNNING THE SCRIPTS

1. filter.sh
2. vcf_to_tsv.sh
3. gene_map.sh
4. gene_map_png.sh


SCRIPTS DESCRIPTION

1. filter.sh
This script filters VCF files by quality.
In particular, by
 - mapping quality (MQ>10)
 - sequencing depth of each allele (allele depth, AD>10)
 - ratio of depth of the ALT and REF alleles in polymorphic positions (>= 0.5).
It also archives the filtered VCF to VCF.gz and creates a CSI index for further steps.


2. vcf_to_tsv.sh
This script converts VCF to TSV for further python scripts.
It consists of the following steps 
- groups VCF files (parents - NIL)
- deletes empty genotypes (./.)
- renames samples to standard names
- creates TSV file in the desired format.
The final TSV file contains columns 'CHROM' 'POS' 'REF' 'ALT' 'SAMPLES'.


3. gene_map.sh
This script executes python scripts gene_map.py, gene_map_N.py, chr_split.py

	3.1 gene_map.py
	Compares the genotype of the NIL to the genotypes of parents
	- If the genotype of NIL is similar to the recipient's genotype but different from the donor's, writes R
	- If similar to the donor and different from the recipient, writes D 	- If the site is non-polymorphic (does not differ between the parents), writes N.
	The result is a CSV table with columns 'CHR' 'POS' 'GT' where R, D or N is specified for each nucleotide position. This is actually a gene map :)

	3.2 gene_map_N.py
	Removes all N from CSV gene map and keep only polymorfic positions.

	3.3 chr_split.py
	Splits a CSV gene map by the chromosomes.


4. gene_map_png.sh
This script executes python script visualise_gene_map.py
copy this py-script to the directory where the CSV gene maps for individual chromosomes are located.

	4.1 visualise_gene_map.py
	Creates a png picture of your gene map.
	You can add a region of interest on a picture by specifying the chromosome where this region is located, the start and end point, and the name of the region. 

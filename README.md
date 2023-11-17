# gene-map
## Construction of a genetic map for barley near-isogenic lines (NILs) showing which regions were inherited from the recipient variety and which - from the donor.

### BEFORE RUNNING

1. Copy a gene_map directory in your working directory where dir with VCF files is located.
2. Type in work_dir_path.txt the path to your working directory without '/' at the end.
3. In a /gene_map, create a vcf_preparing/zip_vcf directory. Then, in /zip_vcf, create txt file(s) with VCF-files' names which you want to merge. You should keep the following order: recipient, donor and NIL, each on a new line. Add to the end of each VCF '.gz'
	For example, you want to create a gene map for Aley_BA sample and you have Aley.vcf, BA.vcf and Aley_BA.vcf. You need to create a txt with 
	Aley.vcf.gz
	BA.vcf.gz
	Aley_BA.vcf.gz


### ORDER OF RUNNING THE SCRIPTS

1. filter.sh
2. vcf_to_tsv.sh
3. gene_map.sh
4. gene_map_png.sh


### SCRIPTS DESCRIPTION

#### 1. filter.sh
This script filters VCF files by quality:
 - mapping quality (MQ>10)
 - sequencing depth of each allele (allele depth, AD>10)
 - ratio of depth of the ALT and REF alleles in polymorphic positions (>= 0.5).
After each filtering step it gives statistical info
It also archives the filtered VCF to VCF.gz and creates a CSI index for further steps.


#### 2. vcf_to_tsv.sh
This script converts VCF to TSV for further python scripts.
It consists of the following steps 
- groups VCF files (parents - NIL)
- deletes empty genotypes (./.)
- renames samples to standard names (according to names.txt)
- creates TSV file
The final TSV file contains columns 'CHROM' 'POS' 'REF' 'ALT' 'SAMPLES'.

Output example:
'''
CHR     POS     REF     ALT     RECIPIENT       DONOR   NIL
1H      50230   C       .       0/0     0/0     0/0
1H      50231   G       A       1/1     0/0     1/1
1H      50232   G       T       1/1     0/0     1/1
'''

#### 3. gene_map.sh
This script executes python scripts gene_map.py, gene_map_N.py, chr_split.py

##### 3.1 gene_map.py
Compares the genotype of the NIL to the genotypes of parents
- If the genotype of NIL is similar to the recipient's genotype but different from the donor's, writes R (Recipient)
- If similar to the donor and different from the recipient, writes D (Donor)
- If the site does not differ between the parents, writes N (Non-polymorfic).
The result is a CSV table with columns 'CHR' 'POS' 'GT' where R, D or N is specified for each nucleotide position. This is actually a gene map :)
	
Output example:
CHR,POS,GT
1H,50230,N
1H,50231,R
1H,50232,R

##### 3.2 gene_map_N.py
Removes all Non-polymorfic sites from CSV gene map and keep only polymorfic positions.

##### 3.3 chr_split.py
Splits a CSV gene map by chromosomes.

#### 4. gene_map_png.sh
This script executes python script visualise_gene_map.py
!!! copy these sh- and py-scripts to the directory where the CSV gene maps for individual chromosomes are located.

##### 4.1 visualise_gene_map.py
Creates a png picture of your gene map.
You can add a region of interest on a picture by specifying the chromosome where this region is located, the start and end point, and the name of the region. 

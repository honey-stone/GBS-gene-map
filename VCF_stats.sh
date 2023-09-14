Well, we have 4 stats.txt for each VCF file (before filtration and after 3 steps of filtration).
1. VCF.txt
2. VCF-MQ.txt
3. VCF-AD.txt
4. VCF-ALT-REF.txt
I need to extract from all 4 txt lines starting with SN and keep it into one common file.
To do this, lets use grep '^SN' stats.txt with for cycle.

for txt in *.txt
do
  grep '^ID\t' ${txt} >> parsed_stats.csv
  grep '^SN' ${txt} >> parsed_stats.csv
done


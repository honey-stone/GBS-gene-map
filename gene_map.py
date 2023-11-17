import pandas as pd
import os
import glob2

WORK_DIR = os.getcwd()

os.makedirs(f'{WORK_DIR}/gene_map/maps', exist_ok=True)

INPUT_DIR = f'{WORK_DIR}/vcf_preparing'
OUTPUT_DIR = f'{WORK_DIR}/maps'

os.chdir(INPUT_DIR)
csv = glob2.glob('*.csv')

for input in csv:
	df = pd.read_csv(input, sep='\t')
	# Custom function compare
	def compare(row):
		if row['NIL'] == row['RECIPIENT']:
			return 'R' # recipient
		elif row['NIL'] != row['RECIPIENT']:
			return 'D' # different from recipient
		else:
			return 'NA'
	df['GT'] = df.apply(compare, axis=1)
	
	df_out = df[['CHR', 'POS', 'GT']]
	output = f'{OUTPUT_DIR}/map_{input}'
	df_out.to_csv(output)

import pandas as pd
import os
import glob2

INPUT_DIR = os.getcwd()

WORK_DIR = f'{INPUT_DIR}/maps'

os.chdir(WORK_DIR)

maps = glob2.glob('map_*.csv')

for map in maps:
	os.mkdir(f'{WORK_DIR}/{map}_dir')
	df_map = pd.read_csv(map, sep=',')

	for CHR in '1H', '2H', '3H', '4H', '5H', '6H', '7H':
		df_CHR = df_map[df_map['CHR'] == CHR]
		out_file = f'{WORK_DIR}/{map}_dir/{CHR}.csv'
		df_CHR.to_csv(out_file)
import pandas as pd
import os
import glob2

WORK_DIR = '/beegfs/data/hpcws/ws1/molobekova-work/chr/gene_map/maps'
OUT_DIR = '/beegfs/data/hpcws/ws1/molobekova-work/chr/gene_map/no_N_maps'

os.chdir(WORK_DIR)

maps = glob2.glob('map_*.csv')

for map in maps:
	df_map = pd.read_csv(map, sep=',')
	mask = ~df_map['GT'].str.contains('N', case=False, na=False)
	df_map_no_N = df_map[mask]
	
	map_no_N = f'{OUT_DIR}/no_N_{map}'
	df_map_no_N.to_csv(map_no_N, sep=',')

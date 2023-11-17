import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
import matplotlib.colors as mcolors
from matplotlib.lines import Line2D
from matplotlib.ticker import FixedLocator, FixedFormatter
import numpy as np
from matplotlib.lines import Line2D
import os

matplotlib.use('Agg')

WORK_DIR = os.getcwd()

# Creating variables for loop
y = 0

fig, ax = plt.subplots()

ytick_positions = []
ytick_labels = []

for CHR in '1H', '2H', '3H', '4H', '5H', '6H', '7H':
  input = f'{WORK_DIR}/{CHR}.csv'
  map = pd.read_csv(input, sep=',')
  R = map[map['GT'] == 'R']
  D = map[map['GT'] == 'D']
    
  r = ax.scatter(R['POS'], [y] * len(R), color='yellowgreen', marker='|', linewidth=0.5, s=200)  # CHOSING COLOR FOR RECIPIENT SNP (R)
  d = ax.scatter(D['POS'], [y] * len(D), color='tomato', marker='|', linewidth=0.3, s=200)   # CHOSING COLOR FOR DONOR SNP (D)

  if CHR == '4H': # choosing chromosome where region of interest is located
    region_name = 'HvMyc2'
    region_start = 507301407
    region_end = 507302689
    region_POS = np.arange(region_start, region_end)
    region = pd.DataFrame({'POS': region_POS})
    gene = ax.scatter(region['POS'], [y] * len(region), color='darkblue', marker='|', s=200)
    ax.annotate(region_name, xy=(region_start, y), xytext=(region_start*0.95, y+0.25), fontsize=7, color="black")

  ytick_positions.append(y)
  ytick_labels.append(f'{CHR}')

  y = y + 1

r_proxy = Line2D([0], [0], color='yellowgreen', lw=4, label='recipient')
d_proxy = Line2D([0], [0], color='tomato', lw=4, label='donor')

ax.legend(handles=[r_proxy, d_proxy], loc='upper left', bbox_to_anchor=(1, 1), fontsize='small')

ax.yaxis.set_major_locator(FixedLocator(ytick_positions))
ax.yaxis.set_major_formatter(FixedFormatter(ytick_labels))

ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

out_file = 'gene_map.png'
fig.savefig(out_file, dpi=300, bbox_extra_artists=(ax.legend_, ), bbox_inches='tight')

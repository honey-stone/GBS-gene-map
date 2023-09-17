How many sites is the map built from?
How many of them are polymorphic (R, D)
How many are non-polymorphic (N)?

maps_dir=path
for map in *.csv
do
  grep -c ${map} > all_stats.txt

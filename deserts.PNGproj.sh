file=$1      #eg. Pop1356_*.all
Model=$2     #eg. "Tenn", "GravelLwcExn",...
sim_size=$3  #eg. 500kb, 1Mb, 15Mb
##winfile=$5   #eg. ~/Documents/SimulatedDemographic_Deserts/bedops/sim_regions_15Mb_Xkb.bed

#echo "sampling simulated data"
#echo "columns: chr, haplo_start, haplo_end, haplo_len, Model"
#time Rscript /Users/abwolf/Documents/SimulatedDemographic_Deserts/bedops/Sampling_complex_StndrdMdl.R $file $Model \
#	| grep -v Read \
#	| awk 'BEGIN {OFS="\t"} $2!=$3 {print $6, $2, $3, $9, $10}' \
#	| sort-bed - \
#	> $file.sample

echo "sorting bed"
time awk 'BEGIN {OFS="\t"} $2!=$3 {print $6, $2, $3}' $file \
	| sort-bed - \
	> out.bed
echo "calling deserts"
echo "col : chr, desstrt, desend, Model"
time bedops --ec -d ~/AkeyRotation/bin/sim_regions.bed.$sim_size out.bed \
	| awk 'BEGIN {OFS="\t"} {print$0,"'$Model'"}' \
	> "$file".sample.deserts

echo "deleting intermediate file"
time rm out.bed

#echo "calling #of introgressed bases in genomic window of given size"
#echo "columns: chr, win_start, win_end, #introgressed_bases, Ne, mr"
#time bedmap --ec --delim "\t" --echo --bases ~/Documents/SimulatedDemographic_Deserts/bedops/sim_regions_15Mb_100kb.bed $file.sample \
 #	| awk 'BEGIN {OFS="\t"} {print$0,'$Ne','$mr'}' \
  #	> $file.sample.window.15Mb100kb

#echo "calling #of introgressed bases in genomic window of given size"
#echo "columns: chr, win_start, win_end, #introgressed_bases, Ne, mr"
#time bedmap --ec --delim "\t" --echo --bases ~/Documents/SimulatedDemographic_Deserts/bedops/sim_regions_15Mb_1Mb.bed $file.sample \
 #       | awk 'BEGIN {OFS="\t"} {print$0,'$Ne','$mr'}' \
  #      > $file.sample.window.15Mb1Mb

#echo "calling #of introgressed bases in genomic window of given size"
#echo "columns: chr, win_start, win_end, #introgressed_bases, Ne, mr"
#time bedmap --ec --delim "\t" --echo --bases ~/Documents/SimulatedDemographic_Deserts/bedops/sim_regions_15Mb_500kb.bed $file.sample \
 #       | awk 'BEGIN {OFS="\t"} {print$0,'$Ne','$mr'}' \
  #      > $file.sample.window.15Mb500kb


echo "done"

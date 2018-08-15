file=$1
ID=$2

echo "taking all the called introgressed haplotypes for EU and EA pops, determine how many haplotypesfall into a 1kb window of 15Mb sim seq"
	awk 'BEGIN {OFS="\t"} $2!=$3 {if($5=="pop_2" || $5=="pop_3") print $6, $2, $3, $5}' $file \
	| sort-bed - \
	| bedmap --ec --delim "\t" --echo --count ~/Documents/SimulatedDemographic_Deserts/bedops/sim_regions_15Mb_1kb.bed - \
	| awk 'BEGIN {OFS="\t"} {print$0, $4/2014, "'$ID'"}' \
	> $file.haplofreq1kb

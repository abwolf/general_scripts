PROJ=/net/akey/vol2/bvernot/archaic_1kg_p3

callable=/net/akey/vol2/bvernot/archaic_1kg_p3/data/call_set_2015.11.06/callable_windows.EAS_EUR_SAS_PNG.bed.merged

queryable=queryable_windows_AllPops.be.merged

callset_EUR=/net/akey/vol2/bvernot/archaic_1kg_p3/data/call_set_2015.11.06/EUR/LL.callsetEUR.mr_0.99.neand_calls_by_hap.bed.merged.by_chr.bed
callset_EAS=/net/akey/vol2/bvernot/archaic_1kg_p3/data/call_set_2015.11.06/EAS/LL.callsetEAS.mr_0.99.neand_calls_by_hap.bed.merged.by_chr.bed

callset_EUREAS=LL.callset_EUREAS_.mr_0.99.neand_calls_by_hap.bed.merged.by_chr.bed

winfile=windows.10Mb.500kb.bed

echo "list of callabale windows"
time awk 'BEGIN {OFS="\t"} {$1="'chr'"$1; print$0}' $callable  \
    > $queryable

echo "make the window file"
time python $PROJ/bin/generate_window_bed_file.py 10000000 500000 \
    | sort-bed - \
    | bedmap --ec --delim '\t' --echo --bases - $queryable \
    > $winfile

echo "merge and sort EUR and EAS callsets into single bed file"
time cat $callset_EUR $callset_EAS \
    | awk 'BEGIN {OFS="\t"} {$1="'chr'"$1; print $1, $2, $3}' \
    | sort-bed - \
    > $callset_EUREAS

echo "getting total introgressed bases per window"
echo "cols are: chr, winstrt, winend, queryable_bases, total_bases from map-file's (callset) element covered by overlapping element in ref-file (genome-windows)"
time bedmap --ec --delim '\t' --echo --bases $winfile $callset_EUREAS \
    > $winfile.introgressed_bases

echo "getting desert sizes in 15mb windows, for comparison to 15mb simulations"
echo "cols are: chr, desert start, desert end, desert len, winchr, winstart, winend, queryable"
# chr2    185000000       185202372       202372  chr2    185000000       190000000       5000000
# chr2    185229208       188506446       3277238 chr2    185000000       190000000       5000000
# chr2    188589601       188632650       43049   chr2    185000000       190000000       5000000

time \
    while read c s e m ; do 
    echo $c $s $e \
        | tr ' ' '\t' \
        | bedops --ec -d - $callset_EUREAS \
        | awk 'BEGIN {OFS="\t"} {print $0, $3-$2, "'$c'", "'$s'", "'$e'", "'$m'"}'
    done < $winfile > $winfile.deserts_by_window

echo "convert desert length from bp to cM using genetic map GRCh37"
time 	sort-bed $winfile.deserts_by_window \
	| bedmap --delim '\t' --ec --echo --min --max - /net/akey/vol1/home/bvernot/archaic_exome/data/recombination_rates/genetic_map_HapMapII_GRCh37/2013.01.26/genetic_map_GRCh37_all.txt.distance.bed \
	| awk 'BEGIN {OFS="\t"} {print $0, $3-$2, $10-$9}' \
	> $winfile.deserts_by_window.length_in_cM

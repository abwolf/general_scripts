args = commandArgs(TRUE)
x. = args[1]
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
bed.format = function(x){

  ##Read in regions file, name and reorder column, write to a table as a .bed file
  x = fread(x)
 x = rename(x, 'sim_pop_chrom'=V1,'start'=V2,'stop'=V3,'chrom'=V4,'pop'=V5,'sim.iter'=V6,'iteration_tag'=V7,'intr_regions_tag'=V8)
  x = setcolorder(x, c('sim.iter','start','stop','sim_pop_chrom','pop','chrom','iteration_tag','intr_regions_tag'))
  
  x_EU = filter(x, pop =='pop_2')
  
  x_EA = filter(x, pop == 'pop_3')
  
    #Removing instances where the start and stop are identical
  x_EU[, complete := F]
  x_EU[start != stop, complete := T]
  x_EU_t = x_EU[complete == T]
  
  x_EA[, complete := F]
  x_EA[start != stop, complete := T]
  x_EA_t = x_EA[complete == T]

    #Write the cleaned data to a new .bed file
  write.table(x_EA_t,'~/Desktop/SimulatedDemographic/bedops/out_EA.bed', quote = FALSE, sep="\t", row.names = FALSE, col.names = FALSE)
  
  write.table(x_EU_t,'~/Desktop/SimulatedDemographic/bedops/out_EU.bed', quote = FALSE, sep="\t", row.names = FALSE, col.names = FALSE) 
}

bed.format(x.)

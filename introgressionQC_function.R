args = commandArgs(TRUE)
x. = args[1]
library("data.table")
library("dplyr")
library("ggplot2")

introgression.QC = function(x){
  data = fread(x, header = F)
  data = rename(data, sim.it.chr = V1, start = V2, stop =V3, chr = V4, pop = V5, sim.it = V6, tag= V7, itr = V8)
  data = mutate(data, diff = stop-start)
  ##Average % introgression
  EA.pctintr=data[pop=='pop_3', sum(as.numeric(diff)) / 572/(5000000*1000)]
  EU.pctintr=data[pop=='pop_2', sum(as.numeric(diff)) / 758/(5000000*1000)]
  
  ##A count of 5MB deserts based on error rate
  #create a set of all sim.it IDs
  uniq_sims = sprintf('sim_%d.task_%d', as.vector(sapply(0:9, function(x) rep(x, 100))), 1:100)
  #take a random sample of our data based to achieve a total recovery rate of 25%, weight based on size of fragment
  num.total = as.numeric(nrow(data))
  
  data.small = filter(data, diff <= 20000)
  dt.small = sample_frac(data.small, .01)
  num.small = as.numeric(nrow(dt.small))
  
  data.medium = filter(data, 20000 < diff, diff < 30000)
  dt.medium = sample_frac(data.medium, .1)
  num.medium = as.numeric(nrow(dt.medium))
  
  data.large = filter(data, diff >= 30000)
  dt.large = sample_n(data.large, (0.25*(num.total)-(num.medium+num.small)))
  num.large = as.numeric(nrow(dt.large))
  
  dt = rbind(dt.small,dt.medium,dt.large)

  #calculate for average percent of introgression across all 5MB haplotypes
  pctintr.5MB.window = as.data.table(sapply(uniq_sims, function(x){dt[x == sim.it, sum(as.numeric(diff))/1330 /5000000]}))
  #count the number of 5Mb haplotypes with 0 introgression
  n0=nrow(pctintr.5MB.window[V1==0])
  #plot the distribution of % introgression for 5MB haplotypes
  pctintr.5Mb.window.distribution = ggplot(pctintr.5MB.window, aes(x=V1)) + ggtitle(x) + xlab('% introgression in 5MB haplotype') + geom_histogram()
  
  haplotype.size.distribution = ggplot(dt, aes(x=diff/1000)) + ggtitle(x) + xlab('haplotype size (kb)') + geom_histogram()
 
  out.list = list('EA.pctintr'=EA.pctintr, 'EU.pctintr'=EU.pctintr,'total recovery rate'= as.numeric(nrow(dt)/nrow(data)), 'n0'=n0, 'pctintr.5Mb.window.distribution'=pctintr.5Mb.window.distribution, 'haplotype.size.distribution' = haplotype.size.distribution)
  return(out.list)
}

Z = introgression.QC(x.)

write.table(Z[1:4], file = 'QC', quote = FALSE, sep = '\t', row.names = FALSE, col.names = TRUE)

pdf('PercentIntrogession_by_5Mb.pdf')
print(Z[5])
dev.off()
pdf('Haplotype_size_distribution.pdf')
print(Z[6])
dev.off()


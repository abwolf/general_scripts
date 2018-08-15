args = commandArgs(TRUE)

x. = args[1]
x.Ne = args[2]
x.t = args[3]
MB = as.numeric(args[4])
SIMS = as.numeric(args[5])

library("data.table")
library("dplyr")

introgression.QC = function(x,Ne,t, mb, sims){
  data = fread(x, header = F)
  data = rename(data, sim.it.chr = V1, start = V2, stop =V3, chr = V4, pop = V5, sim.it = V6, tag= V7, itr = V8)
  data = mutate(data, diff = stop-start)
  ##Average % introgression                                     XMb  Ysims
   EA.pctintr=data[pop=='pop_3', sum(as.numeric(diff)) / 572/(as.numeric(mb)*as.numeric(sims))] # XMbxYsimulations for 572 individuals
  EU.pctintr=data[pop=='pop_2', sum(as.numeric(diff)) / 758/(as.numeric(mb)*as.numeric(sims))]
  
  ##Down sample 
  data = filter(data, pop=='pop_3' | pop=='pop_2')
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
  dt = mutate(dt, Ne = Ne)
  dt = mutate(dt, t = t)
  
  out.list = list('EA.pctintr'=EA.pctintr, 'EU.pctintr'=EU.pctintr,'total recovery rate'= as.numeric(nrow(dt)/nrow(data)), 'dt'=dt)
  
  return(out.list)
}

Z1 = introgression.QC(x.,x.Ne,x.t, MB, SIMS)

write.table(Z1[4], file = "sampled", quote = FALSE, sep = '\t', row.names = FALSE, col.names = TRUE)
write.table(Z1[1:3], file = "QC", quote = FALSE, sep = '\t', row.names = FALSE, col.names = TRUE)

args = commandArgs(TRUE)

x. = args[1]
x.Ne = args[2]
x.t = args[3]

introgression.QC = function(x,Ne,t){
  suppressMessages(library("data.table"))
  suppressMessages(library("dplyr"))
  data = fread(x, header = F)
  data = rename(data, sim.it.chr = V1, start = V2, stop = V3, chr = V4, pop = V5, sim.it = V6, tag= V7, itr = V8)
  data = mutate(data, diff = stop-start)
  
  ##Down sample
  data = filter(data, pop=='pop_3' | pop=='pop_2')
  num.total = as.numeric(nrow(data))
  
  dt.1 = sample_n(filter(data, diff < 15000), .00881*(num.total)*.25)
  
  dt.2 = sample_n(filter(data, 15000 <= diff, diff < 30000), .0995*(num.total)*.25)
  
  dt.3 = sample_n(filter(data, 30000 <= diff, diff < 45000), .358*(num.total)*.25)
  
  dt.4 = sample_n(filter(data, 45000 <= diff, diff < 60000), .218*(num.total)*.25)
  
  dt.5 = sample_n(filter(data, 60000 <= diff, diff < 75000), .121*(num.total)*.25)
  
  dt.6 = sample_n(filter(data, 75000 <= diff, diff < 90000), .080*(num.total)*.25)
  
  dt.7 = sample_n(filter(data, 90000 <= diff, diff < 105000), .0370*(num.total)*.25)
  
  dt.8 = sample_n(filter(data, 105000 <= diff, diff < 120000), .0228*(num.total)*.25)
  
  dt.9 = sample_n(filter(data, 120000 <= diff, diff < 135000), .0201*(num.total)*.25)
  
  dt.10 = sample_n(filter(data, 135000 <= diff, diff < 150000), .0113*(num.total)*.25)
  
  dt.11 = sample_n(filter(data, 150000 <= diff, diff < 165000), .00576*(num.total)*.25)
  
  dt.small = rbind(dt.1,dt.2,dt.3,dt.4,dt.5,dt.6,dt.7,dt.8,dt.9,dt.10,dt.11)
  
  num.sampled = as.numeric(nrow(dt.small))
  
  dt.12 = sample_n(filter(data, 165000 <= diff), (0.125*(num.total)-(num.sampled)))
  
  dt = rbind(dt.1,dt.2,dt.3,dt.4,dt.5,dt.6,dt.7,dt.8,dt.9,dt.10,dt.11,dt.12)
  
  dt = mutate(dt, Ne = Ne)
  dt = mutate(dt, t = t)
  
  out.list = list('totalrecovery rate'= as.numeric(nrow(dt)/nrow(data)), 'dt'=dt)
  
  return(out.list)
}

Z1 = introgression.QC(x.,x.Ne,x.t)

write.table(Z1[2], file = "", quote = FALSE, sep = '\t', row.names = FALSE, col.names = FALSE)

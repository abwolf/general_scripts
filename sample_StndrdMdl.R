args = commandArgs(TRUE)

x. = args[1]
x.Mdl = args[2]
x.Pct = args[3]

sampling.StndrdMdl = function(x,Mdl,Pct){
  suppressMessages(library("data.table"))
  suppressMessages(library("dplyr"))
  data = fread(x, header = F)
  data = rename(data, sim.pop.chr = V1, hapstart = V2, hapstop = V3, chr = V4, pop = V5, sim.it = V6, tag= V7, itr = V8)
  data = mutate(data, len_kb = (hapstop-hapstart)/1000)
  
  ##Down sample
  data = filter(data, pop=='pop_3' | pop=='pop_2', len_kb>0)
  num.total = as.numeric(nrow(data))
  
    dt.1 = sample_n(filter(data, len_kb < 15), 5.7e-03*(num.total)*as.numeric(Pct))
  
    dt.2 = sample_n(filter(data, 15 <= len_kb, len_kb < 30), 5.6e-02*(num.total)*as.numeric(Pct))
  
    dt.3 = sample_n(filter(data, 30 <= len_kb, len_kb < 45), 2.0e-01*(num.total)*as.numeric(Pct))
  
  
    dt.small = rbind(dt.1,dt.2,dt.3)
  
    dt.4 = sample_frac(filter(data, 45 <= len_kb), as.numeric(Pct))

    dt = rbind(dt.small, dt.4)
  
    dt = mutate(dt, Model = Mdl)
  
    out=dt
 
 #dt.1 = mutate(dt.1, Model = Mdl)
 
 #out=dt.1
 
  return(out)
}

#############

toPct_Int.StndrdMdl = function(sampled.data){
    Pct_Intr.format = sampled.data %>% select(sim.it, len_kb) %>% group_by(sim.it) %>% summarise(sum(len_kb)) %>% setnames(c('sim.tsk','sum_len_kb')) %>% mutate(Pct_Int=sum_len_kb/15000/2014)
    return(Pct_Intr.format)
}

#############

Z1 = sampling.StndrdMdl(x.,x.Mdl,x.Pct)

Z1.pct = toPct_Int.StndrdMdl(Z1)

Z1.pct.mean = mean(Z1.pct[,Pct_Int])

write(Z1.pct.mean, stderr())

write.table(Z1, file = stdout(), quote = FALSE, sep = '\t', row.names = FALSE, col.names = FALSE)

args = commandArgs(TRUE)

x. = args[1]
MB = as.numeric(args[2])
SIMS = as.numeric(args[3])

print('CHECK POPULATION SIZE SET CORRECTLY')

suppressMessages(library("data.table", quietly = TRUE, verbose = FALSE))
suppressMessages(library("dplyr", quietly = TRUE, verbose = FALSE))

introgression.QC = function(x,mb,sims){
  data = fread(x, header = FALSE)
  data = rename(data, sim.it.chr = V1, start = V2, stop = V3, chr = V4, pop = V5, sim.it = V6, tag= V7, itr = V8)
  data = mutate(data, diff = stop-start)
  ##Average % introgression                                     XMb  Ysims
  EA.pctintr=data[pop=='pop_3', sum(as.numeric(diff))/1008/(as.numeric(mb)*as.numeric(sims))] #XMbxYsimulations for 572 individuals
  EU.pctintr=data[pop=='pop_2', sum(as.numeric(diff))/1006/(as.numeric(mb)*as.numeric(sims))]
  SAS.pctintr=data[pop=='pop_4', sum(as.numeric(diff))/978/(as.numeric(mb)*as.numeric(sims))]

 out.list = list('EA.pctintr'=EA.pctintr, 'EU.pctintr'=EU.pctintr, 'SAS.pctintr'=SAS.pctintr) 
 return(out.list)
}

Z1 = introgression.QC(x.,MB,SIMS)

print(Z1[1:3])

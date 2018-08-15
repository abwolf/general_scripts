import sys

macsout_file = open(sys.argv[1],'r')


#print 'SITE_ID','\t','COUNT','\t','NUM_INDs','\t','FREQ_EU','\t','FREQ_EA'

for line in macsout_file:
	if 'SITE:' in line:
		line_stripped = line.strip()
		line_split = line_stripped.split('\t')
		sites = str(line_split[4]) #the sting of 0s and 1s describing the state at that site for each individualp
		sites_EU = sites[26:784] #create a substring containing just the state for the EU samples
		sites_EA = sites[784:1356] #create substring containing state for just the EA samples
		#print sites_NonAf
		#print len(sites_NonAf)
		num_sites_EU = len(sites_EU)
		num_sites_EA = len(sites_EA)
		count_EU = float(sites_EU.count('1'))
		count_EA = float(sites_EA.count('1'))
		freq_EU = float(count_EU/num_sites_EU)
		freq_EA = float(count_EA/num_sites_EA)
		
		print line_split[1],'\t',count_EU,'\t',count_EA,'\t',num_sites_EU,'\t',num_sites_EA,'\t',"%e" % freq_EU,'\t',"%e" % freq_EA 	
	
macsout_file.close()	

#		print 'SITE ID:', line_split[1]
#		print 'SITES:', sites
#		print 'COUNT:', count
#		print 'FREQ:', "%e" % freq
#		print '-----'

		

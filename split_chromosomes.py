# File format
#   chr         d.start   d.end  OA     t
# sim_0.task_1	2048116	4132969	1000	54

import sys
import copy

open_bed = open(sys.argv[1], 'r') #open the desert bed file
out_bed = open('test_split', 'w') #create a new file to write the split desert locations to
out_count = open('counter', 'w')
for line in open_bed:
    line = line.strip() #take a line from the original bed file, strip the end
    line_list = line.split('\t') #split it into a list
    if int(line_list[1]) < 15000000: #if the desert start position is less that 15Mb
        if int(line_list[2]) <= 15000000: #and if the desert end position is equal or less than 15Mb
        	line_join = '\t'.join(line_list) #join the list to a string. tab-delimited
        	out_bed.write(line_join + '\n') #and write the string to the new bed file
        
        elif int(line_list[2]) > 15000000: #if the desert end is beyond 15Mb, we will split the desert into 2 deserts, truncating the original, and replacing the truncated tail as a new desert in the bedfile
            line_list_dup = copy.copy(line_list) #create a copy of that line

			#Truncate the original desert, e.g. 14-30Mb desert --> 14-15Mb desert (1Mb)
            line_list[2] = str(15000000) #to the original line, set a hard end at 15Mb, this has truncated the desert to be bound by a 15Mb chromosome
            line_join = '\t'.join(line_list)
            out_bed.write(line_join + '\n')
			
			#Replace the truncated tail as a new desert, e.g. 14-30Mb --> 15-30Mb --> 0-15Mb (15Mb)
            line_list_dup[1] = str(0) #working with the duplicate line, set the desert start to 0
            line_list_dup[2] = str(int(line_list_dup[2]) - 15000000) #then adjust the desert end to fit in a 15Mb chromosome
            line_join_dup = '\t'.join(line_list_dup)
            out_bed.write(line_join_dup + '\n')
            out_count.write('dup'+'\n')
  			
            
    elif int(line_list[1]) >= 15000000: #If the desert starts beyond 15Mb, readjust the start and end locations to fit into a 15Mb chromsome
        line_list[1] = str(int(line_list[1]) - 15000000) #subtract 15Mb from the start position
        line_list[2] = str(int(line_list[2]) - 15000000) #subtract 15 Mb from the end position
        line_join = '\t'.join(line_list)
        out_bed.write(line_join + '\n')

open_bed.close()
out_bed.close()
out_count.close()

#out_bed_open = open('test_split', 'r')

#for line in out_bed_open:
#    print line.strip()


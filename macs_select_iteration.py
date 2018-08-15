#For extracting only the 7th iteration (sim_6) of a macs simulation raw output.

import sys

count = 0
 
print sys.stdin.readline().strip() #print the first line of macs output, the command line paramters
print sys.stdin.readline().strip() #print the seed used for the simulation

for line in sys.stdin:
        if 'END_SELECTED_SITES' in line: #END_SELECTED_SITES occurs at the end of each iterations output.
                count = count + 1 
                if count == 6: #count up through the simulations to reach the 7th 
                        break
for line in sys.stdin:
        print line.strip() #print all the output lines until reaching the end of the simulation
        if 'END_SELECTED_SITES' in line:
                count = count + 1
                if count == 7:
                        break 

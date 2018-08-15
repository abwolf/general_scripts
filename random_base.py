from __future__ import division
import sys, math, random


chr_list = open(sys.argv[1], 'r')

for line in chr_list:
	line_list = line.strip().split()
	chr = line_list[0]
	win_start = int(line_list[1])
	win_end = int(line_list[2])
	random_base1 = int(random.randrange(win_start, win_end,1))
	random_base2 = random_base1 + 1
	print "%s\t%d\t%d" % (chr, random_base1, random_base2)
	

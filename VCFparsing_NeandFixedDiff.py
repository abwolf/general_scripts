from __future__ import division
import vcf
import pybedtools
from vcf import utils
from vcf import filters
from pybedtools import BedTool
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-v", "--vcf", action = "store", type = "string", dest = "vcf_filename")
parser.add_option("-n", "--nea", action = "store", type = "string", dest = "nea_filename")
(options, args) = parser.parse_args()

vcf_reader = vcf.Reader(open(options.vcf_filename, 'r'))
nea_reader = vcf.Reader(open(options.nea_filename, 'r'))

for record in utils.walk_together(vcf_reader, nea_reader):
     human_record = record[0]
     neand_record = record[1]
     if(human_record is not None) & (neand_record is not None):
          neand_gt = neand_record.genotype('AltaiNea').gt_bases
          if (neand_gt is not None):
               if ( (human_record.INFO['AFR_AF'][0] < 0.01) & ((human_record.INFO['EAS_AF'][0] > 0.01) | (human_record.INFO['EUR_AF'][0] > 0.01)) ):
                    if ((neand_gt[0] is not human_record.REF) | (neand_gt[2] is not human_record.REF)):
                         print human_record.CHROM, human_record.POS, human_record.POS, human_record.ID, human_record.REF, human_record.ALT[0], human_record.QUAL,
                         print neand_gt[0], neand_gt[2], neand_record.QUAL,
                         print human_record.INFO['AFR_AF'][0], human_record.INFO['EUR_AF'][0], human_record.INFO['EAS_AF'][0]
               elif ( (human_record.INFO['AFR_AF'][0] > 0.99) & ((human_record.INFO['EAS_AF'][0] < 0.99) | (human_record.INFO['EUR_AF'][0] < 0.99)) ):
                    if ((neand_gt[0] is not human_record.ALT[0]) | (neand_gt[2] is not human_record.ALT[0])):
                         print human_record.CHROM, human_record.POS, human_record.POS, human_record.ID, human_record.REF, human_record.ALT[0], human_record.QUAL,
                         print neand_gt[0], neand_gt[2], neand_record.QUAL,
                         print human_record.INFO['AFR_AF'][0], human_record.INFO['EUR_AF'][0], human_record.INFO['EAS_AF'][0]
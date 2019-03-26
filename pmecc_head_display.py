#!/usr/bin/env python

import struct, sys

import pmecc_head


if len(sys.argv) < 5:
	print('param error')
	print('use : ./pmecc_head_display.py [page-size] [oob-size] [ecc-bit] [sector-size]')
	exit()

page_size = int(sys.argv[1])
oob_size = int(sys.argv[2])
ecc_bit = int(sys.argv[3])
sector_size = int(sys.argv[4])

#pmecc_word = pmecc_head.gen_pmecc_header(2048, 64, 4, 512)
pmecc_word = pmecc_head.gen_pmecc_header(page_size, oob_size, ecc_bit, sector_size)
# generate a new file with pmecc header
#fd = open(sys.argv[2], "wb")
print('pmecc header = 0x%x'%len(sys.argv))
print('pmecc header = 0x%x'%pmecc_word)

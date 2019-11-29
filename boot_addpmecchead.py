#!/usr/bin/env python

import struct, sys
import os
import pmecc_head




if len(sys.argv) < 5:
	print('param error')
	print('use : ./boot_addpmecchead.py [page-size] [oob-size] [ecc-bit] [sector-size]')
	exit()

page_size = int(sys.argv[1])
oob_size = int(sys.argv[2])
ecc_bit = int(sys.argv[3])
sector_size = int(sys.argv[4])

    
if os.path.isfile('../binaries/boot.bin') != True:
    print('no found boot file from ../binaries, please build bootsrap')
    exit()
    
# open bootstrap file
fd = open('../binaries/boot.bin', "rb")
line = fd.read()
fd.close()

    

pmecc_word = pmecc_head.gen_pmecc_header(page_size, oob_size, ecc_bit, sector_size)


vec = struct.pack("<I", pmecc_word)

# generate a new file with pmecc header
fd = open('boot_pmecc_head.bin', "wb")

for i in range(0, 52):
	fd.write(vec)

fd.write(line[0:])

fd.close()

print('create boot_pmecc_head.bin OK')

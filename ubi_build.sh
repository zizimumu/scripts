#!/bin/bash


# here is the nandflash parameters need to change
# rootfs directory
ROOTFS_DIR=./sam9x60_buildroot_mini
PAGE_SIZE=4096
SUB_PAGE_SIZE=4096
# total physic blocks, used to caculate max bad block
PHYSIC_BLK_NUM=2048
# block count, used by UBI
ROOTFS_BLK_NUM=480
# physic block size, unit is KB
PHYSIC_ERASE_BLK_SZ=256




let LOGIC_ERASE_BLK_SZ=PHYSIC_ERASE_BLK_SZ*1024-PAGE_SIZE*2

let BAD_BLK=PHYSIC_BLK_NUM*20/1024
echo "reserver ${BAD_BLK} blocks for bad block"


let logic_blk_num=ROOTFS_BLK_NUM-BAD_BLK-4
let vol_size=logic_blk_num*LOGIC_ERASE_BLK_SZ/1024/1024

echo "UBI vol size ${vol_size}MB"


rm -rf ubi.cfg ubi_yocto.ubi

echo [ubifs] >> ubi.cfg
echo mode=ubi >> ubi.cfg
echo image=yocto_ubi.bin >> ubi.cfg
echo vol_id=0 >> ubi.cfg
echo vol_size=${vol_size}MiB >> ubi.cfg
echo vol_type=dynamic >> ubi.cfg
echo vol_name=rootfs >> ubi.cfg
echo vol_flags=autoresize >> ubi.cfg



echo "rootfs dir : ${ROOTFS_DIR}, page size ${PAGE_SIZE},logic erase block size ${LOGIC_ERASE_BLK_SZ}, logic blk num ${logic_blk_num}"
mkfs.ubifs -r ${ROOTFS_DIR} -m ${PAGE_SIZE} -e ${LOGIC_ERASE_BLK_SZ} -c ${logic_blk_num} -o yocto_ubi.bin

ubinize -o ubi_yocto.ubi -m ${PAGE_SIZE} -p ${PHYSIC_ERASE_BLK_SZ}KiB -s ${SUB_PAGE_SIZE} ubi.cfg

rm -rf yocto_ubi.bin
echo "ubi image done success"

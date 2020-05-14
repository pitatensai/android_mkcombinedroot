#!/bin/bash
KERNEL_IMAGE=../kernel/arch/arm64/boot/Image
if [ ! -n "$1" ]; then
  DTB_PATH=../kernel/arch/arm64/boot/dts/rockchip/rk3399-evb-ind-lpddr4-android-avb.dtb
else    
  DTB_PATH=../kernel/arch/arm64/boot/dts/rockchip/$1.dtb
fi
echo "use DTS as $DTB_PATH"
export PATH=$PATH:bin/
echo "make ramdisk..."
mkbootfs -d ./system ./ramdisk | minigzip > out/ramdisk.img
echo "make ramdisk done."

echo "make boot image..."
mkbootimg  --kernel $KERNEL_IMAGE --ramdisk out/ramdisk.img --dtb $DTB_PATH --cmdline "console=ttyFIQ0 androidboot.baseband=N/A androidboot.wificountrycode=US androidboot.veritymode=enforcing androidboot.hardware=rk30board androidboot.console=ttyFIQ0 androidboot.verifiedbootstate=orange firmware_class.path=/vendor/etc/firmware init=/init rootwait ro loop.max_part=7 androidboot.first_stage_console=1 androidboot.selinux=permissive buildvariant=userdebug" --os_version 11 --os_patch_level 2020-06-05 --second ../kernel/resource.img --header_version 2 --output out/boot.img 
echo "make boot image done."

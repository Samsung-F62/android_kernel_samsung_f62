#!/bin/bash

echo "Setting Up Environment"
echo ""
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=neel0210
export KBUILD_BUILD_HOST=Catelina
export PLATFORM_VERSION="12"
export ANDROID_MAJOR_VERSION=s

# Variables
export Image="$(pwd)/out/arch/arm64/boot/Image.gz-dtb"
export TC="/home/neel/Desktop/toolchain/"
export VMTC="$(pwd)/clang"
clear
echo "---------------------------"
echo checking if bulding offline
echo "---------------------------"
if [ -d "$TC" ]; then
	echo "building offline; thus exporting paths"
	export CROSS_COMPILE=/home/neel/Desktop/toolchain/linaro/bin/aarch64-linux-gnu-
	export CLANG_TRIPLE=/home/neel/Desktop/toolchain/proton/bin/aarch64-linux-gnu-
	export CC=/home/neel/Desktop/toolchain/proton/bin/clang
else
	echo "Not finding Toolchains at Home/toolchains; thus clonning them; would take some couple of minutes"
	if [ -d "$VMTC" ]; then
		echo exporting paths
		export CROSS_COMPILE=$(pwd)/clang/linaro/bin/aarch64-linux-gnu-
		export CLANG_TRIPLE=$(pwd)/clang/bin/aarch64-linux-gnu-
		export CC=$(pwd)/clang/bin/clang
	else
		git clone --depth=1 https://github.com/KakarotKernel/clang.git clang
		export CROSS_COMPILE=$(pwd)/clang/linaro/bin/aarch64-linux-gnu-
		export CLANG_TRIPLE=$(pwd)/clang/bin/aarch64-linux-gnu-
		export CC=$(pwd)/clang/bin/clang
	fi
fi
#
CLEAN(){
	make clean && make mrproper
	rm -rf out
}
#
MAGISK(){
	bash usr/magisk/update_magisk.sh
}
#
F62(){	
	make f62_defconfig O=out CC=clang
	make -j$(nproc --all) O=out CC=clang
}

CLEAN
#MAGISK
F62
#
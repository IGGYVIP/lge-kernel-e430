#!/bin/bash
# Written by cybojenix <anthonydking@gmail.com>

vendor=lge
version=3.4.11
if [ -z $target ]; then
echo "choose your target device"
echo "1) E430"
echo "2) E425"
echo "3) E435"
read -p "1/3: " choice
case "$choice" in
1 ) export target=e430 ; export defconfig=vee3-rev_11_led_defconfig;;
2 ) export target=e425 ; export defconfig=vee3-rev_11_led_defconfig;;
3 ) export target=e435 ; export defconfig=vee3ds-rev_11_defconfig;;
* ) echo "invalid choice"; sleep 2 ; $0;;
esac
fi # [ -z $target ]

export ARCH=arm
export CROSS_COMPILE=arm-eabi-4.6.2/bin/arm-eabi-
export LOCALVERSION=-schenker@gmail.com

if [ -z "$clean" ]; then
read -p "do make clean mrproper?(y/n)" clean
fi # [ -z "$clean" ]
case "$clean" in
y|Y ) echo "cleaning..."; make clean mrproper;;
n|N ) echo "continuing...";;
* ) echo "invalid option"; sleep 2 ; build.sh;;
esac

echo "now building the kernel"

make $defconfig
make -j `cat /proc/cpuinfo | grep "^processor" | wc -l` "$@"

if [ -f arch/arm/boot/zImage ]; then

rm -rf mod
mkdir -p mod
find . -name *.ko | xargs cp -a --target-directory=mod/
ls -al mod
ls -al arch/arm/boot/zImage
echo "finished. kernel modules in mod/ dir, kernel in arch/arm/boot/zImage"

else # [ -f arch/arm/boot/zImage ]
echo "build failed."
fi # [ -f arch/arm/boot/zImage ]

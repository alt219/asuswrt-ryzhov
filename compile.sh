#!/bin/sh

echo Downloading and unpacking firmware sources...
HOME_DIR=$(pwd -P)
FW_ZIP=GPL_RT_N66U_B1_3004220.zip
FW_TGZ=GPL_RT-N66U_3.0.0.4.220.tgz
cd ..
[ -e "./$FW_ZIP" ] || wget http://dlcdnet.asus.com/pub/ASUS/wireless/RT-N66U_B1/$FW_ZIP
[ -e "./$FW_TGZ" ] || unzip ./$FW_ZIP
[ -d "./asuswrt" ] && rm -fr ./asuswrt
tar -xzf ./$FW_TGZ
cd $HOME_DIR

echo Fixing broken 3.0.0.4.220 build tree...
mkdir ../asuswrt/release/src/router/wps/prebuilt/
cp -f ./prebuilded/wps_monitor ../asuswrt/release/src/router/wps/prebuilt/
patch -p0 -i ./patches/lighttpd.patch
mkdir ../asuswrt/release/src-rt/router/asuswebstorage/prebuilt
cp -f ./prebuilded/asuswebstorage ../asuswrt/release/src-rt/router/asuswebstorage/prebuilt


echo Adding JFFS, SSH and custom scripts support...
patch -p0 -i ./patches/jffs2.patch
patch -p0 -i ./patches/scripts.patch
patch -p0 -i ./patches/target.patch


echo A root privileges needed to create /opt/brcm and /media/ASUSWRT symlinks
sudo ln -s $(cd .. && pwd -P)/asuswrt/tools/brcm /opt/brcm
export PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin:/opt/brcm/hndtools-mipsel-uclibc/bin
mkdir -p ../asuswrt/release/src-rt/wl/sysdeps/default/linux
sudo mkdir -p /media/ASUSWRT/
sudo ln -s $(cd .. && pwd -P)/asuswrt /media/ASUSWRT/asuswrt

echo Compiling firmware. Now its up to ASUS guys...
cd ../asuswrt/release/src-rt/
#make rt-n16
make rt-n66u

#cd ../asuswrt/release/src-rt-6.x/
#make rt-ac66u

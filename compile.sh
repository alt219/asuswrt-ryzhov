#!/bin/sh

# Download and unpack firmware sources
HOME_DIR=$(pwd -P)
FW_ZIP=GPL_RT_N66U_B1_3004220.zip
FW_TGZ=GPL_RT-N66U_3.0.0.4.220.tgz
cd ..
[ -e "./$FW_ZIP" ] || wget http://dlcdnet.asus.com/pub/ASUS/wireless/RT-N66U_B1/$FW_ZIP
[ -e "./$FW_TGZ" ] || unzip ./$FW_ZIP
[ -d "./asuswrt" ] && rm -fr ./asuswrt
tar -xzf ./$FW_TGZ
cd $HOME_DIR

# fix broken 3.0.0.4.220 build tree
mkdir ../asuswrt/release/src/router/wps/prebuilt/
cp -f ./wps_monitor ../asuswrt/release/src/router/wps/prebuilt/
patch -p0 -i ./lighttpd.patch
mkdir ../asuswrt/release/src-rt/router/asuswebstorage/prebuilt
cp -f ./asuswebstorage ../asuswrt/release/src-rt/router/asuswebstorage/prebuilt


# add JFFS, SSH and user's scripts support
patch -p0 -i ./jffs2.patch
patch -p0 -i ./scripts.patch
patch -p0 -i ./target.patch


# Compilation
sudo ln -s $(cd .. && pwd -P)/asuswrt/tools/brcm /opt/brcm
export PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin:/opt/brcm/hndtools-mipsel-uclibc/bin
mkdir -p ../asuswrt/release/src-rt/wl/sysdeps/default/linux
sudo mkdir -p /media/ASUSWRT/
sudo ln -s $(cd .. && pwd -P)/asuswrt /media/ASUSWRT/asuswrt
cd ../asuswrt/release/src-rt/
#make clean
make rt-n66u

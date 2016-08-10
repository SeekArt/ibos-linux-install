#!/bin/bash

#IBOS
wget -O iboslinux.zip https://github.com/SeekArt/ibos-linux-install/archive/master.zip
rm -rf ibos-linux-install-master
unzip iboslinux.zip
rm -rf iboslinux.zip
chmod -R 777 ./ibos-linux-install-master/
cd ./ibos-linux-install-master/ibos_install_sh/
./install.sh
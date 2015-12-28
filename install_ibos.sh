#!/bin/bash

#IBOS
wget https://github.com/SeekArt/ibos-linux-install/archive/master.zip
rm -rf ibos-linux-install-master
unzip ibos-linux-install-master.zip
chmod -R 777 ./ibos-linux-install-master/
cd ./ibos-linux-install-master/ibos_install_sh/
./install.sh
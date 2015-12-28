#!/bin/bash

#IBOS
wget http://www.ibos.com.cn/download/ibos_install_sh.zip
rm -rf ibos_install_sh
unzip ibos_install_sh.zip
chmod -R 777 ./ibos_install_sh/
cd ./ibos_install_sh/
./install.sh
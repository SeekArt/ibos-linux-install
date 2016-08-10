#!/bin/bash

#IBOS
if [ ! -f iboscode.zip ];then
  wget -O iboscode.zip https://github.com/SeekArt/IBOS/archive/master.zip
fi
rm -rf IBOS-master
unzip iboscode.zip
mv IBOS-master/* /ibos/www/
chmod -R 777 /ibos/www/system/config
chmod -R 777 /ibos/www/data
chmod -R 777 /ibos/www/static
cd /ibos/www/
find ./ -type f | xargs chmod 644
find ./ -type d | xargs chmod 755
chmod -R 777 system/config/ static/ data/
cd -


chown -R www:www /ibos/www/
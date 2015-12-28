#!/bin/bash

#IBOS
if [ ! -f ibos.zip ];then
  wget https://github.com/SeekArt/IBOS/archive/master.zip
fi
rm -rf IBOS-master
unzip master.zip
mv IBOS-master/* /ibos/www/
chmod -R 777 /ibos/www/system/config
chmod -R 777 /ibos/www/data
chmod -R 777 /ibos/www/static
cd /ibos/www/
find ./ -type f | xargs chmod 644
find ./ -type d | xargs chmod 755
chmod -R 777 system/config/ static/ data/
cd -

#phpmyadmin
if [ ! -f phpmyadmin.zip ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/phpMyAdmin-4.1.8-all-languages.zip
fi
rm -rf phpMyAdmin-4.1.8-all-languages
unzip phpMyAdmin-4.1.8-all-languages.zip
mv phpMyAdmin-4.1.8-all-languages /ibos/www/phpmyadmin

chown -R www:www /ibos/www/
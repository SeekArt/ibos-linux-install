#!/bin/bash

userdel www
groupadd www
useradd -g www -M -d /ibos/www -s /sbin/nologin www &> /dev/null

mkdir -p /ibos
mkdir -p /ibos/server
mkdir -p /ibos/www
mkdir -p /ibos/log
mkdir -p /ibos/log/php
mkdir -p /ibos/log/mysql
mkdir -p /ibos/log/nginx
mkdir -p /ibos/log/nginx/access
chown -R www:www /ibos/log

mkdir -p /ibos/server/${mysql_dir}
ln -s /ibos/server/${mysql_dir} /ibos/server/mysql

mkdir -p /ibos/server/${php_dir}
ln -s /ibos/server/${php_dir} /ibos/server/php


mkdir -p /ibos/server/${web_dir}
if echo $web |grep "nginx" > /dev/null;then
mkdir -p /ibos/log/nginx
mkdir -p /ibos/log/nginx/access
ln -s /ibos/server/${web_dir} /ibos/server/nginx
else
mkdir -p /ibos/log/httpd
mkdir -p /ibos/log/httpd/access
ln -s /ibos/server/${web_dir} /ibos/server/httpd
fi

#!/bin/bash

ifubuntu=$(cat /proc/version | grep ubuntu)
if14=$(cat /etc/issue | grep 14)

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.5.40-linux2.6-x86_64
  if [ ! -f mysql-5.5.40-linux2.6-x86_64.tar.gz ];then
	 wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.5.40-linux2.6-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.5.40-linux2.6-x86_64.tar.gz
  mv mysql-5.5.40-linux2.6-x86_64/* /ibos/server/mysql
else
  rm -rf mysql-5.5.40-linux2.6-i686
  if [ ! -f mysql-5.5.40-linux2.6-i686.tar.gz ];then
    wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.5.40-linux2.6-i686.tar.gz
  fi
  tar -xzvf mysql-5.5.40-linux2.6-i686.tar.gz
  mv mysql-5.5.40-linux2.6-i686/* /ibos/server/mysql
fi

if [ "$ifubuntu" != "" ] && [ "$if14" != "" ];then
	mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
fi

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
/ibos/server/mysql/scripts/mysql_install_db --datadir=/ibos/server/mysql/data/ --basedir=/ibos/server/mysql --user=mysql
chown -R mysql:mysql /ibos/server/mysql/
chown -R mysql:mysql /ibos/server/mysql/data/
chown -R mysql:mysql /ibos/log/mysql
\cp -f /ibos/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/ibos/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/ibos/server/mysql/data#' /etc/init.d/mysqld
\cp -f /ibos/server/mysql/support-files/my-medium.cnf /etc/my.cnf
echo "expire_logs_days = 5" >> /etc/my.cnf
echo "max_binlog_size = 1000M" >> /etc/my.cnf
sed -i 's#skip-external-locking#skip-external-locking\nlog-error=/ibos/log/mysql/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start

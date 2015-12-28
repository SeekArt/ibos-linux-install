#!/bin/bash
rm -rf httpd-2.4.10 apr-1.5.0 apr-util-1.5.3
if [ ! -f httpd-2.4.10.tar.gz ];then
  wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/httpd/httpd-2.4.10.tar.gz
fi
tar zxvf httpd-2.4.10.tar.gz

if [ ! -f apr-1.5.0.tar.gz ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/apache/apr-1.5.0.tar.gz
fi
tar -zxvf apr-1.5.0.tar.gz
cp -rf apr-1.5.0 httpd-2.4.10/srclib/apr

if [ ! -f apr-util-1.5.3.tar.gz ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/apache/apr-util-1.5.3.tar.gz
fi
tar -zxvf apr-util-1.5.3.tar.gz
cp -rf apr-util-1.5.3 httpd-2.4.10/srclib/apr-util

cd httpd-2.4.10
./configure --prefix=/ibos/server/httpd \
--with-mpm=prefork \
--enable-so \
--enable-rewrite \
--enable-mods-shared=all \
--enable-nonportable-atomics=yes \
--disable-dav \
--enable-deflate \
--enable-cache \
--enable-disk-cache \
--enable-mem-cache \
--enable-file-cache \
--enable-ssl \
--with-included-apr \
--enable-modules=all  \
--enable-mods-shared=all
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cp support/apachectl /etc/init.d/httpd
chmod u+x /etc/init.d/httpd
cd ..

cp /ibos/server/httpd/conf/httpd.conf /ibos/server/httpd/conf/httpd.conf.bak

sed -i "s;#LoadModule rewrite_module modules/mod_rewrite.so;LoadModule rewrite_module modules/mod_rewrite.so\nLoadModule php5_module modules/libphp5.so;" /ibos/server/httpd/conf/httpd.conf
sed -i "s#User daemon#User www#" /ibos/server/httpd/conf/httpd.conf
sed -i "s#Group daemon#Group www#" /ibos/server/httpd/conf/httpd.conf
sed -i "s;#ServerName www.example.com:80;ServerName www.example.com:80;" /ibos/server/httpd/conf/httpd.conf
sed -i "s#/ibos/server/httpd/htdocs#/ibos/www#" /ibos/server/httpd/conf/httpd.conf
sed -i "s#<Directory />#<Directory \"/ibos/www\">#" /ibos/server/httpd/conf/httpd.conf
sed -i "s#AllowOverride None#AllowOverride all#" /ibos/server/httpd/conf/httpd.conf
sed -i "s#DirectoryIndex index.html#DirectoryIndex index.html index.htm index.php#" /ibos/server/httpd/conf/httpd.conf
sed -i "s;#Include conf/extra/httpd-mpm.conf;Include conf/extra/httpd-mpm.conf;" /ibos/server/httpd/conf/httpd.conf
sed -i "s;#Include conf/extra/httpd-vhosts.conf;Include conf/extra/httpd-vhosts.conf;" /ibos/server/httpd/conf/httpd.conf

echo "HostnameLookups off" >> /ibos/server/httpd/conf/httpd.conf
echo "AddType application/x-httpd-php .php" >> /ibos/server/httpd/conf/httpd.conf

echo "Include /ibos/server/httpd/conf/vhosts/*.conf" > /ibos/server/httpd/conf/extra/httpd-vhosts.conf


mkdir -p /ibos/server/httpd/conf/vhosts/
cat > /ibos/server/httpd/conf/vhosts.conf << END
<DirectoryMatch "/ibos/www/(attachment|html|data)">
<Files ~ ".php">
Order allow,deny
Deny from all
</Files>
</DirectoryMatch>

<VirtualHost *:80>
	DocumentRoot /ibos/www
	ServerName localhost
	ServerAlias localhost
	<Directory "/ibos/www">
	    Options Indexes FollowSymLinks
	    AllowOverride all
	    Order allow,deny
	    Allow from all
	</Directory>
	<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteRule ^(.*)-htm-(.*)$ $1.php?$2
		RewriteRule ^(.*)/simple/([a-z0-9\_]+\.html)$ $1/simple/index.php?$2
	</IfModule>
	ErrorLog "/ibos/log/httpd-error.log"
	CustomLog "/ibos/log/httpd.log" common
</VirtualHost>
END

#adjust httpd-mpm.conf
sed -i 's/StartServers             5/StartServers            10/g' /ibos/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MinSpareServers          5/MinSpareServers         10/g' /ibos/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MaxSpareServers         10/MaxSpareServers         30/g' /ibos/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MaxRequestWorkers      150/MaxRequestWorkers      255/g' /ibos/server/httpd/conf/extra/httpd-mpm.conf

/etc/init.d/httpd start
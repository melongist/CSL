#!/bin/bash
#Korean HUSTOJ installation script
#Made by melongist(melongist@gmail.com)
#for Korean
#Last edits 25.02.03

VER_DATE="25.01.31"

THISFILE="hustoj250131.sh"
SRCZIP="hustoj250131.zip"
DOCKERFILE="Dockerfile250131"

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')

if [ ${OSVER:0:5} != "24.04" ] ; then
  echo ""
  echo "This is not Ubuntu 24.04 LTS!!"
  echo ""
  echo "Ubuntu 24.04 LTS needed!!'"
  echo ""
  exit 1
fi


#detect and refuse to run under WSL
if [ -d /mnt/c ]; then
    echo "WSL is NOT supported."
    exit 1
fi

cd


MEM=`free -m|grep Mem|awk '{print $2}'`
NBUFF=512
if [ "$MEM" -lt "2000" ] ; then
        echo "Memory size less than 2GB."
        NBUFF=128
        if grep 'swap' /etc/fstab ; then
                echo "already has swap"
        else
                dd if=/dev/zero of=/swap bs=2M count=1024
                chmod 600 /swap
                mkswap /swap
                swapon /swap
                echo "/swap none swap defaults 0 0 " >> /etc/fstab 
                /etc/init.d/multipath-tools stop
                pkill -9 snapd
                pkill -9 ds-identify
         fi
else
        echo "Memory size : $MEM MB"
fi


#for OJ NAME
INPUTS="x"

while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo -n "Rename HUSTOJ logo name? [y/n]: "
  read INPUTS
done

echo ""
if [ ${INPUTS} == "y" ] ; then
  OJNAME="o"
  INPUTS="x"
  while [ ${OJNAME} != ${INPUTS} ]; do
    echo -n "Enter  NAME : "
    read OJNAME
    echo -n "Repeat NAME : "
    read INPUTS
  done
else
  OJNAME="HUSTOJ"
fi


echo ""
echo "Waiting 3 seconds..."
echo ""
sleep 3


#for South Korea's timezone
timedatectl set-timezone 'Asia/Seoul'


#needrestart auto check for Ubuntu 24.04
#/etc/needrestart/needrestart.conf
#if [ ! -e /etc/needrestart/needrestart.conf ] ; then
#  sudo apt install needrestart -y
#fi
sudo sed -i "s:#\$nrconf{restart} = 'i':\$nrconf{restart} = 'a':" /etc/needrestart/needrestart.conf
#sudo sed -i "s:#\$nrconf{kernelhints} = -1:\$nrconf{kernelhints} = 0:" /etc/needrestart/needrestart.conf

apt autoremove -y --purge needrestart

apt update
apt -y upgrade
apt -y autoremove


apt install -y software-properties-common
add-apt-repository -y universe
add-apt-repository -y multiverse
add-apt-repository -y restricted

apt -y install subversion zip unzip curl

/usr/sbin/useradd -m -u 1536 -s /sbin/nologin judge

cd /home/judge/ || exit

#using tgz src files
#wget -O hustoj.tar.gz http://dl.hustoj.com/hustoj.tar.gz
#tar xzf hustoj.tar.gz
#svn up src
#svn co https://github.com/zhblue/hustoj/trunk/trunk/  src

#how to make src zip
#zip -r hustojYYMMDD.zip ./src
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SRCZIP}
unzip ${SRCZIP}
rm ${SRCZIP}

#changing Dockerfile
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${DOCKERFILE}
chown root:root ./${DOCKERFILE}
chmod 644 ./${DOCKERFILE}
mv -f ./${DOCKERFILE} /home/judge/src/install/Dockerfile


#------ original intallation scripts start




apt-get install -y libmysqlclient-dev
apt-get install -y libmysql++-dev
apt-get install -y libmariadb-dev libmariadbclient-dev 
PHP_VER=`apt-cache search php-fpm|grep -e '[[:digit:]]\.[[:digit:]]' -o`
if [ "$PHP_VER" = "" ] ; then PHP_VER="8.1"; fi
for pkg in bzip2 flex net-tools make g++ php$PHP_VER-fpm memcached nginx php$PHP_VER-mysql php$PHP_VER-common php$PHP_VER-gd php$PHP_VER-zip php$PHP_VER-mbstring php$PHP_VER-xml php$PHP_VER-curl php$PHP_VER-intl php$PHP_VER-xmlrpc php$PHP_VER-soap php-memcache php-memcached php-yaml php-apcu tzdata
do
        while ! apt-get install -y "$pkg"
        do
                dpkg --configure -a
                apt-get install -f
                echo "Network fail, retry... you might want to change another apt source for install"
        done
done
apt-get install -y mariadb-server
service php$PHP_VER-fpm start
service mariadb start
service nginx start

chgrp www-data  /home/judge
chmod +x /home/judge/src/install/*

USER="hustoj"
PASSWORD=`tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1`
mysql < src/install/db.sql
echo "DROP USER $USER;" | mysql
echo "CREATE USER $USER identified by '$PASSWORD';grant all privileges on jol.* to $USER ;flush privileges;"|mysql
CPU=$(grep "cpu cores" /proc/cpuinfo |head -1|awk '{print $4}')
MEM=`free -m|grep Mem|awk '{print $2}'`

if [ "$MEM" -lt "1000" ] ; then
        echo "Memory size less than 1GB."
        if grep 'key_buffer_size        = 1M' /etc/mysql/mariadb.conf.d/50-server.cnf ; then
                echo "already trim config"
        else
                sed -i 's/#key_buffer_size        = 128M/key_buffer_size        = 1M/' /etc/mysql/mariadb.conf.d/50-server.cnf
                sed -i 's/#table_cache            = 64/#table_cache            = 5/' /etc/mysql/mariadb.conf.d/50-server.cnf
                sed -i 's/#skip-name-resolve/skip-name-resolve/' /etc/mysql/mariadb.conf.d/50-server.cnf
                service mariadb restart
                free -h
        fi
else
        echo "Memory size : $MEM MB"
fi

mkdir etc data log backup

cp src/install/java0.policy  /home/judge/etc
cp src/install/judge.conf  /home/judge/etc
chmod +x src/install/ans2out /home/judge/src/install/*.sh

# create enough runX dirs for each CPU core
if grep "OJ_SHM_RUN=0" etc/judge.conf ; then
        for N in `seq 0 $(($CPU-1))`
        do
           mkdir run$N
           chown judge run$N
        done
fi

sed -i "s/OJ_USER_NAME=.*/OJ_USER_NAME=$USER/g" etc/judge.conf
sed -i "s/OJ_PASSWORD=.*/OJ_PASSWORD=$PASSWORD/g" etc/judge.conf
sed -i "s/OJ_COMPILE_CHROOT=1/OJ_COMPILE_CHROOT=0/g" etc/judge.conf
sed -i "s/OJ_RUNNING=1/OJ_RUNNING=$CPU/g" etc/judge.conf

chmod 700 backup
chmod 700 etc/judge.conf
chown -R root:root etc

sed -i "s/DB_USER[[:space:]]*=[[:space:]]*\".*\"/DB_USER=\"$USER\"/g" src/web/include/db_info.inc.php
sed -i "s/DB_PASS[[:space:]]*=[[:space:]]*\".*\"/DB_PASS=\"$PASSWORD\"/g" src/web/include/db_info.inc.php
chmod 700 src/web/include/db_info.inc.php
chown -R www-data:www-data src/web/

chown -R root:root src/web/.svn
chmod 750 -R src/web/.svn

chown www-data:www-data src/web/upload
chown www-data:judge data
chmod 750 -R data
if grep "client_max_body_size" /etc/nginx/nginx.conf ; then
        echo "client_max_body_size already added" ;
else
        sed -i 's/# multi_accept on;/ multi_accept on;/' /etc/nginx/nginx.conf
        sed -i "s:include /etc/nginx/mime.types;:client_max_body_size    500m;\n\tinclude /etc/nginx/mime.types;:g" /etc/nginx/nginx.conf
fi

echo "insert into jol.privilege values('admin','administrator','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD"
echo "insert into jol.privilege values('admin','source_browser','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD"

if grep "added by hustoj" /etc/nginx/sites-enabled/default ; then
        echo "default site modified!"
else
        echo "modify the default site"
        sed -i "s#listen 80 default_server;#listen 80 default_server backlog=4096;#g" /etc/nginx/sites-enabled/default
        sed -i "s#root /var/www/html;#root /home/judge/src/web;#g" /etc/nginx/sites-enabled/default
        sed -i "s:index index.html:index index.php:g" /etc/nginx/sites-enabled/default
        sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
        sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
        sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
        sed -i "s:}#added by hustoj::g" /etc/nginx/sites-enabled/default
        sed -i "s:php7.4:php$PHP_VER:g" /etc/nginx/sites-enabled/default
        sed -i "s|# deny access to .htaccess files|}#added by hustoj\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default
        sed -i "s|fastcgi_pass 127.0.0.1:9000;|fastcgi_pass 127.0.0.1:9001;\n\t\tfastcgi_buffer_size 256k;\n\t\tfastcgi_buffers $NBUFF 64k;|g" /etc/nginx/sites-enabled/default
fi
/etc/init.d/nginx restart
sed -i "s/post_max_size = 8M/post_max_size = 500M/g" /etc/php/$PHP_VER/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 500M/g" /etc/php/$PHP_VER/fpm/php.ini
if grep 'date.timezone = PRC' /etc/php/$PHP_VER/fpm/php.ini ; then
    echo "date.timezone = PRC is already set ... "
else
    sed -i 's/;date.timezone =/date.timezone = PRC/' /etc/php/$PHP_VER/fpm/php.ini 
fi
if grep "opcache.jit_buffer_size" /etc/php/$PHP_VER/fpm/php.ini ; then
    echo "opcache for jit is already enabled ... "
else
    sed -i "s|opcache.lockfile_path=/tmp|opcache.lockfile_path=/tmp\nopcache.jit_buffer_size=16M|g" /etc/php/$PHP_VER/fpm/php.ini
fi
WWW_CONF=$(find /etc/php -name www.conf)
sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 128/g' "$WWW_CONF"
sed -i 's/pm.max_children = 5/pm.max_children = 600/g' "$WWW_CONF"
sed -i 's/;listen.backlog = 511/listen.backlog = 4096/g' "$WWW_CONF"

COMPENSATION=$(grep 'mips' /proc/cpuinfo|head -1|awk -F: '{printf("%.2f",$2/7000)}')
sed -i "s/OJ_CPU_COMPENSATION=1.0/OJ_CPU_COMPENSATION=$COMPENSATION/g" etc/judge.conf

PHP_FPM=$(find /etc/init.d/ -name "php*-fpm")
$PHP_FPM restart
PHP_FPM=$(service --status-all|grep php|awk '{print $4}')
if [ "$PHP_FPM" != ""  ]; then service "$PHP_FPM" restart ;else echo "NO PHP FPM";fi;

cd src/core || exit
chmod +x ./make.sh
./make.sh
if grep "/usr/bin/judged" /etc/rc.local ; then
        echo "auto start judged added!"
else
        sed -i "s/exit 0//g" /etc/rc.local
        echo "/usr/bin/judged" >> /etc/rc.local
        echo "exit 0" >> /etc/rc.local
fi
if grep "bak.sh" /var/spool/cron/crontabs/root ; then
        echo "auto backup added!"
else
        crontab -l > conf 
        echo "1 0 * * * /home/judge/src/install/bak.sh" >> conf
        echo "0 * * * * /home/judge/src/install/oomsaver.sh" >> conf 
        crontab conf 
        rm -f conf
        /etc/init.d/cron reload
fi
ln -s /usr/bin/mcs /usr/bin/gmcs

/usr/bin/judged
cp /home/judge/src/install/hustoj /etc/init.d/hustoj
update-rc.d hustoj defaults
systemctl enable hustoj
systemctl enable nginx
systemctl enable mariadb
systemctl enable php$PHP_VER-fpm
#systemctl enable judged

if ps -C memcached; then 
    sed -i 's/static  $OJ_MEMCACHE=false;/static  $OJ_MEMCACHE=true;/g' /home/judge/src/web/include/db_info.inc.php
    sed -i 's/-m 64/-m 8/g' /etc/memcached.conf
    /etc/init.d/memcached restart
fi

/etc/init.d/mariadb start
mkdir /var/log/hustoj/
chown www-data -R /var/log/hustoj/
cd /home/judge/src/install
if test -f  /.dockerenv ;then
        echo "Already in docker, skip docker installation, install some compilers ... "
        apt-get intall -y flex fp-compiler openjdk-17-jdk mono-devel
else
        sed -i 's/ubuntu:22/ubuntu:24/g' Dockerfile
        sed -i 's|/usr/include/c++/9|/usr/include/c++/11|g' Dockerfile
        bash docker.sh
fi

#clear
#reset

#------ original intallation scripts end




cd

#judge.conf edit
#time result fix ... for use_max_time : to record the max time of all results, not sum of...
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf
sed -i "s/OJ_TIME_LIMIT_TO_TOTAL=1/OJ_TIME_LIMIT_TO_TOTAL=0/" /home/judge/etc/judge.conf

#db_info.inc.php edit
#for OJ name
sed -i "s/OJ_NAME=\"HUSTOJ\"/OJ_NAME=\"${OJNAME}\"/" /home/judge/src/web/include/db_info.inc.php
#for bs3 template
sed -i "s/OJ_TEMPLATE=\"syzoj\"/OJ_TEMPLATE=\"bs3\"/" /home/judge/src/web/include/db_info.inc.php

#for korean kindeditor
sed -i "s/OJ_LANG=\"en\"/OJ_LANG=\"ko\"/" /home/judge/src/web/include/db_info.inc.php
sed -i "s/zh_CN.js/ko.js/" /home/judge/src/web/admin/kindeditor.php

#Removing QR codes + CSL
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js250131.php
mv -f ./js250131.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/template/bs3/js.php


#Identifing AWS/GCE Ubuntu 24.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS/GCE SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi


#temporary fix until next release
#...


#Replacing msg.txt
mkdir /home/judge/src/web/admin/msg
chown www-data:root /home/judge/src/web/admin/msg
chmod 744 /home/judge/src/web/admin/msg
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg250131.txt
mv -f ./msg250131.txt /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
chown www-data:${SUDO_USER} /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
chmod 644 /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt



#discuss upgrade for 24.12.25
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/lang/ko.php
#mv -f ./ko.php /home/judge/src/web/lang/ko.php
#chown www-data:www-data /home/judge/src/web/lang/ko.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bbs.php
#mv -f ./bbs.php /home/judge/src/web/bbs.php
#chown www-data:www-data /home/judge/src/web/bbs.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/nav.php
#mv -f ./nav.php /home/judge/src/web/template/bs3/nav.php
#chown www-data:www-data /home/judge/src/web/template/bs3/nav.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/discuss.php
#mv -f ./discuss.php /home/judge/src/web/discuss.php
#chown www-data:www-data /home/judge/src/web/discuss.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/discuss.php
#mv -f ./discuss.php /home/judge/src/web/template/bs3/discuss.php
#chown www-data:www-data /home/judge/src/web/template/bs3/discuss.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/post.php
#mv -f ./post.php /home/judge/src/web/post.php
#chown www-data:www-data /home/judge/src/web/post.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/thread.php
#mv -f ./thread.php /home/judge/src/web/thread.php
#chown www-data:www-data /home/judge/src/web/thread.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/threadadmin.php
#mv -f ./threadadmin.php /home/judge/src/web/threadadmin.php
#chown www-data:www-data /home/judge/src/web/threadadmin.php

#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/newpost.php
#mv -f ./newpost.php /home/judge/src/web/newpost.php
#chown www-data:www-data /home/judge/src/web/newpost.php




#clear

echo ""
echo "--- $OJNAME HUSTOJ installed!! ---"
echo ""
echo "Register admin!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
echo ""
echo "Check & Edit HUSTOJ configurations"
echo "sudo nano /home/judge/src/web/include/db_info.inc.php"
echo ""

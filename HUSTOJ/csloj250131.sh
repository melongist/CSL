#!/bin/bash
#CSL HUSTOJ
#Made by melongist(melongist@gmail.com)
#for CSL Computer Science teachers
#Last edits 25.02.17
#도움 주신 분 : 유현호


clear

VER_DATE="25.01.31"

THISFILE="csloj250131.sh"
SRCZIP="hustoj250131.zip"
DOCKERFILE="Dockerfile250131"

SQLFILE="csl250131jol.sql"
UPLOADFILE="csl250131uploads.tar.gz"
DATAFILE="csl250131data.tar.gz"

MAINTENANCEFILE="cslojmaintenance.sh"
BACKUPFILE="cslojbackup.sh"


if [[ -z $SUDO_USER ]]
then
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


if [ -d /home/judge ] ; then
  echo ""
  echo "HUSTOJ is already installed at this computer!!"
  echo ""
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


echo ""
echo "---- CSL HUSTOJ release ${VER_DATE} ----"
echo ""

INPUTS="n"
echo -n "Do you want to install the CSL HUSTOJ release ${VER_DATE}? [y/n] : "
read INPUTS
if [ ${INPUTS} = "y" ]
then
  echo ""
  echo ""
  echo "---- CSL HUSTOJ release ${VER_DATE} installation started..." | tee -a /home/${SUDO_USER}/cslojlog.txt
  echo ""
else
  echo ""
  exit 1
fi

cd


#for OJ NAME
INPUTS="x"

while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo -n "Rename CSL HUSTOJ logo name? [y/n]: "
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

timedatectl set-timezone 'Asia/Seoul'
#PHP timezone set
sudo sed -i "s:date.timezone = PRC:date.timezone = Asia/Seoul:g" /etc/php/8.3/fpm/php.ini
sudo sed -i "s:Asia/Shanghai:Asia/Seoul:g" /home/judge/src/web/include/init.php
sudo sed -i "s:+8\:00:+9\:00:g" /home/judge/src/web/include/init.php

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
sed -i "s/OJ_LANG=\"cn\"/OJ_LANG=\"ko\"/" /home/judge/src/web/include/db_info.inc.php
sed -i "s/zh_CN.js/ko.js/" /home/judge/src/web/admin/kindeditor.php

#Removing QR codes + CSL
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/cslojjs250131.php
mv -f ./cslojjs250131.php /home/judge/src/web/template/bs3/js.php
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
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/cslojmsg250131.txt
mv -f ./cslojmsg250131.txt /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
chown www-data:${SUDO_USER} /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
chmod 644 /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt

#phpmyadmin install script
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/phmyadmin02.sh
#mv -f ./phpmyadmin02.sh /home/${SUDO_USER}/
#chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/phpmyadmin02.sh
#chmod 664 /home/${SUDO_USER}/phpmyadmin02.sh


#jol database overwriting
#current mysql backup
#how to backup from HUSTOJ for CSL :> mysqldump -u hustoj -p --add-drop-table --create-options jol > jol.sql
#command   : sudo mysqldump -u hustoj -p --add-drop-table jol > /home/${SUDO_USER}/oldjol.sql
#overwriting
DBUSER=$(grep '$DB_USER' /home/judge/src/web/include/db_info.inc.php|head -1|awk  '{print $2}'|cut -d "\"" -f2)
PASSWORD=$(grep '$DB_PASS' /home/judge/src/web/include/db_info.inc.php|head -1|awk  '{print $2}'|cut -d "\"" -f2)


wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/sql/${SQLFILE}
mysql -u ${DBUSER} -p${PASSWORD} jol < ${SQLFILE}
rm ${SQLFILE}
#add source_browser privilege to admin
#echo "insert into jol.privilege values('admin','source_browser','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD"


#Coping all upload files to server
#how to backup upload files from CSL HUSTOJ
#directory : /home/judge/src/wb/upload/
#command   : sudo tar -czvpf /home/${SUDO_USER}/olduploads.tar.gz /home/judge/src/web/upload
rm -rf /home/judge/src/web/upload/*
#overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/${UPLOADFILE}
tar -xzvpf ./${UPLOADFILE} -C /
rm ./${UPLOADFILE}


chown www-data:www-data -R /home/judge/src/web/upload/*
chmod 755 /home/judge/src/web/upload/*
chmod 755 /home/judge/src/web/upload/file
chmod 755 /home/judge/src/web/upload/image
chown www-data:root -R /home/judge/src/web/upload/index.html
chmod 664 /home/judge/src/web/upload/index.html


#Coping all problem *.in & *.out data to server
#how to backup test in/out files from CSL HUSTOJ
#directory : /home/judge/
#command   : sudo tar -czvpf /home/${SUDO_USER}/olddata.tar.gz /home/judge/data
rm -rf /home/judge/data
#overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/data/${DATAFILE}
tar -xzvpf ./${DATAFILE} -C /
rm ./${DATAFILE}

chmod 644 -R /home/judge/data
chown www-data:www-data -R /home/judge/data
chmod 755 /home/judge/data/*
chmod 711 /home/judge/data
chown www-data:judge /home/judge/data


#file upload privelege fix 744 to 644
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/phpfm250131.php
mv -f ./phpfm250131.php /home/judge/src/web/admin/phpfm.php
chown www-data:root /home/judge/src/web/admin/phpfm.php
chmod 664 /home/judge/src/web/admin/phpfm.php


#problem_add_page.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page250131.php
mv -f ./problem_add_page250131.php /home/judge/src/web/admin/problem_add_page.php
chown www-data:root /home/judge/src/web/admin/problem_add_page.php
chmod 664 /home/judge/src/web/admin/problem_add_page.php


#problem_add.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add250131.php
mv -f ./problem_add250131.php /home/judge/src/web/admin/problem_add.php
chown www-data:root /home/judge/src/web/admin/problem_add.php
chmod 664 /home/judge/src/web/admin/problem_add.php


#problem_edit.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit250131.php
mv -f ./problem_edit250131.php /home/judge/src/web/admin/problem_edit.php
chown www-data:root /home/judge/src/web/admin/problem_edit.php
chmod 664 /home/judge/src/web/admin/problem_edit.php


#problem_export_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml250131.php
mv -f ./problem_export_xml250131.php /home/judge/src/web/admin/problem_export_xml.php
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php


#problem_export.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export250131.php
mv -f ./problem_export250131.php /home/judge/src/web/admin/problem_export.php
chown www-data:root /home/judge/src/web/admin/problem_export.php
chmod 664 /home/judge/src/web/admin/problem_export.php


#problem_import_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml250131.php
mv -f ./problem_import_xml250131.php /home/judge/src/web/admin/problem_import_xml.php
chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
chmod 664 /home/judge/src/web/admin/problem_import_xml.php


#problem_import.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import250131.php
mv -f ./problem_import250131.php /home/judge/src/web/admin/problem_import.php
chown www-data:root /home/judge/src/web/admin/problem_import.php
chmod 664 /home/judge/src/web/admin/problem_import.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem250131.php
mv -f ./problem250131.php /home/judge/src/web/include/problem.php
chown www-data:root /home/judge/src/web/include/problem.php
chmod 664 /home/judge/src/web/include/problem.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem250131.php
mv -f ./problem250131.php /home/judge/src/web/template/bs3/problem.php
chown www-data:root /home/judge/src/web/template/bs3/problem.php
chmod 644 /home/judge/src/web/template/bs3/problem.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage250131.php
mv -f ./submitpage250131.php /home/judge/src/web/template/bs3/submitpage.php
chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
chmod 644 /home/judge/src/web/template/bs3/submitpage.php


#submit.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit250131.php
mv -f ./submit250131.php /home/judge/src/web/submit.php
chown www-data:root /home/judge/src/web/submit.php
chmod 644 /home/judge/src/web/submit.php


#db_info.inc.php edit
#set OJ_REGISTER=false : not allow register
sed -i "s/OJ_REGISTER=true/OJ_REGISTER=false/" /home/judge/src/web/include/db_info.inc.php
#set OJ_VCODE=true : set vcode
sed -i "s/OJ_VCODE=false/OJ_VCODE=true/" /home/judge/src/web/include/db_info.inc.php
#set OJ_LANGMASK to  C++ & python only...
sed -i "s/OJ_LANGMASK=33554356/OJ_LANGMASK=33554364/" /home/judge/src/web/include/db_info.inc.php
#set BBS discuss3
sed -i "s/OJ_BBS=false/OJ_BBS=\"discuss3\"/" /home/judge/src/web/include/db_info.inc.php
#set OJ_POISON_BOT_COUNT=100;
sed -i "s/OJ_POISON_BOT_COUNT=10/OJ_POISON_BOT_COUNT=100/" /home/judge/src/web/include/db_info.inc.php


#php.ini edit
#file upload size more up
sed -i "s/post_max_size = 180M/post_max_size = 256M/g" /etc/php/$PHP_VER/fpm/php.ini
sed -i "s/upload_max_filesize = 180M/upload_max_filesize = 256M/g" /etc/php/$PHP_VER/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 120/g" /etc/php/$PHP_VER/fpm/php.ini
#sed -i "s/memory_limit = 128M/memory_limit = 512M/g" /etc/php/$PHP_VER/fpm/php.ini
sed -i "s:client_max_body_size    80m:client_max_body_size    256m:g" /etc/nginx/nginx.conf


#Identifing AWS/GCE Ubuntu 24.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]
then
  SERVERTYPES="AWS/GCE SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi

#Removing QR codes + CSL link
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/jsCSL250131.php
mv -f ./jsCSL250131.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/template/bs3/js.php

#Add homebanner(home.ko)
sed -i "s/'faqs.\$OJ_LANG'/'faqs.\$OJ_LANG' AND \`title\`!='home.ko'/" /home/judge/src/web/index.php
sed -i "s#/////////////////////////Template#/////////////////////////Template\n\$homebanner=\"home.ko\";\n\$sql=\"select title,content from news where title=? and defunct='N' order by news_id limit 1\";\n\$result=pdo_query(\$sql,\$homebanner);\nif(count(\$result)>0) \$view_homebanner=\$result[0][1];\nelse \$view_homebanner=\"\";\n#" /home/judge/src/web/index.php
sed -i "s#call to action -->#call to action -->\n\t\t<div> <?php echo \$view_faqs?> </div>\n\t\t<?php if(\$view_homebanner != \"\") { echo \"<div><br><br><br>\"; echo \$view_homebanner; echo \"</div>\";}?>#" /home/judge/src/web/template/bs3/index.php
sed -i "s#<?php echo \$MSG_HELP_ADD_FAQS?>#<?php echo \$MSG_HELP_ADD_FAQS?><br>\n- <?php echo '\"home.ko\"를 제목으로 공지사항을 등록하면 첫 페이지의 위 쪽에 배너처럼 나타납니다.'?>#" /home/judge/src/web/admin/news_list.php


#for contest concerned errors fix
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/problem250131.php
mv -f ./problem250131.php /home/judge/src/web/problem.php
chown www-data:root /home/judge/src/web/problem.php
chmod 644 /home/judge/src/web/problem.php

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/contest250131.php
mv -f ./contest250131.php /home/judge/src/web/contest.php
chown www-data:root /home/judge/src/web/contest.php
chmod 644 /home/judge/src/web/contest.php

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/contestset250131.php
mv -f ./contestset250131.php /home/judge/src/web/template/bs3/contestset.php
chown www-data:root /home/judge/src/web/template/bs3/contestset.php
chmod 644 /home/judge/src/web/template/bs3/contestset.php


#for cslojmaintenance
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${MAINTENANCEFILE} -O /home/${SUDO_USER}/${MAINTENANCEFILE}
chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${MAINTENANCEFILE}
sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${MAINTENANCEFILE}

if [ -e "/var/spool/cron/crontabs/root" ]
then
  if [ grep "bak.sh" /var/spool/cron/crontabs/root ]
  then
    sed -i "/bak.sh/d" /var/spool/cron/crontabs/root
  fi

  if [ grep "cslojmaintenance" /var/spool/cron/crontabs/root ]
  then
    sed -i "/cslojmaintenance/d" /var/spool/cron/crontabs/root
  fi
fi


crontab -l > temp
echo "30 4 * * * sudo bash /home/${SUDO_USER}/${MAINTENANCEFILE}" >> temp
crontab temp
rm -f temp


#temporary fix until next release
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_list250131.php
mv -f ./problem_list250131.php /home/judge/src/web/admin/problem_list.php
chown www-data:root /home/judge/src/web/admin/problem_list.php
chmod 664 /home/judge/src/web/admin/problem_list.php
#for bs3 ranklist
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/ranklist250131.php
mv -f ./ranklist250131.php /home/judge/src/web/template/bs3/ranklist.php
chown www-data:www-data /home/judge/src/web/template/bs3/ranklist.php
chmod 644 /home/judge/src/web/template/bs3/ranklist.php


#...
sed -i "s/count(\$used_in_contests)>0/count(\$used_in_contests)>0 \&\& cid==0/g" /home/judge/src/web/template/bs3/problem.php
#pdf file upload error fix
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/upload_json250131.php
mv -f ./upload_json250131.php /home/judge/src/web/kindeditor/php/upload_json.php
chown www-data:root /home/judge/src/web/kindeditor/php/upload_json.php
chmod 664 /home/judge/src/web/kindeditor/php/upload_json.php




#discuss upgrade for 24.01.30
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


#for /home/judge/src/web/template/bs3/
#for bs3 submit windows resize
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem240403.php
#mv -f ./problem240403.php /home/judge/src/web/template/bs3/problem.php
#chown www-data:www-data /home/judge/src/web/template/bs3/problem.php
#chmod 644 /home/judge/src/web/template/bs3/problem.php
#for bs3 judges rejudge & delete
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/status250131.php
mv -f ./status250131.php /home/judge/src/web/template/bs3/status.php
chown www-data:www-data /home/judge/src/web/template/bs3/status.php
chmod 644 /home/judge/src/web/template/bs3/status.php
#for bs3 submit windows resize
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage240403.php
#mv -f ./submitpage240403.php /home/judge/src/web/template/bs3/submitpage.php
#chown www-data:www-data /home/judge/src/web/template/bs3/submitpage.php
#chmod 644 /home/judge/src/web/template/bs3/submitpage.php


#for /home/judge/src/web/
#for bs3 submit windows resize
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/problem240403.php
#mv -f ./problem240403.php /home/judge/src/web/problem.php
#chown www-data:www-data /home/judge/src/web/problem.php
#chmod 644 /home/judge/src/web/problem.php
#for bs3 judges rejudge & delete
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/status250131.php
mv -f ./status250131.php /home/judge/src/web/status.php
chown www-data:www-data /home/judge/src/web/status.php
chmod 644 /home/judge/src/web/status.php


#for backup
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${BACKUPFILE} -O /home/${SUDO_USER}/${BACKUPFILE}
chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${BACKUPFILE}
sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${BACKUPFILE}
bash /home/${SUDO_USER}/${BACKUPFILE} -${VER_DATE}


echo "" | tee -a /home/${SUDO_USER}/cslojlog.txt
echo "---- ${OJNAME}(CSL HUSTOJ release ${VER_DATE}) installed! ----" | tee -a /home/${SUDO_USER}/cslojlog.txt
echo "" | tee -a /home/${SUDO_USER}/cslojlog.txt

echo "First of all! Change the default CSL HUSTOJ admin password!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
echo ""
echo ""
echo "---- system reboot ----"
echo "System will be rebooted in 20 seconds!"
echo ""
COUNT=20
while [ $COUNT -ge 0 ]
do
  echo $COUNT
  ((COUNT--))
  sleep 1
done
echo "System rebooted" | tee -a /home/${SUDO_USER}/cslojlog.txt
sleep 5
reboot

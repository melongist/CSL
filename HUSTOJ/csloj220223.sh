#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

VER_DATE="22.02.23"

THISFILE="csloj220223.sh"
SRCZIP="hustoj220223.zip"
DOCKERFILE="Dockerfile220223"

SQLFILE="csl220223jol.sql"
UPLOADFILE="csl220223uploads.tar.gz"
DATAFILE="csl220223data.tar.gz"

MAINTENANCEFILE="cslojmaintenance00.sh"
BACKUPFILE="cslojbackup00.sh"




if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
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
  echo "---- CSL HUSTOJ release ${VER_DATE} installation started..."
  echo ""
else
  echo ""
  exit 1
fi

UPGRADETYPE="0"

#if /home/judge exists. i.e. there is old HUSTOJ
if [ -d /home/judge ]
then
  INPUTS="n"
  while [ ${INPUTS} != "y" ]
  do
    echo ""
    echo "---- Select installation type"
    echo " 1) Upgrade & Migration to ${VER_DATE} ..."
    echo " 2) Reset & New installation ..."
    echo " 3) Exit without installation ..."
    echo ""
    echo -n " Select [1/2/3] : "
    read UPGRADETYPE
    echo ""
    if [ ${UPGRADETYPE} = "1" ]
    then
      echo " 1) Upgrade & Migration to ${VER_DATE} ... selected."
      echo ""
      echo -n " Are you sure? [y/n] : "
      read INPUTS
      echo ""
    elif [ ${UPGRADETYPE} = "2" ]
    then
      echo " 2) Reset & New installation ... selected."
      echo ""
      echo -n " Are you sure? [y/n] : "
      read INPUTS
      echo ""
    else
      echo " 3) Exit without installation ... selected."
      echo ""
      exit 1
    fi
  done
fi

#for OJ NAME
OJNAME="o"
INPUTS="x"
while [ ${OJNAME} != ${INPUTS} ]
do
  echo -n "Enter  the CSL HUSTOJ name you want : "
  read OJNAME
  echo -n "Repeat the CSL HUSTOJ name you want : "
  read INPUTS
done


#if /home/judge exists. i.e. there is old HUSTOJ
if [ -d /home/judge ]
then
  #backup old hustoj
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${BACKUPFILE} -O /home/${SUDO_USER}/${BACKUPFILE}
  chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${BACKUPFILE}
  sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${BACKUPFILE}
  bash /home/${SUDO_USER}/${BACKUPFILE} -old

  DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
  PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

  if [ ${UPGRADETYPE} = "1" ]
  then
    #backup current old DB
    #how to backup database : mysqldump -u debian-sys-maint -p jol > jol.sql
    mysqldump -u ${DBUSER} -p${PASSWORD} jol > /home/${SUDO_USER}/oldjol.sql
    #backup current old *.in/*.out data
    tar -czvpf /home/${SUDO_USER}/olddata.tar.gz /home/judge/data
    #backup old uploads (images included)
    tar -czvpf /home/${SUDO_USER}/olduploads.tar.gz /home/judge/src/web/upload
    #backup old msg.txt
    tar -czvpf /home/${SUDO_USER}/oldmsg.tar.gz /home/judge/src/web/admin/msg.txt
  fi

  rm -rf /home/judge/src/*
  rm -rf /home/judge/src/.svn
  cd /home/judge/
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SRCZIP}
  unzip ${SRCZIP}
  rm ${SRCZIP}

  sed -i "s/DB_USER[[:space:]]*=[[:space:]]*\"root\"/DB_USER=\"$DBUSER\"/g" src/web/include/db_info.inc.php
  sed -i "s/DB_PASS[[:space:]]*=[[:space:]]*\"root\"/DB_PASS=\"$PASSWORD\"/g" src/web/include/db_info.inc.php
  chmod 700 src/web/include/db_info.inc.php
  chown -R www-data src/web/

  chown -R root:root src/web/.svn
  chmod 750 -R src/web/.svn
  chown www-data:judge src/web/upload

else
#new installation block start

echo ""
echo "Waiting 3 seconds..."
echo ""
sleep 3


#for South Korea's timezone
timedatectl set-timezone 'Asia/Seoul'

apt update
apt -y upgrade
apt -y autoremove

apt -y install subversion zip unzip curl

/usr/sbin/useradd -m -u 1536 judge
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




#手工解决阿里云软件源的包依赖问题
apt install libssl1.1=1.1.1f-1ubuntu2.8 -y --allow-downgrades
apt-get install -y libmysqlclient-dev
apt-get install -y libmysql++-dev 

for pkg in net-tools make g++ php-fpm nginx mysql-server php-mysql  php-common php-gd php-zip php-mbstring php-xml php-curl php-intl php-xmlrpc php-soap tzdata
do
  while ! apt-get install -y "$pkg" 
  do
    echo "Network fail, retry... you might want to change another apt source for install"
  done
done

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
CPU=$(grep "cpu cores" /proc/cpuinfo |head -1|awk '{print $4}')

mkdir etc data log backup

cp src/install/java0.policy  /home/judge/etc
cp src/install/judge.conf  /home/judge/etc
chmod +x src/install/ans2out

# create enough runX dirs for each CPU core
if grep "OJ_SHM_RUN=0" etc/judge.conf ; then
  for N in `seq 0 $(($CPU-1))`
  do
     mkdir run$N
     chown judge run$N
  done
fi

sed -i "s/OJ_USER_NAME=root/OJ_USER_NAME=$USER/g" etc/judge.conf
sed -i "s/OJ_PASSWORD=root/OJ_PASSWORD=$PASSWORD/g" etc/judge.conf
sed -i "s/OJ_COMPILE_CHROOT=1/OJ_COMPILE_CHROOT=0/g" etc/judge.conf
sed -i "s/OJ_RUNNING=1/OJ_RUNNING=$CPU/g" etc/judge.conf

chmod 700 backup
chmod 700 etc/judge.conf

sed -i "s/DB_USER[[:space:]]*=[[:space:]]*\"root\"/DB_USER=\"$USER\"/g" src/web/include/db_info.inc.php
sed -i "s/DB_PASS[[:space:]]*=[[:space:]]*\"root\"/DB_PASS=\"$PASSWORD\"/g" src/web/include/db_info.inc.php
chmod 700 src/web/include/db_info.inc.php
chown -R www-data src/web/

chown -R root:root src/web/.svn
chmod 750 -R src/web/.svn

chown www-data:judge src/web/upload
chown www-data:judge data
chmod 711 -R data
if grep "client_max_body_size" /etc/nginx/nginx.conf ; then 
  echo "client_max_body_size already added" ;
else
  sed -i "s:include /etc/nginx/mime.types;:client_max_body_size    80m;\n\tinclude /etc/nginx/mime.types;:g" /etc/nginx/nginx.conf
fi

mysql -h localhost -u"$USER" -p"$PASSWORD" < src/install/db.sql
echo "insert into jol.privilege values('admin','administrator','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD" 

if grep "added by hustoj" /etc/nginx/sites-enabled/default ; then
  echo "default site modified!"
else
  echo "modify the default site"
  sed -i "s#root /var/www/html;#root /home/judge/src/web;#g" /etc/nginx/sites-enabled/default
  sed -i "s:index index.html:index index.php:g" /etc/nginx/sites-enabled/default
  sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
  sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
  sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
  sed -i "s:}#added by hustoj::g" /etc/nginx/sites-enabled/default
  sed -i "s:php7.0:php7.4:g" /etc/nginx/sites-enabled/default
  sed -i "s|# deny access to .htaccess files|}#added by hustoj\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default
fi
/etc/init.d/nginx restart
sed -i "s/post_max_size = 8M/post_max_size = 80M/g" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 80M/g" /etc/php/7.4/fpm/php.ini
WWW_CONF=$(find /etc/php -name www.conf)
sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 128/g' "$WWW_CONF"
sed -i 's/pm.max_children = 5/pm.max_children = 200/g' "$WWW_CONF"
 
COMPENSATION=$(grep 'mips' /proc/cpuinfo|head -1|awk -F: '{printf("%.2f",$2/5000)}')
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
  crontab -l > conf && echo "1 0 * * * /home/judge/src/install/bak.sh" >> conf && crontab conf && rm -f conf
fi
ln -s /usr/bin/mcs /usr/bin/gmcs

/usr/bin/judged
cp /home/judge/src/install/hustoj /etc/init.d/hustoj
update-rc.d hustoj defaults
systemctl enable hustoj
systemctl enable nginx
systemctl enable mysql
systemctl enable php7.4-fpm
#systemctl enable judged

/etc/init.d/mysql start


mkdir /var/log/hustoj/
chown www-data -R /var/log/hustoj/
cd /home/judge/src/install
if test -f  /.dockerenv ;then
  echo "Already in docker, skip docker installation, install some compilers ... "
  apt-get intall -y flex fp-compiler openjdk-14-jdk mono-devel
else
  bash docker.sh
   sed -i "s/OJ_USE_DOCKER=0/OJ_USE_DOCKER=1/g" /home/judge/etc/judge.conf
   sed -i "s/OJ_PYTHON_FREE=0/OJ_PYTHON_FREE=1/g" /home/judge/etc/judge.conf
fi

#cls
#reset



#------ original intallation scripts end



#new installation block end
fi




cd 

#judge.conf edit
#time result fix ... for use_max_time : to record the max time of all results, not sum of...
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf

#db_info.inc.php edit
#for OJ name
sed -i "s/OJ_NAME=\"HUSTOJ\"/OJ_NAME=\"${OJNAME}\"/" /home/judge/src/web/include/db_info.inc.php
#for bs3 template
sed -i "s/OJ_TEMPLATE=\"syzoj\"/OJ_TEMPLATE=\"bs3\"/" /home/judge/src/web/include/db_info.inc.php

#for korean kindeditor
sed -i "s/OJ_LANG=\"en\"/OJ_LANG=\"ko\"/" /home/judge/src/web/include/db_info.inc.php
sed -i "s/zh_CN.js/ko.js/" /home/judge/src/web/admin/kindeditor.php

#Removing QR codes + CSL
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/cslojjs220223.php
mv -f ./cslojjs220223.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/template/bs3/js.php


#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
  #for python juding error fix
  sed -i "s/OJ_RUNNING=1/OJ_RUNNING=4/" /home/judge/etc/judge.conf
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi


#temporary fix until next release
#...
sed -i "s/<img src=\"refresh/<\!--<img src=\"refresh/" /home/judge/src/web/template/bs3/error.php
sed -i "s/on error\" >/on error\" >-->/" /home/judge/src/web/template/bs3/error.php
mkdir /home/judge/src/web/admin/msg
chown www-data:root /home/judge/src/web/admin/msg
chmod 744 /home/judge/src/web/admin/msg

#Replacing msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/cslojmsg220223.txt
mv -f ./cslojmsg220223.txt /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
chown www-data:${SUDO_USER} /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
chmod 644 /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/admin/msg/${IPADDRESS[0]}.txt

#phpmyadmin install script
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/phadmin00.sh
#mv -f ./phadmin00.sh /home/${SUDO_USER}/
#chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/phadmin00.sh
#chmod 664 /home/${SUDO_USER}/phadmin00.sh

#jol database overwriting
#current mysql backup
#how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > jol.sql
#command   : mysqldump -u debian-sys-maint -p jol > /home/${SUDO_USER}/oldjol.sql
#overwriting
DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
if [ ${UPGRADETYPE} = "1" ]
then
  mysql -u ${DBUSER} -p${PASSWORD} jol < /home/${SUDO_USER}/oldjol.sql
  rm /home/${SUDO_USER}/oldjol.sql
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SQLFILE}
  mysql -u ${DBUSER} -p${PASSWORD} jol < ${SQLFILE}
  rm ${SQLFILE}
  #add source_browser privilege to admin
  echo "insert into jol.privilege values('admin','source_browser','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD"
fi


#Coping all uploads to server
#current uploads backup
#how to backup uploads from CSL HUSTOJ
#directory : /home/judge/src/wb/upload/
#command   : sudo tar -czvpf /home/${SUDO_USER}/olduploads.tar.gz /home/judge/src/web/upload
rm -rf /home/judge/src/web/upload/*
#overwriting
if [ ${UPGRADETYPE} = "1" ]
then
  tar -xzvpf /home/${SUDO_USER}/olduploads.tar.gz -C /
  rm /home/${SUDO_USER}/olduploads.tar.gz
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/${UPLOADFILE}
  tar -xzvpf /home/${SUDO_USER}/${UPLOADFILE} -C /
  rm /home/${SUDO_USER}/${UPLOADFILE}
fi
chown www-data:www-data -R /home/judge/src/web/upload/*
chmod 755 /home/judge/src/web/upload/*
chmod 755 /home/judge/src/web/upload/file
chmod 755 /home/judge/src/web/upload/image
chown www-data:root -R /home/judge/src/web/upload/index.html
chmod 664 /home/judge/src/web/upload/index.html


#Coping all problem *.in & *.out data to server
#current data backup
#how to backup test in/out files from CSL HUSTOJ
#directory : /home/judge/
#command   : sudo tar -czvpf /home/${SUDO_USER}/olddata.tar.gz /home/judge/data
rm -rf /home/judge/data
#overwriting
if [ ${UPGRADETYPE} = "1" ]
then
  rm -rf /home/judge/data/*
  tar -xzvpf /home/${SUDO_USER}/olddata.tar.gz -C /
  rm /home/${SUDO_USER}/olddata.tar.gz
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/${DATAFILE}
  tar -xzvpf /home/${SUDO_USER}/${DATAFILE} -C /
  rm ${DATAFILE}
fi
chmod 644 -R /home/judge/data
chown www-data:www-data -R /home/judge/data
chmod 755 /home/judge/data/*
chmod 711 /home/judge/data
chown www-data:judge /home/judge/data


#file upload privelege fix 711 to 644
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/phpfm220223.php
mv -f ./phpfm220223.php /home/judge/src/web/admin/phpfm.php
chown www-data:root /home/judge/src/web/admin/phpfm.php
chmod 664 /home/judge/src/web/admin/phpfm.php


#problem_add_page.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page220223.php
mv -f ./problem_add_page220223.php /home/judge/src/web/admin/problem_add_page.php
chown www-data:root /home/judge/src/web/admin/problem_add_page.php
chmod 664 /home/judge/src/web/admin/problem_add_page.php


#problem_add.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add220223.php
mv -f ./problem_add220223.php /home/judge/src/web/admin/problem_add.php
chown www-data:root /home/judge/src/web/admin/problem_add.php
chmod 664 /home/judge/src/web/admin/problem_add.php


#problem_edit.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit220223.php
mv -f ./problem_edit220223.php /home/judge/src/web/admin/problem_edit.php
chown www-data:root /home/judge/src/web/admin/problem_edit.php
chmod 664 /home/judge/src/web/admin/problem_edit.php


#problem_export_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml220223.php
mv -f ./problem_export_xml220223.php /home/judge/src/web/admin/problem_export_xml.php
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php


#problem_export.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export220223.php
mv -f ./problem_export220223.php /home/judge/src/web/admin/problem_export.php
chown www-data:root /home/judge/src/web/admin/problem_export.php
chmod 664 /home/judge/src/web/admin/problem_export.php


#problem_import_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml220223.php
mv -f ./problem_import_xml220223.php /home/judge/src/web/admin/problem_import_xml.php
chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
chmod 664 /home/judge/src/web/admin/problem_import_xml.php


#problem_import.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import220223.php
mv -f ./problem_import220223.php /home/judge/src/web/admin/problem_import.php
chown www-data:root /home/judge/src/web/admin/problem_import.php
chmod 664 /home/judge/src/web/admin/problem_import.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem220223.php
mv -f ./problem220223.php /home/judge/src/web/include/problem.php
chown www-data:root /home/judge/src/web/include/problem.php
chmod 664 /home/judge/src/web/include/problem.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem220223.php
mv -f ./problem220223.php /home/judge/src/web/template/bs3/problem.php
chown www-data:root /home/judge/src/web/template/bs3/problem.php
chmod 644 /home/judge/src/web/template/bs3/problem.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage220223.php
mv -f ./submitpage220223.php /home/judge/src/web/template/bs3/submitpage.php
chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
chmod 644 /home/judge/src/web/template/bs3/submitpage.php


#submit.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit220223.php
mv -f ./submit220223.php /home/judge/src/web/submit.php
chown www-data:root /home/judge/src/web/submit.php
chmod 644 /home/judge/src/web/submit.php


#db_info.inc.php edit
#set OJ_REGISTER=false
sed -i "s/OJ_REGISTER=true/OJ_REGISTER=false/" /home/judge/src/web/include/db_info.inc.php
#set OJ_VCODE=true
sed -i "s/OJ_VCODE=false/OJ_VCODE=true/" /home/judge/src/web/include/db_info.inc.php
#set OJ_SHOW_DIFF=true
#sed -i "s/OJ_SHOW_DIFF=false/OJ_SHOW_DIFF=true/" /home/judge/src/web/include/db_info.inc.php
#set OJ_LANGMASK to  C++ & python only...
sed -i "s/$OJ_LANGMASK=1637684/$OJ_LANGMASK=2097085/" /home/judge/src/web/include/db_info.inc.php


#judge.conf edit
#time result fix ... for use_max_time : to record the max time of all results, not sum of...
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf


#php.ini edit
#file upload size more up
sed -i "s/post_max_size = 80M/post_max_size = 512M/g" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = 80M/upload_max_filesize = 512M/g" /etc/php/7.4/fpm/php.ini
sed -i "s:client_max_body_size    80m:client_max_body_size    512m:g" /etc/nginx/nginx.conf


#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]
then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi

#Removing QR codes + CSL link
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/jsCSL220223.php
mv -f ./jsCSL220223.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/template/bs3/js.php

#Add homebanner(home.ko)
sed -i "s/'faqs.\$OJ_LANG'/'faqs.\$OJ_LANG' AND \`title\`!='home.ko'/" /home/judge/src/web/index.php
sed -i "s#/////////////////////////Template#/////////////////////////Template\n\$homebanner=\"home.ko\";\n\$sql=\"select title,content from news where title=? and defunct='N' order by news_id limit 1\";\n\$result=pdo_query(\$sql,\$homebanner);\nif(count(\$result)>0) \$view_homebanner=\$result[0][1];\nelse \$view_homebanner=\"\";\n#" /home/judge/src/web/index.php
sed -i "s#call to action -->#call to action -->\n\t\t<div> <?php echo \$view_faqs?> </div>\n\t\t<?php if(\$view_homebanner != \"\") { echo \"<div class>\"; echo \$view_homebanner; echo \"</div>\";}?>#" /home/judge/src/web/template/bs3/index.php
sed -i "s#<?php echo \$MSG_HELP_ADD_FAQS?>#<?php echo \$MSG_HELP_ADD_FAQS?><br>\n- <?php echo '\"home.ko\"를 제목으로 공지사항을 등록하면 첫 페이지의 위 쪽에 배너처럼 나타납니다.'?>#" /home/judge/src/web/admin/news_list.php


#for contest concerned errors fix
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/problem220223.php
mv -f ./problem220223.php /home/judge/src/web/problem.php
chown www-data:root /home/judge/src/web/problem.php
chmod 644 /home/judge/src/web/problem.php

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/contest220223.php
mv -f ./contest220223.php /home/judge/src/web/contest.php
chown www-data:root /home/judge/src/web/contest.php
chmod 644 /home/judge/src/web/contest.php

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/contestset220223.php
mv -f ./contestset220223.php /home/judge/src/web/template/bs3/contestset.php
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
#...




#for backup
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${BACKUPFILE} -O /home/${SUDO_USER}/${BACKUPFILE}
chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${BACKUPFILE}
sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${BACKUPFILE}
bash /home/${SUDO_USER}/${BACKUPFILE} -${VER_DATE}


if [ ${UPGRADETYPE} = "1" ]
then
  echo ""
  echo "---- ${OJNAME}(CSL HUSTOJ release ${VER_DATE}) upgraded! ----"
  echo ""
else
  echo ""
  echo "---- ${OJNAME}(CSL HUSTOJ release ${VER_DATE}) installed! ----"
  echo ""
fi
echo "First of all! Change the default CSL HUSTOJ admin password!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
echo ""
echo ""
echo "---- system reboot ----"
echo ""
echo "Waiting 10 seconds..."
sleep 10
echo "Rebooted"
reboot

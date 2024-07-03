#!/bin/bash

#2024.7 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge8.3.0 stable(2024.05.31) + Ubuntu 22.04.4 LTS + apache2/nginx

#This installation script only works on Ubuntu 22.04 LTS!!
#terminal commands to install dedicated DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830server.sh
#bash dj830server.sh

DJVER="8.3.0 stable (2024.05.31)"
DOMVER="domjudge-8.3.0"
THIS="dj830server.sh"
README="dj830server.txt"


if [[ $SUDO_USER ]] ; then
  echo ""
  echo "Just use 'bash ${THIS}'"
  exit 1
fi

OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')
if [ ${OSVER:0:5} != "22.04" ] ; then
  echo ""
  echo "This installation script only works on Ubuntu 22.04 LTS!!"
  echo ""
  exit 1
fi


WEBSERVER="no"
while [ ${WEBSERVER} != "apache2" ] && [ ${WEBSERVER} != "nginx" ]; do
  clear
  echo    ""
  echo    "Select Web-server for DOMjudge!"
  echo -n "apache2 or nginx? [apache2/nginx]: "
  read WEBSERVER
done


case ${WEBSERVER} in
  "apache2")
    ;;
  "nginx")
    INPUTS="x"
    while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
      echo    ""
      echo    "DOMjudge(+nginx) must have domain name!"
      echo -n "Do you have domain name? [y/n]: "
      read INPUTS
    done

    echo ""
    if [ ${INPUTS} == "y" ] ; then
      DOMAINNAME="o"
      INPUTS="x"
      while [ ${DOMAINNAME} != ${INPUTS} ]; do
        echo    ""
        echo -n "Enter  domain name : "
        read DOMAINNAME
        echo -n "Repeat domain name : "
        read INPUTS
      done
    else
      echo "Use DOMjudge(+apache2)"
      exit 1
    fi

    echo ""
    echo ${DOMAINNAME} > domainname.txt
    ;;
esac


cd


#time synchronization
echo ""
sudo timedatectl
echo ""

#set timezone
NEWTIMEZONE=$(tzselect)
sudo timedatectl set-timezone ${NEWTIMEZONE}
echo ""


#needrestart auto check for Ubuntu 22.04
#/etc/needrestart/needrestart.conf
if [ ! -e /etc/needrestart/needrestart.conf ] ; then
  sudo apt install needrestart -y
fi
sudo sed -i "s:#\$nrconf{restart} = 'i':\$nrconf{restart} = 'a':" /etc/needrestart/needrestart.conf
sudo sed -i "s:#\$nrconf{kernelhints} = -1:\$nrconf{kernelhints} = 0:" /etc/needrestart/needrestart.conf


sudo apt update
sudo apt upgrade -y

sudo apt install -y libcgroup-dev
sudo apt install -y make
sudo apt install -y acl
sudo apt install -y zip unzip
sudo apt install -y pv
#sudo apt install -y software-properties-common
#sudo apt install -y dirmngr
#sudo apt install -y apt-transport-https
sudo apt install -y composer
sudo apt install -y ntp
sudo apt install -y curl
sudo apt install -y python3-yaml
sudo apt install -y build-essential
sudo apt install -y pkg-config
#sudo apt install -y libcurl4-openssl-dev
#sudo apt install -y libcurl4-gnutls-dev
#sudo apt install -y libjsoncpp-dev




#DBMS
sudo apt install -y mariadb-server
#You must input mariaDB's root account password! <---- #1
sudo mysql_secure_installation
#For DOMjudge configuration check
#MariaDB Max connections to 16384
sudo sed -i "s/\#max_connections        = 100/max_connections        = 16384/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo sed -i "s/\[mysqld\]/\[mysqld\]\ninnodb_log_file_size=512M\nmax_allowed_packet=512M/" /etc/mysql/mariadb.conf.d/50-server.cnf




#Webserver
case ${WEBSERVER} in
  "apache2")
    sudo apt install -y apache2
    ;;
  "nginx")
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo service nginx start
    ;;
esac




#php 8.1
sudo apt install -y php8.1
sudo apt install -y php8.1-fpm
sudo apt install -y php8.1-gd
sudo apt install -y php8.1-cli
sudo apt install -y php8.1-intl
sudo apt install -y php8.1-mbstring
sudo apt install -y php8.1-mysql
sudo apt install -y php8.1-curl
#sudo apt install -y php8.1-json
sudo apt install -y php8.1-xml
sudo apt install -y php8.1-zip
case ${WEBSERVER} in
  "apache2")
    sudo systemctl restart apache2
    ;;
  "nginx")
    sudo systemctl restart nginx
    ;;
esac




#DOMjudge X.X.X stable
#wget https://www.domjudge.org/releases/domjudge-X.X.X.tar.gz
#tar xvf domjudge-X.X.X.tar.gz
#cd domjudge-X.X.X
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/${DOMVER}.tar.gz
tar xvf ${DOMVER}.tar.gz
rm ${DOMVER}.tar.gz




#Building and installing
cd ${DOMVER}
./configure --with-baseurl=BASEURL
make domserver
sudo make install-domserver

cd /opt/domjudge/domserver/bin
#./dj_setup_database genpass #it's not required..

#Use mariaDB's root password above #1
sudo ./dj_setup_database -u root -r install

case ${WEBSERVER} in
  "apache2")
    sudo ln -s -f /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
    sudo ln -s -f /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/8.1/fpm/pool.d/domjudge.conf
    sudo a2enmod proxy_fcgi setenvif rewrite
    sudo systemctl restart apache2
    sudo a2enconf php8.1-fpm domjudge
    sudo systemctl reload apache2
    sudo service php8.1-fpm reload
    sudo service apache2 reload
    ;;
  "nginx")
    sudo apt install -y apache2-utils
    sudo systemctl disable apache2    ###disable apache2
    sudo ln -s -f /opt/domjudge/domserver/etc/nginx-conf /etc/nginx/sites-enabled/domjudge
    sudo ln -s -f /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/8.1/fpm/pool.d/domjudge.conf
    sudo sed -i "s:# server_names_hash_bucket_size 64;:server_names_hash_bucket_size 64;:g" /etc/nginx/nginx.conf
    sudo sed -i "s:_default_:${DOMAINNAME}:g" /opt/domjudge/domserver/etc/nginx-conf-inner
    sudo nginx -t
    sudo systemctl restart nginx
    sudo service nginx reload
    ;;
esac


cd




#For DOMjudge configuration check
#PHP upload_max_filesize to 256M
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 256M/" /etc/php/8.1/fpm/php.ini
#PHP max_file_uploads to 512
sudo sed -i "s/max_file_uploads = 20/max_file_uploads = 512/" /etc/php/8.1/fpm/php.ini
#PHP post_max_size to 256M
sudo sed -i "s/post_max_size = 8M/post_max_size = 256M/" /etc/php/8.1/fpm/php.ini
#PHP memory_limit to 2048M
sudo sed -i "s/memory_limit = 128M/memory_limit = 2048M/" /etc/php/8.1/fpm/php.ini
#PHP timezone set
sudo sed -i "s:;date.timezone = :date.timezone = ${NEWTIMEZONE}:g" /etc/php/8.1/fpm/php.ini
#php reload
sudo service php8.1-fpm reload




#Customizing for DOMjudge H/W!!
#check the H/W memory size GiB
echo "Memory size(GiB)"
MEMS=$(free --gibi | grep "Mem:" | awk  '{print $2}')
echo "${MEMS} GiB"

if [ ${MEMS} -lt 1 ] ; then
  MEMS=1
fi

MEMS=$(($MEMS*40))
#40 per GiB of memory ... 4GiB -> 160
sudo sed -i "s:pm.max_children = 40:pm.max_children = ${MEMS}:g" /etc/php/8.1/fpm/pool.d/domjudge.conf
#number of requests before respawning
sudo sed -i "s:pm.max_requests = 5000:pm.max_requests = 4096:g" /etc/php/8.1/fpm/pool.d/domjudge.conf
#memory_limit
sudo sed -i "s:php_admin_value\[memory_limit\] = 512M:php_admin_value\[memory_limit\] = 2048M:g" /etc/php/8.1/fpm/pool.d/domjudge.conf
#upload_max_filesize
sudo sed -i "s:php_admin_value\[upload_max_filesize\] = 256M:php_admin_value\[upload_max_filesize\] = 512M:g" /etc/php/8.1/fpm/pool.d/domjudge.conf
#post_max_size
sudo sed -i "s:php_admin_value\[post_max_size\] = 256M:php_admin_value\[post_max_size\] = 512M:g" /etc/php/8.1/fpm/pool.d/domjudge.conf
#max_file_uploads
sudo sed -i "s:php_admin_value\[max_file_uploads\] = 101:php_admin_value\[max_file_uploads\] = 512:g" /etc/php/8.1/fpm/pool.d/domjudge.conf
#timezone set
sudo sed -i "s:;php_admin_value\[date.timezone\] = America/Denver:php_admin_value\[date.timezone\] = ${NEWTIMEZONE}:g" /etc/php/8.1/fpm/pool.d/domjudge.conf


sudo sed -i "s:pm.max_children = 5:pm.max_children = 128:g" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s:pm.min_spare_servers = 1:pm.min_spare_servers = 1:g" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s:pm.max_spare_servers = 3:pm.max_spare_servers = 128:g" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s:pm.start_servers = 2:pm.start_servers = 64:g" /etc/php/8.1/fpm/pool.d/www.conf


cd


case ${WEBSERVER} in
  "apache2")
    echo "" | tee -a ~/${README}
    echo "DOMjudge ${DJVER} + apache2 installed!!" | tee -a ~/${README}
    echo "" | tee -a ~/${README}
    sudo rm -f /var/www/html/index.html
    echo "<script>document.location=\"./domjudge/\";</script>" > index.html
    sudo chmod 644 index.html
    sudo chown root:root index.html
    sudo mv index.html /var/www/html/
    ;;
  "nginx")
    echo "" | tee -a ~/${README}
    echo "DOMjugde ${DJVER} + nginx installed!!" | tee -a ~/${README}
    echo "${DOMAINNAME} must be linked to IP address!!" | tee -a ~/${README}
    echo "" | tee -a ~/${README}
    sudo rm -f /usr/share/nginx/html/index.html
    #echo "<script>document.location=\"http://${DOMAINNAME}/domjudge/\";</script>" > index.html
    echo "<script>document.location=\"./domjudge/\";</script>" > index.html
    sudo chmod 644 index.html
    sudo chown root:root index.html
    sudo mv index.html /usr/share/nginx/html/
    ;;
esac


PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

echo "" | tee -a ~/${README}
echo "DOMserver installed!!" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "Check this server's web page" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "http://localhost/domjudge/" | tee -a ~/${README}
echo "admin ID : admin" | tee -a ~/${README}
echo "admin PW : ${PASSWORD}" | tee -a ~/${README}
echo ""| tee -a ~/${README}

echo "Use this ID & PW at dedicated remote judgehosts server" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "Edit judgehosts server's /opt/domjudge/judgehost/etc/restapi.secret" | tee -a ~/${README}
JUDGEHOSTID=$(cat /opt/domjudge/domserver/etc/restapi.secret | grep "default" | awk  '{print $3}')
echo "judgehost ID : ${JUDGEHOSTID}" | tee -a ~/${README}
JUDGEHOSTPW=$(cat /opt/domjudge/domserver/etc/restapi.secret | grep "default" | awk  '{print $4}')
echo "judgehost PW : ${JUDGEHOSTPW}" | tee -a ~/${README}
echo ""


cd




#make docs
sudo apt install -y python3-sphinx python3-sphinx-rtd-theme rst2pdf fontconfig python3-yaml texlive-latex-extra latexmk
sudo mkdir /opt/domjudge/doc
sudo mkdir /opt/domjudge/doc/manual
sudo mkdir /opt/domjudge/doc/manual/html
sudo mkdir /opt/domjudge/doc/examples
sudo mkdir /opt/domjudge/doc/logos
cd ~/${DOMVER}/doc/
make docs
sudo make install-docs


sudo apt autoremove -y


cd




#scripts set download
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830clear.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830mas.sh




#DOMjudge memory autoscaling for php(fpm)
if [ -e /etc/rc.local ] ; then
  sudo rm /etc/rc.local
fi

sudo touch /etc/rc.local
sudo chmod 777 /etc/rc.local
if grep "/home/ubuntu/dj830mas.sh" /etc/rc.local ; then
  echo "DOMjudge memory autoscaling for php(fpm) registered!"
else
  sudo sed -i "s/exit 0//g" /etc/rc.local
  sudo echo "#! /bin/sh" >> /etc/rc.local
  sudo echo "bash /home/ubuntu/dj830mas.sh" >> /etc/rc.local
  sudo echo "exit 0" >> /etc/rc.local
fi
sudo chmod 755 /etc/rc.local




echo "------ DOMjudge server cache clearing script ------" | tee -a ~/${README}
echo "bash dj830clear.sh" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "------ DOMjudge server web cache clearing script ------" | tee -a ~/${README}
echo "sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*" | tee -a ~/${README}
echo "" | tee -a ~/${README}
chmod 660 ~/${README}
echo "Saved as ${README}"


echo ""
echo "System will be rebooted in 10 seconds!"
echo ""
COUNT=10
while [ $COUNT -ge 0 ]
do
  echo $COUNT
  ((COUNT--))
  sleep 1
done
echo "rebooted!" | tee -a ~/${README}
sleep 5
sudo reboot

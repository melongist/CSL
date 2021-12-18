#!/bin/bash

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge7.3.4 stable + Ubuntu 20.04 LTS
#Made by melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers

#terminal commands to install DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734dj.sh
#bash dj734dj.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj734dj.sh'"
  exit 1
fi

cd

#change your timezone
#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade

sudo apt -y install software-properties-common dirmngr apt-transport-https
sudo apt -y install acl
sudo apt -y install zip

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el,s390x] https://mirror.yongbok.net/mariadb/repo/10.6/ubuntu focal main'

sudo apt update
sudo apt -y upgrade

sudo apt -y install mariadb-server mariadb-client

#You must input mariaDB's root account password! #1
sudo mysql_secure_installation

sudo apt -y install apache2
sudo apt -y install php
sudo apt -y install php-fpm
sudo apt -y install php-gd
sudo apt -y install php-cli
sudo apt -y install php-intl
sudo apt -y install php-mbstring
sudo apt -y install php-mysql
sudo apt -y install php-curl
sudo apt -y install php-json
sudo apt -y install php-xml
sudo apt -y install php-zip
sudo apt -y install composer
sudo apt -y install ntp
sudo apt -y install build-essential
sudo apt -y install libcgroup-dev
sudo apt -y install libcurl4-openssl-dev
sudo apt -y install libjsoncpp-dev


#scripts set download
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734jh.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734kr.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734start.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734clear.sh


#DOMjudge 7.3.4 stable
#wget https://www.domjudge.org/releases/domjudge-7.3.4.tar.gz
#tar xvf domjudge-7.3.4.tar.gz
#cd domjudge-7.3.4

#DOMjudge 7.3.4 stable
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/domjudge-7.3.4.tar.gz
tar xvf domjudge-7.3.4.tar.gz
rm domjudge-7.3.4.tar.gz
cd domjudge-7.3.4

./configure --with-baseurl=BASEURL
make domserver
sudo make install-domserver

cd /opt/domjudge/domserver/bin
#./dj_setup_database genpass # it's not required..

#Use mariaDB's root password above #1
sudo ./dj_setup_database -u root -r install


sudo ln -s /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
sudo ln -s /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/7.4/fpm/pool.d/domjudge.conf

sudo a2enmod proxy_fcgi setenvif rewrite
sudo systemctl restart apache2

sudo a2enconf php7.4-fpm domjudge
sudo systemctl reload apache2

sudo service php7.4-fpm reload
sudo service apache2 reload


#For DOMjudge configuration check
#MariaDB Max connections to 1000
sudo sed -i "s/\#max_connections        = 100/max_connections        = 1000/" /etc/mysql/mariadb.conf.d/50-server.cnf
#PHP upload_max_filesize to 512M
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 512M/" /etc/php/7.4/apache2/php.ini
#PHP max_file_uploads to 512
sudo sed -i "s/max_file_uploads = 20/max_file_uploads = 512/" /etc/php/7.4/apache2/php.ini
#PHP post_max_size to 512M
sudo sed -i "s/post_max_size = 8M/post_max_size = 512M/" /etc/php/7.4/apache2/php.ini
#PHP memory_limit to 2048M
sudo sed -i "s/memory_limit = 128M/memory_limit = 2048M/" /etc/php/7.4/apache2/php.ini



#option
#making auto direction
cd
sudo rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
sudo chmod 644 index.html
sudo chown root:root index.html
sudo mv index.html /var/www/html/

sudo apt -y autoremove

#clear

PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

echo "" | tee -a domjudge.txt
echo "DOMjudge 7.3.4 stable 21.11.22" | tee -a domjudge.txt
echo "DOMserver installed!!" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Check below to access DOMserver's web interface!" | tee -a domjudge.txt
echo "------" | tee -a domjudge.txt
echo "http://localhost/domjudge/" | tee -a domjudge.txt
echo "admin ID : admin" | tee -a domjudge.txt
echo "admin PW : $PASSWORD" | tee -a domjudge.txt
echo ""
echo "admin PW saved as domjudge.txt"
echo "Next step : judgehosts installing"
echo ""
echo ""

bash dj734jh.sh

echo ""
echo "---- system reboot needed! ----"
echo "After rebooted, read domjudge.txt"
echo "use 'sudo reboot'"
sudo sleep 10
echo "system rebooted!"
sudo reboot

#!/bin/bash

#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge


#domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#terminal commands to install
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj740dj.sh
#bash dj740dj.sh

#------
#DOMserver

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj740dj.sh'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade

sudo apt -y install acl
sudo apt -y install zip

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/10.5/ubuntu focal main'

sudo apt update
sudo apt -y upgrade

sudo apt -y install mariadb-server mariadb-client

echo ""
echo "------"
echo "Change!! Mariadb's root password to your own!!!"
echo "..."
echo "Change the root password? [Y/n] y     <------ !!"
echo "..."
echo "------"
echo ""

#You must input mariadb's root account password! #1
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

#wget https://www.domjudge.org/releases/domjudge-7.3.0.tar.gz
#tar xvf domjudge-7.3.0.tar.gz
#tar xvf domjudge.tar.gz
#cd domjudge-7.3.0

#for 7.4.0.dev
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/domjudge-snapshot-20201019.tar.gz
tar xvf domjudge-snapshot-20201019.tar.gz
sudo mv domjudge-snapshot-20201019 domjudge-7.4.0.dev
cd domjudge-7.4.0.dev

./configure --with-baseurl=BASEURL
make domserver
sudo make install-domserver

cd /opt/domjudge/domserver/bin
#./dj_setup_database genpass # it's not required..


echo ""
echo "------"
echo "Input!! Mariadb's root password with your own!!!"
echo "------"
echo ""

#Use mariadbs's root password above #1
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
#PHP upload_max_filesize to 128M
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php/7.4/apache2/php.ini
#PHP max_file_uploads to 128
sudo sed -i "s/max_file_uploads = 20/max_file_uploads = 128/" /etc/php/7.4/apache2/php.ini
#PHP post_max_size to 128M
sudo sed -i "s/post_max_size = 8M/post_max_size = 128M/" /etc/php/7.4/apache2/php.ini
#PHP memory_limit to 2048M
sudo sed -i "s/memory_limit = 128M/memory_limit = 2048M/" /etc/php/7.4/apache2/php.ini




#making auto direction
cd
#sudo rm -f /var/www/html/index.html
#echo "<script>document.location=\"./domjudge/\";</script>" > index.html
#sudo chmod 644 index.html
#sudo chown root:root index.html
#sudo mv index.html /var/www/html/

sudo apt -y autoremove

clear

PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

echo "" | tee -a domjudge.txt
echo "domjudge 7.4.0.DEV DOMserver installed!!" | tee -a domjudge.txt
echo "Ver 2020.10.09" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Check below to access DOMserver's web interface!" | tee -a domjudge.txt
echo "------" | tee -a domjudge.txt
echo "http://localhost/domjudge/" | tee -a domjudge.txt
echo "admin ID : admin" | tee -a domjudge.txt
echo "admin PW : $PASSWORD" | tee -a domjudge.txt
echo ""
echo "admin PW saved as domjudge.txt"
echo "Next step : installing judgehosts"
echo ""
echo ""


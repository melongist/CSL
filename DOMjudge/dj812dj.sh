#!/bin/bash

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge8.1.2 stable + Ubuntu 22.04 LTS
#2022.08.04 Made by melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers

#terminal commands to install DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj812dj.sh
#bash dj812dj.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj812dj.sh'"
  exit 1
fi

OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')

if [ ${OSVER:0:5} != "22.04" ] ; then
  echo ""
  echo "This is not Ubuntu 22.04 LTS!!"
  echo ""
  echo "Ubuntu 22.04 LTS needed!!'"
  echo ""
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
sudo apt -y install zip unzip
sudo apt -y install mariadb-server mariadb-client

#You must input mariaDB's root account password! #1
sudo mysql_secure_installation


#apache2
sudo apt install -y apache2
sudo apt install -y php8.1

#nginx
#sudo apt install -y nginx
#sudo systemctl enable nginx

#sudo apt install php
#sudo apt install php-fpm
sudo apt install -y php8.1-fpm
#sudo apt install php-gd
sudo apt install -y php8.1-gd
#sudo apt install php-cli
#sudo apt install php-intl
sudo apt install -y php8.1-intl
#sudo apt install php-mbstring
sudo apt install -y php8.1-mbstring
#sudo apt install php-mysql
sudo apt install -y php8.1-mysql
#sudo apt install php-curl
sudo apt install -y php8.1-curl
#sudo apt install php-json
#sudo apt install -y php8.1-json
#sudo apt install php-xml
sudo apt install -y php8.1-xml
#sudo apt install php-zip
sudo apt install -y php8.1-zip


sudo apt -y install composer
sudo apt -y install ntp
sudo apt -y install build-essential
sudo apt -y install libcgroup-dev
sudo apt -y install libcurl4-openssl-dev
sudo apt -y install libcurl4-gnutls-dev
sudo apt -y install libjsoncpp-dev

#nginx
#sudo apt -y install apache2-utils


#DOMjudge 8.1.2 stable
#wget https://www.domjudge.org/releases/domjudge-8.1.2.tar.gz
#tar xvf domjudge-8.1.2.tar.gz
#cd domjudge-8.1.2
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/domjudge-8.1.2.tar.gz
tar xvf domjudge-8.1.2.tar.gz
rm domjudge-8.1.2.tar.gz
cd domjudge-8.1.2

./configure --with-baseurl=BASEURL
make domserver
sudo make install-domserver

cd /opt/domjudge/domserver/bin
#./dj_setup_database genpass # it's not required..

#Use mariaDB's root password above #1
sudo ./dj_setup_database -u root -r install




#apache2
sudo ln -s -f /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
sudo ln -s -f /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/8.1/fpm/pool.d/domjudge.conf
sudo a2enmod proxy_fcgi setenvif rewrite
sudo systemctl restart apache2
sudo a2enconf php8.1-fpm domjudge
sudo systemctl reload apache2
sudo service php8.1-fpm reload
sudo service apache2 reload


#nginx
#nginx
#sudo ln -s /opt/domjudge/domserver/etc/nginx-conf /etc/nginx/sites-enabled/domjudge
#sudo ln -s /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/7.4/fpm/pool.d/domjudge.conf
#sudo service php7.4-fpm reload
#sudo service nginx reload
#sudo sed -i "s:index index.html:index index.html index.php:g" /etc/nginx/sites-enabled/default
#sudo sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
#sudo sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
#sudo sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
#sudo sed -i "s|9000;|9000;\n\t}|g" /etc/nginx/sites-enabled/default
#sudo service php7.4-fpm reload
#sudo service nginx reload


#For DOMjudge configuration check
#apache2
#MariaDB Max connections to 20000
sudo sed -i "s/\#max_connections        = 100/max_connections        = 20000/" /etc/mysql/mariadb.conf.d/50-server.cnf
#PHP upload_max_filesize to 512M
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 512M/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 512M/" /etc/php/8.1/fpm/php.ini
#PHP max_file_uploads to 512
sudo sed -i "s/max_file_uploads = 20/max_file_uploads = 200/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/max_file_uploads = 20/max_file_uploads = 200/" /etc/php/8.1/fpm/php.ini
#PHP post_max_size to 512M
sudo sed -i "s/post_max_size = 8M/post_max_size = 512M/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/post_max_size = 8M/post_max_size = 512M/" /etc/php/8.1/fpm/php.ini
#PHP memory_limit to 2048M
sudo sed -i "s/memory_limit = 128M/memory_limit = 2048M/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/memory_limit = 128M/memory_limit = 2048M/" /etc/php/8.1/fpm/php.ini


#option
#making auto direction
cd
sudo rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
sudo chmod 644 index.html
sudo chown root:root index.html
sudo mv index.html /var/www/html/

sudo apt -y autoremove


PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

echo "" | tee -a ~/domjudge.txt
echo "DOMjudge 8.1.2 stable 22.07.23" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "DOMserver installed!!" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "Check below to access DOMserver's web interface!" | tee -a ~/domjudge.txt
echo "------" | tee -a ~/domjudge.txt
echo "http://localhost/domjudge/" | tee -a ~/domjudge.txt
echo "admin ID : admin" | tee -a ~/domjudge.txt
echo "admin PW : $PASSWORD" | tee -a ~/domjudge.txt
echo ""

#scripts set download
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj812jh.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj812kr.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj812start.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj812clear.sh

bash dj812jh.sh

echo "" | tee -a ~/domjudge.txt
echo "judgehosts installed!!" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "------ Run judgehosts script after every reboot ------" | tee -a ~/domjudge.txt
echo "bash dj810start.sh" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "------ Run DOMjudge cache clearing script when needed ------" | tee -a ~/domjudge.txt
echo "bash dj810clear.sh" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "------ etc ------" | tee -a ~/domjudge.txt
echo "How to kill some judgedaemon processe?" | tee -a ~/domjudge.txt
echo "ps -ef, and find PID# of judgedaemon, run : sudo kill -9 PID#" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "How to clear domserver web cache?" | tee -a domjudge.txt
echo "sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "How to clear DOMjudge cache??" | tee -a ~/domjudge.txt
echo "sudo /opt/domjudge/domserver/webapp/bin/console cache:clear" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
chmod 660 ~/domjudge.txt
echo "Saved as domjudge.txt"

echo ''
echo 'System will be rebooted in 20 seconds!'
echo ''
COUNT=20
while [ $COUNT -ge 0 ]
do
  echo $COUNT
  ((COUNT--))
  sleep 1
done
echo 'rebooted!' | tee -a ~/domjudge.txt
sleep 5
sudo reboot

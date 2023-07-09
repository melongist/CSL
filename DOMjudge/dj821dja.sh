#!/bin/bash

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#2023.07 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.2.1 stable + Ubuntu 22.04.2 LTS + apache2 2.4.57

#terminal commands to install DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj813dja.sh
#bash dj821dja.sh




if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj821dja.sh'"
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


#change to your timezone
#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade

sudo apt -y install software-properties-common dirmngr apt-transport-https
sudo apt -y install acl
sudo apt -y install zip unzip
sudo apt -y install mariadb-server mariadb-client
sudo apt -y install curl

#You must input mariaDB's root account password! #1
sudo mysql_secure_installation




#For DOMjudge configuration check
#MariaDB Max connections to 16384
sudo sed -i "s/\#max_connections        = 100/max_connections        = 16384/" /etc/mysql/mariadb.conf.d/50-server.cnf




#apache2
#sudo add-apt-repository ppa:ondrej/apache2  #added
sudo apt install -y apache2

#nginx
#sudo add-apt-repository ppa:ondrej/nginx    #added
#sudo apt install -y nginx
#sudo systemctl enable nginx
#sudo service nginx start




#php 8.2 for apache2
sudo add-apt-repository ppa:ondrej/php      #added
sudo apt install -y php8.2

#php 8.2 for nginx




sudo apt install -y php8.2-fpm
sudo apt install -y php8.2-gd
sudo apt install -y php8.2-cli
sudo apt install -y php8.2-intl
sudo apt install -y php8.2-mbstring
sudo apt install -y php8.2-mysql
sudo apt install -y php8.2-curl
sudo apt install -y php8.2-xml
sudo apt install -y php8.2-zip




#php for apache2
sudo systemctl restart apache2

#php for nginx
#sudo systemctl restart nginx




# + others
sudo apt install -y composer
sudo apt install -y ntp
sudo apt install -y build-essential
sudo apt install -y libcgroup-dev
sudo apt install -y libcurl4-openssl-dev
sudo apt install -y libcurl4-gnutls-dev
sudo apt install -y libjsoncpp-dev




#DOMjudge 8.2.1 stable
#wget https://www.domjudge.org/releases/domjudge-8.2.1.tar.gz
#tar xvf domjudge-8.2.1.tar.gz
#cd domjudge-8.2.1
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/domjudge-8.2.1.tar.gz
tar xvf domjudge-8.2.1.tar.gz
rm domjudge-8.2.1.tar.gz
cd domjudge-8.2.1

./configure --with-baseurl=BASEURL
make domserver
sudo make install-domserver

cd /opt/domjudge/domserver/bin
#./dj_setup_database genpass # it's not required..

#Use mariaDB's root password above #1
sudo ./dj_setup_database -u root -r install




#apache2 for DOMjudge
sudo ln -s -f /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
sudo a2enmod proxy_fcgi setenvif rewrite
sudo systemctl restart apache2
sudo a2enconf php8.2-fpm domjudge
sudo systemctl reload apache2
sudo service php8.2-fpm reload
sudo service apache2 reload

#nginx for DOMjudge
#sudo apt -y install apache2-utils
#sudo ln -s -f /opt/domjudge/domserver/etc/nginx-conf /etc/nginx/sites-enabled/domjudge
#sudo sed -i "s:_default_:${DOMAINNAME}:g" /opt/domjudge/domserver/etc/nginx-conf-inner
#sudo sed -i "s:# server_names_hash_bucket_size 64;:server_names_hash_bucket_size 64;:g" /etc/nginx/nginx.conf
#sudo nginx -t
#sudo systemctl restart nginx
#sudo service nginx reload




#For DOMjudge configuration check
#PHP upload_max_filesize to 256M
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 256M/" /etc/php/8.2/fpm/php.ini
#PHP max_file_uploads to 512
sudo sed -i "s/max_file_uploads = 20/max_file_uploads = 512/" /etc/php/8.2/fpm/php.ini
#PHP post_max_size to 256M
sudo sed -i "s/post_max_size = 8M/post_max_size = 256M/" /etc/php/8.2/fpm/php.ini
#PHP memory_limit to 2048M
sudo sed -i "s/memory_limit = 128M/memory_limit = 2048M/" /etc/php/8.2/fpm/php.ini
#php reload
sudo service php8.2-fpm reload




#Customizing needed for actual DOMjudge H/W!!
#For DOMjudge configuration check
#php8.2 for DOMjudge
sudo ln -s -f /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/8.2/fpm/pool.d/domjudge.conf
#check the H/W memory size GiB
#sudo dmidecode -t memory | grep "Maximum Capacity"
#MEMS=$(sudo dmidecode -t memory | grep "Maximum Capacity" | awk  '{print $3}')
echo "Memory size(GiB)"
MEMS=$(free --gibi | grep "Mem:" | awk  '{print $2}')
echo "${MEMS} GiB"

if $MEMS<1 ; then
  MEMS=1
fi

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj821dja.sh'"
  exit 1
fi

MEMS=$(($MEMS*40))
#40 per GiB of memory ... 4GiB -> 160
sudo sed -i "s:pm.max_children = 40:pm.max_children = ${MEMS}:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
#number of requests before respawning
#sudo sed -i "s:pm.max_requests = 5000:pm.max_requests = 4096:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
#memory_limit
sudo sed -i "s:php_admin_value\[memory_limit\] = 512M:php_admin_value\[memory_limit\] = 2048M:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
#upload_max_filesize
#sudo sed -i "s:php_admin_value\[upload_max_filesize\] = 256M:php_admin_value\[upload_max_filesize\] = 512M:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
#post_max_size
#sudo sed -i "s:php_admin_value\[post_max_size\] = 256M:php_admin_value\[post_max_size\] = 512M:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
#max_file_uploads
sudo sed -i "s:php_admin_value\[max_file_uploads\] = 101:php_admin_value\[max_file_uploads\] = 512:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
sudo sed -i "s:pm.max_children = 5:pm.max_children = 128:g" /etc/php/8.2/fpm/pool.d/www.conf
sudo sed -i "s:pm.min_spare_servers = 1:pm.min_spare_servers = 1:g" /etc/php/8.2/fpm/pool.d/www.conf
sudo sed -i "s:pm.max_spare_servers = 3:pm.max_spare_servers = 128:g" /etc/php/8.2/fpm/pool.d/www.conf
sudo sed -i "s:pm.start_servers = 2:pm.start_servers = 64:g" /etc/php/8.2/fpm/pool.d/www.conf



cd




#option for apache2. not work for nginx!!
echo "" | tee -a ~/domjudge.txt
echo "DOMjugde(+apache2) installed!!" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
#option for apache2. making auto direction to /domjudge. now work for nginx!!
sudo rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
sudo chmod 644 index.html
sudo chown root:root index.html
sudo mv index.html /var/www/html/

#option for nginx
#echo "" | tee -a ~/domjudge.txt
#echo "DOMjugde(+nginx) installed!!" | tee -a ~/domjudge.txt
#echo "${DOMAINNAME} must be binded with IP address!!" | tee -a ~/domjudge.txt
#echo "" | tee -a ~/domjudge.txt
#sudo rm -f /usr/share/nginx/html/index.html
#echo "<script>document.location=\"http://${DOMAINNAME}/domjudge/\";</script>" > index.html
#sudo chmod 644 index.html
#sudo chown root:root index.html
#sudo mv index.html /usr/share/nginx/html/




PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

echo "" | tee -a ~/domjudge.txt
echo "DOMjudge 8.2.1 stable 23.06.02" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "DOMserver installed!!" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "Check below to access DOMserver's web interface!" | tee -a ~/domjudge.txt
echo "------" | tee -a ~/domjudge.txt
echo "http://localhost/domjudge/" | tee -a ~/domjudge.txt
echo "admin ID : admin" | tee -a ~/domjudge.txt
echo "admin PW : $PASSWORD" | tee -a ~/domjudge.txt
echo ""

#sudo apt autoremove -y

#scripts set download
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj821jh.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj821kr.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj821start.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj821clear.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj821mas.sh

bash dj821jh.sh

echo "" | tee -a ~/domjudge.txt
echo "judgehosts installed!!" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "------ Run judgehosts script after every reboot ------" | tee -a ~/domjudge.txt
echo "bash dj821start.sh" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "------ Run DOMjudge cache clearing script when needed ------" | tee -a ~/domjudge.txt
echo "bash dj821clear.sh" | tee -a ~/domjudge.txt
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

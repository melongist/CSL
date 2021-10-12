#!/bin/bash
#moodle installation script
#Made by melongist(what_is_computer@msn.com)
#for Korean

VER_DATE="21.05.08"

THISFILE="moodle210508.sh"

MAINTENANCEFILE="moodlemaintenance.sh"
BACKUPFILE="moodlebackup.sh"

clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash ${THISFILE}'"
  exit 1
fi

INPUTS="x"
echo -n "Do you want to install moodle 3.10 STABLE? [y/n] : "
read INPUTS
if [[ ${INPUTS} != "y" ]] ; then
  exit 1
fi

echo ""
echo "- Enter moodle DB user/password preset before moodle installation start - "

DBUSER="o"
INPUTS="x"
while [ ${DBUSER} != ${INPUTS} ]; do
  echo -n "Enter  DBUSER name : "
  read DBUSER
  echo -n "Repeat DBUSER name : "
  read INPUTS
done

DBPASS="o"
INPUTS="x"
while [ ${DBPASS} != ${INPUTS} ]; do
  echo -n "Enter  DBUSER password : "
  read DBPASS
  echo -n "Repeat DBUSER password : "
  read INPUTS
done

echo ""
echo "---- Moodle3.10 installation started ----"
echo ""

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade

#https://docs.moodle.org/310/en/Step-by-step_Installation_Guide_for_Ubuntu + but! with Nginx
#nginx
sudo apt install -y nginx

#now working but trying~ hmm... it would be use javascript????
#sudo sed -i "s|root /var/www/html;|root /var/www/html/moodle;|g" /etc/nginx/sites-enabled/default

if grep "client_max_body_size" /etc/nginx/nginx.conf ; then 
  sudo echo "client_max_body_size already added" ;
else
  sudo sed -i "s:include /etc/nginx/mime.types;:client_max_body_size    256m;\n\tinclude /etc/nginx/mime.types;:g" /etc/nginx/nginx.conf
fi

sudo sed -i "s#server_name _;#server_name _;\n\n\tlocation ~ [^/]\\.php(/|$) {\n\t\tfastcgi_split_path_info  ^(.+\\.php)(/.+)$;\n\t\tfastcgi_index            index.php;\n\t\tfastcgi_pass             unix:/var/run/php/php7.4-fpm.sock;\n\t\tinclude                  fastcgi_params;\n\t\tfastcgi_param   PATH_INFO       \$fastcgi_path_info;\n\t\tfastcgi_param   SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\n\t}#g" /etc/nginx/sites-enabled/default

sudo sed -i "s:index index.html:index index.php index.html:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
sudo sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
sudo sed -i "s|# deny access to .htaccess files|}\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default

sudo systemctl restart nginx



#mysql
sudo apt install -y mysql-client mysql-server
wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/changeplugin.sql
echo "- Enter ${USER} password below -"
sudo mysql -u root -p mysql < changeplugin.sql
#enter sudo password
rm changeplugin.sql


sudo systemctl restart mysql

sudo mysql_secure_installation

sudo sed -i "s|\[mysqld\]|\[client\]\ndefault-character-set = utf8mb4\n\n\[mysqld\]|g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s|# pid-file|innodb_file_per_table = 1\ncharacter-set-server = utf8mb4\ncollation-server = utf8mb4_unicode_ci\nskip-character-set-client-handshake\n# pid-file|g" /etc/mysql/mysql.conf.d/mysqld.cnf
#sudo sed -i "s|# If MySQL is running as|\[mysql\]\ndefault-character-set = utf8mb4\n\n# If MySQL is running as|g" /etc/mysql/mysql.conf.d/mysqld.cnf


#moodledb.sql edit
#for moodle db user
wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodledb.sql
sed -i "s#moodledbuser#${DBUSER}#g" /home/${USER}/moodledb.sql
sed -i "s#moodledbpw#${DBPASS}#g" /home/${USER}/moodledb.sql

echo ""
echo "- Enter mysql root password below -"
mysql -u root -p < /home/${USER}/moodledb.sql
#sudo rm moodledb.sql

sudo systemctl restart mysql


#php
sudo apt install -y php php-fpm php-cli php-curl php-mysql php-gd php-imagick php-tidy php-xmlrpc
sudo apt install -y graphviz aspell ghostscript clamav php7.4-pspell php7.4-gd php7.4-intl php7.4-curl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring

sudo sed -i "s:memory_limit = 128M:memory_limit = 256M:g" /etc/php/7.4/fpm/php.ini
sudo sed -i "s:upload_max_filesize = 2M:upload_max_filesize = 256M:g" /etc/php/7.4/fpm/php.ini
sudo sed -i "s:;opcache.enable=1:opcache.enable=1:g" /etc/php/7.4/fpm/php.ini


#restart services
sudo systemctl restart nginx
sudo systemctl restart mysql
sudo systemctl restart php7.4-fpm
sudo systemctl restart php7.4-fpm.service


#original git
#------
sudo apt install -y git

cd /opt
sudo git clone git://git.moodle.org/moodle.git
cd moodle
sudo git branch --track MOODLE_310_STABLE origin/MOODLE_310_STABLE
sudo git checkout MOODLE_310_STABLE
#------

cd
sudo cp -R /opt/moodle /var/www/html/
sudo rm -rf /opt/moodle
sudo mkdir /var/moodledata
sudo chown -R www-data /var/moodledata
sudo chmod -R 777 /var/moodledata
sudo chmod -R 777 /var/www/html/moodle
#sudo chmod -R 755 /var/www/html/moodle


#curl installation
sudo apt -y install curl

#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER(Recommended for testing purposes only. Use public IP/Domain for real use)"
  IPADDRESS=($(hostname -I))
fi


#for moodlemaintenance
wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/${MAINTENANCEFILE} -O /home/${USER}/${MAINTENANCEFILE}
chown ${USER}:${USER} /home/${USER}/${MAINTENANCEFILE}
sed -i "s/\${SUDO_USER}/${USER}/g" /home/${USER}/${MAINTENANCEFILE}

if [ -e "/var/spool/cron/crontabs/root" ]
then
  if [ sudo grep "moodlemaintenance" /var/spool/cron/crontabs/root ]
  then
    sudo sed -i "/moodlemaintenance/d" /var/spool/cron/crontabs/root
  fi
fi

sudo crontab -l > temp
sudo echo "30 4 * * * sudo bash /home/${USER}/${MAINTENANCEFILE}" >> temp
sudo crontab temp
sudo rm -f temp

#for backup
wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/${BACKUPFILE} -O /home/${USER}/${BACKUPFILE}
chown ${USER}:${USER} /home/${USER}/${BACKUPFILE}
sed -i "s#moodledbuser#${DBUSER}#g" /home/${USER}/${BACKUPFILE}
sed -i "s#moodledbpw#${DBPASS}#g" /home/${USER}/${BACKUPFILE}
sed -i "s/\${SUDO_USER}/${USER}/g" /home/${USER}/${BACKUPFILE}

sudo bash /home/${USER}/${BACKUPFILE} -${VER_DATE}


#clear

echo ""
echo "--- MOODLE_310_STABLE installed ---"
echo ""
echo "Next : web installaion needed..."
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo "moodle html home directory : /var/www/html/moodle"
echo "moodle data directory :      /var/moodledata"
echo "DBUSER : ${DBUSER}"
echo "DBPASS : ${DBPASS}"
echo ""
echo "If you want to use domain name your own?"
echo "- First of all! Connect you domain name to ${IPADDRESS[0]}."
echo "- And then install with web installation at http://domainname/moodle/"
echo ""
echo "If you don't have any domain name?"
echo "- Just install with web installation at http://${IPADDRESS[0]}/moodle/"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""
echo ""
echo "After installation completed : "
echo "You must change mod with :"
echo "sudo chmod -R 755 /var/www/html/moodle"
echo ""
echo ""
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""
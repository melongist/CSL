#!/bin/bash

#2024.7 Made by melongist(melongist@gmail.com) for CS teachers

#DOMjudge8.3.0 stable(2024.05.31) + Ubuntu 22.04.4 LTS + apache2/nginx

#DOMjudge server Secure HTTPS install script
#terminal commands to install dedicated DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830serverhttps.sh
#bash dj830serverhttps.sh

DJVER="8.3.0 stable (2024.05.31)"
DOMVER="domjudge-8.3.0"
THIS="dj830serverhttps.sh"
README="readme.txt"


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

INPUTS="x"
while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo ""
  echo "Before HTTPS installation!!!"
  echo "DOMjudge server's IP address must be connected to a domain name with A record at DNS!!"
  echo ""
  echo -n "Did you connect IP address to a domain name with A record at DNS? [y/n]: "
  read INPUTS
  if [ ${INPUTS} == "n" ] ; then
    echo ""
    echo "Connect IP address with domain name at DNS first!!"
    echo ""
    exit 1
  fi
done


INPUTS="x"
while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo    ""
  echo    "HTTPS server must use domain name!"
  echo -n "Do you have the domain name? [y/n]: "
  read INPUTS
done

echo ""
if [ ${INPUTS} == "y" ] ; then
  DOMAINNAME="o"
  INPUTS="x"
  while [ ${DOMAINNAME} != ${INPUTS} ]; do
    echo "Examples:"
    echo "contest.domjudge.org"
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


#Check web server : Apache or nginx
WEBSERVER=$(curl -is localhost | grep "Server" | awk '{print $2}')
if [[ ${WEBSERVER} == Apache* ]] ; then
  WEBSERVER="apache2"
elif [[ ${WEBSERVER} == nginx* ]] ; then
  WEBSERVER="nginx"
else
  echo "apache or nginx webserver not exist!!!"
  exit 1
fi

echo "${WEBSERVER} webserver is installed..."


case ${WEBSERVER} in
  "apache2")
    sudo ufw allow 'Apache'
    sudo ufw allow 'Apache Full'
    sudo ufw allow 'Apache Secure'
    sudo ufw allow 'OpenSSH'
    sudo ufw enable
    
    sudo ufw status
    
    sudo mkdir /var/www/${DOMAINNAME}
    sudo chown -R $USER:$USER /var/www/${DOMAINNAME}
    sudo chmod -R 755 /var/www/${DOMAINNAME}

    sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/${DOMAINNAME}.conf
    sudo sed -i "s:/var/www/html:/var/www/${DOMAINNAME}:" /etc/apache2/sites-available/${DOMAINNAME}.conf

    sudo a2ensite ${DOMAINNAME}.conf
    sudo a2dissite 000-default.conf
    sudo apache2ctl configtest
    sudo systemctl restart apache2
    sudo systemctl reload apache2

    sudo apt install -y certbot python3-certbot-apache
    sudo certbot --apache -d ${DOMAINNAME}

    sudo systemctl status certbot.timer
    sudo certbot renew --dry-run

    sudo cp /var/www/html/index.html /var/www/${DOMAINNAME}/index.html
    ;;
  "nginx")
    ;;
esac

echo ""
case ${WEBSERVER} in
  "apache2")
    echo "DOMjudge server ${DJVER} + apache2 + HTTPS installation completed!!" | tee -a ~/${README}
    ;;
  "nginx")
    echo "DOMjugde server ${DJVER} + HTTPS nginx installation completed!!" | tee -a ~/${README}
    ;;
esac

echo ""| tee -a ~/${README}
echo "Check this(DOMjudge) server's web page" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "https://${DOMAINNAME}" | tee -a ~/${README}
echo ""| tee -a ~/${README}

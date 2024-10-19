#!/bin/bash

#spotboard for DOMjudge8.3.1 installation script
#2024.10 Made by melongist(melongist@gmail.com) for CS teachers

#terminal commands to install DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831sbhttps24.sh
#bash dj831sbhttps24.sh

#------
#

if [[ $SUDO_USER ]] ; then
  echo ""
  echo "Just use 'bash ${THIS}'"
  exit 1
fi

OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')
if [ ${OSVER:0:5} != "24.04" ] ; then
  echo ""
  echo "This installation script only works on Ubuntu 24.04 LTS!!"
  echo ""
  exit 1
fi

  echo ""
  echo "Before HTTPS installation!!!"
  echo ""  
  echo "DOMjudge server's IP address must be connected to a domain name with A record at DNS!!"
  echo ""
INPUTS="x"
while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo -n "Did you connect IP address to a domain name with A record at DNS? [y/n]: "
  read INPUTS
  if [ ${INPUTS} == "n" ] ; then
    echo ""
    echo "Connect IP address with a domain name with A record at DNS first!!"
    echo ""
    exit 1
  fi
done

DOMAINNAME="o"
INPUTS="x"
while [ ${DOMAINNAME} != ${INPUTS} ]; do
  echo ""
  echo "Input the domain name."
  echo "Examples:"
  echo "scoreboard.domjudge.org"
  echo ""
  echo -n "Input  domain name : "
  read DOMAINNAME
  echo -n "Repeat domain name : "
  read INPUTS
done
echo ""

sudo ufw allow 'Nginx Full'
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow 'OpenSSH'
sudo ufw enable
    
sudo ufw status

sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d ${DOMAINNAME}

sudo systemctl status certbot.timer
sudo certbot renew --dry-run

echo "Spotboard for DOMjugde HTTPS installation completed!!" | tee -a ~/readme.txt

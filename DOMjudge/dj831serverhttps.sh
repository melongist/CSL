#!/bin/bash

#2024.10 Made by melongist(melongist@gmail.com) for CS teachers

#DOMjudge8.3.1 stable(2024.09.13) + Ubuntu 22.04.4 LTS + apache2/nginx




#DOMjudge server Secure HTTPS install script




#terminal commands to install dedicated DOMjudge server
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831serverhttps.sh
#bash dj831serverhttps.sh


#------
DJVER="8.3.1 stable (2024.09.13)"
DOMVER="domjudge-8.3.1"
THIS="dj831serverhttps.sh"
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
  echo "contest.domjudge.org"
  echo ""
  echo -n "Input  domain name : "
  read DOMAINNAME
  echo -n "Repeat domain name : "
  read INPUTS
done
echo ""


#Web server(Apache/nginx) identifing
WEBSERVER=$(curl -is localhost | grep "Server" | awk '{print $2}')
if [[ ${WEBSERVER} == Apache* ]] ; then
  WEBSERVER="apache2"
elif [[ ${WEBSERVER} == nginx* ]] ; then
  WEBSERVER="nginx"
else
  echo "apache or nginx webserver not exist!!!"
  exit 1
fi


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

    sudo cp /var/www/html/index.html /var/www/${DOMAINNAME}/index.html
    ;;
  "nginx")
    sudo ufw allow 'Nginx Full'
    sudo ufw allow 'Nginx HTTP'
    sudo ufw allow 'Nginx HTTPS'
    sudo ufw allow 'OpenSSH'
    sudo ufw enable
    
    sudo ufw status

    sudo apt install -y certbot python3-certbot-nginx
    sudo certbot --nginx -d ${DOMAINNAME}
    ;;
esac
sudo systemctl status certbot.timer
sudo certbot renew --dry-run


echo ""
echo "" | tee -a ~/${README}
case ${WEBSERVER} in
  "apache2")
    echo "DOMjudge server ${DJVER} + apache2 + HTTPS installation completed!!" | tee -a ~/${README}
    ;;
  "nginx")
    echo "DOMjugde server ${DJVER} + HTTPS nginx installation completed!!" | tee -a ~/${README}
    ;;
esac

echo "" | tee -a ~/${README}
echo "Check this(DOMjudge) server's web page" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "https://${DOMAINNAME}" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "" | tee -a ~/${README}

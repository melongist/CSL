#!/bin/bash

#2025.06 Made by melongist(melongist@gmail.com) for CS teachers




#php(fpm) autoscaling script for DOMjudge server




#Memory autoscaling for php(fpm)
#Terminal commands to autoscaling DOMjudge server
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj900devmas.sh
#bash dj900devmas.sh


#------

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj900devmas.sh'"
  exit 1
fi


if [ ! -d /opt/domjudge/domserver ] ; then
  echo ""
  echo "DOMjudge server is not installed at this computer!!"
  echo ""
  exit 1
fi


echo "php(fpm) autoscaling for DOMjudge server started..."
echo ""
echo "H/W memory information"
#check the H/W memory size GiB
echo "Memory size(GiB)"
MEMS=$(free --gibi | grep "Mem:" | awk  '{print $2}')
echo "${MEMS} GiB"
echo ""

if [ ${MEMS} -lt 1 ] ; then
  MEMS=1
fi

#set to H/W memory size
MEMSNOW=$(($MEMS*40))
MEMSSET=$(grep "pm.max_children =" /etc/php/8.3/fpm/pool.d/domjudge.conf | awk '{print $3}')

if [[ $MEMSSET -ne $MEMSNOW ]] ; then
  echo ""
  echo "H/W memory size changed!!"
  echo ""
  MEMSTRING=$(grep "pm.max_children =" /etc/php/8.3/fpm/pool.d/domjudge.conf)
  NEWSTRING="pm.max_children = ${MEMSNOW}      ; 40 per 1GiB memory(16GiB -> 640)"
  sudo sed -i "s:${MEMSTRING}:${NEWSTRING}:g" /etc/php/8.3/fpm/pool.d/domjudge.conf
  echo "pm.max_children value changed to ${MEMSNOW}"
  echo ""
fi

echo ""
echo "Restarting php..."
sudo service php8.3-fpm restart
sudo service php8.3-fpm reload
echo ""
echo "Restarting mariadb..."
sudo systemctl restart mariadb
echo ""
WEBSERVER=$(curl -is localhost | grep "Server" | awk '{print $2}')
if [[ ${WEBSERVER} == Apache* ]] ; then
  echo "Restarting apache2..."
  sudo systemctl restart apache2
  sudo systemctl reload apache2
fi
if [[ ${WEBSERVER} == nginx* ]] ; then
  echo "Restarting nginx..."
  sudo systemctl restart nginx
  sudo systemctl reload nginx
fi

echo ""
echo "php(fpm) autoscaling for DOMjudge server completed!"
echo ""

exit 0

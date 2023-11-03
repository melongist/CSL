#!/bin/bash

#DOMjudge php memory autoscaling script
#DOMjudge8.2.2 stable + Ubuntu 22.04.3 LTS + apache2/nginx
#2023.11 Made by melongist(melongist@gmail.com) for CS teachers

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj822mas.sh'"
  exit 1
fi

echo "DOMjudge memory autoscaling for php(fpm) started..."
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
MEMSSET=$(grep "pm.max_children =" /etc/php/8.2/fpm/pool.d/domjudge.conf | awk '{print $3}')

if [[ $MEMSSET -ne $MEMSNOW ]] ; then
  echo ""
  echo "H/W memory size changed!!"
  echo ""
  MEMSTRING=$(grep "pm.max_children =" /etc/php/8.2/fpm/pool.d/domjudge.conf)
  NEWSTRING="pm.max_children = ${MEMSNOW}      ; ~40 per gig of memory(16gb system -> 500)"
  sudo sed -i "s:${MEMSTRING}:${NEWSTRING}:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
  echo "pm.max_children value changed to ${MEMSNOW}"
  echo ""
fi

echo ""
echo "Restarting php..."
sudo service php8.2-fpm restart
sudo service php8.2-fpm reload
echo ""
echo "Restarting mariadb..."
sudo systemctl restart mariadb
echo ""
WEBSERVER=$(curl -is localhost | grep "Server" | awk '{sub(/\/*/, ""); print $2}')
if [[ "$WEBSERVER" == "Apache*" ]] ; then
  echo "Restarting apache2..."
  sudo systemctl restart apache2
  sudo systemctl reload apache2
fi
if [[ "$WEBSERVER" == "nginx" ]] ; then
  echo "Restarting nginx..."
  sudo systemctl restart nginx
  sudo systemctl reload nginx
fi

echo ""
echo "DOMjudge memory autoscaling for php(fpm) finished!"
echo ""
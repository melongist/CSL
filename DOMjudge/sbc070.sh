#!/bin/bash

#origin
#https://github.com/spotboard
#https://github.com/spotboard/domjudge-converter

#DOMjudge spotboard converter install script
#2024.01 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.2.2 stable + Ubuntu 22.04.3 LTS + apache2/nginx


#spotboard 0.7.0 for domjudge8.2.2 + Ubuntu 22.04 LTS Server

#terminal commands to install domjudge spotboard converter
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sbc070.sh
#bash sbc070.sh

#------
#spotboard converter for spotboard

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash sbc070.sh'"
  exit 1
fi

cd

sudo apt update
sudo apt -y upgrade


WEBSERVER="no"
while [ ${WEBSERVER} != "apache2" ] && [ ${WEBSERVER} != "nginx" ]; do
  clear
  echo    ""
  echo    "Select Web-server for DOMjudge!"
  echo -n "apache2 or nginx? [apache2/nginx]: "
  read WEBSERVER
done

#https://github.com/spotboard/domjudge-converter
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/domjudge-converter-master.zip
unzip domjudge-converter-master.zip
mv domjudge-converter-master dcm
cd dcm

echo ""

#config.js
INPUTS="n"
SBACCOUNT=""
while [ ${INPUTS} = "n" ]; do
  echo -n "spotboard jury account? : "
  read SBACCOUNT
  echo -n "spotboard jury account  : $SBACCOUNT     OK?[y/n] "
  read INPUTS
done

INPUTS="n"
SBACCOUNTPW=""
while [ ${INPUTS} = "n" ]; do
  echo -n "spotboard jury account password? : "
  read SBACCOUNTPW
  echo -n "spotboard jury account password  : $SBACCOUNTPW     OK?[y/n] "
  read INPUTS
done

INPUTS="n"
CID=""
while [ ${INPUTS} = "n" ]; do
  echo -n "DOMjudge contest CID? : "
  read CID
  echo -n "DOMjudge contest CID  : $CID     OK?[y/n] "
  read INPUTS
done

sed -i "s#username: 'username'#username: '$SBACCOUNT'#" ./config.js
sed -i "s#password: 'password'#password: '$SBACCOUNTPW'#" ./config.js
sed -i "s#cid: 1#cid: $CID#" ./config.js

case ${WEBSERVER} in
  "apache2")
    sed -i "s#api: 'http://localhost/api'#api: 'http://localhost/domjudge/api'#" ./config.js
    sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ./config.js
    ;;
  "nginx")
    sed -i "s#api: 'http://localhost/api'#api: 'http://localhost/domjudge/api'#" ./config.js
    sed -i "s#dest: '.'#dest: '/usr/share/nginx/html/spotboard/dist/'#" ./config.js
    ;;
esac



npm install

clear

cd

echo "" | tee -a ~/domjudge.txt
echo "domjudge-converter for domjudge installed!!" | tee -a ~/domjudge.txt
echo "Ver 2024.01.14" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "Next step : npm start"
echo "" | tee -a ~/domjudge.txt
echo "------ run npm start every reboot ------" | tee -a ~/domjudge.txt
echo "run : cd dcm" | tee -a ~/domjudge.txt
echo "run : npm start" | tee -a ~/domjudge.txt
echo "Check spotboard!" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "------" | tee -a ~/domjudge.txt
echo "http://localhost/spotboard/dist/" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "configuration for domjudge-converter" | tee -a ~/domjudge.txt
echo "check and edit ~/dcm/config.js" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt

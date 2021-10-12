#!/bin/bash

#https://github.com/spotboard
#https://github.com/spotboard/domjudge-converter


#domjudge converter for spotboard 0.6.0 for domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#terminal commands to install domjudge converter
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sbc.sh
#bash sbc.sh

#------
#spotboard converter for spotboard

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash sbc070.sh'"
  exit 1
fi

cd

sudo apt update
sudo apt -y upgrade

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

sed -i "s#api: 'http://localhost/api'#api: 'http://localhost/domjudge/api'#" ./config.js
sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ./config.js


npm install

clear

cd

echo "" | tee -a domjudge.txt
echo "domjudge-converter for domjudge installed!!" | tee -a domjudge.txt
echo "Ver 2020.10.19" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Next step : npm start"
echo "" | tee -a domjudge.txt
echo "------ run npm start every reboot ------" | tee -a domjudge.txt
echo "run : cd dcm" | tee -a domjudge.txt
echo "run : setsid npm start &" | tee -a domjudge.txt
echo "Check spotboard!" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "------" | tee -a domjudge.txt
echo "http://localhost/spotboard/dist/" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "configuration for domjudge-converter" | tee -a domjudge.txt
echo "check and edit ~/dcm/config.js" | tee -a domjudge.txt
echo ""

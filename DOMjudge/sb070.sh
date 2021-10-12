#!/bin/bash

#https://github.com/spotboard
#https://github.com/spotboard/spotboard


#spotboard 0.7.0 for domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#terminal commands to install spotboard webapp
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sb070.sh
#bash sb070.sh

#------
#spotboard for domjudge

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash sb070.sh'"
  exit 1
fi

cd

sudo apt update
sudo apt -y upgrade

#https://github.com/spotboard/spotboard
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/spotboard-webapp-0.7.0.tar.gz
tar -xvf spotboard-webapp-0.7.0.tar.gz
mv spotboard-webapp-0.7.0 spotboard
sudo mv spotboard /var/www/html/
cd /var/www/html/spotboard/

sudo apt -y install nodejs
sudo apt -y install npm
sudo npm install -g npm
sudo npm install -g grunt-cli
npm install
npm run build

sed -i "s#feed_server_path = './sample/'#feed_server_path = './'#" /var/www/html/spotboard/dist/config.js
sed -i "s#'award_slide.json' :'./sample/award_slide.json'#'award_slide.json' :'./award_slide.json'#" /var/www/html/spotboard/dist/config.js
sed -i "s#animation          : false#animation          : true#" /var/www/html/spotboard/dist/config.js

clear

echo "" | tee -a domjudge.txt
echo "spotboard for domjudge installed!!" | tee -a domjudge.txt
echo "Ver 2020.10.19" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Check spotboard!" | tee -a domjudge.txt
echo "------" | tee -a domjudge.txt
echo "http://localhost/spotboard/dist/" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "configuration for spotboard" | tee -a domjudge.txt
echo "check /var/www/html/spotboard/dist/config.js" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Next step : install domjudge-converter" | tee -a domjudge.txt
echo ""
echo ""



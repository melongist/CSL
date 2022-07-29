#!/bin/bash

#https://github.com/spotboard
#https://github.com/spotboard/spotboard

#DOMjudge judgehost starting script
#DOMjudge8.1.0 stable + Ubuntu 22.04 LTS
#Made by 
#2022.07.30 melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers


#spotboard 0.7.0 for domjudge8.1.0 + Ubuntu 22.04 LTS Server

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

sudo apt install -y curl

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs




#sudo apt -y install nodejs
sudo apt -y install npm

#nodejs stable update
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
node -v


sudo npm install -g npm
sudo npm install -g grunt-cli


#npm install & update
npm install
sudo npm i -g npm
npm -v
npm run build


sed -i "s#feed_server_path = './sample/'#feed_server_path = './'#" /var/www/html/spotboard/dist/config.js
sed -i "s#'award_slide.json' :'./sample/award_slide.json'#'award_slide.json' :'./award_slide.json'#" /var/www/html/spotboard/dist/config.js
sed -i "s#animation          : false#animation          : true#" /var/www/html/spotboard/dist/config.js





cd

clear

echo "" | tee -a ./domjudge.txt
echo "spotboard for domjudge installed!" | tee -a ./domjudge.txt
echo "Ver 2022.01.18" | tee -a ./domjudge.txt
echo "" | tee -a ./domjudge.txt
echo "Check spotboard!" | tee -a ./domjudge.txt
echo "------" | tee -a ./domjudge.txt
echo "http://localhost/spotboard/dist/" | tee -a ./domjudge.txt
echo "" | tee -a ./domjudge.txt
echo "configuration for spotboard" | tee -a ./domjudge.txt
echo "check /var/www/html/spotboard/dist/config.js" | tee -a ./domjudge.txt
echo "" | tee -a ./domjudge.txt
echo "Next step : install domjudge-converter" | tee -a ./domjudge.txt
echo "" | tee -a ./domjudge.txt
echo "" | tee -a ./domjudge.txt



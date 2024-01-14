#!/bin/bash

#origin
#https://github.com/spotboard
#https://github.com/spotboard/spotboard

#DOMjudge judgehost starting script
#2024.01 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.2.2 stable + Ubuntu 22.04.3 LTS + apache2/nginx


#spotboard 0.7.0 for domjudge8.2.2 + Ubuntu 22.04 LTS Server

#terminal commands to install spotboard webapp
#------
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


WEBSERVER="no"
while [ ${WEBSERVER} != "apache2" ] && [ ${WEBSERVER} != "nginx" ]; do
  clear
  echo    ""
  echo    "Select Web-server for DOMjudge!"
  echo -n "apache2 or nginx? [apache2/nginx]: "
  read WEBSERVER
done


#https://github.com/spotboard/spotboard
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/spotboard-webapp-0.7.0.tar.gz
tar -xvf spotboard-webapp-0.7.0.tar.gz
mv spotboard-webapp-0.7.0 spotboard


case ${WEBSERVER} in
  "apache2")
    sudo mv spotboard /var/www/html/
    cd /var/www/html/spotboard/
    ;;
  "nginx")
    sudo mv spotboard /usr/share/nginx/html/
    cd /usr/share/nginx/html/spotboard/
    ;;
esac


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


case ${WEBSERVER} in
  "apache2")
    sed -i "s#feed_server_path = './sample/'#feed_server_path = './'#" /var/www/html/spotboard/dist/config.js
    sed -i "s#'award_slide.json' :'./sample/award_slide.json'#'award_slide.json' :'./award_slide.json'#" /var/www/html/spotboard/dist/config.js
    sed -i "s#animation          : false#animation          : true#" /var/www/html/spotboard/dist/config.js
    ;;
  "nginx")
    sed -i "s#feed_server_path = './sample/'#feed_server_path = './'#" /usr/share/nginx/html/spotboard/dist/config.js
    sed -i "s#'award_slide.json' :'./sample/award_slide.json'#'award_slide.json' :'./award_slide.json'#" /usr/share/nginx/html/spotboard/dist/config.js
    sed -i "s#animation          : false#animation          : true#" /usr/share/nginx/html/spotboard/dist/config.js
    ;;
esac


cd

clear

echo "" | tee -a ~/domjudge.txt
echo "spotboard for domjudge installed!" | tee -a ~/domjudge.txt
echo "Ver 2024.01.14" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "Check spotboard!" | tee -a ~/domjudge.txt
echo "------" | tee -a ~/domjudge.txt
echo "http://localhost/spotboard/dist/" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "configuration for spotboard" | tee -a ~/domjudge.txt

case ${WEBSERVER} in
  "apache2")
    echo "check /var/www/html/spotboard/dist/config.js" | tee -a ~/domjudge.txt
    ;;
  "nginx")
    echo "check /usr/share/nginx/html/spotboard/dist/config.js" | tee -a ~/domjudge.txt
    ;;
esac

echo "" | tee -a ~/domjudge.txt
echo "Next step : install domjudge-converter" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt


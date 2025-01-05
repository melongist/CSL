#!/bin/bash

#origin
#https://github.com/spotboard
#https://github.com/spotboard/spotboard
#https://github.com/spotboard/domjudge-converter

#DOMjudge spotboard install script
#2025.01 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.3.1 stable + Ubuntu 24.04 LTS + apache2/nginx

#spotboard 0.7.0 for domjudge8.3.1 + Ubuntu 24.04 LTS Server


#terminal commands to install spotboard webapp
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831spotboard24.sh
#bash dj831spotboard24.sh

#------
#spotboard for domjudge

if [[ $SUDO_USER ]] ; then
  echo "Just use 'dj831spotboard24.sh'"
  exit 1
fi

cd

sudo apt update
sudo apt upgrade -y


WEBSERVER="no"
while [ ${WEBSERVER} != "apache2" ] && [ ${WEBSERVER} != "nginx" ]; do
  clear
  echo    ""
  echo    "Select Web-server for spotboard!"
  echo -n "apache2 or nginx? [apache2/nginx]: "
  read WEBSERVER
done


#spotboard
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
    sudo mv spotboard /var/www/html/
    cd /var/www/html/spotboard/
    ;;
esac


sudo apt install curl -y

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs




sudo apt install nodejs -y
sudo apt install npm -y

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
    sed -i "s#feed_server_path = './sample/'#feed_server_path = './'#" /var/www/html/spotboard/dist/config.js
    sed -i "s#'award_slide.json' :'./sample/award_slide.json'#'award_slide.json' :'./award_slide.json'#" /var/www/html/spotboard/dist/config.js
    sed -i "s#animation          : false#animation          : true#" /var/www/html/spotboard/dist/config.js
    ;;
esac


cd

clear

echo "" | tee -a ~/spotboard.txt
echo "spotboard for domjudge installed!" | tee -a ~/spotboard.txt
echo "Ver 2025.01" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "Check spotboard!" | tee -a ~/spotboard.txt
echo "------" | tee -a ~/spotboard.txt

PRIVADDRESS=$(hostname -i)
THISADDRESS=$(curl checkip.amazonaws.com)

echo "Private IP URL: http://${PRIVADDRESS}/spotboard/dist/" | tee -a ~/spotboard.txt
echo "Public  IP URL: http://${THISADDRESS}/spotboard/dist/" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "configuration for spotboard" | tee -a ~/spotboard.txt

case ${WEBSERVER} in
  "apache2")
    echo "check /var/www/html/spotboard/dist/config.js" | tee -a ~/spotboard.txt
    ;;
  "nginx")
    echo "check /var/www/html/spotboard/dist/config.js" | tee -a ~/spotboard.txt
    ;;
esac

echo "" | tee -a ~/spotboard.txt
echo "Next step : install domjudge-converter" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt

cd

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
    sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ./config.js
    ;;
esac

npm install

clear

cd

echo "" | tee -a ~/spotboard.txt
echo "domjudge-converter for domjudge installed!!" | tee -a ~/spotboard.txt
echo "Ver 2025.01" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "Next step : npm start"
echo "" | tee -a ~/spotboard.txt
echo "------ run npm start every reboot ------" | tee -a ~/spotboard.txt
echo "run : cd dcm" | tee -a ~/spotboard.txt
echo "run : npm start" | tee -a ~/spotboard.txt
echo "Check spotboard!" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "------" | tee -a ~/spotboard.txt
echo "http://localhost/spotboard/dist/" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "configuration for domjudge-converter" | tee -a ~/spotboard.txt
echo "check and edit ~/dcm/config.js" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt



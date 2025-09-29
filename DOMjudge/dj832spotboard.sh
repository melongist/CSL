#!/bin/bash

#origin
#https://github.com/spotboard
#https://github.com/spotboard/spotboard
#https://github.com/spotboard/domjudge-converter

#DOMjudge spotboard install script
#2025.01 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.3.2 stable + Ubuntu 24.04 LTS + apache2/nginx

#spotboard 0.7.0 for domjudge8.3.2 + Ubuntu 24.04 LTS Server


#terminal commands to install spotboard webapp
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj832spotboard.sh
#bash dj832spotboard.sh

#------
#spotboard for domjudge

if [[ $SUDO_USER ]] ; then
  echo "Just use 'dj832spotboard.sh'"
  exit 1
fi


if [ -d /opt/domjudge/domserver ] ; then
  echo ""
  echo "DOMjudge server is already installed at this computer!!"
  echo ""
  echo "Use the other computer!!!"
  echo ""
  exit 1
fi


if [ -d /opt/domjudge/judgehost ] ; then
  echo ""
  echo "DOMjudge judgehost is already installed at this computer!!"
  echo ""
  echo "Use the other computer!!!"
  echo ""
  exit 1
fi


cd

sudo apt update
sudo apt upgrade -y


#time synchronization
echo ""
sudo timedatectl
echo ""

#set timezone
NEWTIMEZONE=$(tzselect)
sudo timedatectl set-timezone ${NEWTIMEZONE}
echo ""

#needrestart auto check for Ubuntu 24.04
#/etc/needrestart/needrestart.conf
if [ ! -e /etc/needrestart/needrestart.conf ] ; then
  sudo apt install needrestart -y
fi
sudo sed -i "s:#\$nrconf{restart} = 'i':\$nrconf{restart} = 'a':" /etc/needrestart/needrestart.conf
sudo sed -i "s:#\$nrconf{kernelhints} = -1:\$nrconf{kernelhints} = 0:" /etc/needrestart/needrestart.conf


WEBSERVER="no"
while [ ${WEBSERVER} != "apache2" ] && [ ${WEBSERVER} != "nginx" ]; do
  clear
  echo    ""
  echo    "Select Web-server for DOMjudge!"
  echo -n "apache2 or nginx? [apache2/nginx]: "
  read WEBSERVER
done


#Webserver
case ${WEBSERVER} in
  "apache2")
    sudo apt install apache2 -y
    ;;
  "nginx")
    sudo add-apt-repository ppa:ondrej/nginx -y
    sudo apt install nginx -y
    sudo systemctl enable nginx
    sudo service nginx start
    ;;
esac

sudo apt install zip unzip -y
sudo apt install curl -y

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

sudo apt install nodejs -y
sudo apt install npm -y

#nodejs stable update
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
node -v

sudo npm install -g npm
sudo npm install -g grunt-cli


#https://github.com/spotboard/spotboard
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/spotboard-webapp-0.7.0.tar.gz
tar -xvf spotboard-webapp-0.7.0.tar.gz
mv spotboard-webapp-0.7.0 spotboard
rm spotboard-webapp-0.7.0.tar.gz

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

#npm install & update
npm install
sudo npm i -g npm
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


echo "" | tee -a ~/spotboard.txt
echo "spotboard for domjudge installed!" | tee -a ~/spotboard.txt
echo "Ver 2025.09" | tee -a ~/spotboard.txt
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
rm domjudge-converter-master.zip

cd dcm

echo ""

#config.js
SERVERURL="o"
INPUTS="x"
while [ ${SERVERURL} != ${INPUTS} ]; do
  echo ""
  echo "Input DOMjudge server's URL"
  echo "Examples:"
  echo "http://123.123.123.123"
  echo "http://contest.domjudge.org"
  echo "https://contest.domjudge.org"
  echo ""
  echo -n "Input  server's URL: "
  read SERVERURL
  echo -n "Repeat server's URL: "
  read INPUTS
done

case ${WEBSERVER} in
  "apache2")
    sed -i "s#api: 'http://localhost/api'#api: '${SERVERURL}/domjudge/api'#" ~/dcm/config.js
    sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ~/dcm/config.js
    ;;
  "nginx")
    sed -i "s#api: 'http://localhost/api'#api: '${SERVERURL}/domjudge/api'#" ~/dcm/config.js
    sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ~/dcm/config.js
    ;;
esac
echo "DOMjudge server's URL setting is completed!"
echo ""

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

sed -i "s#username: 'username'#username: '$SBACCOUNT'#" ~/dcm/config.js
sed -i "s#password: 'password'#password: '$SBACCOUNTPW'#" ~/dcm/config.js
sed -i "s#cid: 1#cid: $CID#" ~/dcm/config.js

#npm install & update
npm install
sudo npm i -g npm
npm audit fix --force

cd

echo "" | tee -a ~/spotboard.txt
echo "domjudge-converter for domjudge installed!!" | tee -a ~/spotboard.txt
echo "Ver 2025.09" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "Next step : npm start"
echo "" | tee -a ~/spotboard.txt
echo "------ run npm start every reboot ------" | tee -a ~/spotboard.txt
echo "run : cd dcm" | tee -a ~/spotboard.txt
echo "run : npm start" | tee -a ~/spotboard.txt
echo "Check spotboard!" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "------" | tee -a ~/spotboard.txt
echo "Private IP URL: http://${PRIVADDRESS}/spotboard/dist/" | tee -a ~/spotboard.txt
echo "Public  IP URL: http://${THISADDRESS}/spotboard/dist/" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt
echo "configuration for domjudge-converter" | tee -a ~/spotboard.txt
echo "check and edit ~/dcm/config.js" | tee -a ~/spotboard.txt
echo "" | tee -a ~/spotboard.txt



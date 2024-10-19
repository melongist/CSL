#!/bin/bash

#spotboard for DOMjudge8.3.1 installation script
#2024.10 Made by melongist(melongist@gmail.com) for CS teachers

#terminal commands to install DOMjudge server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831sb.sh
#bash dj831sb.sh

#------
#spotboard for domjudge

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj831sb24.sh'"
  exit 1
fi

OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')
if [ ${OSVER:0:5} != "24.04" ] ; then
  echo ""
  echo "Ubuntu 24.04 LTS needed!!'"
  echo ""
  exit 1
fi

WEBSERVER="no"
while [ ${WEBSERVER} != "apache2" ] && [ ${WEBSERVER} != "nginx" ]; do
  clear
  echo    ""
  echo    "Select Web-server for spotboard!"
  echo -n "apache2 or nginx? [apache2/nginx]: "
  read WEBSERVER
done

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


sudo apt update
sudo apt upgrade -y

sudo apt install unzip -y


case ${WEBSERVER} in
  "apache2")
    sudo apt install apache2 -y
    ;;
  "nginx")
    sudo apt install nginx -y
    sudo systemctl enable nginx
    sudo service nginx start
    ;;
esac


case ${WEBSERVER} in
  "apache2")
    sudo systemctl restart apache2
    ;;
  "nginx")
    sudo systemctl restart nginx
    ;;
esac


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
sudo apt-get install nodejs -y



#sudo apt -y install nodejs
sudo apt install npm -y

#nodejs stable update
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
node -v

sudo npm install -g npm@latest
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

echo "" | tee -a ~/readme.txt
echo "spotboard for domjudge installed!" | tee -a ~/readme.txt
echo "Ver 2024.10" | tee -a ~/readme.txt
echo "" | tee -a ~/readme.txt
echo "Check spotboard!" | tee -a ~/readme.txt
echo "------" | tee -a ~/readme.txt
echo "http://localhost/spotboard/dist/" | tee -a ~/readme.txt
echo "" | tee -a ~/readme.txt
echo "configuration for spotboard" | tee -a ~/readme.txt

case ${WEBSERVER} in
  "apache2")
    echo "check /var/www/html/spotboard/dist/config.js" | tee -a ~/readme.txt
    ;;
  "nginx")
    echo "check /var/www/html/spotboard/dist/config.js" | tee -a ~/readme.txt
    ;;
esac

echo "" | tee -a ~/readme.txt
echo "Next step : install domjudge-converter" | tee -a ~/readme.txt
echo "" | tee -a ~/readme.txt
echo "" | tee -a ~/readme.txt


#https://github.com/spotboard/domjudge-converter
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/domjudge-converter-master.zip
unzip domjudge-converter-master.zip
mv domjudge-converter-master dcm
cd dcm

echo ""


echo "Input DOMjudge server URL"
echo "Examples:"
echo "http://123.123.123.123"
echo "http://contest.domjudge.org"
echo "https://contest.domjudge.org"
SERVERURL="o"
INPUTS="x"
while [ ${SERVERURL} != ${INPUTS} ]; do
  echo    ""
  echo -n "Input  DOMjudge server URL : "
  read SERVERURL
  echo -n "Repeat DOMjudge server URL : "
  read INPUTS
done

case ${WEBSERVER} in
  "apache2")
    sed -i "s#api: 'http://localhost/api'#api: '${SERVERURL}/domjudge/api'#" ./config.js
    sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ./config.js
    ;;
  "nginx")
    sed -i "s#api: 'http://localhost/api'#api: '${SERVERURL}/domjudge/api'#" ./config.js
    sed -i "s#dest: '.'#dest: '/var/www/html/spotboard/dist/'#" ./config.js
    ;;
esac

#config.js
INPUTS="n"
SBACCOUNT=""
while [ ${INPUTS} = "n" ]; do
  echo -n "spotboard jury account? : "
  read SBACCOUNT
  echo -n "spotboard jury account  : $SBACCOUNT     OK?[y/n] "
  read INPUTS
done

echo ""

INPUTS="n"
SBACCOUNTPW=""
while [ ${INPUTS} = "n" ]; do
  echo -n "spotboard jury account password? : "
  read SBACCOUNTPW
  echo -n "spotboard jury account password  : $SBACCOUNTPW     OK?[y/n] "
  read INPUTS
done

echo ""

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

echo ""

npm install

cd

echo "" | tee -a ~/domjudge.txt
echo "domjudge-converter for domjudge installed!!" | tee -a ~/domjudge.txt
echo "Ver 2024.10" | tee -a ~/domjudge.txt
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





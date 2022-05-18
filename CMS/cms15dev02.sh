#!/bin/bash

#http://cms-dev.github.io/
#https://github.com/cms-dev/cms

#CMS1.5.dev0 + Ubuntu 20.04 LTS Server
#Installation

#------

cd

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash cms15dev02.sh'"
  exit 1
fi

cd cms

sudo pip3 install -r requirements.txt

wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/db.txt

USERPW="o"
INPUTS="x"
while [ ${USERPW} != ${INPUTS} ]; do
  echo -n "Enter  postgresql cmsuser password : "
  read USERPW
  echo -n "Repeat postgresql cmsuser password : "
  read INPUTS
done

sudo sed -i "s#login password 'enternewpassword'#login password '$USERPW'#" ./db.txt
sudo su - postgres < db.txt
cd

sudo sed -i "s#your_password_here#$USERPW#" /usr/local/etc/cms.conf
sudo chown cmsuser:cmsuser /usr/local/etc/cms.conf

cd cms
sudo python3 setup.py install
cd

cmsInitDB

cmsAddAdmin admin -p $USERPW

echo "cms1.5.dev0 installation completed!!" | tee -a cms.txt
echo "Ver 2022.05.18 CSL" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ After every reboot ------" | tee -a cms.txt
echo "For CMS admin page" | tee -a cms.txt
echo "run   : cmsAdminWebServer" | tee -a cms.txt
echo "      id : admin" | tee -a cms.txt
echo "      pw : $USERPW" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "make  : contest, user ... with contest admin menu" | tee -a cms.txt
echo "      http://localhost:8889" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "For service monitoring" | tee -a cms.txt
echo "run   : cmsResourceService -a" | tee -a cms.txt
echo "and   select # to start contest!" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "check : contest, user ... with user menu" | tee -a cms.txt
echo "      http://localhost:8888" | tee -a cms.txt
echo "  how to change port number : sudo nano /usr/local/etc/cms.conf" | tee -a cms.txt
echo "" | tee -a cms.txt

cmsAdminWebServer


#for admin page service
#setsid cmsAdminWebServer &

#for ranking page service
#setsid cmsRankingWebServer &

#for run contest
#cmsResourceService -a
#and select contest number
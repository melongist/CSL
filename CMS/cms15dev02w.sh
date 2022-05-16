#!/bin/bash

#http://cms-dev.github.io/
#https://github.com/cms-dev/cms

#CMS1.5.dev0 + Ubuntu 20.04 LTS Server
#Installation for worker-only servers
#no database

#------

cd

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash cms15dev02w.sh'"
  exit 1
fi

cd cms

sudo pip3 install -r requirements.txt
sudo python3 setup.py install

cd

echo "cms1.5.dev0 worker installation completed!!" | tee -a cms.txt
echo "Ver 2022.05.16 CSL" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ After every reboot ------" | tee -a cms.txt
echo "For workers" | tee -a cms.txt
echo "run : cmsResourceService -a" | tee -a cms.txt

cmsResourceService -a

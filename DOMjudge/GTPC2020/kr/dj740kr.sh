#!/bin/bash
#domjudge korean interface for beginner

#terminal commands to install domjudge korean interface
#wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/kr/dj740kr.sh
#bash dj740kr.sh

#------
#domjudge korean interface for beginner

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj740kr.sh'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo rm -rf /opt/domjudge/domserver/webapp/templates
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/kr/20201019krtemplates.tar.gz
sudo tar -zxvf 20201019krtemplates.tar.gz
sudo mv templates /opt/domjudge/domserver/webapp/
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*

cd

echo ""
echo "domjudge 7.4.0 korean interface for beginner installed!!"
echo ""
echo "Check domjudge!"
echo ""

sudo timedatectl set-timezone 'Asia/Seoul'
date

#!/bin/bash

#2024.7 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge8.3.0 stable(2024.05.31) + Ubuntu 22.04.4 LTS + apache2/nginx

#This installation script only works on Ubuntu 22.04 LTS!!
#terminal commands to install dedicated remote DOMjudge judgehost server
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830judgehost.sh
#bash dj830judgehost.sh

DJVER="8.3.0 stable (2024.05.31)"
DOMVER="domjudge-8.3.0"
THIS="dj830judgehost.sh"
README="dj830judgehost.txt"


if [[ $SUDO_USER ]] ; then
  echo ""
  echo "Just use 'bash ${THIS}'"
  exit 1
fi

OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')
if [ ${OSVER:0:5} != "22.04" ] ; then
  echo ""
  echo "This installation script only works on Ubuntu 22.04 LTS!!"
  echo ""
  exit 1
fi


cd


#time synchronization
echo ""
sudo timedatectl
echo ""

#set timezone
NEWTIMEZONE=$(tzselect)
sudo timedatectl set-timezone ${NEWTIMEZONE}
echo ""


#needrestart auto check for Ubuntu 22.04
#/etc/needrestart/needrestart.conf
if [ ! -e /etc/needrestart/needrestart.conf ] ; then
  sudo apt install needrestart -y
fi
sudo sed -i "s:#\$nrconf{restart} = 'i':\$nrconf{restart} = 'a':" /etc/needrestart/needrestart.conf
sudo sed -i "s:#\$nrconf{kernelhints} = -1:\$nrconf{kernelhints} = 0:" /etc/needrestart/needrestart.conf



sudo apt update
sudo apt upgrade -y

sudo apt install -y make
sudo apt install -y pkg-config
sudo apt install -y sudo
sudo apt install -y debootstrap
sudo apt install -y libcgroup-dev
sudo apt install -y php8.1-cli
sudo apt install -y php8.1-curl
#sudo apt install -y php8.1-json
sudo apt install -y php8.1-xml
sudo apt install -y php8.1-zip
sudo apt install -y lsof
sudo apt install -y procps
sudo apt install -y gcc
sudo apt install -y g++
sudo apt install -y build-essential

#for ubuntu
sudo apt remove -y apport


#Languages
#pypy3
sudo apt install -y pypy3
#java
sudo apt install -y default-jre-headless
sudo apt install -y default-jdk-headless
#haskell
sudo apt install -y ghc
#pascal
sudo apt install -y fp-compiler
#JavaScript
sudo apt install -y nodejs
sudo apt install -y npm
#R
sudo apt install -y r-base
#rust
sudo apt install -y rustc



#DOMjudge X.X.X stable
#wget https://www.domjudge.org/releases/domjudge-X.X.X.tar.gz
#tar xvf domjudge-X.X.X.tar.gz
#cd domjudge-X.X.X
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/${DOMVER}.tar.gz
tar xvf ${DOMVER}.tar.gz
rm ${DOMVER}.tar.gz




#Building and installing
cd ${DOMVER}
./configure --prefix=/opt/domjudge --with-baseurl=BASEURL
make judgehost
sudo make install-judgehost
echo ""




#Judgehosts group and user
#multiple judgedaemons per machine
#checking the number of CPU(s)
lscpu | grep "^CPU(s)"
CPUS=$(lscpu | grep "^CPU(s)"|awk  '{print $2}')
#make judgedaemo group
sudo groupadd domjudge-run
#default judgedaemon
sudo useradd -d /nonexistent -g domjudge-run -M -s /bin/false domjudge-run
#multi judgedaemons, max 127
for ((i=1; i<=127; i++));
do
  sudo useradd -d /nonexistent -g domjudge-run -M -s /bin/false domjudge-run-$i
done




#Sudo permissions
sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge




#Creating a chroot environment
#make chroot
#add nodejs, r-base
#sudo sed -i "s#INSTALLDEBS=\"gcc g++ make default-jdk-headless default-jre-headless pypy3 locales\"#INSTALLDEBS=\"gcc g++ make default-jdk-headless default-jre-headless pypy3 nodejs r-base locales\"#" /opt/domjudge/judgehost/bin/dj_make_chroot
#default
sudo /opt/domjudge/judgehost/bin/dj_make_chroot -i nodejs,r-base,rustc


cd

#swift not working... temporary removed. 2022.11.17
#sudo apt -y install clang libicu-dev
#sudo wget https://download.swift.org/swift-5.7.1-release/ubuntu2204/swift-5.7.1-RELEASE/swift-5.7.1-RELEASE-ubuntu22.04.tar.gz
#sudo tar -zxvf swift-5.7.1-RELEASE-ubuntu22.04.tar.gz
#sudo rm swift-5.7.1-RELEASE-ubuntu22.04.tar.gz
#sudo mv ~/swift-5.7.1-RELEASE-ubuntu22.04 ~/swift

#sudo ln -s -f ~/swift/usr/bin/swiftc /usr/bin/swiftc



#Linux Control Groups
#try #1 for Ubuntu 22.04 LTS
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub
#try #2 AWS Ubuntu 22.04 LTS Server
if [ -e /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi
sudo update-grub
#after reboot
#sudo systemctl enable create-cgroups --now


#https://www.domjudge.org/docs/manual/8.3/judging.html
#For Judging consistency
sudo sed -i "s:#kernel.sysrq=438:#kernel.sysrq=438\n\nkernel.randomize_va_space=0:g" /etc/sysctl.conf
#+For lazy judging to increase capacity
#In order to increase capacity, you can set the DOMjudge configuration option lazy_eval_results.
#When enabled, judging of a submission will stop when a highest priority result has been found for any testcase.
#You can find these priorities under the results_prio setting.



sudo apt autoremove -y

#scripts set download
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830start.sh
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj830mas.sh




#DOMjudge memory autoscaling for php(fpm)
if [ -e /etc/rc.local ] ; then
  sudo rm /etc/rc.local
fi

sudo touch /etc/rc.local
sudo chmod 777 /etc/rc.local
if grep "/home/ubuntu/dj830mas.sh" /etc/rc.local ; then
  echo "DOMjudge memory autoscaling for php(fpm) registered!"
else
  sudo sed -i "s/exit 0//g" /etc/rc.local
  sudo echo "#! /bin/sh" >> /etc/rc.local
  sudo echo "bash /home/ubuntu/dj830mas.sh" >> /etc/rc.local
  sudo echo "exit 0" >> /etc/rc.local
fi
sudo chmod 755 /etc/rc.local




echo "" | tee -a ~/${README}
echo "DOMjudgehosts installed!!" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "Input DOMjudge server's IP address or hostname"
echo "Examples:"
echo "http://123.123.123.123"
echo "https://contest.domjudge.org"
IPADDRESS="o"
INPUTS="x"
while [ ${IPADDRESS} != ${INPUTS} ]; do
  echo    ""
  echo -n "Enter  IP address or hostname : "
  read IPADDRESS
  echo -n "Repeat IP address or hostname : "
  read INPUTS
done
sudo sed -i "s:http\:\/\/localhost:${IPADDRESS}:g" /opt/domjudge/judgehost/etc/restapi.secret


echo "Input DOMjudge server's judgehost ID & PW"
JUDGEHOSTID="o"
INPUTS="x"
while [ ${JUDGEHOSTID} != ${INPUTS} ]; do
  echo    ""
  echo -n "Enter  judgehost ID : "
  read JUDGEHOSTID
  echo -n "Repeat judgehost ID : "
  read INPUTS
done
sudo sed -i "s:judgehost:${JUDGEHOSTID}:g" /opt/domjudge/judgehost/etc/restapi.secret

JUDGEHOSTOLDPW=$(cat /opt/domjudge/judgehost/etc/restapi.secret | grep "default" | awk  '{print $4}')
JUDGEHOSTPW="o"
INPUTS="x"
while [ ${JUDGEHOSTPW} != ${INPUTS} ]; do
  echo    ""
  echo -n "Enter  judgehost PW : "
  read JUDGEHOSTPW
  echo -n "Repeat judgehost PW : "
  read INPUTS
done
sudo sed -i "s:${JUDGEHOSTOLDPW}:${JUDGEHOSTPW}:g" /opt/domjudge/judgehost/etc/restapi.secret

echo "judgehost ID & PW set completed!"

echo "To change judgehost IPADDRESS/HOSTNAME, ID or PW" | tee -a ~/${README}
echo "Edit /opt/domjudge/judgehost/etc/restapi.secret" | tee -a ~/${README}
echo "" | tee -a ~/${README}

echo "------ Run judgehosts start script after every reboot ------" | tee -a ~/${README}
echo "bash dj830start.sh" | tee -a ~/${README}
echo "" | tee -a ~/${README}

echo "------ To kill some judgedaemon processe ------" | tee -a ~/${README}
echo "ps -ef, and find PID# of judgedaemon, run : sudo kill -9 PID#" | tee -a ~/${README}
echo "" | tee -a ~/${README}


echo ""
echo "System will be rebooted in 10 seconds!"
echo ""
COUNT=10
while [ $COUNT -ge 0 ]
do
  echo $COUNT
  ((COUNT--))
  sleep 1
done
echo "rebooted!" | tee -a ~/${README}
sleep 5
sudo reboot


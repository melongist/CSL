#!/bin/bash

#2025.01 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge


#It is recommended to separate main server and dedicated judge server.
#https://www.domjudge.org/docs/manual/8.3/overview.html#features
#Each judgehost should be a dedicated (virtual) machine that performs no other tasks.
#For example, although running a judgehost on the same machine as the domserver is possible,
#it’s not recommended except for testing purposes. 
#Judgehosts should also not double as local workstations for jury members.
#Having all judgehosts be of uniform hardware configuration helps in creating a fair, reproducible setup; 
#in the ideal case they are run on the same type of machines that the teams use.

#This installation script only works on Ubuntu 24.04 LTS!!
#2024.10.24 This scripts works for PC, AWS(Amazon Web Server), GCE(Google Cloud Engine)

#DOMjudge8.3.1 stable(2024.09.13) + Ubuntu 24.04 LTS + apache2/nginx




#DOMjudge judgehost installation script




#terminal commands to install dedicated remote DOMjudge judgehost server
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831judgehost.sh
#bash dj831judgehost.sh


#------

DJVER="8.3.1 stable (2024.09.13)"
DOMVER="domjudge-8.3.1"
THIS="dj831judgehost.sh"
README="readme.txt"


if [[ $SUDO_USER ]] ; then
  echo ""
  echo "Just use 'bash ${THIS}'"
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


OSVER=$(grep "Ubuntu" /etc/issue|head -1|awk  '{print $2}')
if [ ${OSVER:0:5} != "24.04" ] ; then
  echo ""
  echo "This installation script only works on Ubuntu 24.04 LTS!!"
  echo ""
  exit 1
fi


echo ""
echo "Before DOMjudge ${DJVER} judgehost installation!!!"
echo ""  
echo "DOMjudge server must be installed at the other system!!"
echo ""
INPUTS="x"
while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo -n "Did you make Domjudge server? [y/n]: "
  read INPUTS
  if [ ${INPUTS} == "n" ] ; then
    echo ""
    echo "Make Domjudge server first!!"
    echo ""
    exit 1
  fi
done


cd


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

sudo apt install -y make
sudo apt install -y pkg-config
sudo apt install -y sudo
sudo apt install -y debootstrap
sudo apt install -y libcgroup-dev
sudo apt install -y php8.3-cli
sudo apt install -y php8.3-curl
#sudo apt install -y php8.3-json
sudo apt install -y php8.3-xml
sudo apt install -y php8.3-zip
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


#for faster installation
UBUNTUMIRROR=$(grep "^URIs:" /etc/apt/sources.list.d/ubuntu.sources|awk 'NR==1 {print $2}')
sudo sed -i "s#http://us.archive.ubuntu.com/ubuntu/#${UBUNTUMIRROR}#" ~/${DOMVER}/misc-tools/dj_make_chroot.in


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
#multi judgedaemons, max 64
#https://www.domjudge.org/docs/manual/8.3/team.html
for ((i=1; i<=64; i++));
do
  sudo useradd -d /nonexistent -g domjudge-run -M -s /bin/false domjudge-run-$i
done


cd


#Adding sudo permissions
sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge


#judgehosts starting script download
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831start.sh
sudo sed -i "s/\$USER/${USER}/g" ~/dj831start.sh

#Number of judgehosts autoscaling for the number of cpu change to /etc/rc.local
echo '#!/bin/bash' >> ~/rc.local
echo "bash /home/${USER}/dj831start.sh" >> ~/rc.local
echo "exit 0" >> ~/rc.local
sudo chown root:root ~/rc.local
sudo chmod 755 ~/rc.local
sudo mv -f ~/rc.local /etc/rc.local

sudo sed -i '$s/$/\n/g' /lib/systemd/system/rc-local.service
sudo sed -i '$s/$/[Install]\n/g' /lib/systemd/system/rc-local.service
sudo sed -i '$s/$/WantedBy=multi-user.target\n\n/g' /lib/systemd/system/rc-local.service
sudo systemctl enable rc-local.service
sudo systemctl start rc-local.service


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
sudo sed -i "s#http://localhost#${SERVERURL}#g" /opt/domjudge/judgehost/etc/restapi.secret
echo "DOMjudge server's URL setting is completed!"
echo ""

JUDGEHOSTOLDPW=$(cat /opt/domjudge/judgehost/etc/restapi.secret | grep "default" | awk  '{print $4}')
JUDGEHOSTPW="o"
INPUTS="x"
while [ ${JUDGEHOSTPW} != ${INPUTS} ]; do
  echo    ""
  echo "Input DOMjudge server's judgehost PW"
  echo "You can find judgehost PW at DOMjudge server's /opt/domjudge/domserver/etc/restapi.secret"
  echo ""
  echo -n "Input  judgehost PW : "
  read JUDGEHOSTPW
  echo -n "Repeat judgehost PW : "
  read INPUTS
done
sudo sed -i "s:${JUDGEHOSTOLDPW}:${JUDGEHOSTPW}:g" /opt/domjudge/judgehost/etc/restapi.secret
echo "judgehost PW set completed!"
echo ""

echo "" | tee -a ~/${README}
echo "DOMjudge judgehost installed!!" | tee -a ~/${README}
echo "" | tee -a ~/${README}

echo "To change judgehost IPADDRESS, HOSTNAME, ID or PW for DOMjudge server?" | tee -a ~/${README}
echo "First, check /opt/domjudge/domserver/etc/restapi.secret at DOMjudge server" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "sudo nano /opt/domjudge/domserver/etc/restapi.secret" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "Second, edit /opt/domjudge/judgehost/etc/restapi.secret at this DOMjudge judgehost" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "sudo nano /opt/domjudge/judgehost/etc/restapi.secret" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "" | tee -a ~/${README}

#echo "To start judgehosts after every reboot?" | tee -a ~/${README}
#echo "------" | tee -a ~/${README}
#echo "bash dj831start.sh" | tee -a ~/${README}
#echo "" | tee -a ~/${README}
#echo "" | tee -a ~/${README}

echo "To kill some judgedaemon process?" | tee -a ~/${README}
echo "------" | tee -a ~/${README}
echo "Find the PID # of judgedaemon and kill the PID #" | tee -a ~/${README}
echo "sudo ps -ef" | tee -a ~/${README}
echo "sudo kill -9 #" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "" | tee -a ~/${README}


cd


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
#try #1 for PC Ubuntu 24.04 LTS
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub
#try #2 for AWS EC2 Ubuntu 24.04 LTS
if [ -e /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi
#try #3 for GCE Ubuntu 24.04 LTS
if [ -e /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for GCE"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=ttyS0,115200\"#GRUB_CMDLINE_LINUX_DEFAULT=\"console=ttyS0,115200 quiet cgroup_enable=memory swapaccount=1 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi
sudo update-grub
#after reboot?
sudo systemctl enable create-cgroups


#https://www.domjudge.org/docs/manual/8.3/judging.html
#For Judging consistency
sudo sed -i "s:#kernel.sysrq=438:#kernel.sysrq=438\n\nkernel.randomize_va_space=0:g" /etc/sysctl.conf
#+For lazy judging to increase capacity
#In order to increase capacity, you can set the DOMjudge configuration option lazy_eval_results.
#When enabled, judging of a submission will stop when a highest priority result has been found for any testcase.
#You can find these priorities under the results_prio setting.



sudo apt autoremove -y

echo ""
echo "DOMjudge judgehost installation completed!!"


echo ""
echo "System will be reboot in 10 seconds!"
echo ""
COUNT=10
while [ $COUNT -ge 0 ]
do
  echo $COUNT
  ((COUNT--))
  sleep 1
done
echo "Rebooted!" | tee -a ~/${README}
echo "" | tee -a ~/${README}
echo "" | tee -a ~/${README}


chmod 660 ~/${README}
echo "Saved as ${README}"


sleep 3
sudo reboot


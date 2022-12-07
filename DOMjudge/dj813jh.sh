#!/bin/bash

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge8.1.3 stable + Ubuntu 22.04 LTS
#2022.12.08 Made by melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers

#terminal commands to install DOMjudge judgehosts
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj813jh.sh
#bash dj813jh.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj813jh.sh'"
  exit 1
fi

cd

sudo apt update
sudo apt -y upgrade

sudo apt -y install make
sudo apt -y install pkg-config
sudo apt -y install sudo
sudo apt -y install debootstrap
sudo apt -y install libcgroup-dev
sudo apt -y install php8.1-cli
sudo apt -y install php8.1-curl
sudo apt -y install php8.1-xml
sudo apt -y install php8.1-zip
sudo apt -y install lsof
sudo apt -y install procps

#for ubuntu
sudo apt -y remove apport






#pypy3
#sudo apt -y install pypy3
#java
#sudo apt -y install default-jre-headless
#sudo apt -y install default-jdk-headless
#haskell
#sudo apt -y install ghc
#pascal
#sudo apt -y install fp-compiler
#JavaScript
#sudo apt -y install nodejs
#sudo apt -y install npm
#R
#sudo apt -y install r-base


#DOMjudge 8.1.3 stable
cd domjudge-8.1.3
./configure --prefix=/opt/domjudge --with-baseurl=BASEURL

#make judgehost
make judgehost
sudo make install-judgehost

echo ""
#check the number of CPU(s)
lscpu | grep "^CPU(s)"
CPUS=$(lscpu | grep "^CPU(s)"|awk  '{print $2}')

#judgehosts
#default judgedaemon
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run
#multi judgedaemons, max 127
for ((i=1; i<=127; i++));
do
  sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-$i
done

sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge

#try #1 for Ubuntu 22.04 LTS Desktop
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub
#try #2 for Ubuntu 22.04 LTS Server
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub
#try #3 AWS Ubuntu 22.04 LTS Server
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 quiet cgroup_enable=memory swapaccount=1 isolcpus=2 systemd.unified_cgroup_hierarchy=0\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi

sudo 


#make docs
sudo apt -y install python3-sphinx python3-sphinx-rtd-theme rst2pdf fontconfig python3-yaml texlive-latex-extra latexmk

sudo mkdir /opt/domjudge/doc
sudo mkdir /opt/domjudge/doc/manual
sudo mkdir /opt/domjudge/doc/manual/html
sudo mkdir /opt/domjudge/doc/examples
sudo mkdir /opt/domjudge/doc/logos

cd ~/domjudge-8.1.3/doc/

make docs

sudo make install-docs

sudo update-grub

#make chroot
#add nodejs, r-base
sudo sed -i "s#INSTALLDEBS=\"gcc g++ make default-jdk-headless default-jre-headless pypy3 locales\"#INSTALLDEBS=\"gcc g++ make default-jdk-headless default-jre-headless pypy3 nodejs r-base locales\"#" /opt/domjudge/judgehost/bin/dj_make_chroot
#default
sudo /opt/domjudge/judgehost/bin/dj_make_chroot


#swift not working... temporary removed. 2022.11.17
#sudo apt -y install clang libicu-dev
#sudo wget https://download.swift.org/swift-5.7.1-release/ubuntu2204/swift-5.7.1-RELEASE/swift-5.7.1-RELEASE-ubuntu22.04.tar.gz
#sudo tar -zxvf swift-5.7.1-RELEASE-ubuntu22.04.tar.gz
#sudo rm swift-5.7.1-RELEASE-ubuntu22.04.tar.gz
#sudo mv ~/swift-5.7.1-RELEASE-ubuntu22.04 ~/swift

#sudo ln -s -f ~/swift/usr/bin/swiftc /usr/bin/swiftc


sudo apt -y autoremove

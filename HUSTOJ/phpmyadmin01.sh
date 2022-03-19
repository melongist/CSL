#!/bin/bash
#phpmyadmin installation script for HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="2021.01.09"

THISFILE="phadmin00.sh"

clear

cd

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash ${THISFILE}'"
  exit 1
fi

sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove

clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

#Confirmation
INPUTS="n"
echo -n "phpmyadmin for HUSTOJ will be installed. Are you sure?[y/n] "
read INPUTS
if [ ${INPUTS} = "n" ] ; then 
  exit 1
fi

echo ""

#for phpmyadmin home name
PANAME="o"
INPUTS="x"
while [ ${PANAME} != ${INPUTS} ]; do
  echo -n "Enter  phpmyadmin home directory NAME : "
  read PANAME
  echo -n "Repeat phpmyadmin home directory NAME : "
  read INPUTS
done

#phpmyadmin installation
if [ -d "/usr/share/phpmyadmin" ]; then
  echo ""
  echo "phpmyadmin already installed!"
  PANAME=$(sudo find /home/judge/src/web/ -maxdepth 1 -type l -print | cut -d"/" -f6)
else
  echo ""
  sudo apt -y install phpmyadmin
  sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
  if [ ${PANAME} != "phpmyadmin" ]; then
    sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/${PANAME}
  fi
fi

#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(sudo curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(sudo hostname -I))
fi

DBUSER=$(sudo grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(sudo grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

echo ""
echo "--- phpmyadmin for HUSTOJ installed ---"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}/${PANAME}"
echo ""
echo "ID : ${DBUSER}"
echo "PW : ${PASSWORD}"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""


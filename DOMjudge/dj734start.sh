#!/bin/bash

#DOMjudge judgehost starting script
#DOMjudge7.3.4 stable + Ubuntu 20.04 LTS
#Made by 
#2022.01.02 melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash djstart.sh'"
  exit 1
fi

echo ""
#DOMjudge cache clear
sudo /opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo ""
#CPU(s)
lscpu | grep "^CPU(s)"
CPUS=$(lscpu | grep "^CPU(s)"|awk  '{print $2}')

#Thread(s) per core
lscpu | grep "Thread(s) per core"
CORES=$(lscpu | grep "Thread(s) per core"|awk  '{print $4}')

echo ""
echo "Starting create cgroups..."
sudo /opt/domjudge/judgehost/bin/create_cgroups
echo "create cgroups started!"

echo ""
echo "Starting judgedaemon..."
#default judgedaemon
#echo "start judgedaemon-run..."
#sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon &
#echo "judgedaemon-run started!"
#multiple judgedaemons, bound to a core, max 128
for ((i=0; i<$CPUS; i++));
do
  echo "start judgedaemon-run-$i..."
  sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n $i &
  echo "judgedaemon-run-$i started!"
done

echo ""
echo ""

echo "CPU information"
lscpu | grep "^CPU(s)"
lscpu | grep "Thread(s) per core"
echo "$CPUS judgedamons started!"
echo ""

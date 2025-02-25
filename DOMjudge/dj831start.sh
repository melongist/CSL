#!/bin/bash

#2025.01 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge




#DOMjudge judgehost judgehosts starting script




#Terminal commands to start judgehosts
#bash dj831start.sh


#------

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj831start.sh'"
  exit 1
fi


if [ ! -d /opt/domjudge/judgehost ] ; then
  echo ""
  echo "DOMjudge judgehost is not installed at this computer!!"
  echo ""
  exit 1
fi


echo "DOMjudge judgehosts starting ..."
echo ""
echo ""
echo "CPU information"
#check the number of CPU(s)
lscpu | grep "^CPU(s)"
CPUS=$(lscpu | grep "^CPU(s)"|awk  '{print $2}')

#The maximum number of processes can be run simultaneously is 64(including processes that started your program).
#https://www.domjudge.org/docs/manual/8.3/team.html
if [ ${CPUS} -gt 64 ] ; then
  CPUS=64
fi

#Thread(s) per core
#lscpu | grep "Thread(s) per core"
#CORES=$(lscpu | grep "Thread(s) per core"|awk  '{print $4}')


#Disk space and cleanup
#https://www.domjudge.org/docs/manual/8.3/judging.html
#Judgehost crashes cleanup
sudo /opt/domjudge/judgehost/bin/dj_judgehost_cleanup all


echo ""
#sudo systemctl enable create-cgroups --now
echo "Starting create cgroups..."
sudo /opt/domjudge/judgehost/bin/create_cgroups
echo "create cgroups started!"

echo ""
echo "Starting judgedaemon..."
#kill current all judgedaemons
kill -9 `pgrep -f judgedaemon`

#start new judgedaemons
#default judgedaemon
sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon &
#echo "judgedaemon-run started!"
#multi judgedaemons, limited to the number of cores, max 64
#https://www.domjudge.org/docs/manual/8.3/team.html
for ((i=1; i<${CPUS}; i++));
do
  echo "start judgedaemon-run-$i..."
  sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n $i &
  echo "judgedaemon-run-$i started!"
done

echo ""
echo "${CPUS} judgedamons started!"
echo ""


echo "DOMjudge judgehosts starting completed..."
echo ""

#!/bin/bash

#2025.06 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge




#DOMjudge server cache & webserver cache clearing script




#Terminal commands to clear server cache & webserver cache
#bash dj900devclear.sh


#------

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj900devclear.sh'"
  exit 1
fi


if [ ! -d /opt/domjudge/domserver ] ; then
  echo ""
  echo "DOMjudge server is not installed at this computer!!"
  echo ""
  exit 1
fi


echo "DOMjudge server cache & webserver cache clearing started..."
echo ""

#DOMjudge PHP/Symfony cache clear
/opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo "DOMjudge server cache & webserver cache clearing completed..."
echo ""

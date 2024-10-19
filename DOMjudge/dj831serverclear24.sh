#!/bin/bash

#2024.10 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge




#DOMjudge server cache & webserver cache clearing script




#Terminal commands to clear server cache & webserver cache
#bash dj831serverclear24.sh


#------

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj831serverclear24.sh'"
  exit 1
fi


echo "DOMjudge server cache & webserver cache clearing started..."
echo ""

#DOMjudge cache clear
/opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo "DOMjudge server cache & webserver cache clearing completed..."
echo ""

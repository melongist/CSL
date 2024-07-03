#!/bin/bash

#2024.7 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server cache & webserver cache clearing script
#DOMjudge8.3.0 stable(2024.05.31) + Ubuntu 22.04.4 LTS + apache2/nginx


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj830clear.sh'"
  exit 1
fi


echo "DOMjudge server cache & webserver cache clearing started..."
echo ""

#DOMjudge cache clear
sudo /opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo "DOMjudge server cache & webserver cache clearing completed..."
echo ""

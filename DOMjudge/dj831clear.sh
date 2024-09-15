#!/bin/bash

#2024.9 Made by melongist(melongist@gmail.com) for CS teachers

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge8.3.1 stable(2024.05.31) + Ubuntu 22.04.4 LTS + apache2/nginx

#DOMjudge server cache & webserver cache clearing script


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj831clear.sh'"
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

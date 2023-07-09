#!/bin/bash

#DOMjudge server clearing script
#2023.07 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.2.1 stable + Ubuntu 22.04.2 LTS + apache2 2.4.57


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj821clear.sh'"
  exit 1
fi

#DOMjudge cache clear
sudo /opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo ""

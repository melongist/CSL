#!/bin/bash

#DOMjudge server clearing script
#2023.11 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.2.2 stable + Ubuntu 22.04.3 LTS + apache2 2.4.52


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj822clear.sh'"
  exit 1
fi

#DOMjudge cache clear
sudo /opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo ""

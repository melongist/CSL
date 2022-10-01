#!/bin/bash

#DOMjudge server clearing script
#DOMjudge8.1.3 stable + Ubuntu 22.04 LTS
#Made by 
#2022.10.02 melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj813clear.sh'"
  exit 1
fi

#DOMjudge cache clear
sudo /opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo ""

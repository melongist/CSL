#!/bin/bash

#For spotboard's nodejs & npm update
#Just run 'bash nnupdate.sh'

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash nnupdate.sh'"
  exit 1
fi

#nodejs stable update
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
node -v

#npm update
sudo npm i -g npm
npm -v


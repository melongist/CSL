#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

THISFILE="230223patch.sh"


if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

cd

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/upload_json.php
mv -f ./upload_json.php /home/judge/src/web/kindeditor/php/upload_json.php
chown www-data:root /home/judge/src/web/kindeditor/php/upload_json.php
chmod 664 /home/judge/src/web/kindeditor/php/upload_json.php


echo ""
echo "---- CSL HUSTOJ 230223 pdf file upload error patched ----"
echo ""


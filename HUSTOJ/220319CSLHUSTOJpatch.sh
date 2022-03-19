#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

THISFILE="220319CSLHUSTOJpatch.sh"

if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

echo ""
echo "---- CSL HUSTOJ xml image download error patch ----"
echo ""

#problem_export_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml220223.php
mv -f ./problem_export_xml220223.php /home/judge/src/web/admin/problem_export_xml.php
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php

#problem_export_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml220223.php
mv -f ./problem_import_xml220223.php /home/judge/src/web/admin/problem_import_xml.php
chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
chmod 664 /home/judge/src/web/admin/problem_import_xml.php


sed -i "s/release 22.02.23 /release 22.02.23p1/" /home/judge/src/web/template/bs3/js.php

echo ""
echo "---- CSL HUSTOJ xml image download error patched ----"
echo ""

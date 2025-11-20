#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers
#Last edits 25.11.20

clear

THISFILE="251120patch.sh"


if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi


CSLOJVER=$(sudo grep "release" /home/judge/src/web/template/bs3/js.php|awk '{print $7}')


if [ ${CSLOJVER:0:8} != "25.01.31" ] ; then
  echo ""
  echo "This is not the CSL HUSTOJ 25.01.31 !!"
  echo ""
  echo "This patch is for the CSL HUSTOJ 25.01.31 only!!'"
  echo ""
  exit 1
fi


cd


#for /home/judge/src/web/template/bs3/
#for problem_export error patch
#problem_export_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml250131.php
mv -f ./problem_export_xml250131.php /home/judge/src/web/admin/problem_export_xml.php
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php

echo ""
echo "---- CSL HUSTOJ 251120 patched ----"
echo ""


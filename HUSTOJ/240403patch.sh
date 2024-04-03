#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers
#Last edits 24.04.03

clear

THISFILE="240403patch.sh"


if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi


CSLOJVER=$(sudo grep "release" /home/judge/src/web/template/bs3/js.php|awk '{print $7}')


if [ ${CSLOJVER:0:8} != "24.01.30" ] ; then
  echo ""
  echo "This is not the CSL HUSTOJ 24.01.30 !!"
  echo ""
  echo "This patch is for the CSL HUSTOJ 24.01.30 only!!'"
  echo ""
  exit 1
fi


cd

#for /home/judge/src/web/template/bs3/
#for bs3 submit windows resize
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem240403.php
mv -f ./problem240403.php /home/judge/src/web/template/bs3/problem.php
chown www-data:www-data /home/judge/src/web/template/bs3/problem.php
chmod 644 /home/judge/src/web/template/bs3/problem.php
#for bs3 judges rejudge & delete
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/status240403.php
mv -f ./status240403.php /home/judge/src/web/template/bs3/status.php
chown www-data:www-data /home/judge/src/web/template/bs3/status.php
chmod 644 /home/judge/src/web/template/bs3/status.php
#for bs3 submit windows resize
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage240403.php
mv -f ./submitpage240403.php /home/judge/src/web/template/bs3/submitpage.php
chown www-data:www-data /home/judge/src/web/template/bs3/submitpage.php
chmod 644 /home/judge/src/web/template/bs3/submitpage.php


#for /home/judge/src/web/
#for bs3 submit windows resize
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/problem240403.php
mv -f ./problem240403.php /home/judge/src/web/problem.php
chown www-data:www-data /home/judge/src/web/problem.php
chmod 644 /home/judge/src/web/problem.php
#for bs3 judges rejudge & delete
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/status240403.php
mv -f ./status240403.php /home/judge/src/web/status.php
chown www-data:www-data /home/judge/src/web/status.php
chmod 644 /home/judge/src/web/status.php


echo ""
echo "---- CSL HUSTOJ 240403 patched ----"
echo ""


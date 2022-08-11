#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

THISFILE="220710patch.sh"


if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

cd

sed -i "s/if(count(\$used_in_contests)>0){/if(\$cid==0 \&\& count(\$used_in_contests)>0){/g" /home/judge/src/web/template/bs3/problem.php


echo ""
echo "---- CSL HUSTOJ 220710 contest admin error patched ----"
echo ""


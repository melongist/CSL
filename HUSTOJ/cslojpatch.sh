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

#judge.conf edit
#time result fix ... for use_max_time : to record the max time of all results, not sum of...
sed -i "s/OJ_TIME_LIMIT_TO_TOTAL=1/OJ_TIME_LIMIT_TO_TOTAL=0/" /home/judge/etc/judge.conf


DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

echo "DELETE FROM \`problem\` WHERE \`problem\`.\`problem_id\` >=1301 AND \`problem\`.\`problem_id\` <= 1321);" | mysql -u${DBUSER} -p${PASSWORD} -D jol 

rm -rf /home/judge/data/1301
rm -rf /home/judge/data/1302
rm -rf /home/judge/data/1303
rm -rf /home/judge/data/1304
rm -rf /home/judge/data/1305
rm -rf /home/judge/data/1306
rm -rf /home/judge/data/1307
rm -rf /home/judge/data/1308
rm -rf /home/judge/data/1309
rm -rf /home/judge/data/1310
rm -rf /home/judge/data/1311
rm -rf /home/judge/data/1312
rm -rf /home/judge/data/1313
rm -rf /home/judge/data/1314
rm -rf /home/judge/data/1315
rm -rf /home/judge/data/1316
rm -rf /home/judge/data/1317
rm -rf /home/judge/data/1318
rm -rf /home/judge/data/1319
rm -rf /home/judge/data/1320
rm -rf /home/judge/data/1321

sed -i "s/release 22.02.23 /release 22.02.23p1/" /home/judge/src/web/template/bs3/js.php

echo ""
echo "---- CSL HUSTOJ xml image download error patched ----"
echo ""

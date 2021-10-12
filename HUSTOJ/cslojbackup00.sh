#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

VER_DATE="21.04.13"

THISFILE="cslojbackup00.sh"
RESTOREFILE="restore.sh"




if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

echo ""
echo "---- CSL HUSTOJ backup ----"
echo ""
echo "Waiting 3 seconds..."
echo ""
sleep 3


if [ ! -d /home/${SUDO_USER}/cslojbackups ]
then
  mkdir /home/${SUDO_USER}/cslojbackups
  chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/cslojbackups  
fi


BACKUPS=$(echo `date '+%y%m%d%H%M'`)

if [ -z "$1" ]
then
  BACKUPS="${BACKUPS}-manual"
else
  BACKUPS="${BACKUPS}$1"
fi

mkdir /home/${SUDO_USER}/cslojbackups/${BACKUPS}

cp /home/${SUDO_USER}/${THISFILE} /home/${SUDO_USER}/cslojbackups/${BACKUPS}/
mv /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${THISFILE} /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${THISFILE}.bak 

touch /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "clear" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "if [[ -z \$SUDO_USER ]]" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "then" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  echo \"Use 'sudo bash ${RESTOREFILE}'\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "fi" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"---- CSL HUSTOJ backup restore ----\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "INPUTS=\"n\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"This script will restore ${BACKUPS} backup!\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo -n \"Are you sure? [y/n] : \"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "read INPUTS" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "if [ \${INPUTS} = \"y\" ]" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "then" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "else" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "fi" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}


DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#current mysql backup
#how to backup database : mysqldump -u debian-sys-maint -p jol > jol.sql
mysqldump -u ${DBUSER} -p$PASSWORD jol > /home/${SUDO_USER}/cslojbackups/${BACKUPS}/jol.sql
#for restoring
echo "DBUSER=\$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "PASSWORD=\$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "mysql -u \${DBUSER} -p\${PASSWORD} jol < jol.sql" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}

#current /home/judge/src/ directory backup
#how to backup /home/judge/src/ directory : sudo tar -czvpf ~/cslojsrc.tar.gz /home/judge/src/
sed -i "s/$DB_PASS=\"${PASSWORD}\"/$DB_PASS=\"HUSTOJPASSWORD\"/" /home/judge/src/web/include/db_info.inc.php
tar -czvpf /home/${SUDO_USER}/cslojbackups/${BACKUPS}/cslojsrc.tar.gz /home/judge/src
sed -i "s/$DB_PASS=\"HUSTOJPASSWORD\"/$DB_PASS=\"${PASSWORD}\"/" /home/judge/src/web/include/db_info.inc.php
#for restoring
echo "rm -rf /home/judge/src/*" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "tar -xzvpf ./cslojsrc.tar.gz -C /" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "sed -i \"s/\$DB_PASS=\\\"HUSTOJPASSWORD\\\"/\$DB_PASS=\\\"\${PASSWORD}\\\"/\" /home/judge/src/web/include/db_info.inc.php" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}

#current /home/judge/data/ directory backup
#how to backup /home/judge/src/ directory : sudo tar -czvpf ~/cslojdata.tar.gz /home/judge/data/
tar -czvpf /home/${SUDO_USER}/cslojbackups/${BACKUPS}/cslojdata.tar.gz /home/judge/data
#for restoring
echo "rm -rf /home/judge/data/*" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "tar -xzvpf ./cslojdata.tar.gz -C /" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}

echo "echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"--- CSL HUSTOJ backup ${BACKUPS} restored!! ---\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}

echo ""
echo "---- CSL HUSTOJ backuped successfully at ${BACKUPS} ----"
echo ""
echo "You can restore CSL HUSTOJ ${BACKUPS} backup with ..."
echo ""
echo "$ sudo bash ~/cslojbackups/${BACKUPS}/${RESTOREFILE}"
echo ""

#!/bin/bash
#moodle backup script
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

#clear

VER_DATE="21.05.08"

THISFILE="moodlebackup.sh"
RESTOREFILE="restore.sh"




if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

echo ""
echo "---- CSL moodle backup ----"
echo ""
echo "Waiting 3 seconds..."
echo ""
sleep 3


if [ ! -d /home/${SUDO_USER}/moodlebackups ]
then
  mkdir /home/${SUDO_USER}/moodlebackups
  chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/moodlebackups  
fi


BACKUPS=$(echo `date '+%y%m%d%H%M'`)

if [ -z "$1" ]
then
  BACKUPS="${BACKUPS}-manual"
else
  BACKUPS="${BACKUPS}$1"
fi

mkdir /home/${SUDO_USER}/moodlebackups/${BACKUPS}

cp /home/${SUDO_USER}/${THISFILE} /home/${SUDO_USER}/moodlebackups/${BACKUPS}/
mv /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${THISFILE} /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${THISFILE}.bak 

touch /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "clear" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "if [[ -z \$USER ]]" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "then" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "  echo \"Use 'sudo bash ${RESTOREFILE}'\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "fi" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"---- CSL moodle backup restore ----\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "INPUTS=\"n\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"This script will restore ${BACKUPS} backup!\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo -n \"Are you sure? [y/n] : \"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "read INPUTS" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "if [ \${INPUTS} = \"y\" ]" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "then" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "  echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "else" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "fi" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}


DBUSER="moodledbuser"
DBPASS="moodledbpw"

#current mysql backup
mysqldump --no-tablespaces --single-transaction --add-drop-database -u ${DBUSER} -p${DBPASS} moodle > /home/${SUDO_USER}/moodlebackups/${BACKUPS}/moodledbdump.sql
#for restoring
echo "DBUSER=\"${DBUSER}\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "DBPASS=\"${DBPASS}\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "mysql -u \${DBUSER} -p\${DBPASS} moodle < moodledbdump.sql" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}

#current /home/judge/src/ directory backup
tar -czvpf /home/${SUDO_USER}/moodlebackups/${BACKUPS}/moodlesrc.tar.gz /var/www/html

#for restoring
echo "rm -rf /var/www/html/*" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "tar -xzvpf ./moodlesrc.tar.gz -C /" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}

#current /home/judge/data/ directory backup
tar -czvpf /home/${SUDO_USER}/moodlebackups/${BACKUPS}/moodledata.tar.gz /var/moodledata
#for restoring
echo "rm -rf /var/moodledata/*" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "tar -xzvpf ./moodledata.tar.gz -C /" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}

echo "echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"--- CSL moodle backup ${BACKUPS} restored!! ---\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${SUDO_USER}/moodlebackups/${BACKUPS}/${RESTOREFILE}

echo ""
echo "---- CSL moodle backuped successfully at ${BACKUPS} ----"
echo ""
echo "You can restore CSL moodle ${BACKUPS} backup with ..."
echo ""
echo "$ sudo bash ~/moodlebackups/${BACKUPS}/${RESTOREFILE}"
echo ""

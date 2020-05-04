#!/bin/bash
#
# Basic MySQL backups with retention.
#

set -e
set -o pipefail

BACKUP_LOCATION=/backup/
DATE=$(date +"%Y%m%d")
EXTRA_FILE=/root/.my.cnf
RETENTION=2

# DirectAdmin doesn't support /root/.my.cnf
# See https://help.directadmin.com/item.php?id=329

if [ -f "/usr/local/directadmin/conf/my.cnf" ]; then
  EXTRA_FILE=/usr/local/directadmin/conf/my.cnf
fi

# DO NOT MAKE ANY CHANCES BELOW

DATABASES=$(mysql --defaults-extra-file="$EXTRA_FILE" -e "SHOW DATABASES" | grep -Ev 'Database|information_schema|performance_schema|mysql')

mkdir -p $BACKUP_LOCATION/$DATE

for DB in $DATABASES; do
  echo $DB
  mysqldump --defaults-extra-file="$EXTRA_FILE" --force --skip-lock-tables --events --databases $DB | gzip > "$BACKUP_LOCATION/$DATE/$DB.sql.gz"
done

# Cleanup, remove old backups and empty directories
find $BACKUP_LOCATION/* -mtime +$RETENTION -delete -print
find $BACKUP_LOCATION/ -type d -empty -delete -print
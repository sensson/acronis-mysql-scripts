#!/usr/bin/env bash
#
# Basic MySQL backups with retention.
#

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${DIR}/functions.sh"

BACKUP_LOCATION=$(getValueFromConfig backup_location /backup)
LOCAL_RETENTION=$(getValueFromConfig local_retention 2)
DATE=$(date +"%Y%m%d")
EXTRA_FILE=/root/.my.cnf

# DirectAdmin doesn't support /root/.my.cnf
# See https://help.directadmin.com/item.php?id=329

if [ -f "/usr/local/directadmin/conf/my.cnf" ]; then
  EXTRA_FILE=/usr/local/directadmin/conf/my.cnf
fi

# DO NOT MAKE ANY CHANCES BELOW

if [ "${BACKUP_LOCATION}" = "/" ]; then
  >&2 echo "backup_location cannot be set to /"
  exit 1
fi

DATABASES=$(mysql --defaults-extra-file="$EXTRA_FILE" -e "SHOW DATABASES" | grep -Ev 'Database|information_schema|performance_schema|mysql')

mkdir -p "${BACKUP_LOCATION}/${DATE}"

for DB in $DATABASES; do
  echo -n $DB
  mysqldump --defaults-extra-file="${EXTRA_FILE}" --force --skip-lock-tables --events --routines --databases "${DB}" | gzip > "${BACKUP_LOCATION}/${DATE}/${DB}.sql.gz"
  echo " OK"
done

# Cleanup, remove old backups and empty directories
# In some odd cases this fails, continue if so

find "${BACKUP_LOCATION}/" -type f -mtime +"${LOCAL_RETENTION}" -delete -print || true
find "${BACKUP_LOCATION}/" -type d -empty -delete -print || true

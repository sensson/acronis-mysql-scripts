#!/usr/bin/env bash

set -euo pipefail

unset LD_LIBRARY_PATH
unset LD_PRELOAD

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${DIR}/functions.sh"

EXTRA_FILE=$(getValueFromConfig extra_file "" mysql-remote.conf)
BACKUP_LOCATION=$(getValueFromConfig backup_location /backup/remote mysql-remote.conf)
LOCAL_RETENTION=$(getValueFromConfig local_retention 2 mysql-remote.conf)
DATE=$(date +"%Y%m%d")

if [ -z "${EXTRA_FILE}" ]; then
  >&2 echo "extra_file is not set in mysql-remote.conf"
  exit 1
fi

if [ ! -f "${EXTRA_FILE}" ]; then
  >&2 echo "credentials file ${EXTRA_FILE} does not exist"
  exit 1
fi

if [ "${BACKUP_LOCATION}" = "/" ]; then
  >&2 echo "backup_location cannot be set to /"
  exit 1
fi

DATABASES=$(mysql --defaults-extra-file="$EXTRA_FILE" -N -e "SHOW DATABASES" | grep -Ev '^(information_schema|performance_schema|mysql)$')

mkdir -p "${BACKUP_LOCATION}/${DATE}"

for DB in $DATABASES; do
  echo -n $DB
  mysqldump --defaults-extra-file="${EXTRA_FILE}" --force --skip-lock-tables --events --routines --databases "${DB}" | gzip > "${BACKUP_LOCATION}/${DATE}/${DB}.sql.gz"
  echo " OK"
done

find "${BACKUP_LOCATION}/" -type f -mtime +"${LOCAL_RETENTION}" -delete -print || true
find "${BACKUP_LOCATION}/" -type d -empty -delete -print || true

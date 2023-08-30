#!/usr/bin/env bash
#
# Lock writes before data backup
#

set -euo pipefail

unset LD_LIBRARY_PATH
unset LD_PRELOAD

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${DIR}/functions.sh"

LOGGING_LOCATION=$(getValueFromConfig logging_location /var/lib/Acronis/logs)
FREEZE_LOGFILE=freeze.log
FREEZE_LOCKFILE=freeze.lock
FREEZE_SNAPSHOT_TIMEOUT=$(getValueFromConfig freeze_snapshot_timeout 5)
FREEZE_MYSQL_TIMEOUT=$(getValueFromConfig freeze_mysql_timeout 300)
EXTRA_FILE=/root/.my.cnf

# DirectAdmin doesn't support /root/.my.cnf
# See https://help.directadmin.com/item.php?id=329

if [ -f "/usr/local/directadmin/conf/my.cnf" ]; then
  EXTRA_FILE=/usr/local/directadmin/conf/my.cnf
fi

# DO NOT MAKE ANY CHANCES BELOW

mkdir -p "$LOGGING_LOCATION"

echo "$(date -Ins) ---------------------------------------------------------------------" >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
echo "$(date -Ins) - Pre-freeze script started." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"

echo "$(date -Ins) - Deleting freeze lock file..." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
rm -f "$LOGGING_LOCATION/$FREEZE_LOCKFILE"

echo "$(date -Ins) - Starting MySQL freeze session..." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
mysql \
  --defaults-extra-file="$EXTRA_FILE" \
  --execute="FLUSH TABLES WITH READ LOCK; SYSTEM touch \"$LOGGING_LOCATION/$FREEZE_LOCKFILE\"; SYSTEM echo \"\$(date -Ins) - Freeze lock aquired.\" >> \"$LOGGING_LOCATION/$FREEZE_LOGFILE\"; SYSTEM sleep $FREEZE_SNAPSHOT_TIMEOUT; SYSTEM echo \"\$(date -Ins) - Freeze session terminated.\" >> \"$LOGGING_LOCATION/$FREEZE_LOGFILE\";" \
  1>/dev/null 2>/dev/null &

FREEZE_SESSION_PID=$!
echo "$(date -Ins) - Started MySQL freeze session, PID is $FREEZE_SESSION_PID..." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"

attempts=0
while [ ! -f "$LOGGING_LOCATION/$FREEZE_LOCKFILE" ]; do

  if ! ps -p $FREEZE_SESSION_PID 1>/dev/null; then
    echo "$(date -Ins) - Seems like MySQL freeze statement failed. Aborted." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
    exit 1
  fi

  sleep 1s
  attempts=$((attempts+1))

  if [ $attempts -gt $FREEZE_MYSQL_TIMEOUT ]; then
    echo "$(date -Ins) - MySQL cannot freeze in suitable time. Aborting..." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
    kill $FREEZE_SESSION_PID
    exit 2
  fi

  echo "$(date -Ins) - Waiting for MySQL to freeze tables. Making try $attempts..." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"

done

echo $FREEZE_SESSION_PID > "$LOGGING_LOCATION/$FREEZE_LOCKFILE"
echo "$(date -Ins) - Freeze successful." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"

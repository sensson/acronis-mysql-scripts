#!/usr/bin/env bash
#
# Release lock
#

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${DIR}/functions.sh"

# DO NOT MAKE ANY CHANCES BELOW

LOGGING_LOCATION=$(getValueFromConfig logging_location /var/lib/Acronis/logs)
FREEZE_LOGFILE=freeze.log
FREEZE_LOCKFILE=freeze.lock

echo "$(date -Ins) - Post-thaw script started." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"

FREEZE_SESSION_PID=$(cat "$LOGGING_LOCATION/$FREEZE_LOCKFILE")

echo "$(date -Ins) - Terminating freeze session. PID is $FREEZE_SESSION_PID." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
pkill -9 -P $FREEZE_SESSION_PID

echo "$(date -Ins) - Deleting freeze lock file..." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
rm -f "$LOGGING_LOCATION/$FREEZE_LOCKFILE"

echo "$(date -Ins) - Unfreeze successful." >> "$LOGGING_LOCATION/$FREEZE_LOGFILE"
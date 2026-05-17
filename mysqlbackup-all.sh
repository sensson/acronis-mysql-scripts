#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

STATUS=0

"${DIR}/mysqlbackup.sh" || STATUS=$?
"${DIR}/mysqlbackup-remote.sh" || STATUS=$?

exit $STATUS

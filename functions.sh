#!/usr/bin/env bash

getValueFromConfig() {
    if [ ! -f "${DIR}/mysql.conf" ]; then
      >&2 echo 'Configuration file missing.'
      exit 1
    fi

    VALUE=$(grep ${1} "${DIR}/mysql.conf" | cut -d '=' -f 2)

    if [ -z $VALUE ]; then
      >&2 echo "No value set for ${1}"
      exit 1
    fi

    echo $VALUE
}
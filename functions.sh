#!/usr/bin/env bash

getValueFromConfig() {
    if [ ! -f "${DIR}/mysql.conf" ]; then
      >&2 echo 'Configuration file missing.'
      exit 1
    fi

    if [ -z $2 ]; then
      >&2 echo "No default value set for ${1}"
    fi

    VALUE=$(grep ${1} "${DIR}/mysql.conf" | cut -d '=' -f 2)

    # Return default value ($2) when no value exists

    if [ -z $VALUE ]; then
      echo $2
      exit 0
    fi

    echo $VALUE
}

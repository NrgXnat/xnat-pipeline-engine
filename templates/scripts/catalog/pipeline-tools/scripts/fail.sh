#!/bin/bash

VERSION=1.0
if [ "$1" == "--version" ]; then
    echo $VERSION
    exit 0
fi

ERROR_STRING=ERROR
while [ $# -ne 0 ] ; do
    if [ "${1}" == "-e" ]; then
        echo $ERROR_STRING
        echo $ERROR_STRING >&2
        shift
        ERROR_STRING="$1"
    else
        ERROR_STRING+=" $1"
    fi
    shift

done

echo $ERROR_STRING
echo $ERROR_STRING >&2

exit 1

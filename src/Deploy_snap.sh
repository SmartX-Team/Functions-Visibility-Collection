#!/bin/bash


if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cp ../bin/snapctl ../bin/snapd /usr/sbin

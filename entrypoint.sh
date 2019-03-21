#!/bin/sh

set -e

if [ "$1" = 'test' ]; then
  exec su-exec usr-w3af /opt/w3af/w3af_console -y

elif [ "$1" = 'makemeroot' ]; then
  exec ash

else
  exec su-exec usr-w3af "$@"
fi
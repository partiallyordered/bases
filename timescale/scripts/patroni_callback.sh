#!/bin/sh
set -e

. "${HOME}/.pod_environment"

for suffix in "$1" all
do
  CALLBACK="/etc/timescaledb/callbacks/${suffix}"
  if [ -f "${CALLBACK}" ]
  then
    "${CALLBACK}" "$@"
  fi
done

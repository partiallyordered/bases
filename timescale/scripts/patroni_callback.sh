#!/bin/sh
# This file and its contents are licensed under the Apache License 2.0.
# Please see the included NOTICE for copyright information and LICENSE for a copy of the license.
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

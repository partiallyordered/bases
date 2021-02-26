#!/bin/sh
# This file and its contents are licensed under the Apache License 2.0.
# Please see the included NOTICE for copyright information and LICENSE for a copy of the license.
PGBACKREST_BACKUP_ENABLED=0
[ ${PGBACKREST_BACKUP_ENABLED} -ne 0 ] || exit 0

. "${HOME}/.pgbackrest_environment"
exec pgbackrest --stanza=poddb archive-get "${1}" "${2}"

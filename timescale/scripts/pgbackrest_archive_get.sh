#!/bin/sh
PGBACKREST_BACKUP_ENABLED=0
[ ${PGBACKREST_BACKUP_ENABLED} -ne 0 ] || exit 0

. "${HOME}/.pgbackrest_environment"
exec pgbackrest --stanza=poddb archive-get "${1}" "${2}"

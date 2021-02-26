#!/bin/sh
# This file and its contents are licensed under the Apache License 2.0.
# Please see the included NOTICE for copyright information and LICENSE for a copy of the license.
PGBACKREST_BACKUP_ENABLED=0
[ ${PGBACKREST_BACKUP_ENABLED} -ne 0 ] || exit 1

. "${HOME}/.pod_environment"

PGDATA="/var/lib/postgresql/data"
WALDIR="/var/lib/postgresql/wal/pg_wal"

# A missing PGDATA points to Patroni removing a botched PGDATA, or manual
# intervention. In this scenario, we need to recreate the DATA and WALDIRs
# to keep pgBackRest happy
[ -d "${PGDATA}" ] || install -o postgres -g postgres -d -m 0700 "${PGDATA}"
[ -d "${WALDIR}" ] || install -o postgres -g postgres -d -m 0700 "${WALDIR}"

exec pgbackrest --force --delta --log-level-console=detail restore

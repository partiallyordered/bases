#!/bin/sh

# If no backup is configured, archive_command would normally fail. A failing archive_command on a cluster
# is going to cause WAL to be kept around forever, meaning we'll fill up Volumes we have quite quickly.
#
# Therefore, if the backup is disabled, we always return exitcode 0 when archiving

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - archive - $1"
}

[ -z "$1" ] && log "Usage: $0 <WALFILE or DIRECTORY>" && exit 1

PGBACKREST_BACKUP_ENABLED=0
[ ${PGBACKREST_BACKUP_ENABLED} -ne 0 ] || exit 0

. "${HOME}/.pgbackrest_environment"
exec pgbackrest --stanza=poddb archive-push "$@"

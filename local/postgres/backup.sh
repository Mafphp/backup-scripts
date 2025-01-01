#!/bin/sh

SOURCE_DATABASE_NAME=
SOURCE_DATABASE_USERNAME=
SOURCE_DATABASE_PORT=
BACKUP_FILE_NAME=

# Create a function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log_message "Starting backup of database $SOURCE_DATABASE_NAME"

# Run the pg_dump command with verbose flag and capture its output and errors
docker run --rm --network host -v "$PWD:/backup" postgres:16 pg_dump -h localhost -p $SOURCE_DATABASE_PORT -U $SOURCE_DATABASE_USERNAME -d $SOURCE_DATABASE_NAME -Fc -f /backup/$BACKUP_FILE_NAME -v

if [ $? -eq 0 ]; then
    log_message "$BACKUP_FILE_NAME backup complete"
else
    log_message "Backup failed"
fi


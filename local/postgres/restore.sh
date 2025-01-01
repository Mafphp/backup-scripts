#!/bin/bash

TARGET_DATABASE_NAME=
TARGET_DATABASE_USERNAME=
TARGET_DATABASE_PASSWORD=
TARGET_DATABASE_PORT=

BACKUP_FILE_NAME=

# Function to execute SQL commands
execute_sql() {
  local sql="$1"
  docker run --rm --network host -e PGPASSWORD=$TARGET_DATABASE_PASSWORD postgres:16 psql -h localhost -p $TARGET_DATABASE_PORT -U $TARGET_DATABASE_USERNAME -c "$sql"
}

# Terminate all connections to the target database
echo "Terminating all connections to the target database..."
terminate_sql="SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$TARGET_DATABASE_NAME' AND pid <> pg_backend_pid();"
execute_sql "$terminate_sql"

# Drop the existing database
echo "Dropping the existing database..."
execute_sql "DROP DATABASE IF EXISTS \"$TARGET_DATABASE_NAME\";"

# Create a new database
echo "Creating a new database..."
execute_sql "CREATE DATABASE \"$TARGET_DATABASE_NAME\";"

# Restore the backup to the new database
echo "Restoring the backup to the new database..."
docker run --rm --network host -e PGPASSWORD=$TARGET_DATABASE_PASSWORD -v "$PWD:/backup" postgres:16 pg_restore -h localhost -p $TARGET_DATABASE_PORT -U $TARGET_DATABASE_USERNAME -d $TARGET_DATABASE_NAME -Fc /backup/$BACKUP_FILE_NAME

#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: ./restore.sh backup.sql"
    exit 1
fi

docker exec hotel-postgres \
psql \
-U postgres \
-c "DROP DATABASE IF EXISTS hotel_restore;"

docker exec hotel-postgres \
psql \
-U postgres \
-c "CREATE DATABASE hotel_restore;"

cat "$1" | docker exec -i hotel-postgres \
psql \
-U postgres \
-d hotel_restore

echo "Restore completed."

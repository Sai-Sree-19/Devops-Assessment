#!/bin/bash

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p backups

docker exec hotel-postgres \
pg_dump \
-U postgres \
-d hoteldb \
> backups/hoteldb_$TIMESTAMP.sql

echo "Backup completed"

echo "File : backups/hoteldb_$TIMESTAMP.sql"

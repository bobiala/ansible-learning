#!/bin/bash
set -x
set -euo pipefail

bck_dir="/data/backup/postgresql"
passwd_file="/data/system/cron/postgres_password"

date_str=$(date +"%Y%m%d_%H%M%S")
passwd="$(cat "$passwd_file")"
export PGPASSWORD="${passwd}"

dbs=`sudo -u postgres PGPASSWORD="${passwd}" psql -h 127.0.0.1 -U postgres -t -c "SELECT datname FROM pg_database" | grep -Ev "template0|template1"`

echo "Will be backed up: $dbs to $bck_dir"
for db in $dbs
do
  mkdir -p "${bck_dir}/${db}"
  filename="${bck_dir}/${db}/${db}-${date_str}.sql"
  sudo -u postgres PGPASSWORD="${passwd}" pg_dump -h localhost -p 5432 -Upostgres -v "${db}" -F p > "$filename"
  echo "Finished backup for $db"
done

echo "Backup completed!"

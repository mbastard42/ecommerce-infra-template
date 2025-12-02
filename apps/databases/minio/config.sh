#!/bin/sh
set -e

echo "Waiting for MinIO to be ready..."

tries=0
while [ $tries -lt 30 ]; do
  if mc alias set root "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" >/dev/null 2>&1; then
    echo "MinIO is ready."
    break
  fi
  tries=$((tries+1))
  echo "MinIO not ready yet, retrying... ($tries/30)"
  sleep 2
done

mc mb --ignore-existing root/$MINIO_ADMIN_BUCKET
mc mb --ignore-existing root/$MINIO_BACKEND_BUCKET

mc admin policy create root truth-rw /policies/truth_rw.json
mc admin policy create root truth-ro /policies/truth_ro.json
mc admin policy create root mirror-rw /policies/mirror_rw.json

mc admin user add root $MINIO_ADMIN_USER $MINIO_ADMIN_PASSWORD || true
mc admin user add root $MINIO_BACKEND_USER $MINIO_BACKEND_PASSWORD || true

mc admin policy attach root truth-rw --user $MINIO_ADMIN_USER
mc admin policy attach root truth-ro --user $MINIO_BACKEND_USER
mc admin policy attach root mirror-rw --user $MINIO_BACKEND_USER

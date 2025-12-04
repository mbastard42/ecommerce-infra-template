#!/usr/bin/env bash
set -e

TEMPLATE=$ODOO_RC.tpl
RENDERED=$ODOO_RC

if [ -f "$TEMPLATE" ]; then
  echo "render_conf.sh: rendering $TEMPLATE -> $RENDERED"

  SED_ARGS=()

  SED_ARGS+=(-e "s|{{ POSTGRES_HOST }}|${POSTGRES_HOST:-postgres}|g")
  SED_ARGS+=(-e "s|{{ POSTGRES_PORT }}|${POSTGRES_PORT:-5432}|g")
  SED_ARGS+=(-e "s|{{ POSTGRES_DATABASE }}|${POSTGRES_DATABASE:-truth}|g")
  SED_ARGS+=(-e "s|{{ POSTGRES_USER }}|${POSTGRES_USER:-odoo}|g")
  SED_ARGS+=(-e "s|{{ POSTGRES_PASSWORD }}|${POSTGRES_PASSWORD:-odoo}|g")

  SED_ARGS+=(-e "s|{{ MINIO_ENDPOINT }}|${MINIO_ENDPOINT:-http://minio:9000}|g")
  SED_ARGS+=(-e "s|{{ MINIO_ROOT_USER }}|${MINIO_ROOT_USER:-minioadmin}|g")
  SED_ARGS+=(-e "s|{{ MINIO_ROOT_PASSWORD }}|${MINIO_ROOT_PASSWORD:-minioadmin}|g")
  SED_ARGS+=(-e "s|{{ MINIO_BUCKET }}|${MINIO_BUCKET:-truth}|g")

  sed "${SED_ARGS[@]}" "$TEMPLATE" > "$RENDERED"
  echo "render_conf.sh: done"
fi
#!/usr/bin/env bash
set -e

if [ -z "$PGDATA" ]; then
  echo "PGDATA is not set"
  exit 1
fi

HBA="$PGDATA/pg_hba.conf"
TEMPLATE="/etc/postgresql/pg_hba.conf.tpl"

echo "0_render_hba.sh: rendering $TEMPLATE into $HBA"

BACKEND_IP=$(getent hosts backend | awk '{print $1}' || true)
ADMIN_IP=$(getent hosts admin | awk '{print $1}' || true)

SED_ARGS=()

if [ -n "$BACKEND_IP" ]; then
  SED_ARGS+=(-e "s/{{ BACKEND_IP }}/$BACKEND_IP/g")
  SED_ARGS+=(-e "s/{{ PG_BACKEND_DB }}/$PG_BACKEND_DB/g")
  SED_ARGS+=(-e "s/{{ PG_BACKEND_USER }}/$PG_BACKEND_USER/g")
else
  SED_ARGS+=(-e "/{{ BACKEND_IP }}/d")
fi

if [ -n "$ADMIN_IP" ]; then
  SED_ARGS+=(-e "s/{{ ADMIN_IP }}/$ADMIN_IP/g")
  SED_ARGS+=(-e "s/{{ PG_ADMIN_DB }}/$PG_ADMIN_DB/g")
  SED_ARGS+=(-e "s/{{ PG_ADMIN_USER }}/$PG_ADMIN_USER/g")
else
  SED_ARGS+=(-e "/{{ ADMIN_IP }}/d")
fi

sed "${SED_ARGS[@]}" "$TEMPLATE" > "$HBA"

echo "0_render_hba.sh: done"
cat "$HBA"
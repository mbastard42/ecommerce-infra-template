#!/usr/bin/env bash
set -e

echo "1_databases_and_users.sh: Initializing users & databases..."

#----------------------------------------------------------
# 1. CREATE ROLES (safe inside DO $$)
#----------------------------------------------------------
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL

DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${PG_ADMIN_USER}') THEN
    CREATE ROLE ${PG_ADMIN_USER} LOGIN PASSWORD '${PG_ADMIN_PASSWORD}';
  END IF;

  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${PG_BACKEND_USER}') THEN
    CREATE ROLE ${PG_BACKEND_USER} LOGIN PASSWORD '${PG_BACKEND_PASSWORD}';
  END IF;
END
\$\$;

EOSQL

#----------------------------------------------------------
# 2. CREATE DATABASES
#----------------------------------------------------------

# truth (odoo)
DB_EXISTS=$(psql --username "$POSTGRES_USER" --dbname "postgres" -tAc \
  "SELECT 1 FROM pg_database WHERE datname='${PG_ADMIN_DB}'")

if [ "$DB_EXISTS" != "1" ]; then
  echo "Creating database ${PG_ADMIN_DB}..."
  psql --username "$POSTGRES_USER" --dbname "postgres" -c \
    "CREATE DATABASE ${PG_ADMIN_DB} OWNER ${PG_ADMIN_USER};"
fi

# mirror (symfony)
DB_EXISTS=$(psql --username "$POSTGRES_USER" --dbname "postgres" -tAc \
  "SELECT 1 FROM pg_database WHERE datname='${PG_BACKEND_DB}'")

if [ "$DB_EXISTS" != "1" ]; then
  echo "Creating database ${PG_BACKEND_DB}..."
  psql --username "$POSTGRES_USER" --dbname "postgres" -c \
    "CREATE DATABASE ${PG_BACKEND_DB} OWNER ${PG_BACKEND_USER};"
fi

#----------------------------------------------------------
# 3. LOCK DOWN DEFAULT PRIVILEGES
#----------------------------------------------------------
psql --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL

REVOKE CONNECT ON DATABASE ${PG_ADMIN_DB}  FROM PUBLIC;
REVOKE CONNECT ON DATABASE ${PG_BACKEND_DB} FROM PUBLIC;

GRANT CONNECT ON DATABASE ${PG_ADMIN_DB}  TO ${PG_ADMIN_USER};
GRANT CONNECT ON DATABASE ${PG_BACKEND_DB} TO ${PG_BACKEND_USER};

EOSQL

echo "1_databases_and_users.sh: Databases and users initialized"

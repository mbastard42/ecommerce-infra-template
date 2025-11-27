#!/bin/sh
set -e

envsubst < /tmp/odoo.conf > /etc/odoo/odoo.conf
exec "$@"
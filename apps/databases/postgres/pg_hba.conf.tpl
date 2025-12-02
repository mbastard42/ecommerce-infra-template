# pg_hba.conf.tpl

local   all                     postgres                                            peer
host    {{ PG_BACKEND_DB }}     {{ PG_BACKEND_USER }}       {{ BACKEND_IP }}/32     scram-sha-256
host    {{ PG_ADMIN_DB }}       {{ PG_ADMIN_USER }}         {{ ADMIN_IP }}/32       scram-sha-256
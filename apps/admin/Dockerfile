FROM odoo:18.0 AS base
USER root
RUN pip3 install --no-cache-dir --break-system-packages \
    packaging \
    fsspec \
    s3fs \
    boto3 \
    cachetools \
    cerberus
USER odoo

FROM base AS deps
COPY ./odoo/entrypoint.sh /entrypoint.sh
COPY ./odoo/render_conf.sh /render_conf.sh
COPY ./odoo/addons/ /mnt/extra-addons/
USER root
RUN chmod +x /entrypoint.sh
RUN chmod +x /render_conf.sh
USER odoo

FROM deps AS dev
COPY ./odoo/conf/dev.conf.tpl /etc/odoo/odoo.conf.tpl

FROM deps AS prod
COPY ./odoo/conf/prod.conf.tpl /etc/odoo/odoo.conf.tpl

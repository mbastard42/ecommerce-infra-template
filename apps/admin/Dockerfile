FROM odoo:18.0 AS dev

USER root
RUN pip3 install --no-cache-dir --break-system-packages \
    packaging \
    fsspec \
    s3fs \
    boto3 \
    cachetools \
    cerberus
USER odoo

COPY ./odoo/entrypoint.sh /entrypoint.sh
COPY ./odoo/conf/dev.conf /tmp/odoo.conf
COPY ./odoo/addons/ /mnt/extra-addons/

USER root
RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN chmod +x /entrypoint.sh
USER odoo
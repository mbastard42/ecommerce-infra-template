FROM node:22.20.0-alpine AS base
WORKDIR /app

FROM base AS deps
COPY ./svelte/package.json ./svelte/package-lock.json ./
RUN npm ci

FROM deps AS dev
COPY ./svelte .
RUN npm run prepare || true

FROM dev AS build
RUN npm run build

FROM caddy:2.10.2-builder AS caddy
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    XCADDY_SKIP_CGO=1
RUN xcaddy build --with github.com/caddyserver/replace-response

FROM gcr.io/distroless/static AS prod
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=build /app/build /usr/share/caddy
COPY ./Caddyfile /etc/caddy/Caddyfile
USER 65532:65532
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
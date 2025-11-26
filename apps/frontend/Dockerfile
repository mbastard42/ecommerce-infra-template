FROM node:22.20.0-alpine AS dev

WORKDIR /app
COPY ./svelte .

RUN npm install -g npm@11.6.3
COPY ./svelte/package.json ./svelte/package-lock.json ./
RUN npm install

CMD ["npm", "run", "dev"]
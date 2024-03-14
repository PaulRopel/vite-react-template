FROM node:21-alpine AS build

WORKDIR /app

COPY package.json yarn.lock ./

ARG VITE_SERVER_URL

RUN yarn install --frozen-lockfile && \
    yarn run build

FROM caddy:latest

WORKDIR /app

COPY --from=build /app/dist ./dist

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

ENTRYPOINT ["caddy"]

CMD ["run", "--config", "Caddyfile", "--adapter", "caddyfile", "2>&1"]
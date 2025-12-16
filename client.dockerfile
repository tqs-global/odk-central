FROM node:22-slim AS builder
WORKDIR /client
COPY client/package*.json ./
RUN npm clean-install --omit=dev --no-audit --fund=false --update-notifier=false
COPY client/ ./
RUN npm run build

FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /client/dist/ ./
COPY client/common-headers.nginx.conf /etc/nginx/common-headers.nginx.conf
COPY client/main.nginx.conf /etc/nginx/nginx.conf
EXPOSE 80